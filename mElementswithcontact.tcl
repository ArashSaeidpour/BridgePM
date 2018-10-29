##########################################################
#                                                         #
#                 BridgePM                                #
#   Created by:   Arash Saeidpour                         #
#                 University of Georgia                   #
#                                                         #
#                                                         #
###########################################################


puts "Elments Module Start"





#############
#################
#############  Generating contact elements

set counter 1




 model basic -ndm 3 -ndf 6;  ## Remove hashtag when using contact elements


source materials.tcl



for {set i [expr $startelement]} {$i <= [expr $startelement+$NumGirders-1]} {incr i} {


# Left nodes 
 



equalDOF    $contacttopleft($spancounter,$counter) $dummytopleft($spancounter,$counter)            1 2 3;   #####  Rigid links between top dummy node and contact node


if {$contactelementswitch==1} { 




element      zeroLengthContact3D          $i     $contacttopleft($spancounter,$counter)     $contactbottomleft($spancounter,$counter) $Kn $Kt $mu $coh $normdir;



} else { 
element zeroLength $i            $contacttopleft($spancounter,$counter)     $contactbottomleft($spancounter,$counter)    -mat 27 27 27 27 27 27                                           -dir 1 2 3 4 5 6 
}

equalDOF  $dummybottomleft($spancounter,$counter)  $contactbottomleft($spancounter,$counter)        1 2 3; #### Rigid links between bottom dummy node and contact node


set ContactElementLeft($spancounter,$counter)  $i
    


# Right nodes 
    
equalDOF $contacttopright($spancounter,$counter) $dummytopright($spancounter,$counter)           1 2 3;            ### Rigid links between top dummy node and contact node


if {$contactelementswitch==1} { 
element  zeroLengthContact3D          [expr $i+20]     $contacttopright($spancounter,$counter)     $contactbottomright($spancounter,$counter) $Kn $Kt $mu $coh $normdir;


} else {
element zeroLength [expr $i+20]            $contacttopright($spancounter,$counter)     $contactbottomright($spancounter,$counter)    -mat 27 27 27 27 27 27                                           -dir 1 2 3 4 5 6 
}
equalDOF     $dummybottomright($spancounter,$counter) $contactbottomright($spancounter,$counter)         1 2 3 ;         ### Rigid links between bottom dummy node and contact node  

set ContactElementRight($spancounter,$counter) [expr $i+20]
  
set counter [expr $counter+1] 


        
}


############
###########
puts "contact elements created"








#### Maximum number of Girders is 10



# model basic -ndm 3 -ndf 6;


#source materials.tcl



################
################
##############   Creating longitudinal elements

set counter 1
set startelement [expr $startelement+80]

# Creat deck longitudinal elements


set DeckGirderTrans 1
geomTransf Linear $DeckGirderTrans 0 0 1

##### Creating Deck longitudinal nodes
for {set i $startelement} {$i <= [expr $startelement+$DeckDivisions-1]} {incr i} {
# coordinates of longitudinal deck nodes 
    
set MassDeck($spancounter) [expr $DeckWeigth($spancounter)/$g]    
    # element elasticBeamColumn   $eleTag       $iNode                   $jNode                                   $A            $E                       $G                           $J                             $Iy                  $Iz                  $transfTag             <-mass $massDens>
    
   element elasticBeamColumn	  $i       $decklongnodes($spancounter,$counter)     $decklongnodes($spancounter,[expr $counter+1])    $DeckArea($spancounter)  $DeckElasticModulus       $DeckShearModulus         $DeckTorsionalStiffness              $IyDeck($spancounter)               $IzDeck($spancounter)	            $DeckGirderTrans           -mass $MassDeck($spancounter)  	
puts "longitudinal elements"  
puts $i
set decklongelements($spancounter,$counter) $i
set counter [expr $counter+1]
 

}

set lastdecklongelement($spancounter) [expr $counter-1]
set lastdecklongnode $decklongnodes($spancounter,$counter)

puts "Deck Longitudinal elements created"


###########
############
###### ##### Creating Deck end elements


set startelement [expr $startelement+$counter-1]
set endnodepointer [expr $counter-1]
set counter 1


for {set i $startelement} {$i <= [expr $startelement+$NumGirders-1]} {incr i} {



rigidLink beam $decklongnodes($spancounter,1)                    $deckleft($spancounter,$counter)
rigidLink beam $decklongnodes($spancounter,$endnodepointer)      $deckright($spancounter,$counter)




# Left nodes 

element zeroLength $i            $deckleft($spancounter,$counter)          $dummytopleft($spancounter,$counter)    -mat 27 27 27 27 27 27                                           -dir 1 2 3 4 5 6                 ### Rigid link between deck end nodes and dummy nodes
element zeroLength [expr $i+20]  $dummybottomleft($spancounter,$counter)   $elastomerleft($spancounter,$counter)   -mat 27 27 27 27 27 27   -dir 1 2 3 4 5 6                   ### Elastomer Bearings
element zeroLength [expr $i+40]  $elastomerleft($spancounter,$counter) $deckleft($spancounter,$counter)      -mat 10 $VerImpMat $ElastomerZDirection $rotmat $rotmat $rotmatZ   -dir 1 2 3 4 5 6                   ### Elastomer Bearings

# Right nodes

element zeroLength [expr $i+60]        $deckright($spancounter,$counter)          $dummytopright($spancounter,$counter)    -mat 27 27 27 27 27 27                                           -dir 1 2 3 4 5 6                 ### Rigid link between deck end nodes and dummy nodes
element zeroLength [expr $i+80]        $dummybottomright($spancounter,$counter)   $elastomerright($spancounter,$counter)   -mat 27 27 27 27 27 27    -dir 1 2 3 4 5 6                 ### Elastomer Bearings
element zeroLength [expr $i+100]        $elastomerright($spancounter,$counter) $deckright($spancounter,$counter)      -mat 11 $VerImpMat $ElastomerZDirection $rotmat $rotmat $rotmatZ    -dir 1 2 3 4 5 6                 ### Elastomer Bearings
 
    
    

set ElastomerBearingElementLeft($spancounter,$counter) [expr $i+40];
set ElastomerBearingElementRight($spancounter,$counter) [expr $i+100];


    
    set counter [expr $counter+1]



}



set startelement [expr $i+$counter+50+100]
set counter 1

for {set i $startelement} {$i <= [expr $startelement+$NumGirders-2]} {incr i} {

element twoNodeLink  $i                      $elastomerleft($spancounter,$counter)           $elastomerleft($spancounter,[expr $counter+1])     -mat 27 27 27 27 27 27  -dir 1 2 3 4 5 6 -orient 0. 1. 0.
element twoNodeLink  [expr $i+30]            $elastomerright($spancounter,$counter)          $elastomerright($spancounter,[expr $counter+1])    -mat 27 27 27 27 27 27  -dir 1 2 3 4 5 6 -orient 0. 1. 0.

set counter [expr $counter+1]

}

set startelement [expr $i+30+$counter+100]



puts "end of element procedure"





















