##########################################################
#                                                         #
#                 BridgePM                                #
#   Created by:   Arash Saeidpour                         #
#                 University of Georgia                   #
#                                                         #
#                                                         #
###########################################################



set eleSize [expr $MaxColumnHeigth/$columndivisions]

 
# p-y spring material

  # depth of current py node
	set pyDepth [expr $GroundElevation - $yCoord]
  # procedure to define pult and y50
    set pyParam [get_pyParam $pyDepth $gamma $phi $DSec $eleSize $puSwitch $kSwitch $gwtSwitch]
    set pult [lindex $pyParam 0]
    set y50  [lindex $pyParam 1]
    uniaxialMaterial PySimple1 [expr $PileMaterialsCOunter]  $PySoilType  [expr 1000.0*$pult]  $y50  0.0
set PileSpringPyMaterial $PileMaterialsCOunter 
set PileMaterialsCOunter [expr $PileMaterialsCOunter+1]
 
 
# t-z spring material

  
  # vertical effective stress at current depth
    set sigV    [expr $gamma*$pyDepth]
  # procedure to define tult and z50
    set tzParam  [get_tzParam $phi $DSec $sigV $eleSize]
    set tult [lindex $tzParam 0]
    set z50  [lindex $tzParam 1]

uniaxialMaterial TzSimple1 [expr $PileMaterialsCOunter]  $TzSoilType  [expr 1000.0*$tult]  $z50  0.0
set PileSpringTzMaterial $PileMaterialsCOunter
set PileMaterialsCOunter [expr $PileMaterialsCOunter+1]


 

