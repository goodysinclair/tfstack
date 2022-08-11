#!/bin/sh

############################################
# add functions BEFORE main()
# call them from main BEFORE userdata_end
# see your_function example
############################################

##so we can see from the system log via the AWS console:
userdata_begin() {
  echo "userdata-started" >> /var/log/messages
}

##so we can see from the system log via the AWS console:
userdata_end() {
  echo "userdata-finished-$return_status" >> /var/log/messages
}

##set return_status to true:
exit_clean() {
  return_status=true
}

##set return_status to false:
exit_dirty() {
  return_status=false
}

#your_function() {
#
#}
 
main() {
  userdata_begin || exit_dirty
  #your_function
  userdata_end && exit_clean
}

main

exit 0

