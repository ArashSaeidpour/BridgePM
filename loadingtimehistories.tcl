##########################################################
#                                                         #
#                 BridgePM                                #
#   Created by:   Arash Saeidpour                         #
#                 University of Georgia                   #
#                                                         #
#                                                         #
###########################################################

#set LoadingDT 0.01;  ### Time steps for which loading values will be generated
set tFinal $Tpfinal ; ### temporary variables, will be transfered to input file
puts " Tp"
puts $tFinal
#set MaxHorForce 20000
#set MaxVerForce 30000
#set SlammingForce 10000
#set pi [expr acos(-1)]
set w [expr (2*$pi)/$tFinal]
set wn [expr ($w)*(8/5)*($NumGirders-1)]
set wa [expr ($w)*(5.0/8.0)]
#set s 0.05
set wd [expr $wn*sqrt(1-$s*$s)]
puts $wd


set hor          [open "$dataDir/Loading time histories/horizontal.in" w+]
set ver          [open "$dataDir/Loading time histories/vertical.in" w+]
set moment       [open "$dataDir/Loading time histories/moment.in" w+]
set counter 1;
for {set t 0} {$t <= $tFinal} {set t [expr $t+$LoadingDT]} {


##set transient($counter) [expr 2.8*ceil(cos($t*($pi/2.0)/($tFinal*(5.0/8.0))))*exp(-$s*$wn*$t)*(sin($wd*$t))*sin($wa*$t)];  ## Slamming force time history

set uvertical($counter) [expr $SlammingForce*2.8*ceil(cos($t*($pi/2.0)/($tFinal*(5.0/8.0))))*exp(-$s*$wn*$t)*(sin($wd*$t))*sin($wa*$t)+$MaxVerForce*sin($w*$t)];  ### verticaltal force including slamming and quasi-static forces
puts $ver $uvertical($counter)
set uhorizontal($counter) [expr $SlammingForce*1.4*ceil(cos($t*($pi/2)/($tFinal*(5.0/8.0))))*exp(-$s*$wn*$t)*(sin($wd*$t))*sin($wa*$t)+$MaxHorForce*ceil(cos((2.0*$t/$tFinal)*($pi/2)))*sin($w*$t)];  ## Horizontal Force including slamming and quasi-static forces
puts $hor $uhorizontal($counter)
 ###    if {$t<=[expr $tFinal/2]} {
        set OverTurningMoment($counter) [expr ($uvertical($counter))*($DeckWidth/2)*(1-(2*$t)/$tFinal)]
 ###     } else {
 ###     set OverTurningMoment($counter) 0
 ###     }

puts $moment $OverTurningMoment($counter)
set counter [expr $counter+1]
}
close $hor
close $ver
close $moment