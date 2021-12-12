# Running a QRL node on a Raspberry Pi 4

Running a [QRL](https://www.theqrl.org/) node strengthens the network, supports the decentralization and further verifies transactions on the network. 

This project is a PoC developped during the [QRL Winter Hackathon 2021](https://www.theqrl.org/blog/qrl-winter-hackathon-2021/).

## Node setup

1) [Download and flash Raspberry Pi OS](https://www.raspberrypi.com/software/). 
		
	- Tests were done with [`Raspberry Pi OS with desktop`](https://www.raspberrypi.com/software/operating-systems/#raspberry-pi-os-32-bit) (with the Rapsberry Pi imager, choose Raspberry Pi OS (32-bit))
	
2) Boot the Raspberry Pi and connect to a network.

3) Open a terminal and download the installation script. Make the script executable.

	    $ wget https://github.com/0xFF0/QRL_rpi/Install_qrl_node_pi.sh
	    $ chmod +x Install_qrl_node_pi.sh
	
4) Run the script (it takes approximatively 2 hours to setup everything).

	    $ ./Install_qrl_node_pi.sh


5) When you’re done, you can start the QRL node. 

	    $ start_qrl
