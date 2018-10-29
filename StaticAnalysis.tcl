##########################################################
#                                                         #
#                 BridgePM                                #
#   Created by:   Arash Saeidpour                         #
#                 University of Georgia                   #
#                                                         #
#                                                         #
###########################################################

source output.tcl;   ### Generate output recorders



# assigning Gravity loads - Create a Plain load pattern with a linear TimeSeries:                                        
#  command pattern Plain $tag $timeSeriesTag { $loads }                               
pattern Plain 1 Linear {
for {set i 1} {$i <= $numberofspans} {incr i} {
    eleLoad -range $decklongelements($i,1) $decklongelements($i,$lastdecklongelement($i))  -type -beamUniform   [expr -$DeckWeigth($i)]    0.    0.
  }  
}





pattern Plain 2 Linear {
for {set i 2} {$i <= $numberofspans} {incr i} {
      for {set j 1} {$j <= $numofcolumns}  {incr j} {
        eleLoad -range $columnelement($i,$j,1) $columnelement($i,$j,$columndivisions)  -type -beamUniform   0.    0.    [expr $ColMassDen * 9.81] 
      }
  }  

}














pattern Plain 3 Linear {
for {set i 2} {$i <= $numberofspans} {incr i} {
      
        eleLoad -range $capbeamelement($i,1) $capbeamelement($i,[expr $colcounter($i)+$NumGirders-1])  -type -beamUniform   [expr $CapBeamMassDen*9.81]    0.    0. 
     
  }  

}















# real time display recorder for visualization during analysis
recorder display "First shot of the bridge!" 10 10 600 800 -wipe 
prp $prpx $prpy $prpz
vup $vupx $vupy $vupz
viewWindow $viewwindowx1 $viewwindowx2 $viewwindowy1 $viewwindowy2
display $displaymode $displaymagnodes $displaymagres




###recorder Node -file enddeckmiddle.out -time -node elastomerright()  -dof 1 2 3 4 5 6 reaction


constraints $StaticConstraints $StaticAlphaS $StaticAlphaM
numberer $StaticNumberer 
#numberer RCM
system $StatisSystem ; #-lvalueFact 10 ; ### works best
#system FullGeneral  ; ###   not good
####system BandGeneral ; ### not good
####system BandSPD ; ###     not good
#system ProfileSPD ; ### works well
#system SparseGEN ; ## speed is good but freezes
####system SparseSYM ; ## not good, error!

test $StatistestTestType $StaticTestTol $StaticTestIterations
algorithm Newton -initial 
integrator $StaticIntegrator $StaticIncrement
analysis Static




set timeStepReduction 10
set tCurrent [getTime]
set tFinalStatic 1.0
set ok 0
while {$ok == 0 && $tCurrent < $tFinalStatic} {


set ok [analyze 1 ]; 

set tCurrent [getTime]
 
puts "Run $RunCounter Gravity Loads Analysis - Progress: [getTime] / $tFinalStatic"

}

if {$ok != 0} {
                        puts "Simulation ran into a problem, solve it please!"
            }

if {$ok == 0} {
                        puts "Enjoy!"
           }



loadConst -time 0.0

puts " End of Gravity load analysis"



