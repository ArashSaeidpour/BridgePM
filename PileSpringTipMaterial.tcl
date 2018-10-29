##########################################################
#                                                         #
#                 BridgePM                                #
#   Created by:   Arash Saeidpour                         #
#                 University of Georgia                   #
#                                                         #
#                                                         #
###########################################################

# q-z spring material
  # vertical effective stress at pile tip, no water table (depth is embedded pile length)
    set sigVq   [expr $gamma*$PileEmbededLength]
  # procedure to define qult and z50
    set qzParam [get_qzParam $phi $DSec $sigVq $Gsoil]
    set qult [lindex $qzParam 0]
    set z50q [lindex $qzParam 1]
 
    uniaxialMaterial QzSimple1 $PileMaterialsCOunter  $QzSoilType  $qult  $z50q  0.0  0.0 
    set QzSimpleMaterialForPileTip $PileMaterialsCOunter
    set PileMaterialsCOunter [expr $PileMaterialsCOunter+1]




