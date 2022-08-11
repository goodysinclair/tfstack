# EC2 Instance

## This module creates an EC2 instance. 
By default it will create the instance in private-subnet-1 in any given account.   
It assigns a couple of default security groups, feel free to   
add additional ones.   

There is a default 'user data' file available for modification.   
   
If you would like to create a new SSH key for your instance,   
please add the ssh_key module:   
   
> tfstack -am ssh_key   
   
