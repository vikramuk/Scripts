#https://media.readthedocs.org/pdf/python-can/latest/python-can.pdf
#http://www.peak-system.com/Downloads.76.0.html?
>>> print t2
0.000000    00000000    010    5    01 02 03 04 05
>>> print(Message(extended_id=False))
0.000000        0000    000    0
>>> print(Message(extended_id=True))
0.000000    00000000    010    0
>>> print(Message(extended_id=False, arbitration_id=100))
0.000000        0064    000    0
>>> print(Message(dlc=1))
0.000000    00000000    010    1
>>> print(Message(dlc=5))
0.000000    00000000    010    5
>>> print(Message(extended_id=False, arbitration_id=100, dlc=6))
0.000000        0064    000    6
>>> print (can.Message(dlc=5, data=[2,2]))
0.000000    00000000    010    5    02 02
>>> print (can.Message(dlc=4, extended_id=True,arbitration_id=100, data=[1,2,3,4,5]))
0.000000    00000064    010    4    01 02 03 04 05


import can
can_interface = 'vcan0'

bus = can.interface.Bus(can_interface, bustype='socketcan_native')
message = bus.recv()

message = bus.recv(1.0) # Timeout in seconds.
if message is None:
    print('Timeout occurred, no message.')
    
    
    
from __future__ import print_function
import can

def main():
	bus = can.interface.Bus()
	msg = can.Message(arbitration_id=0xc0ffee,data=[0, 25, 0, 1, 3, 1, 4, 1],extended_id=False)
	if bus.send(msg) < 0:
		print("Message NOT sent")
	else:
		print("Message sent")

if __name__ == "__main__":
	main()
    
