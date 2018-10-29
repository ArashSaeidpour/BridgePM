##########################################################
#                                                         #
#                 BridgePM                                #
#   Created by:   Arash Saeidpour                         #
#                 University of Georgia                   #
#                                                         #
#                                                         #
###########################################################

set RecorderCounter 1
set RunCounter 1;
for {set RunCounter 1} {$RunCounter <= 10} {incr RunCounter} {

set address ""
append address "Run" $RunCounter "/" "Run" $RunCounter ".txt"
puts $address
set fp [open $address r]
     set file_data [read $fp]
     close $fp

  #  Process data file
     set data [split $file_data "\n"]

set counter 1

     foreach line $data {
         set dataline($counter)  $line
         puts "line $counter"
          puts $dataline($counter)
incr counter
puts "  "
   
     }

source sequencewithcontact.tcl
set  RecorderCounter [expr 20000*($RunCounter-1)+1];  ### counter used to creat recorder files
}
