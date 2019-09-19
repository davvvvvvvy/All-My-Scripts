autocmd BufNewFile,BufRead *.py setfiletype python

if exists('b:current_syntax')
    finish
endif

let g:python_collections = get(g:, 'python_collections', '0')
let g:python_more_operators = get(g:, 'python_more_operators', '0')

if g:python_more_operators == 0
    syn match pyOperator "\v\?:|::|[-!%&*+/?|]"
else
    syn match pyOperator "\v[-!%&*+/?|{}\[\]=\<\>(),_.:;]"
endif

syn keyword pyStatement break continue return
syn keyword pyConditional if else elif
syn keyword pyRepeat for while
syn keyword pyOperator as in is and or
syn keyword pyKeyword get set
syn keyword pyException try except finally

syn keyword pyInclude import from

syn keyword pyType Any Boolean Byte Char Double Float Int Long Nothing Short Unit String UByte UShort UInt ULong Throwable
if g:python_collections == 1
    syn keyword pyCollections list map set
endif
syn keyword pyModifier final open expect enumerate len range print input
syn keyword pyStructure class def __init__ __file__

syn keyword pyReservedKeyword Exception

syn keyword pyBoolean True False
syn keyword pyConstant None

syn keyword pyModifier data

syn keyword pyTodo TODO FIXME XXX contained
syn match pyShebang "\v^#!.*$"
syn match pyLineComment "\v//.*$" contains=pyTodo,@Spell
syn region pyComment matchgroup=pyCommentMatchGroup start="/\*" end="\*/" contains=pyComment,pyTodo,@Spell

syn region pyDocComment start="/\*\*" end="\*/" contains=pyDocTag,pyTodo,@Spell
syn match pyDocTag "\v\@(author|constructor|receiver|return|since|suppress)>" contained
syn match pyDocTag "\v\@(exception|param|property|throws|see|sample)>\s*\S+" contains=pyDocTagParam contained
syn match pyDocTagParam "\v(\s|\[)\S+" contained
syn match pyComment "/\*\*/"

syn match pySpecialCharError "\v\\." contained
syn match pySpecialChar "\v\\([tbnr'"$\\]|u\x{4})" contained
syn region pyString start='"' skip='\\"' end='"' contains=pySimpleInterpolation,pyComplexInterpolation,pySpecialChar,pySpecialCharError
syn region pyString start='"""' end='""""*' contains=pySimpleInterpolation,pyComplexInterpolation,pySpecialChar,pySpecialCharError
syn match pyCharacter "\v'[^']*'" contains=pySpecialChar,pySpecialCharError
syn match pyCharacter "\v'\\''" contains=pySpecialChar
syn match pyCharacter "\v'[^\\]'"

" TODO: highlight label in 'this@Foo'
syn match pyAnnotation "\v(\w)@<!\@[[:alnum:]_.]*(:[[:alnum:]_.]*)?"
syn match pyLabel "\v\w+\@"

syn match pySimpleInterpolation "\v\$\h\w*" contained
syn region pyComplexInterpolation matchgroup=pyComplexInterpolationBrace start="\v\$\{" end="\v\}" contains=ALLBUT,pySimpleInterpolation,pyTodo,pySpecialCharError,pySpecialChar,pyDocTag,pyDocTagParam

syn match pyNumber "\v<\d+[_[:digit:]]*(uL?|UL?|[LFf])?"
syn match pyNumber "\v<0[Xx]\x+[_[:xdigit:]]*(uL?|UL?|L)?"
syn match pyNumber "\v<0[Bb][01]+[_01]*(uL?|UL?|L)?"
syn match pyFloat "\v<\d*(\d[eE][-+]?\d+|\.\d+([eE][-+]?\d+)?)[Ff]?"

syn match pyEscapedName "\v`.*`"

syn match pyExclExcl "!!"
syn match pyArrow "->"



hi def link pyStatement Statement
hi def link pyConditional Conditional
hi def link pyRepeat Repeat
hi def link pyOperator Operator
hi def link pyKeyword Keyword
hi def link pyException Exception
hi def link pyReservedKeyword Error

hi def link pyInclude Include

hi def link pyType Type
if g:python_collections == 1
    hi def link pyCollections Type
endif
hi def link pyModifier StorageClass
hi def link pyStructure Structure
hi def link pyTypedef Typedef

hi def link pyBoolean Boolean
hi def link pyConstant Constant

hi def link pyTodo Todo
hi def link pyShebang Comment
hi def link pyLineComment Comment
hi def link pyComment Comment
hi def link pyCommentMatchGroup Comment
hi def link pyDocComment Comment
hi def link pyDocTag Special
hi def link pyDocTagParam Identifier

hi def link pySpecialChar SpecialChar
hi def link pySpecialCharError Error
hi def link pyString String
hi def link pyCharacter Character

hi def link pyAnnotation Identifier
hi def link pyLabel Identifier

hi def link pySimpleInterpolation Identifier
hi def link pyComplexInterpolationBrace Identifier

hi def link pyNumber Number
hi def link pyFloat Float

hi def link pyExclExcl Special
hi def link pyArrow Structure

let b:current_syntax = 'python'


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