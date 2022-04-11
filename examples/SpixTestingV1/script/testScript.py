#!/usr/bin/env python3


import xmlrpc.client

s = xmlrpc.client.ServerProxy('http://localhost:9000')
print("Available Methods:")
print(s.system.listMethods())
s.mouseClick("mainWindow/button00")
s.wait(200)
s.mouseClick("mainWindow/button01")
s.wait(200)
s.mouseClick("mainWindow/button01")
s.wait(200)
s.mouseClick("mainWindow/button00")
s.wait(200)
s.mouseClick("mainWindow/button00")
s.wait(200)
s.mouseClick("mainWindow/button01")
s.wait(200)
s.mouseClick("mainWindow/button00")
s.wait(200)
s.mouseClick("mainWindow/button00")
s.wait(200)
s.mouseClick("mainWindow/button00")
s.wait(200) 
s.mouseClick("mainWindow/button01")
s.wait(200)
resultText = s.getStringProperty("mainWindow/results", "text")
print("Result:\n{}".format(resultText))

