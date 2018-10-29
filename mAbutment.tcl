##########################################################
#                                                         #
#                 BridgePM                                #
#   Created by:   Arash Saeidpour                         #
#                 University of Georgia                   #
#                                                         #
#                                                         #
###########################################################

puts " Abutment Module starts"


set startnode [expr $startnode+200]

#### Maximum number of Girders is 10


puts "Abutment nodes"
###### ##### Creating Deck end
set counter 0

for {set k $startnode} {$k <= [expr $startnode+$NumGirders-1]} {incr k} {


# Left Abut 
    
    set xCoord $LeftAbut
    set yCoord $DeckElevation
    set zCoord [expr $counter*$GirderSpacing-double($DeckWidth)/2]



    
    node $k           $xCoord   $yCoord   $zCoord ;    # Abutment node
    node [expr $k+50] $xCoord   $yCoord   $zCoord ;   # soil node
    fix  [expr $k+50] 1 1 1 1 1 1 ;  ## Fixing the soil node
    
# Right Abut 
    
    set xCoord $RightAbut
    set yCoord $DeckElevation
    set zCoord [expr $counter*$GirderSpacing-double($DeckWidth)/2]



    
    node [expr $k+80]           $xCoord   $yCoord   $zCoord    # Abutment node
    node [expr $k+110]           $xCoord   $yCoord   $zCoord    # soil node
    
    fix  [expr $k+110] 1 1 1 1 1 1   ;  ## Fixing the soil node
    






    
    set counter [expr $counter+1]


    set abutleft($counter)                 $k
    set soilleft($counter)             [expr $k+50]

    set abutright($counter)              [expr $k+80]
    set soilright($counter)             [expr $k+110]
    
    
      
    
}


set startnode [expr $k+200]
set k $startnode

#### Transverse fix nodes
#################################
#################################
    set xCoord $LeftAbut
    set yCoord $DeckElevation
    set zCoord [expr double(-$DeckWidth)/2]

    node [expr $k+1] $xCoord   $yCoord   $zCoord    # soil node
    fix  [expr $k+1] 1 1 1 1 1 1   ;  ## Fixing the soil node
    set  transversefixnode(1) [expr $k+1]  


    set xCoord $LeftAbut
    set yCoord $DeckElevation
    set zCoord [expr double($DeckWidth)/2]

    node [expr $k+2] $xCoord   $yCoord   $zCoord    # soil node
    fix [expr $k+2] 1 1 1 1 1 1   ;  ## Fixing the soil node
    set transversefixnode(2) [expr $k+2]


    set xCoord $RightAbut
    set yCoord $DeckElevation
    set zCoord [expr double(-$DeckWidth)/2]

    node [expr $k+3] $xCoord   $yCoord   $zCoord    # soil node
    fix [expr $k+3] 1 1 1 1 1 1   ;  ## Fixing the soil node
    set transversefixnode(3) [expr $k+3]


    set xCoord $RightAbut
    set yCoord $DeckElevation
    set zCoord [expr double($DeckWidth)/2]

    node [expr $k+4] $xCoord   $yCoord   $zCoord    # soil node
    fix [expr $k+4] 1 1 1 1 1 1   ;  ## Fixing the soil node
    set transversefixnode(4) [expr $k+4]
###########################################################
###########################################################
###########################################################

set startnode [expr $k+100]


puts "Abutment nodes nodes created"



set counter 1
set k $startelement


###### ##### Creating elements

for {set i 1} {$i <= $NumGirders} {incr i} {

element zeroLength $k  $abutleft($i) $soilleft($i) -mat 17 27 28 27 27 27  -dir 1 2 3 4 5 6  
set k [expr $k+1]

element zeroLength $k  $abutright($i) $soilright($i) -mat 17 27 28 27 27 27  -dir 1 2 3 4 5 6  
set k [expr $k+1]

set AbutmentLeftLongElement($counter) [expr $k-2]
set AbutmentRightLongElement($counter) [expr $k-1]

incr counter    
       
}

element zeroLength [expr $k+1]  $abutleft(1)              $transversefixnode(1)    -mat 28 28 16 27 27 27  -dir 1 2 3 4 5 6 ;#  
element zeroLength [expr $k+2]  $abutleft($NumGirders)    $transversefixnode(2)    -mat 28 28 16 27 27 27  -dir 1 2 3 4 5 6 ;#  
element zeroLength [expr $k+3]  $abutright(1)             $transversefixnode(3)    -mat 28 28 16 27 27 27  -dir 1 2 3 4 5 6 ;#  
element zeroLength [expr $k+4]  $abutright($NumGirders)   $transversefixnode(4)    -mat 28 28 16 27 27 27  -dir 1 2 3 4 5 6 ;#  

set AbutLeftTransElement(1) [expr $k+1]
set AbutLeftTransElement(2) [expr $k+2]
set AbutRightTransElement(1) [expr $k+3]
set AbutRightTransElement(2) [expr $k+4]


set startelement [expr $k+100]
set k $startelement

for {set i 1} {$i <= [expr $NumGirders-1]} {incr i} {

element twoNodeLink $k  $abutleft($i)  $abutleft([expr $i+1])   -mat 27 27 27 27 27 27 -dir 1 2 3 4 5 6 -orient 0. 1. 0.  
set k [expr $k+1]

element twoNodeLink $k  $abutright($i) $abutright([expr $i+1])  -mat 27 27 27 27 27 27 -dir 1 2 3 4 5 6 -orient 0. 1. 0.  
set k [expr $k+1]
    
       
}

set startelement [expr $k+50]
















