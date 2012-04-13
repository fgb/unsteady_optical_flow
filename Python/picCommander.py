#*********************************************
# Name: picCommander.py
# Desc: ImageProc commander to request image
#       data and PWM duty cycle changes
# Date: 2009-02-9
# Author: fgb, amh
#*********************************************

import serial, PIL, time
from PIL import Image

ser = serial.Serial('/dev/tty.ImageProc-SPP-1', 230400, timeout=15, rtscts=1)
ser.flushInput()
ser.flushOutput()

#*** Duty Cycle update
print
print
print "Changing duty cycle to..."
ser.write(chr(0))  # DC update command
ser.write(chr(50)) # duty cycle
print "this is the value: " + str(ord(ser.read()))

time.sleep(2)

#*** Image request
#print
#print "Requesting an image..."
#ser.write(chr(1)) # image command
#ser.write(chr(2)) # 2s delay

#x = 160
#y = 100
#k = 0
#im = Image.new("L",(x,y))
#imarray = im.load()

#for j in range(0,y):
#    for i in range(0,x):
#        imarray[i,j] = ord(ser.read())
#        print k, i, j, imarray[i,j]
#        k=k+1

#print
#print
#print "...now watch it..."
#print

#im.show()

#time.sleep(2)

#*** Video request
print
print "Requesting a video..."
ser.write(chr(2)) # video command
ser.write(chr(2)) # 2s delay

x = 18
y = 13
z = 60
k = 0
im = Image.new("L",(x,y*z))
imarray = im.load()

for j in range(0,y*z):
    for i in range(0,x):
        imarray[i,j] = ord(ser.read())
        print k, i, j, imarray[i,j]
        k=k+1

print
print
print "...now watch it..."
print

im.show()

time.sleep(0)

#*** Stop motor
print
print "Stopping the motor..."
ser.write(chr(0))
ser.write(chr(0))
print ord(ser.read())

print
print
print "...Done."
print
