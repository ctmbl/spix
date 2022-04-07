#!/usr/bin/env python3


import xmlrpc.client

s = xmlrpc.client.ServerProxy('http://localhost:9000')
print("[+] Available Methods:")
for method in s.system.listMethods():
    print("\t- ","{:20s}".format(method), " : ", end="")
    print(s.system.methodHelp(method))

s.mouseClick("mainWindow/Button_1")
s.wait(200)
s.mouseClick("mainWindow/Button_2")
s.wait(200)
s.mouseClick("mainWindow/Button_2")
s.wait(200)
s.mouseClick("mainWindow/Button_2")
s.wait(200)
s.mouseClick("mainWindow/Button_1")
s.wait(200)
s.mouseClick("mainWindow/Button_2")
s.wait(200)
s.mouseClick("mainWindow/Button_1")
s.wait(200)
s.mouseClick("mainWindow/Button_1")
s.wait(200)
s.mouseClick("mainWindow/Button_1")
s.wait(200)
s.mouseClick("mainWindow/Button_2")
s.wait(200)
resultText = s.getStringProperty("mainWindow/results", "text")
print("Result:\n{}".format(resultText))
s.quit()
