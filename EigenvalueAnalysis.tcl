##########################################################
#                                                         #
#                 BridgePM                                #
#   Created by:   Arash Saeidpour                         #
#                 University of Georgia                   #
#                                                         #
#                                                         #
###########################################################

##set numModes 3;


#for { set k 1 } { $k <= $numModes } { incr k } {
#    recorder Node -file [format "modes/mode%i.out" $k] -nodeRange 1 27 -dof 1 3  "eigen $k"
#} 



set lambda [eigen  $numModes];

set omega {}
set f {}
set T {}

set pi 3.141593

#puts $lambda


foreach lam $lambda {


	lappend omega [expr sqrt($lam)]


	lappend f [expr sqrt($lam)/(2*$pi)]
	lappend T [expr (2*$pi)/sqrt($lam)]
       

}





set lambda1 [lindex $lambda 0]
set lambda2 [lindex $lambda 1]
#puts $lambda1
#puts $lambda2
set w1 [expr pow($lambda1,0.5)];					# w1 (1st mode circular frequency)
set w2 [expr pow($lambda2,0.5)];				# w2 (2nd mode circular frequency)
set T1 [expr 2.0*$pi/$w1];					# 1st mode period of the structure
set T2 [expr 2.0*$pi/$w2];					# 2nd mode period of the structure

set fp [open "$dataDir/Periods.txt" w+]

puts $fp "T1 = $T1 s";						# display the first mode period in the command window
puts $fp "T2 = $T2 s";

puts  "T1 = $T1 s";						# display the first mode period in the command window
puts  "T2 = $T2 s";


close $fp









	







