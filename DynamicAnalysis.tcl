##########################################################
#                                                         #
#                 BridgePM                                #
#   Created by:   Arash Saeidpour                         #
#                 University of Georgia                   #
#                                                         #
#                                                         #
###########################################################


# Rayleigh Damping
# calculate damping parameters
## set zeta 0.005;		# percentage of critical damping
set a0 [expr $zeta*2.0*$w1*$w2/($w1 + $w2)];	                # mass damping coefficient based on first and second modes
set a1 [expr $zeta*2.0/($w1 + $w2)];			        # stiffness damping coefficient based on first and second modes



#### Assigining damping to deck longitudinal elements
				
for {set i 1} {$i <= $numberofspans} {incr i} {
set dampingrangecounter [expr $dampingrangecounter+1]
region $dampingrangecounter -eleRange  $decklongelements($i,1) $decklongelements($i,$lastdecklongelement($i))  -rayleigh 0.0 0.0 $a1 0.0;	        # assign stiffness proportional damping to frame beams & columns w
}




#### Assigining damping to capbeam elements

for {set i 2} {$i <= $numberofspans} {incr i} {
set dampingrangecounter [expr $dampingrangecounter+1]
region $dampingrangecounter -eleRange  $capbeamelement($i,1) $capbeamelement($i,[expr $colcounter($i)+$NumGirders-1])  -rayleigh 0.0 0.0 $a1 0.0;	        # assign stiffness proportional damping to frame beams & columns w
}




#### Assigining damping to column elements

for {set i 2} {$i <= $numberofspans} {incr i} {
for {set j 1} {$j <= $numofcolumns} {incr j} {
set dampingrangecounter [expr $dampingrangecounter+1]
region $dampingrangecounter -eleRange  $columnelement($i,$j,1) $columnelement($i,$j,$columndivisions)  -rayleigh 0.0 0.0 $a1 0.0;	        # assign stiffness proportional damping to frame beams & columns w
}
}

#### Assigin damping to deck long nodes

for {set i 1} {$i <= $numberofspans} {incr i} {
set dampingrangecounter [expr $dampingrangecounter+1]
region $dampingrangecounter -nodeRange  $decklongnodes($i,1) $decklongnodes($i,[expr $DeckDivisions+1])  -rayleigh $a0 0.0 0.0 0.0;	        # assign stiffness proportional damping to frame beams & columns w
}

#### Assigin damping to capbeam nodes

for {set i 2} {$i <= $numberofspans} {incr i} {
set dampingrangecounter [expr $dampingrangecounter+1]
region $dampingrangecounter -nodeRange  $capbeamnodes($i,1) $capbeamnodes($i,[expr $colcounter($i)+$NumGirders])  -rayleigh $a0 0.0 0.0 0.0;	        # assign stiffness proportional damping to frame beams & columns w
}


#### Assigin damping to Column nodes

for {set i 2} {$i <= $numberofspans} {incr i} {
for {set j 1} {$j <= $numofcolumns} {incr j} {
set dampingrangecounter [expr $dampingrangecounter+1]
region $dampingrangecounter -nodeRange  $columnnode($i,$j,1) $columnnode($i,$j,$columndivisions)  -rayleigh $a0 0.0 0.0 0.0;	        # assign stiffness proportional damping to frame beams & columns w
}
}



##### Performing nonlinear analysis

#set rightdeckmiddleelastomernode [expr $elastomerright(1)+$NumGirders/2]
#set deckmiddlenode [expr $decklongnodes(1)+$DeckDivisions/2]


##source output.tcl; ### File containing output inqueries




set horizontalpath 6
set verticalpath 7
set BendingMoment 8 


timeSeries Path $horizontalpath -dt $LoadingDT -filePath "$dataDir/Loading time histories/horizontal.in"

pattern Plain 6  $horizontalpath {
    
  for {set i 1} {$i <= $numberofspans} {incr i} {   
    eleLoad -range $decklongelements($i,1) $decklongelements($i,$lastdecklongelement($i))  -type -beamUniform   0.    1.    0.
  }  
}


timeSeries Path $verticalpath -dt $LoadingDT -filePath "$dataDir/Loading time histories/vertical.in"

pattern Plain 7  $verticalpath {
    
  for {set i 1} {$i <= $numberofspans} {incr i} {   
    eleLoad -range $decklongelements($i,1) $decklongelements($i,$lastdecklongelement($i))  -type -beamUniform   1.    0.    0.
  }  
}


timeSeries Path $BendingMoment -dt $LoadingDT -filePath "$dataDir/Loading time histories/moment.in"

pattern Plain 8  $BendingMoment {
    
  for {set i 1} {$i <= $numberofspans} {incr i} {   
    load  $decklongnodes($i,1)  0. 0. 0. [expr $DeckNodesSpacing/2] 0. 0.
            for {set j 2} {$j <= [expr $DeckDivisions]} {incr j} { 
            load  $decklongnodes($i,$j)   0. 0. 0. $DeckNodesSpacing 0. 0.
            }
    load  $decklongnodes($i,[expr $DeckDivisions+1])  0. 0. 0. [expr $DeckNodesSpacing/2] 0. 0.
  }  
}





test $DynamicTestType $DynamicTestTol $DynamicTelMaxIte 0
#algorithm Broyden  
#algorithm Newton -initial
numberer $DynamicNumberer
#numberer AMD
#constraints Penalty 10e10 10e10
constraints $DynamicConstriants
system UmfPack -lvalueFact 10
#system SparseGeneral
#system BandGeneral
#integrator GeneralizedMidpoint 0.50
#integrator Newmark $gamma $beta
#integrator Newmark 0.5 0.25
#integrator HHT 0.6
#integrator TRBDF2
integrator Newmark 0.6 0.3025
#integrator Newmark 0.5 [expr 1.0/6.0]
#integrator HHT $alpha <$gamma $beta>
#integrator HHT 1.0
#integrator HHT 1.0 0.5 0.25
#set HHTalpha 1.0;
#integrator HHT $HHTalpha [expr 1.5-$HHTalpha] [expr pow((2-$HHTalpha),2)/4]
analysis Transient
#analyze $NPTS $DT;                                                                      # apply 1000 0.02-sec time steps in analysis

#set DT .01
#set timeStepReduction 10
set tCurrent [getTime]
#set tFinal 6
set ok 0

set MaximumDeckHorizontalDisplacement 0
set MaximumDeckVerticalDisplacement 0


puts ".. loop of solver ........................................................................ started .."
while {$ok == 0 && $tCurrent < $tFinal && $MaximumDeckHorizontalDisplacement<= $dataline(151) && $MaximumDeckVerticalDisplacement<= $dataline(152)} {
algorithm $DynamicAlgorithm
set ok [analyze 1 [expr $DT]];                                     # actually perform analysis; returns ok=0 if analysis was successful
 
 
 
                                if {$ok != 0} {
                                        set ok [analyze 1 [expr $DT/$timeStepReduction]];
                                        
                                if {$ok == 0} {
            puts "OKKKKKKKKKKKKKtimeStep/$timeStepReduction"
                                }}
 
 
 
 
 
                                if {$ok != 0} {
                                        set ok [analyze 1 [expr $DT/$timeStepReduction]];
                                        
                                if {$ok == 0} {
            puts "OKKKKKKKKKKKKKtimeStep/$timeStepReduction"
                                }}
 
 
 
 
 
 
                                if {$ok != 0} {
                                                puts "Trying Broyden .."
                                                algorithm Broyden
                  set ok [analyze 1 [expr $DT/$timeStepReduction]];                                           # actually perform analysis; returns ok=0 if analysis was successful
 
                                if {$ok == 0} {
            puts "OKKKKKKKKKKKKK44444"
                                }}
 
 
                                if {$ok != 0} {
                  puts "NG"
                                                puts "Trying KrylovNewton .."
                                                algorithm KrylovNewton
                  set ok [analyze 1 [expr $DT/$timeStepReduction]];                                           # actually perform analysis; returns ok=0 if analysis was successful
                                if {$ok == 0} {
            puts "OKKKKKKKKKKKKK33333"
                                }}
 
               
                                if {$ok != 0} {
                  puts "NG"
                                                puts "Trying Newton -initial .."
                                                algorithm Newton -initial
                  set ok [analyze 1 [expr $DT/$timeStepReduction]];                                           # actually perform analysis; returns ok=0 if analysis was successful
                                if {$ok == 0} {
            puts "OKKKKKKKKKKKKK33333"
                                }}
                               
 
                               
                                if {$ok != 0} {
                  puts "NG"
                                                puts "Trying ModifiedNewton .."
                                                algorithm ModifiedNewton
                  set ok [analyze 1 [expr $DT/$timeStepReduction]];                                           # actually perform analysis; returns ok=0 if analysis was successful
                                if {$ok == 0} {
            puts "OKKKKKKKKKKKKK55555"
                                }}
 
                                if {$ok != 0} {
                  puts "NG"
                                                puts "Trying Newton .."
                                                algorithm Newton
                  set ok [analyze 1 [expr $DT/$timeStepReduction]];                                           # actually perform analysis; returns ok=0 if analysis was successful
                                if {$ok == 0} {
            puts "OKKKKKKKKKKKKK66666"
                                }}
 
                                if {$ok != 0} {
                  puts "NG"
                                                puts "Trying ModifiedNewton -initial .."
                                                algorithm ModifiedNewton -initial
                  set ok [analyze 1 [expr $DT/$timeStepReduction]];                                           # actually perform analysis; returns ok=0 if analysis was successful
                                if {$ok == 0} {
            puts "OKKKKKKKKKKKKK77777"
                                }}
 
                                if {$ok != 0} {
 
                  puts "NG"
                                                puts "Trying BFGS .."
                                                algorithm BFGS
                  set ok [analyze 1 [expr $DT/$timeStepReduction]];                                           # actually perform analysis; returns ok=0 if analysis was successful
                                if {$ok == 0} {
            puts "OKKKKKKKKKKKKK88888"
                                }}
                               
                                if {$ok != 0} {
                  puts "NG"
                                                puts "Trying RCM .."
                                                numberer RCM
                  set ok [analyze 1 [expr $DT/$timeStepReduction]];                                           # actually perform analysis; returns ok=0 if analysis was successful
                                if {$ok == 0} {
            puts "OKKKKKKKKKKKKK99999"
                                }}
               
                                if {$ok != 0} {
                  puts "NG"
                                                puts "Trying BandGeneral .."
                                                system BandGeneral
                  set ok [analyze 1 [expr $DT/$timeStepReduction]];                                           # actually perform analysis; returns ok=0 if analysis was successful
                                if {$ok == 0} {
            puts "OKKKKKKKKKKKKK99999"
                                }}
 
                                if {$ok != 0} {
                  puts "NG"
                                                puts "Trying UmfPack .."
                                                system UmfPack
                  set ok [analyze 1 [expr $DT/$timeStepReduction]];                                           # actually perform analysis; returns ok=0 if analysis was successful
                                if {$ok == 0} {
            puts "OKKKKKKKKKKKKK99999"
                                }}
 
                                if {$ok != 0} {
                  puts "NG"
                                                puts "Trying SparseGEN .."
                                                system SparseGEN
                  set ok [analyze 1 [expr $DT/$timeStepReduction]];                                           # actually perform analysis; returns ok=0 if analysis was successful
                                if {$ok == 0} {
            puts "OKKKKKKKKKKKKK99999"
                                }}
 
                                if {$ok != 0} {
                  puts "NG"
                                                puts "Trying EnergyIncr 1.0e-4 40 .."
                                                test EnergyIncr 1.0e-2 1000
                  set ok [analyze 1 [expr $DT/$timeStepReduction]];                                           # actually perform analysis; returns ok=0 if analysis was successful
                                if {$ok == 0} {
            puts "OKKKKKKKKKKKKK99999"
                                }}
 
                                if {$ok != 0} {
                  puts "NG"
                                                puts "Trying NormUnbalance 1.0e-4 40 .."
                                                test NormUnbalance 1.0e-4 40
                  set ok [analyze 1 [expr $DT/$timeStepReduction]];                                           # actually perform analysis; returns ok=0 if analysis was successful
                                if {$ok == 0} {
            puts "OKKKKKKKKKKKKK99999"
                                }}
 
                                if {$ok != 0} {
                  puts "NG"
                                                puts "Trying RelativeNormDispIncr 1.0e-4 40 .."
                                                test RelativeNormDispIncr 1.0e-4 40
                  set ok [analyze 1 [expr $DT/$timeStepReduction]];                                           # actually perform analysis; returns ok=0 if analysis was successful
                                if {$ok == 0} {
            puts "OKKKKKKKKKKKKK99999"
                                }}
 
 
set tCurrent [getTime]
 
puts "Run $RunCounter Dynamic Analysis Progress: [getTime] / $tFinal"

for {set i 1} {$i <= $numberofspans} {incr i} { 


set DeckLeftNodeHorizontalDisplacement($i)   [expr abs([nodeDisp $decklongnodes($i,1) 3])]
set DeckMiddleNodeHorizontalDisplacement($i) [expr abs([nodeDisp $decklongnodes($i,[expr int(ceil($DeckDivisions/2))]) 3])] 
set DeckRightNodeHorizontalDisplacement($i)  [expr abs([nodeDisp $decklongnodes($i,[expr $DeckDivisions+1]) 3])]


###set MaximumDeckHorizontalDisplacement [expr max($DeckLeftNodeHorizontalDisplacement($i),$DeckMiddleNodeHorizontalDisplacement($i),$DeckRightNodeHorizontalDisplacement($i),$MaximumDeckHorizontalDisplacement)]; ## becasue of the obsolote tcl version this line has benn replaced with the below code

set tempvar1 $DeckLeftNodeHorizontalDisplacement($i)
set tempvar2 $DeckMiddleNodeHorizontalDisplacement($i)
set tempvar3 $DeckRightNodeHorizontalDisplacement($i)
set tempvar4 $MaximumDeckHorizontalDisplacement
 


if {$tempvar1>$tempvar2 } {
set tempout1 $tempvar1;
} else {
set tempout1 $tempvar2;
}


if {$tempvar3>$tempvar4 } {
set tempout2 $tempvar3;
} else {
set tempout2 $tempvar4;
}

if {$tempout1>$tempout2 } {
set MaximumDeckHorizontalDisplacement $tempout1;
} else {
set MaximumDeckHorizontalDisplacement $tempout2;
}






set DeckLeftNodeVerticalDisplacement($i)   [expr abs([nodeDisp $decklongnodes($i,1) 2])]
set DeckMiddleNodeVerticalDisplacement($i) [expr abs([nodeDisp $decklongnodes($i,[expr int(ceil($DeckDivisions/2))]) 2])] 
set DeckRightNodeVerticalDisplacement($i)  [expr abs([nodeDisp $decklongnodes($i,[expr $DeckDivisions+1]) 2])]

##set MaximumDeckVerticalDisplacement [expr max($DeckLeftNodeVerticalDisplacement($i),$DeckMiddleNodeVerticalDisplacement($i),$DeckRightNodeVerticalDisplacement($i),$MaximumDeckVerticalDisplacement)]; ## becasue of the obsolote tcl version this line has benn replaced with the below code

set tempvar1 $DeckLeftNodeVerticalDisplacement($i)
set tempvar2 $DeckMiddleNodeVerticalDisplacement($i)
set tempvar3 $DeckRightNodeVerticalDisplacement($i)
set tempvar4 $MaximumDeckVerticalDisplacement
 


if {$tempvar1>$tempvar2 } {
set tempout1 $tempvar1;
} else {
set tempout1 $tempvar2;
}


if {$tempvar3>$tempvar4 } {
set tempout2 $tempvar3;
} else {
set tempout2 $tempvar4;
}

if {$tempout1>$tempout2 } {
set MaximumDeckVerticalDisplacement $tempout1;
} else {
set MaximumDeckVerticalDisplacement $tempout2;
}



  
}





}

if {$ok != 0} {
                        puts "Simulation ran into a problem, solve it please!"
            }

if {$ok == 0} {
                        puts "Enjoy!"
            }




















