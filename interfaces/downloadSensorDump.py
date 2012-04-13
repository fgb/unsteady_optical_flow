#!/usr/bin/python
#
# Copyright (c) 2010, Regents of the University of California
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# - Redistributions of source code must retain the above copyright notice,
#   this list of conditions and the following disclaimer.
# - Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
# - Neither the name of the University of California, Berkeley nor the names
#   of its contributors may be used to endorse or promote products derived
#   from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#
#
# Request a sensor dump
#
# by Fernando L. Garcia Bermudez
#
# v.beta
#
# Revisions:
#  Fernando L. Garcia Bermudez     2010-9-11    Initial release       
#

import sys, time, serial, numpy as np


#*** Program ***#

# Check and parse arguments
if len(sys.argv) < 5:
    print("Not enough arguments given. Need serial port, path/, duty cycle, and experiment name.")
    sys.exit()

port = sys.argv[1] # serial port for the current bluetooth module
path = sys.argv[2] # path to the place where all experimental data resides ending in /.
dcval = int(sys.argv[3]) # duty cycle to run the motor at. 
name = sys.argv[4] # name of the experiment, also the prefix of the filename.

root = path + name + '_' + str(dcval)

# Open serial port
ser = serial.Serial('/dev/tty.' + port, 230400, timeout=60, rtscts=1)
ser.flushInput()
ser.flushOutput()

time.sleep(1)


#*** Memory contents request
print("\nRequesting memory contents...")
ser.write(chr(5)) # get mem contents command

# Get memory details
mem_pages = ord(ser.read())
mem_pagesize = ord(ser.read())
print(mem_pages, mem_pagesize)

# Receive memory contents
mem_contents = np.zeros((mem_pages,mem_pagesize), dtype=np.int8)
for pagecnt in range(mem_pages):
    for bytecnt in range(mem_pagesize):
        mem_contents[pagecnt,bytecnt] = ord(ser.read())
print("..." + str(pagecnt+1) + " pages transferred.\n")

# Save memory contents
np.savetxt(root + '_mem_contents.txt', mem_contents)
