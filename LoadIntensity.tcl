##########################################################
#                                                         #
#                 BridgePM                                #
#   Created by:   Arash Saeidpour                         #
#                 University of Georgia                   #
#                                                         #
#                                                         #
###########################################################


set MaxColumnHeigthinft [expr $MaxColumnHeigth*3.28084] ; # convert from meter to feet

set DeckWidthinft [expr $DeckWidth*3.28084] ; # convert from meter to feet

set RailHeigthinft [expr $RailHeigth*3.28084] ; ## Railheight in foot

set dsinft [expr $ds*3.28084]; ### convert from meter to feet


puts "control 1"

#########          ############## Maximum Vertical Force
########          ##############
#set PercentAirSwitch 1 ; ## Switch between minimum and maximum values for trapped air, 1 for maximum, 0 for minimum
set waterdensity 0.064; ## unit weight of water(kips/ft^3)
set Zc [expr $MaxColumnHeigthinft-$dsinft]; # Vertical distance from bottom of cross section to the storm water level, positive if storm water level is below the bottom of the cross section(ft)
set dbinft [expr $db*3.28084]; # Girder height plus slab thickness for girder bridges
set Wbar [expr $lambda-(double($lambda)/$Hmax)*(double($Zc)+$Hmax/2.0)]
set WbarRatio [expr $Wbar/$DeckWidthinft]
set dginft [expr $dg*3.28084] ; ## Girder height for girder bridges (ft)
if {$WbarRatio<0.15} {
set Wbar [expr 0.15*$DeckWidthinft]
}

puts "control 2"

set BetaCriterion [expr $etamax-$Zc]

if {$BetaCriterion<=0} {
set Beta 0
} elseif { $BetaCriterion <= $dbinft } {
set Beta [expr $BetaCriterion/$dbinft]
} else {
set Beta 1
}

puts "control 3"

set b0 [expr -0.1*double($dginft)-0.588]
set b1 [expr -0.18*double($dginft)+56.7]
set b2 [expr 0.0028*double($dginft)+0.0454]
set b3 [expr 0.2352*double($dginft)-193.6]
set b4 [expr -0.00006*double($dginft)-0.0003]
set b5 [expr 0.184*double($dginft)-0.608]
set b6 [expr 2.1*double($dginft)+1.56]

puts "control 4"


set Aair [expr 0.0123-0.0045*exp(-$Zc/double($etamax))+0.0014*log(double($DeckWidthinft)/$lambda)]
set Bair [expr exp(-2.477+1.002*exp(-$Zc/double($etamax))-0.403*log(double($DeckWidthinft)/$lambda))]


puts "control 5"


set PercentAirCriterion [expr $BetaCriterion/$dginft] 

if {$PercentAirCriterion>0 && $PercentAirCriterion<=1} {
set MinPercentAir [expr 100*(1-$PercentAirCriterion)]
} elseif { $PercentAirCriterion>1 } {
set MinPercentAir 0
} else {
set MinPercentAir 0
} 

set PercentAir 100
if {$PercentAirSwitch==0} {
set PercentAir $MinPercentAir
}

puts "control 6"

set TAF [expr $Aair*$PercentAir+$Bair];
if {$TAF > 1} {
set TAF 1
}

puts "control 7"

if {$Zc<0} {
set TAF 1 ; ## This condition has been added because in case of a -Zc/etemax>0 then huge values would be derived for B which is not reasonable
}



set x [expr $Hmax/$lambda]
set y [expr $Wbar/$lambda]

puts "control 8"


set MaxVerForcekips [expr double($waterdensity)*$Wbar*$Beta*(-1.30*(double($Hmax)/double($dsinft))+1.80)*(1.35+0.35*tanh(1.2*double($Tpfinal)-8.5))*(double($b0)+$b1*$x+$b2/$y+$b3*$x*$x+$b4/($y*$y)+($b5*$x)/$y+double($b6)*$x*$x*$x) *double($TAF)] ; ## Maximim vertical force in kips/ft
set MaxVerForce [expr abs(1000.0*14.5939029*double($MaxVerForcekips))]



if {$BetaCriterion<=0} {
set MaxVerForce 10      ### In case of Betacriterion<=0; waves do not reach the deck thus no loads, value of 10 is considered only for convergence problems
}


puts "Maximum Vertical Force=$MaxVerForce"




puts "wbar:"
puts $Wbar
puts "beta:"
puts $Beta
puts "TAF:"
puts $TAF

##################
############################

##### Slamming force
if {[expr $Zc/$etamax]>0 && [expr $Zc/$etamax]<1} {
set SlammingA [expr 0.0149*($Zc/$etamax)+0.0316]
} elseif {[expr $Zc/$etamax]<0} {
set SlammingA [expr 1/(-1562.9+1594.5*exp(-$Zc/$etamax))] 
} else {
set SlammingA 10; ### Waves does not hit the deck because of the clearance, value of 10 is considered for convergence problems
}

puts "A:$SlammingA"

set SlammingB [expr 0.6588*pow($Zc/$etamax,2)+0.5368*($Zc/$etamax)-1.193]
puts "B:$SlammingB"
set SlammingForceKips [expr $SlammingA*$waterdensity*$Hmax*$Hmax*pow($Hmax/$lambda,$SlammingB)]; ### Vertical slamming force in kips/ft
set SlammingForce [expr abs($SlammingForceKips*1000*14.5939029)]; ### Vertical slamming force in N/m
puts "Slamming force=$SlammingForce"



########################
######################

###### Maximum Horizontal Force
if {[expr $Zc/$etamax]>0 && [expr $Zc/$etamax]>1} {

set MaxHorForce 100; ### Waves does not hit the deck because of the clearance, value of 10 is considered for convergence problems
} else {
set omega $DeckWidthinft 
if {[expr $lambda-0.5*($Zc+0.5*$Hmax)*($lambda/$Hmax)]<$DeckWidthinft} {
set omega [expr $lambda-0.5*($Zc+0.5*$Hmax)*($lambda/$Hmax)]
}

puts "omega=$omega"


set FasteriskHmax [expr $waterdensity*$pi*($dbinft+$RailHeigthinft)*($omega+0.5*$Hmax)*($Hmax/$lambda)];
set MaxHorForceKips [expr $FasteriskHmax*exp(-3.18+3.76*exp(-$omega/$lambda)-0.95*pow(log(($etamax-$Zc)/($dbinft+$RailHeigthinft)),2))];  ## maximum horizontal force in kips/ft
set MaxHorForce [expr abs($MaxHorForceKips*1000*14.5939029)]; ## Maximum horizontal force in N/m  
puts "F*=$FasteriskHmax"

}


 


puts " Max Hor Force"
puts $MaxHorForce

























