##########################################################
#                                                         #
#                 BridgePM                                #
#   Created by:   Arash Saeidpour                         #
#                 University of Georgia                   #
#                                                         #
#                                                         #
###########################################################


model BasicBuilder -ndm 3 -ndf 3


set k [expr $k+1]
node $k       $xCoord   $yCoord   $zCoord ;    #### pile spring node 1

set k [expr $k+1]
node $k       $xCoord   $yCoord   $zCoord ;    #### Pile spring node 2
fix $k 1 1 1

set NumberofEmbededNodes [expr $NumberofEmbededNodes+1]
set k [expr $k+1]