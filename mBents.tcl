set counter 0
###### ##### Creating Cap beam nodes
#set fp [open "cap beam nodes linked to elastome" w+]
#puts $fp "Cap beam node linked to elastomer bearings"



for {set i $startnode} {$i <= [expr $startnode+$NumGirders-1]} {incr i} {


# Left nodes 
    
    set xCoord $longcoord 
    set yCoord $DeckElevation
    set zCoord [expr $counter*$GirderSpacing-double($DeckWidth)/2]
    
   node $i                     $xCoord   $yCoord   $zCoord    # Contact nodes top Left    - Maximum number of girders is 9
   

    

#puts $fp "node"
#puts $fp $i
#puts $fp "coord"
#puts $fp $xCoord
#puts $fp $yCoord
#puts $fp $zCoord
####puts $counter
#puts $fp "-------"




 
    set counter [expr $counter+1]

    set capbeamnodelinkedtoelastomer($spancounter,$counter)           $i

    
    
       
}
#close $fp




#puts "-------------------------"


#set fp [open "Column node z location" w+]
#puts $fp "Z direction for columns"



if {$numofcolumns==2} { 
set colcounter($spancounter) 2

set columnsdistance [expr double($DeckWidth)-2*$cantileverlength]


set z(1) [expr -double($columnsdistance)/2]
set z(2) [expr  double($columnsdistance)/2]

          

#puts  $z(1)
#puts  $z(2)

}




if {$numofcolumns==3} { 

set colcounter($spancounter) 3
set columnsdistance [expr (double($DeckWidth)-2*$cantileverlength)/2]


set z(1) [expr double($DeckWidth)/(-2)+double($cantileverlength)]
set z(2) [expr $z(1)+double($columnsdistance)]
set z(3) [expr double($DeckWidth)/(2)-double($cantileverlength)]


#puts  $z(1)
#puts  $z(2)
#puts  $z(3)
} 


if {$numofcolumns==4} { 
set colcounter($spancounter) 4

set columnsdistance [expr (double($DeckWidth)-2*$cantileverlength)/3]
##puts $columnsdistance


set z(1) [expr $DeckWidth/(-2)+double($cantileverlength)]
set z(2) [expr $z(1)+double($columnsdistance)]
set z(3) [expr $z(2)+double($columnsdistance)]
set z(4) [expr double($DeckWidth)/(2)-double($cantileverlength)]


#puts $fp $z(1)
#puts $fp $z(2)
#puts $fp $z(3)
#puts $fp $z(4)

}
# close $fp


if {$numofcolumns==5} { 

set colcounter($spancounter) 5
set columnsdistance [expr (double($DeckWidth)-2*$cantileverlength)/4]


set z(1) [expr double($DeckWidth)/(-2)+double($cantileverlength)]
set z(2) [expr $z(1)+double($columnsdistance)]
set z(3) [expr $z(2)+double($columnsdistance)]
set z(4) [expr $z(3)+double($columnsdistance)]
set z(5) [expr double($DeckWidth)/(2)-double($cantileverlength)]


#puts  $z(1)
#puts  $z(2)
#puts  $z(3)


}




if {$numofcolumns==8} { 
set colcounter($spancounter) 8

set columnsdistance [expr (double($DeckWidth)-2*$cantileverlength)/7]
##puts $columnsdistance


set z(1)  [expr $DeckWidth/(-2)+double($cantileverlength)]
set z(2)  [expr $z(1)+double($columnsdistance)]
set z(3)  [expr $z(2)+double($columnsdistance)]
set z(4)  [expr $z(3)+double($columnsdistance)]
set z(5)  [expr $z(4)+double($columnsdistance)]
set z(6)  [expr $z(5)+double($columnsdistance)]
set z(7)  [expr $z(6)+double($columnsdistance)]
set z(8)  [expr $z(7)+double($columnsdistance)]




#puts $fp $z(1)
#puts $fp $z(2)
#puts $fp $z(3)
#puts $fp $z(4)

} 



if {$numofcolumns==10} { 
set colcounter($spancounter) 10

set columnsdistance [expr (double($DeckWidth)-2*$cantileverlength)/9]
##puts $columnsdistance


set z(1)  [expr $DeckWidth/(-2)+double($cantileverlength)]
set z(2)  [expr $z(1)+double($columnsdistance)]
set z(3)  [expr $z(2)+double($columnsdistance)]
set z(4)  [expr $z(3)+double($columnsdistance)]
set z(5)  [expr $z(4)+double($columnsdistance)]
set z(6)  [expr $z(5)+double($columnsdistance)]
set z(7)  [expr $z(6)+double($columnsdistance)]
set z(8)  [expr $z(7)+double($columnsdistance)]
set z(9)  [expr $z(8)+double($columnsdistance)]
set z(10) [expr $z(9)+double($columnsdistance)]



#puts $fp $z(1)
#puts $fp $z(2)
#puts $fp $z(3)
#puts $fp $z(4)

} 


if {$numofcolumns==12} { 
set colcounter($spancounter) 12

set columnsdistance [expr (double($DeckWidth)-2*$cantileverlength)/11]
##puts $columnsdistance


set z(1)  [expr $DeckWidth/(-2)+double($cantileverlength)]
set z(2)  [expr $z(1)+double($columnsdistance)]
set z(3)  [expr $z(2)+double($columnsdistance)]
set z(4)  [expr $z(3)+double($columnsdistance)]
set z(5)  [expr $z(4)+double($columnsdistance)]
set z(6)  [expr $z(5)+double($columnsdistance)]
set z(7)  [expr $z(6)+double($columnsdistance)]
set z(8)  [expr $z(7)+double($columnsdistance)]
set z(9)  [expr $z(8)+double($columnsdistance)]
set z(10) [expr $z(9)+double($columnsdistance)]
set z(11) [expr $z(10)+double($columnsdistance)]
set z(12) [expr $z(11)+double($columnsdistance)]



#puts $fp $z(1)
#puts $fp $z(2)
#puts $fp $z(3)
#puts $fp $z(4)

} 


#set fp [open "Column tip nodes" w+]
#puts $fp "Z direction for columns"


set startnode [expr $startnode+$counter+100]
set counter 1
set checkmiddlenode [expr $NumGirders%2]
for {set i $startnode} {$i <= [expr $startnode+$colcounter($spancounter)-1]} {incr i} {


    set xCoord $longcoord
    set yCoord $DeckElevation
    set zCoord $z($counter)

if {($numofcolumns==3) && ($checkmiddlenode!=0) && ($counter==2)} { 

#puts $fp "Cap beam middle node has already been created"
set middlenodepointer [expr ($NumGirders+1)/2]
set capbeamnodelinkedtocolumn($counter) $capbeamnodelinkedtoelastomer($spancounter,$middlenodepointer)
#puts $fp $capbeamnodelinkedtoelastomer($spancounter,$middlenodepointer) 
} elseif {($numofcolumns==5) && ($checkmiddlenode!=0) && ($counter==3)} {
set middlenodepointer [expr ($NumGirders+1)/2]
set capbeamnodelinkedtocolumn($counter) $capbeamnodelinkedtoelastomer($spancounter,$middlenodepointer)
} else {
 node $i       $xCoord   $yCoord   $zCoord ;   # Contact nodes top Left    - Maximum number of girders is 9
#puts $fp "Cap beam node linked to columns "
#puts $fp $i
#puts $fp $xCoord
#puts $fp $yCoord
#puts $fp $zCoord
#puts $fp "------"


set capbeamnodelinkedtocolumn($counter)           $i
set numberofcolumnnodes [expr $columndivisions]     
 
    
}
set counter [expr $counter+1]
}  
    
    
#close $fp      



set k [expr $startnode+$counter+100]

#set fp [open "Column nodes" w+]
#puts $fp "Column nodes"

for {set i 1} {$i <= [expr $numofcolumns]}     {incr i} {
for {set j 1} {$j <= [expr $columndivisions]}  {incr j} {

    set xCoord $longcoord
    set yCoord [expr $DeckElevation-$j*((double($DeckElevation)-$FoundationElevation)/$columndivisions)]
    set zCoord $z($i)


 node $k       $xCoord   $yCoord   $zCoord ;       


#puts $fp "Column nodes "
#puts $fp $k
#puts $fp $xCoord
#puts $fp $yCoord
#puts $fp $zCoord
#puts $fp "-----"


    set columnnode($spancounter,$i,$j) $k
    set k [expr $k+1]

               
       

}
set ColumnBottomMostNode($spancounter,$i) [expr $k-2]

set foundationnode1($spancounter,$i) [expr $k-1]


node $k       $xCoord   $yCoord   $zCoord ;   # Foundation second node
set foundationnode2($spancounter,$i) [expr $k]
set k [expr $k+1]
#puts $fp "foundation nodes"
#puts $fp $foundationnode1($spancounter,$i)
#puts $fp $foundationnode2($spancounter,$i)
}

#close $fp

#set fp [open "Foundation elements" w+]
#puts $fp "Foundation elements properties"
set startnode [expr $k+$counter+100]
set counter 0


set FoundationMaterial(1) 24
set FoundationMaterial(2) 26
set FoundationMaterial(3) 24
set FoundationMaterial(4) 25
set FoundationMaterial(5) 27
set FoundationMaterial(6) 25

if {$BentSectionSwitch==2} {   ### When using PSC piles, foundation materials are replaced with rigid materials
      for {set m 1} {$m <= 6}     {incr m} {
         set FoundationMaterial($m) 27
      }
}

for {set i 1} {$i <= [expr $numofcolumns]}     {incr i} {



fix $foundationnode2($spancounter,$i) 1 1 1 1 1 1


#puts $fp " fixed node"
#puts $fp $foundationnode1($spancounter,$i)
element twoNodeLink [expr $startelement+$counter] $foundationnode1($spancounter,$i) $foundationnode2($spancounter,$i)  -mat $FoundationMaterial(1) $FoundationMaterial(2) $FoundationMaterial(3) $FoundationMaterial(4) $FoundationMaterial(5) $FoundationMaterial(6) -dir 1 2 3 4 5 6 -orient 1. 0. 0. 0. 1. 0.
####print $fp -ele [expr $startelement+$counter] 
puts "-------"
set counter [expr $counter+1]
 }


#close $fp
  

#####--------------- Defining Column elements


####set fp [open "Column elements" w+]

set k [expr $startelement+$counter] ; #### element counter 
      

                 for {set i 1} {$i <= [expr $numofcolumns]}     {incr i} {

                 element	dispBeamColumn	   $k  $capbeamnodelinkedtocolumn($i)  $columnnode($spancounter,$i,1)	4	$BentSec $ColTrans	-mass	$ColMassDen
                 set columnelement($spancounter,$i,1) $k
                 ####print $fp -ele $k
                 set k [expr $k+1]
                                     for {set j 1} {$j <= [expr $columndivisions-1]}  {incr j} {

    
                                     element	dispBeamColumn	$k	$columnnode($spancounter,$i,$j)	$columnnode($spancounter,$i,[expr $j+1])	4	$BentSec $ColTrans	-mass	$ColMassDen
                                     set columnelement($spancounter,$i,[expr $j+1]) $k
                                     
                                     ###print $fp -ele $k
                                     set k [expr $k+1]

}
    
}
               
 #### close $fp     

puts "---------------"
puts "cap beam nodes"

for {set i 1} {$i <= [expr $colcounter($spancounter)]}  {incr i} {
set capbeamnodes($spancounter,$i) $capbeamnodelinkedtocolumn($i)

puts $capbeamnodes($spancounter,$i)
puts [nodeCoord $capbeamnodes($spancounter,$i) 3]

}

###close $fp


for {set j  $i} {$j <= [expr $colcounter($spancounter)+$NumGirders]}  {incr j} {
set capbeamnodes($spancounter,$j) $capbeamnodelinkedtoelastomer($spancounter,[expr $j-$colcounter($spancounter)])


puts $capbeamnodes($spancounter,$j)
puts [nodeCoord $capbeamnodes($spancounter,$j) 3]

}
puts "$$$$$$$$$$$$$$$$$$"


for {set i 1}  {$i <= [expr $colcounter($spancounter)+$NumGirders]}  {incr i} {
set coordtemp [nodeCoord $capbeamnodes($spancounter,$i) 3] 


             for {set j [expr $i+1]}  {$j <= [expr $colcounter($spancounter)+$NumGirders-1]}  {incr j}  {
             set zcoord [nodeCoord $capbeamnodes($spancounter,$j) 3]

                       if {$zcoord<$coordtemp} {
                         
                        set temp $capbeamnodes($spancounter,$j)
                        set capbeamnodes($spancounter,$j) $capbeamnodes($spancounter,$i)
                        set capbeamnodes($spancounter,$i) $temp
                        set coordtemp [nodeCoord $capbeamnodes($spancounter,$i) 3]
                        }
                            }

puts "capbeam node"
puts $capbeamnodes($spancounter,$i)
puts [nodeCoord $capbeamnodes($spancounter,$i) 3]
}






############# Defining Cap beam elements




for {set i 1}  {$i <= [expr $colcounter($spancounter)+$NumGirders-1]}  {incr i} {

puts [expr $colcounter($spancounter)+$NumGirders-1]
##element dispBeamColumn $eleTag $iNode $jNode $numIntgrPts $secTag $transfTag <-mass $massDens> <-integration $intType>


element	dispBeamColumn	$k	$capbeamnodes($spancounter,$i)	$capbeamnodes($spancounter,[expr $i+1])	4              $CapBeamSecTag3D $CapBeamTrans	-mass	$CapBeamMassDen

set capbeamelement($spancounter,$i) $k
set k [expr $k+1]
}

set startelement [expr $startelement+$k+100]



























