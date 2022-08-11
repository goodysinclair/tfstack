# tfstack
Holds the tfstack shell script for managing terraform backends and encouraging tagging through ease of use.   

To use it, you'll need a a terraform remote state bucket, the name of which is,   
stored in SSM Parameter Store named "/infrastructure/terraform/state-bucket"   
You'll also need a dynamodb table named TerraformLockDB for state locking.   
   
Additionally, you'll need to be in a github repository in order to run most of the options. This is to encourage code getting into version control.   
   
One nice benefit of this script is the ability to add modules easily.    
The script is meant to work with a modules repository in two parts.   
First, the modules themselves, and secondly, a 'tfstack' root module directory.   


