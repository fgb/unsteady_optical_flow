#
# ImageProc commander to request image data
#
# Created: 2009-2-9
# Author: fgb
#

import serial, sys, os
from PIL import Image

# Check and parse arguments
if len(sys.argv) < 5:
    print "Not enough arguments given. Need serial port, path to experimental data, number of pictures requested, and position marker."
    sys.exit()

port = sys.argv[1] # serial port for the current bluetooth module.
path = sys.argv[2] # path to the place where all experimental data resides.
quant = int(sys.argv[3]) # number of pictures required at this position.
pos = sys.argv[4] # position where these pictures were taken from.

# Extract experiment name from folder name, creating folder if necessary
if path[len(path)-1] != '/':
    path = path + '/'
name = os.path.split(path[:len(path)-1])[1]

if not os.path.exists(path):
    print "Directory doesn't exist! Creating it..."
    os.mkdir(path)

# Open serial port
ser = serial.Serial('/dev/tty.' + port, 230400, timeout=15, rtscts=1)

#*** Image request
h = 160
v = 100
im = Image.new("L",(h,v))
imarray = im.load()

for num in range(quant):
    ser.flushInput()
    ser.flushOutput()

    print "\nRequesting image " + str(num)

    ser.write(chr(1)) # image command
    ser.write(chr(0)) # delay [s]
    
    for j in range(0,v):
        for i in range(0,h):
            imarray[i,j] = ord(ser.read())

    im.save(path + name + "_" + pos + "_" + str(num) + ".png", "PNG")
    #im.show()
