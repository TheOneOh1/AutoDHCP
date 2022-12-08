# AutoDHCP

- Automating DHCP Server configuration with Bash
- Client Configuration is not mentioned here as it has to be done manually
- As of now you have to manually install the DHCP package with </br>
`sudo apt install isc-dhcp-server` </br>

### How to use?

- You can directly use the code or clone the repo

  ``bash AutoDHCPilot.sh``

- It will ask for details to that to be filled out by user and configuration will be automated
  
  > - Provide Domain Name </br>
  > - Provide Subnet (eg. 192.168.80.0) </br>
  > - Provide Option Routers (eg. 192.168.80.1) </br>
  > - Provide IP Pool with Starting and Ending IP address </br>

- At the end it will show which IP has been assigned yet.

### Output

![](https://github.com/TheOneOh1/AutoDHCP/blob/main/carbon%20(1).png)

### Client Side

- First check the network interface of client machine (eg. ens33, eth0)
- Open the Interfaces file </br>
`sudo nano /etc/network/interfaces` </br>
  And enter the following details </br>
   ```
   auto <interface-name>
   iface <interface-name>inet dhcp
   ```
- Once done restart the network or reboot the system </br>
`systemctl restart networking` </br>
`dhclient -4` </br>
