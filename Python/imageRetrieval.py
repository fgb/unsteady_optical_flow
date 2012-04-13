#
# ImageProc commander to request image data
# Created on 2010-2-5 by fgb
#

import serial, PIL, time
from PIL import Image

ser = serial.Serial('/dev/tty.ImageProc_3-SPP', 230400, timeout=15, rtscts=1)
ser.flushInput()
ser.flushOutput()

#*** Image request
print "\nRequesting an image..."
ser.write(chr(1)) # image command
ser.write(chr(2)) # 2s delay

x = 160
y = 100
k = 0
im = Image.new("L",(x,y))
imarray = im.load()

for j in range(0,y):
    for i in range(0,x):
        imarray[i,j] = ord(ser.read())
        print k, i, j, imarray[i,j]
        k=k+1

print "\n\n...now watch it...\n"

im.show()
