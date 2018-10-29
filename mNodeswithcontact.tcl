
##########################################################
#                                                         #
#                 BridgePM                                #
#   Created by:   Arash Saeidpour                         #
#                 University of Georgia                   #
#                                                         #
#                                                         #
###########################################################



#### Maximum number of Girders is 10


set SpanLength [expr $DeckEnd-$DeckStart]
set DeckNodesSpacing [expr double($SpanLength)/$DeckDivisions]
set GirderSpacing [expr double($DeckWidth)/($NumGirders-1)]


set counter 0

# Creat Nodes

##### Creating Deck longitudinal nodes
puts "deck long nodes"
for {set i $startnode} {$i <= [expr $startnode+$DeckDivisions]} {incr i} {
# coordinates of longitudinal deck nodes 
   


puts [expr $DeckStart+($i-$startnode)*$DeckNodesSpacing] 
    set xCoord [expr $DeckStart+($i-$startnode)*$DeckNodesSpacing]; 
    set yCoord $DeckElevation
    set zCoord 0
    
    node $i $xCoord   $yCoord   $zCoord
    puts "deck nodes"
    puts $i
     
    
    set counter [expr $counter+1]
    set decklongnodes($spancounter,$counter) $i
    

}


set startnode [expr $startnode+$counter+20]
set counter 0




puts " Deck Longitudinal nodes created"

puts "Deck nodes"
###### ##### Creating Deck end

for {set i $startnode} {$i <= [expr $startnode+$NumGirders-1]} {incr i} {


# Left nodes 
    
    set xCoord $DeckStart
    set yCoord $DeckElevation
    set zCoord [expr $counter*$GirderSpacing-double($DeckWidth)/2]



    
    node $i           $xCoord   $yCoord   $zCoord    # Deck nodes Left - Maximum number of girders is 9
   node [expr $i+20] $xCoord   $yCoord   $zCoord    # Dummy node top - Maximum number of girders is 9
   node [expr $i+60] $xCoord   $yCoord   $zCoord    # Dummy node bottom - Maximum number of girders is 9
    node [expr $i+90] $xCoord   $yCoord   $zCoord    # Elastomer bearings - Maximum number of girders is 9
puts "Span $spancounter Girder [expr $counter+1] left end nodes"
puts "x=$xCoord"
puts "y=$yCoord"
puts "z=$zCoord"
puts "   "
puts "Deck node number=$i"
puts "Dummy node top number=[expr $i+20]"
puts "Dummy node bottom number=[expr $i+60]"
puts "Elastomer bearin node number=[expr $i+90]"


# Right nodes 
    
    set xCoord $DeckEnd
    set $yCoord $DeckElevation
    set $zCoord [expr $counter*$GirderSpacing-double($DeckWidth)/2]
    
    node [expr $i+120] $xCoord   $yCoord   $zCoord    # Deck nodes Left - Maximum number of girders is 9
    node [expr $i+150] $xCoord   $yCoord   $zCoord    # Dummy node top - Maximum number of girders is 9
    node [expr $i+190] $xCoord   $yCoord   $zCoord    # Dummy node bottom - Maximum number of girders is 9
    node [expr $i+220] $xCoord   $yCoord   $zCoord    # elastomerbearings - Maximum number of girders is 9


puts "Span $spancounter Girder [expr $counter+1] right end nodes"
puts "x=$xCoord"
puts "y=$yCoord"
puts "z=$zCoord"
puts "     "
puts "Deck node number=[expr $i+120]"
puts "Dummy node top number=[expr $i+150]"
puts "Dummy node bottom number=[expr $i+190]"
puts "Elastomer bearing node number=[expr $i+220]"



    
    set counter [expr $counter+1]

    set deckleft($spancounter,$counter)                 $i
    set dummytopleft($spancounter,$counter)             [expr $i+20]
    set dummybottomleft($spancounter,$counter)          [expr $i+60]
    set elastomerleft($spancounter,$counter)            [expr $i+90]

    set deckright($spancounter,$counter)                [expr $i+120]
    set dummytopright($spancounter,$counter)            [expr $i+150]
    set dummybottomright($spancounter,$counter)         [expr $i+190]
    set elastomerright($spancounter,$counter)           [expr $i+220]

    
      

}

puts "Deck end nodes (except contact) created"


set startnode [expr $i+250]
set counter 0


##puts $startnode

model basic -ndm 3 -ndf 3;

###### ##### Creating Deck end Contact nodes

for {set i $startnode} {$i <= [expr $startnode+$NumGirders-1]} {incr i} {


# Left nodes 
    
    set xCoord $DeckStart
    set yCoord $DeckElevation
    set zCoord [expr $counter*$GirderSpacing-double($DeckWidth)/2]
    
   node $i                     $xCoord   $yCoord   $zCoord    # Contact nodes top Left    - Maximum number of girders is 9
   node [expr $i+30]           $xCoord   $yCoord   $zCoord    # Contact nodes bottom Left - Maximum number of girders is 9



    
puts "contact left"
puts $xCoord
puts $yCoord
puts $zCoord
puts "   "
puts $i
puts [expr $i+30]


# Right nodes 
    
    set xCoord $DeckEnd
    set yCoord $DeckElevation
    set zCoord [expr $counter*$GirderSpacing-double($DeckWidth)/2]
    
    node [expr $i+80]           $xCoord   $yCoord   $zCoord    # Contact nodes top Right    - Maximum number of girders is 9
    node [expr $i+110]           $xCoord   $yCoord   $zCoord    # Contact nodes bottom Right - Maximum number of girders is 9
 
puts "contact right"
puts $xCoord
puts $yCoord
puts $zCoord
puts "   "
puts [expr $i+80]
puts [expr $i+110]   

 
    set counter [expr $counter+1]

    set contacttopleft($spancounter,$counter)           $i

    set contactbottomleft($spancounter,$counter)         [expr $i+30]

    set contacttopright($spancounter,$counter)          [expr $i+80]
    set contactbottomright($spancounter,$counter)       [expr $i+110]
    
       
}
puts " NOdes for span $RunCounter created"

set startnode [expr $i+500]

puts " end of nodes module for span $RunCounter "
















