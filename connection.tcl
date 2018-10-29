##########################################################
#                                                         #
#                 BridgePM                                #
#   Created by:   Arash Saeidpour                         #
#                 University of Georgia                   #
#                                                         #
#                                                         #
###########################################################

set k $startelement

for {set i 1} {$i <= [expr $NumGirders]} {incr i} {


#element twoNodeLink $eleTag $iNode $jNode -mat $matTags -dir $dirs <-orient <$x1 $x2 $x3> $y1 $y2 $y3> <-pDelta (4 $Mratio)> <-shearDist (2 $sDratios)> <-doRayleigh> <-mass $m>
element twoNodeLink $k  $abutleft($i) $elastomerleft(1,$i) -mat 27 27 27 27 27 27 -dir 1 2 3 4 5 6 -orient 0. 1. 0.
set k [expr $k+1]
element twoNodeLink $k $deckleft(1,$i) $abutleft($i) -mat 20 28 28 28 28 28 -dir 1 2 3 4 5 6 -orient 0. 1. 0.
set k [expr $k+1]
}


set startelement [expr $startelement+$k]
set $k $startelement
for {set i 1} {$i <= [expr $NumGirders]} {incr i} {


#element twoNodeLink $eleTag $iNode $jNode -mat $matTags -dir $dirs <-orient <$x1 $x2 $x3> $y1 $y2 $y3> <-pDelta (4 $Mratio)> <-shearDist (2 $sDratios)> <-doRayleigh> <-mass $m>
element twoNodeLink $k  $abutright($i) $elastomerright($numberofspans,$i) -mat 27 27 27 27 27 27 -dir 1 2 3 4 5 6 -orient 0. 1. 0.
set k [expr $k+1]
element twoNodeLink $k $deckright($numberofspans,$i) $abutright($i) -mat 20 28 28 28 28 28 -dir 1 2 3 4 5 6 -orient 0. 1. 0.
set k [expr $k+1]
}



set startelement [expr $startelement+$k]
set $k $startelement

for {set i 1} {$i <= [expr $numberofspans-1]} {incr i} {
for {set j 1} {$j <= [expr $NumGirders]} {incr j} {

#element twoNodeLink $eleTag $iNode $jNode -mat $matTags -dir $dirs <-orient <$x1 $x2 $x3> $y1 $y2 $y3> <-pDelta (4 $Mratio)> <-shearDist (2 $sDratios)> <-doRayleigh> <-mass $m>
element twoNodeLink $k  $elastomerright($i,$j) $capbeamnodelinkedtoelastomer([expr $i+1],$j)  -mat 27 27 27 27 27 27 -dir 1 2 3 4 5 6 -orient 0. 1. 0.
set k [expr $k+1]



element twoNodeLink  $k  $capbeamnodelinkedtoelastomer([expr $i+1],$j) $elastomerleft([expr $i+1],$j) -mat 27 27 27 27 27 27 -dir 1 2 3 4 5 6 -orient 0. 1. 0.
set k [expr $k+1]

element twoNodeLink $k $deckright($i,$j) $deckleft([expr $i+1],$j) -mat 20 28 28 28 28 28 -dir 1 2 3 4 5 6 -orient 0. 1. 0.
set k [expr $k+1]

}
}
set startelement [expr $startelement+$k]
set $k $startelement

