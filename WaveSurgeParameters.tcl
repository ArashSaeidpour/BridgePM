##########################################################
#                                                         #
#                 BridgePM                                #
#   Created by:   Arash Saeidpour                         #
#                 University of Georgia                   #
#                                                         #
#                                                         #
###########################################################

#########
#########  This wind speed convertion equation will only be used when there is no U3sec availavle
##set UtbarMilesPerHour 100; ## Wind speed given for Elevation Z, which is different from the standard standard elevation(miles/hours)
##set Utbar [expr $UtbarMilesPerHour*1.466666]; # convert UtbarMilesPerHour from miles/hour to ft/sec
##set Z 20; ## elevation, other than the standard elevation, for which wind speeds are given(ft)
##set Ut [expr $Utbar*pow(32.8/$Z,1.0/7.0)];  ####   wind speed at the standard elevation for a given duration,t (ft/sec)
################
#################
set gfts 32.174; ## Gravitional Constant in ft/s^2
set dinft [expr $d*3.28084] ; ## average water depth over the fetch lengthincluding surge, astronomical tide, and local wind set up (ft)
set Finft [expr $F*3.28084] ; ## Fetch length in the direction of the wind from the upwind shore(ft)
set U3secinft [expr $U3sec*3.28084]; ## Design wind velocity at the standard 32.8ft elevation and averaged for a duration of 3 seconds(ft/s)
#set pi [expr acos(-1)]
set dsinft [expr  $ds*3.28084]; # water depth at or near the bridge, including surge, astronimical tide, and local wind set-up (ft)
#set windduration(1) 3 


#set Ut(1) $U3secinft
#puts "U3sec=$U3secinft"
#set counter 1
#set condition 0
#set BaseWindDuration 3;
set U10minutes [expr 0.70*$U3secinft]; ### design wind velocity at the standard 32.2 ft elevation and averaged for a duration of 10 minutes(ft/s)

set UtBase $U10minutes;
set UtNew 0;  

set tbase 600
set tnew $tbase
set counter 1
puts "UBase=$UtBase"
while {$counter<10} {
set counter [expr $counter+1]
set Uasteriskt [expr 0.539*pow($UtBase,1.23)]; ## wind-stress factor (ft/sec)
puts "Ust=$Uasteriskt"
set Tp [expr 7.54*tanh(0.833*pow(($gfts*$dinft)/($Uasteriskt*$Uasteriskt),3.0/8.0))*tanh((0.0379*pow(($gfts*$Finft)/($Uasteriskt*$Uasteriskt),1.0/3.0))/tanh(0.833*pow(($gfts*$dinft)/($Uasteriskt*$Uasteriskt),3.0/8.0)))*($Uasteriskt/$gfts)];  ###   Wave period in sec
puts "Tp=$Tp"
set tnew [expr 537*pow(($gfts*$Tp)/($Uasteriskt),7.0/3.0)*($Uasteriskt/$gfts)] ; ### the time duration required to develope a fetch limited wave, duration of Ut (sec)

#set jupito [expr tanh(0.9*log10(45.0/$windduration($counter)))]

####set U1hour($counter) [expr $Ut($counter)/(1.277+0.296*tanh(0.9*log10(45.0/$windduration($counter))))] ; ## One hour average wind speed justified from Ut



if {$tbase<3600 && $tbase>1} {
set U1hour [expr $UtBase/(1.277+0.296*tanh(0.9*log10(45.0/$tbase)))] ; ## One hour average wind speed justified from Ut
} else {
set U1hour [expr $UtBase/(-0.15*log10($tbase)+1.5334)]; ## new Ut justified from U1hour
}




if {$tnew<3600 && $tnew>1} {
set UtNew [expr $U1hour*(1.277+0.296*tanh(0.9*log10(45/$tnew)))];  ## new Ut justified from U1hour
} else {
set UtNew [expr $U1hour*(-0.15*log10($tnew)+1.5334)]; ## new Ut justified from U1hour
}

set tbase $tnew
set UtBase $UtNew

}
puts "Tp=$Tp"

set counter [expr $counter-1]
set Hs [expr 0.283*tanh(0.53*pow(($gfts*$dinft)/($Uasteriskt*$Uasteriskt),3.0/4.0))*tanh((0.00565*pow(($gfts*$Finft)/($Uasteriskt*$Uasteriskt),1.0/2.0))/tanh(0.53*pow(($gfts*$dinft)/($Uasteriskt*$Uasteriskt),3.0/4.0)))*($Uasteriskt*$Uasteriskt/$gfts)]; ## The significant wave height
puts "Hs=$Hs"
puts "d=$d"
puts "F=$F"
puts "ds=$ds"
puts "U3sec=$U3sec"





puts " Hs"
puts $Hs
set lambda [expr (($gfts*$Tp*$Tp)/(2*$pi))*sqrt(tanh((4*$pi*$pi*$dsinft)/($Tp*$Tp*$gfts)))];
puts " Lambda"
puts $lambda

set vtc [info tclversion]
puts "tcl version $vtc"




#set Hmax [min 1.8*$Hs 0.65*$dsinft $lambda/7.0] ; # because of obsolote tcl version on the server, the min and max functions are not available thus the below code is used instead

set hmax1 [expr 1.8*$Hs];
set hmax2 [expr 0.65*$dsinft];
set hmax3 [expr $lambda/7.0];

if {$hmax1<$hmax2 && $hmax1<$hmax3} {
set Hmax $hmax1;
} elseif {$hmax2<$hmax1 && $hmax2<$hmax3 } {
set Hmax $hmax2;
} else {
set Hmax $hmax3;
}




puts $Hmax
puts "control 1"
set etamax [expr 0.7*$Hmax]
puts "control 2"
set Tpfinal $Tp ; ## Final wave period obtained from iterative loop
puts "control 3"
puts "etamax"
puts $etamax
puts "Tpfinal"
puts $Tpfinal


set fp [open "$dataDir/Wave parameters.txt" w+]

puts $fp "Wave Period=" 
puts $fp $Tpfinal

puts $fp "Loading Dt="
puts $fp $LoadingDT

puts $fp "Hmax="
puts $fp $Hmax


puts $fp "etamax="
puts $fp $etamax

puts $fp " Lambda="
puts $fp $lambda

puts $fp "U3sec="
puts $fp $U3sec

puts $fp "Uasterisk="
puts $fp $Uasteriskt



###close $fp

puts "end of surge and wave parameters module"
