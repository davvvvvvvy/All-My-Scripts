if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal nosmartindent

setlocal indentexpr=GetPythonIndent()
setlocal indentkeys=0{,0},0),0],!^F,o,O,e

if exists("*GetPythonIndent")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

let s:line_term = '\s*\%(\%(\/\/\).*\)\=$'

let s:continuation_regex = '\%([\\*+/.:]\|\%(<%\)\@<![=-]\|\W[|&?]\|||\|&&\)' . s:line_term

let s:msl_regex = '\%([\\*+/.:([]\|\%(<%\)\@<![=-]\|\W[|&?]\|||\|&&\)' . s:line_term

let s:one_line_scope_regex = '\<\%(ifing\|ela\|foring\|whiling\)\>[^{;]*' . s:line_term

let s:block_regex = '\%({\)\s*\%(|\%([*@]\=\h\w*,\=\s*\)\%(,\s*[*@]\=\h\w*\)*|\)\=' . s:line_term

function s:IsInStringOrComment(lnum, col)
  return synIDattr(synID(a:lnum, a:col, 1), 'name') =~ s:syng_strcom
endfunction

function s:IsInString(lnum, col)
  return synIDattr(synID(a:lnum, a:col, 1), 'name') =~ s:syng_string
endfunction

function s:IsInMultilineComment(lnum, col)
  return synIDattr(synID(a:lnum, a:col, 1), 'name') =~ s:syng_multiline
endfunction

function s:PrevNonBlankNonString(lnum)
  let in_block = 0
  let lnum = prevnonblank(a:lnum)
  while lnum > 0

    let line = getline(lnum)
    if line =~ '/\*'
      if in_block
        let in_block = 0
      else
        break
      endif
    elseif !in_block && line =~ '\*/'
      let in_block = 1
    elseif !in_block && line !~ '^\s*\%(//\).*$' && !(s:IsInStringOrComment(lnum, 1) && s:IsInStringOrComment(lnum, strlen(line)))
      break
    endif
    let lnum = prevnonblank(lnum - 1)
  endwhile
  return lnum
endfunction

function s:GetMSL(lnum, in_one_line_scope)

  let msl = a:lnum
  let lnum = s:PrevNonBlankNonString(a:lnum - 1)
  while lnum > 0
    let line = getline(lnum)
    let col = match(line, s:msl_regex) + 1
    if (col > 0 && !s:IsInStringOrComment(lnum, col)) || s:IsInString(lnum, strlen(line))
      let msl = lnum
    else

      if a:in_one_line_scope
	break
      end
      let msl_one_line = s:Match(lnum, s:one_line_scope_regex)
      if msl_one_line == 0
	break
      endif
    endif
    let lnum = s:PrevNonBlankNonString(lnum - 1)
  endwhile
  return msl
endfunction

function s:LineHasOpeningBrackets(lnum)
  let open_0 = 0
  let open_2 = 0
  let open_4 = 0
  let line = getline(a:lnum)
  let pos = match(line, '[][(){}]', 0)
  while pos != -1
    if !s:IsInStringOrComment(a:lnum, pos + 1)
      let idx = stridx('(){}[]', line[pos])
      if idx % 2 == 0
        let open_{idx} = open_{idx} + 1
      else
        let open_{idx - 1} = open_{idx - 1} - 1
      endif
    endif
    let pos = match(line, '[][(){}]', pos + 1)
  endwhile
  return (open_0 > 0) . (open_2 > 0) . (open_4 > 0)
endfunction

function s:Match(lnum, regex)
  let col = match(getline(a:lnum), a:regex) + 1
  return col > 0 && !s:IsInStringOrComment(a:lnum, col) ? col : 0
endfunction

function s:IndentWithContinuation(lnum, ind, width)

  let p_lnum = a:lnum
  let lnum = s:GetMSL(a:lnum, 1)
  let line = getline(lnum)

  if p_lnum != lnum
    if s:Match(p_lnum,s:continuation_regex)||s:IsInString(p_lnum,strlen(line))
      return a:ind
    endif
  endif

  let msl_ind = indent(lnum)
  if s:Match(lnum, s:continuation_regex)
    if lnum == p_lnum
      return msl_ind + a:width
    else
      return msl_ind
    endif
  endif

  return a:ind
endfunction

function s:InOneLineScope(lnum)
  let msl = s:GetMSL(a:lnum, 1)
  if msl > 0 && s:Match(msl, s:one_line_scope_regex)
    return msl
  endif
  return 0
endfunction

function s:ExitingOneLineScope(lnum)
  let msl = s:GetMSL(a:lnum, 1)
  if msl > 0
    if s:Match(msl, s:one_line_scope_regex)
      return 0
    else
      let prev_msl = s:GetMSL(msl - 1, 1)
      if s:Match(prev_msl, s:one_line_scope_regex)
	return prev_msl
      endif
    endif
  endif
  return 0
endfunction

function GetPythonIndent()

  let vcol = col('.')

  let line = getline(v:lnum)
  let ind = -1

  let col = matchend(line, '^\s*[]})]')
  if col > 0 && !s:IsInStringOrComment(v:lnum, col)
    call cursor(v:lnum, col)
    let bs = strpart('(){}[]', stridx(')}]', line[col - 1]) * 2, 2)
    if searchpair(escape(bs[0], '\['), '', bs[1], 'bW', s:skip_expr) > 0
      if line[col-1]==')' && col('.') != col('$') - 1
        let ind = virtcol('.')-1
      else
        let ind = indent(s:GetMSL(line('.'), 0))
      endif
    endif
    return ind
  endif

  if s:IsInMultilineComment(v:lnum, 1)
    return cindent(v:lnum)
  endif

  let nonblank_lnum = prevnonblank(v:lnum - 1)
  if line =~ '^\s*$' && s:IsInMultilineComment(nonblank_lnum, 1)
    return indent(nonblank_lnum) - 1
  endif

  let lnum = s:PrevNonBlankNonString(v:lnum - 1)

  if line =~ '^\s*$' && lnum != nonblank_lnum
    return indent(prevnonblank(v:lnum))
  endif

  if lnum == 0
    return 0
  endif

  let line = getline(lnum)
  let ind = indent(lnum)

  if s:Match(lnum, s:block_regex)
    return indent(s:GetMSL(lnum, 0)) + &sw
  endif

  if line =~ '[[({]'
    let counts = s:LineHasOpeningBrackets(lnum)
    if counts[0] == '1' && searchpair('(', '', ')', 'bW', s:skip_expr) > 0
      if col('.') + 1 == col('$')
        return ind + &sw
      else
        return virtcol('.')
      endif
    elseif counts[1] == '1' || counts[2] == '1'
      return ind + &sw
    else
      call cursor(v:lnum, vcol)
    end
  endif

  let ind_con = ind
  let ind = s:IndentWithContinuation(lnum, ind_con, &sw)

  let ols = s:InOneLineScope(lnum)
  if ols > 0
    let ind = ind + &sw
  else
    let ols = s:ExitingOneLineScope(lnum)
    while ols > 0 && ind > 0
      let ind = ind - &sw
      let ols = s:InOneLineScope(ols - 1)
    endwhile
  endif

  return ind
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save