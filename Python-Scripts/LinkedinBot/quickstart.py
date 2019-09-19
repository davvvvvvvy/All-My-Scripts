from linkedinbot.LinkedinBot import LinkedinBot

username = "your_username"
password = "your_password"
time = 10

lb = LinkedinBot(username, password, times)
lb.login()
lb.click_conn()
lb.close_driver()