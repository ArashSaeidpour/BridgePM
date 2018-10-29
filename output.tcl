##########################################################
#                                                         #
#                 BridgePM                                #
#   Created by:   Arash Saeidpour                         #
#                 University of Georgia                   #
#                                                         #
#                                                         #
###########################################################

set counter [expr $RecorderCounter+1200]
###################  Output recorders  for foundation nodes
##########################
#################################
  for {set i 2} {$i <= [expr $numberofspans]} {incr i} {
                  for {set j 1} {$j <= [expr $numofcolumns]} {incr j} {
                      recorder Node -file [append $counter "$dataDir/Foundation nodes" "/Bent " [expr $i-1] " Column " $j "Foundation node Reactions" ".out"] -time -node $foundationnode2($i,$j) -dof 1 2 3 4 5 6 reaction
                      set counter [expr $counter+1]
                      recorder Node -file [append $counter "$dataDir/Foundation nodes" "/Bent " [expr $i-1] " Column " $j "Foundation node disp" ".out"] -time -node $ColumnBottomMostNode($i,$j) -dof 1 2 3 4 5 6 disp 
                       set counter [expr $counter+1]
                  }
   }
#################### Output recorders for elastomer bearing
##############################
##########################################3

for {set i 1} {$i <= [expr $numberofspans]} {incr i} {
                  for {set j 1} {$j <= $NumGirders} {incr j} {
                      recorder Element -file [append $counter "$dataDir/Elastomer Bearings" "/Span" $i "ElastomerBearingLeft" $j  "force.out"] -time -ele $ElastomerBearingElementLeft($i,$j) -dof 1 2 3 4 5 6 localForce 
                  set counter [expr $counter+1]    
                      
                      recorder Element -file [append $counter "$dataDir/Elastomer Bearings" "/Span" $i "ElastomerBearingLeft" $j  "deformation.out"] -time -ele $ElastomerBearingElementLeft($i,$j) -dof 1 2 3 4 5 6 deformation 
                  set counter [expr $counter+1]  



                      recorder Element -file [append $counter "$dataDir/Elastomer Bearings" "/Span" $i "ElastomerBearingRight" $j  "force.out"] -time -ele $ElastomerBearingElementRight($i,$j) -dof 1 2 3 4 5 6 localForce 
                  set counter [expr $counter+1]

                      recorder Element -file [append $counter "$dataDir/Elastomer Bearings" "/Span" $i "ElastomerBearingRight" $j  "deformation.out"] -time -ele $ElastomerBearingElementRight($i,$j) -dof 1 2 3 4 5 6 deformation 
                  set counter [expr $counter+1]
                      
                  }
   }

####################### Output recorders for deck nodes

for {set i 1} {$i <= [expr $numberofspans]} {incr i} {
                  
recorder Node  -file [append $counter "$dataDir/Deck Nodes" "/Span " $i " Deck Left End Node" ".out"] -time -node $decklongnodes($i,1)  -dof 1 2 3 4 5 6 disp
incr counter

recorder Node  -file [append $counter "$dataDir/Deck Nodes" "/Span " $i " Deck Middle Node" ".out"] -time -node $decklongnodes($i,[expr int(ceil($DeckDivisions/2))])  -dof 1 2 3 4 5 6 disp
incr counter

recorder Node  -file [append $counter "$dataDir/Deck Nodes" "/Span " $i " Deck Right End Node" ".out"] -time -node $decklongnodes($i,[expr $DeckDivisions+1])  -dof 1 2 3 4 5 6 disp
incr counter

}

##################Output recorders for abutment-soil elements
####################
########################

for {set j 1} {$j <= $NumGirders} {incr j} {

recorder Element -file [append $counter "$dataDir/Abutment" "/Left Abutment" " Long Element " $j "force.out"] -time -ele $AbutmentLeftLongElement($j) -dof 1 2 3 4 5 6 force 
incr counter
recorder Element -file [append $counter "$dataDir/Abutment" "/Left Abutment" " Long Element " $j "deformation.out"] -time -ele $AbutmentLeftLongElement($j) -dof 1 2 3 4 5 6  deformation
incr counter


recorder Element -file [append $counter "$dataDir/Abutment" "/Right Abutment" " Long Element " $j "force.out"] -time -ele $AbutmentRightLongElement($j) -dof 1 2 3 4 5 6 force 
incr counter
recorder Element -file [append $counter "$dataDir/Abutment" "/Right Abutment" " Long Element " $j "deformation.out"] -time -ele $AbutmentRightLongElement($j) -dof 1 2 3 4 5 6 deformation
incr counter
                     
                  }

recorder Element -file [append $counter "$dataDir/Abutment" "/Left Abutment" " Trans Element 1"  "force.out"] -time -ele $AbutLeftTransElement(1) -dof 1 2 3 4 5 6 force 
incr counter
recorder Element -file [append $counter "$dataDir/Abutment" "/Left Abutment" " Trans Element 1"  "deformation.out"] -time -ele $AbutLeftTransElement(1) -dof 1 2 3 4 5 6  deformation
incr counter

recorder Element -file [append $counter "$dataDir/Abutment" "/Left Abutment" " Trans Element 2"  "force.out"] -time -ele $AbutLeftTransElement(2) -dof 1 2 3 4 5 6 force 
incr counter
recorder Element -file [append $counter "$dataDir/Abutment" "/Left Abutment" " Trans Element 2"  "deformation.out"] -time -ele $AbutLeftTransElement(2) -dof 1 2 3 4 5 6  deformation
incr counter

recorder Element -file [append $counter "$dataDir/Abutment" "/Right Abutment" " Trans Element 1"  "force.out"] -time -ele $AbutRightTransElement(1) -dof 1 2 3 4 5 6 force 
incr counter
recorder Element -file [append $counter "$dataDir/Abutment" "/Right Abutment" " Trans Element 1"  "deformation.out"] -time -ele $AbutRightTransElement(1) -dof 1 2 3 4 5 6  deformation
incr counter

recorder Element -file [append $counter "$dataDir/Abutment" "/Right Abutment" " Trans Element 2"  "force.out"] -time -ele $AbutRightTransElement(2) -dof 1 2 3 4 5 6 force 
incr counter
recorder Element -file [append $counter "$dataDir/Abutment" "/Right Abutment" " Trans Element 2"  "deformation.out"] -time -ele $AbutRightTransElement(2) -dof 1 2 3 4 5 6  deformation
incr counter


##################### Output recorders for contact elements
############################
###################################
for {set i 1} {$i <= [expr $numberofspans]} {incr i} {
                  for {set j 1} {$j <= $NumGirders} {incr j} {
                      recorder Element -file [append $counter "$dataDir/Contact Elements" "/Span" $i "Contact Left" $j "force.out"] -time -ele $ContactElementLeft($i,$j) -dof 1 2 3 4 5 6 force 
                  set counter [expr $counter+1]  
                     # recorder Element -file [append $counter "$dataDir/Contact Elements" "/Span" $i "Contact Left" $j "deformation.out"] -time -ele $ContactElementLeft($i,$j) -dof 1 2 3 4 5 6  deformation
                 # set counter [expr $counter+1] 

  
                      recorder Element -file [append $counter "$dataDir/Contact Elements" "/Span" $i "Contact Right" $j "force.out"] -time -ele $ContactElementRight($i,$j) -dof 1 2 3 4 5 6 force 
                  set counter [expr $counter+1]
                    #   recorder Element -file [append $counter "$dataDir/Contact Elements" "/Span" $i "Contact Right" $j "deformation.out"] -time -ele $ContactElementRight($i,$j) -dof 1 2 3 4 5 6  deformation
                 # set counter [expr $counter+1]
                     
                  }
   }

##################################
##################################### Output recorders for columns
### Column Section
if {$BentSectionSwitch==1} {      
        for {set i 2} {$i <= [expr $numberofspans]} {incr i} {
                  for {set j 1} {$j <= [expr $numofcolumns]} {incr j} {

                      #recorder Element -file [append $counter "$dataDir/Columns/" "Span " [expr $i-1] " Column " $j "/OutMostSteel1.out"]         -time -ele $columnelement($i,$j,$columndivisions) section 4 fiber  0.0 $ro    23 stressStrain
                      set counter [expr $counter+1]
                      #recorder Element -file [append $counter "$dataDir/Columns/" "Span " [expr $i-1] " Column " $j "/OutMostSteel2.out"]         -time -ele $columnelement($i,$j,$columndivisions) section 4 fiber  0.0 -$ro   23 stressStrain
                      set counter [expr $counter+1]
                      #recorder Element -file [append $counter "$dataDir/Columns/" "Span " [expr $i-1] " Column " $j "/OutMostConc1.out"]          -time -ele $columnelement($i,$j,$columndivisions) section 4 fiber  0.0 $ro    21 stressStrain
                      set counter [expr $counter+1]
                      #recorder Element -file [append $counter "$dataDir/Columns/" "Span " [expr $i-1] " Column " $j "/OutMostConc2.out"]          -time -ele $columnelement($i,$j,$columndivisions) section 4 fiber  0.0 -$ro   21 stressStrain
                      
                      set counter [expr $counter+1]

 for {set l 1} {$l <= [expr 2*($nfCoreR+$nfCoverR)]} {incr l} {


    if {$l<=$nfCoverR || $l>=[expr 2*$nfCoreR+$nfCoverR+1]} {
       set matnumber 21
         
     } 

    if {$l>$nfCoverR && $l<[expr 2*$nfCoreR+$nfCoverR+1]} { 
      set matnumber 22
        
     }  
#recorder Element -file [append $counter "$dataDir/Columns/" "Span " [expr $i-1] " Column " $j  "/Fiber" $l ".out"]  -time -ele $columnelement($i,$j,$columndivisions) section 4 fiber  0.0  [expr $ro-$l*($ro/($nfCoreR+$nfCoverR))]    $matnumber stressStrain
#set counter [expr $counter+1]

 }
                   }
         }

}



##################### 
########################### Prestressed concrete pile section
if {$BentSectionSwitch==2} {
        for {set i 2} {$i <= [expr $numberofspans]} {incr i} {
                  for {set j 1} {$j <= [expr $numofcolumns]} {incr j} {
##### Fiber sections
                      # recorder Element -file [append $counter "$dataDir/Columns/" "Span " [expr $i-1] " Column " $j "/OutMostSteel1.out"]         -time -ele $columnelement($i,$j,$columndivisions) section 4 fiber  0.0 [expr double($PSCPileHSec)/2.0]    124 stressStrain
                      #set counter [expr $counter+1]
                      #recorder Element -file [append $counter "$dataDir/Columns/" "Span " [expr $i-1] " Column " $j "/OutMostSteel2.out"]         -time -ele $columnelement($i,$j,$columndivisions) section 4 fiber  0.0 [expr -double($PSCPileHSec)/2.0]   124 stressStrain
                      #set counter [expr $counter+1]
                      #recorder Element -file [append $counter "$dataDir/Columns/" "Span " [expr $i-1] " Column " $j "/OutMostConc1.out"]          -time -ele $columnelement($i,$j,$columndivisions) section 4 fiber  0.0 [expr double($PSCPileHSec)/2.0]    121 stressStrain
                      #set counter [expr $counter+1]
                      #recorder Element -file [append $counter "$dataDir/Columns/" "Span " [expr $i-1] " Column " $j "/OutMostConc2.out"]          -time -ele $columnelement($i,$j,$columndivisions) section 4 fiber  0.0 [expr -double($PSCPileHSec)/2.0]   121 stressStrain







############ Elements


#recorder Element -file [append $counter "$dataDir/Columns/" "Span " [expr $i-1] " Column " $j "/deformation.out"]         -time -ele $columnelement($i,$j,$columndivisions) section 4 deformation
#set counter [expr $counter+1]
#recorder Element -file [append $counter "$dataDir/Columns/" "Span " [expr $i-1] " Column " $j "/force.out"]         -time -ele $columnelement($i,$j,$columndivisions) section 4 force
#set counter [expr $counter+1]
                      
                      

 for {set l 1} {$l <= [expr $PSCPilenfZ+2]} {incr l} {


    if {$l==1 || $l==[expr $PSCPilenfZ+2]} {
       set matnumber 121
         
     } else { 

     
      set matnumber 122
        
     }  
#recorder Element -file [append $counter "$dataDir/Columns/" "Span " [expr $i-1] " Column " $j  "/Fiber" $l ".out"]  -time -ele $columnelement($i,$j,$columndivisions) section 4 fiber  0.0  [expr double($PSCPileHSec)/2.0-$l*($PSCPileHSec/($PSCPilenfZ+2))]    $matnumber stressStrain
#set counter [expr $counter+1]

 }
                   }
         }

}




####### Critical column nodes ( located near teh ground, for maximum moment and curvature)


if {$BentSectionSwitch==2} {

        for {set i 2} {$i <= [expr $numberofspans]} {incr i} {

                  for {set j 1} {$j <= [expr $numofcolumns]} {incr j} {

                      for  {set k 1} {$k <= [expr $ColumnCriticalNodeCounter-1]} {incr k} {


#recorder Node -file [append $counter "$dataDir/Column Critical Nodes/" "Span " [expr $i-1] " Column " $j  "/Node" $ColumnCriticalNode($i,$j,$k)  " reaction.out"] -time -node $ColumnCriticalNode($i,$j,$k) -dof 1 2 3 4 5 6 reaction
#set counter [expr $counter+1]
#recorder Node -file [append $counter "$dataDir/Column Critical Nodes/" "Span " [expr $i-1] " Column " $j  "/Node" $ColumnCriticalNode($i,$j,$k)  " disp.out"]     -time -node $ColumnCriticalNode($i,$j,$k) -dof 1 2 3 4 5 6 disp
#set counter [expr $counter+1]


                                                                                             
  }
}
}
}

####### Critical column elements ( located near teh ground, for maximum moment and curvature)


if {$BentSectionSwitch==2} {

        for {set i 2} {$i <= [expr $numberofspans]} {incr i} {

                  for {set j 1} {$j <= [expr $numofcolumns]} {incr j} {

                      for  {set k 1} {$k <= [expr $ColumnCriticalElementCounter-1]} {incr k} {






recorder Element -file [append $counter "$dataDir/Column Critical Elements/" "Span " [expr $i-1] " Column " $j  "/Element " $ColumnCriticalElement($i,$j,$k)  " force.out"]     -time -ele $ColumnCriticalElement($i,$j,$k) force
set counter [expr $counter+1]




                                                                                             
  }
}
}
}


recorder Element -file $dataDir/CurvatureEle2024.out  -time -ele 2024 section 4 deformation


