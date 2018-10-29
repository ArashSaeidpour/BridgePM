################################## Column circular Fiber section definition-------------------------------------
# section GEOMETRY 
#set DSec 0.9144; 		# Column Diameter in meter
#set coverSec 0.0508;		# Column cover to reinforcing steel NA.
#set numBarsSec 12;		# number of uniformly-distributed longitudinal-reinforcement bars
set barAreaSec [expr $ColBarDia*$ColBarDia*3.1415*0.25];# area of longitudinal-reinforcement bars
set SecTagCol 1;			# set tag for symmetric section

# Generate a circular reinforced concrete section
# with one layer of steel evenly distributed around the perimeter and a confined core.
# confined core.
# Notes
#    The center of the reinforcing bars are placed at the inner radius
#    The core concrete ends at the inner radius (same as reinforcing bars)
#    The reinforcing bars are all the same size
#    The center of the section is at (0,0) in the local axis system
#    Zero degrees is along section y-axis
# 
#set ri 0.0;			# inner radius of the section, only for hollow sections
set ro [expr $DSec/2];	        # overall (outer) radius of the section
#set nfCoreR 40;		# number of radial divisions in the core (number of "rings")
#set nfCoreT 30;		# number of theta divisions in the core (number of "wedges")
#set nfCoverR 5;		# number of radial divisions in the cover
#set nfCoverT 30;		# number of theta divisions in the cover

# Define the fiber section
section Fiber $SecTagCol  {
	set rc [expr $ro-$coverSec];					# Core radius
	patch circ 22 $nfCoreT $nfCoreR 0 0 $ri $rc 0 360;		# Define the core patch
	patch circ 21 $nfCoverT $nfCoverR 0 0 $rc $ro 0 360;	# Define the cover patch
	set theta [expr 360.0/$numBarsSec];		# Determine angle increment between bars
	layer circ 23 $numBarsSec $barAreaSec 0 0 $rc ;	# Define the reinforcing layer
}


#assign torsional Stiffness for 3D Model
set ColSecTagTorsion 29;		# ID tag for torsional section behavior
set colSecTag3D 3;			# ID tag for combined behavior for 3D model
uniaxialMaterial Elastic $ColSecTagTorsion $ColumnTorsionalStiffness;	# define elastic torsional stiffness - should be revised
section Aggregator $colSecTag3D $ColSecTagTorsion T -section $SecTagCol;	# combine section properties







################################## Bent Beam Fiber section definition-------------------------------------
# Should be designed or use existing georgia bridges 
# section GEOMETRY -------------------------------------------------------------
#set HSec 1.2192; 		# Beam Depth
#set BSec 1.0668;		# Beam Width
#set coverH 0.0762;		# Beam cover to reinforcing steel NA, parallel to H
#set coverB 0.0762;		# Beam cover to reinforcing steel NA, parallel to B
#set numBarsTop 6;		# number of longitudinal-reinforcement bars in steel layer. -- top
#set numBarsBot 9;		# number of longitudinal-reinforcement bars in steel layer. -- bot
#set numBarsIntTot 4;			# number of longitudinal-reinforcement bars in steel layer. -- total intermediate skin reinforcement, symm about y-axis
set barAreaTop [expr $CapBeamTopBarDia*$CapBeamTopBarDia*3.1415*0.25];	# area of longitudinal-reinforcement bars -- top
set barAreaBot [expr $CapBeamBottomBarDia*$CapBeamBottomBarDia*3.1415*0.25];	# area of longitudinal-reinforcement bars -- bot
set barAreaInt [expr $CapBeamIntBarDia*$CapBeamIntBarDia*3.1415*0.25];	# area of longitudinal-reinforcement bars -- intermediate skin reinf
set CapBeamSecTag 4;			# set tag for symmetric section

# FIBER SECTION properties -------------------------------------------------------------
#
#                        y
#                        ^
#                        |     
#             ---------------------    --   --
#             |   o     o     o    |     |    -- coverH
#             |                      |     |
#             |   o            o    |     |
#    z <--- |          +          |     Hsec
#             |   o            o    |     |
#             |                      |     |
#             |   o o o o o o    |     |    -- coverH
#             ---------------------    --   --
#             |-------Bsec------|
#             |---| coverB  |---|
#
#                       y
#                       ^
#                       |    
#             ---------------------
#             |\      cover        /|
#             | \------Top------/ |
#             |c|                   |c|
#             |o|                   |o|
#  z <-----|v|       core      |v|  Hsec
#             |e|                   |e|
#             |r|                    |r|
#             | /-------Bot------\ |
#             |/      cover        \|
#             ---------------------
#                       Bsec
#
# Notes
#    The core concrete ends at the NA of the reinforcement
#    The center of the section is at (0,0) in the local axis system

set coverY [expr $HSec/2.0];	# The distance from the section z-axis to the edge of the cover concrete -- outer edge of cover concrete
set coverZ [expr $BSec/2.0];	# The distance from the section y-axis to the edge of the cover concrete -- outer edge of cover concrete
set coreY [expr $coverY-$coverH];	# The distance from the section z-axis to the edge of the core concrete --  edge of the core concrete/inner edge of cover concrete
set coreZ [expr $coverZ-$coverB];	# The distance from the section y-axis to the edge of the core concrete --  edge of the core concrete/inner edge of cover concreteset nfY 16;			# number of fibers for concrete in y-direction
#set nfY 14;			        # number of fibers for concrete in y-direction
#set nfZ 14;				# number of fibers for concrete in z-direction
set numBarsInt [expr $numBarsIntTot/2];	# number of intermediate bars per side
section Fiber $CapBeamSecTag     {;	# Define the fiber section
	patch quadr 22 $nfZ $nfY -$coreY $coreZ -$coreY -$coreZ $coreY -$coreZ $coreY $coreZ; 	# Define the core patch
	patch quadr 21 1 $nfY -$coverY $coverZ -$coreY $coreZ $coreY $coreZ $coverY $coverZ;	# Define the four cover patches
	patch quadr 21 1 $nfY -$coreY -$coreZ -$coverY -$coverZ $coverY -$coverZ $coreY -$coreZ
	patch quadr 21 $nfZ 1 -$coverY $coverZ -$coverY -$coverZ -$coreY -$coreZ -$coreY $coreZ
	patch quadr 21 $nfZ 1 $coreY $coreZ $coreY -$coreZ $coverY -$coverZ $coverY $coverZ
	layer straight 23 $numBarsInt $barAreaInt  -$coreY $coreZ $coreY $coreZ;	# intermediate skin reinf. +z
	layer straight 23 $numBarsInt $barAreaInt  -$coreY -$coreZ $coreY -$coreZ;	# intermediate skin reinf. -z
	layer straight 23 $numBarsTop $barAreaTop $coreY $coreZ $coreY -$coreZ;	# top layer reinfocement
	layer straight 23 $numBarsBot $barAreaBot  -$coreY $coreZ  -$coreY -$coreZ;	# bottom layer reinforcement
};	# end of fibersection definition


######### assign torsional Stiffness for 3D Model
set CapBeamSecTagTorsion 30;		# ID tag for torsional section behavior
set CapBeamSecTag3D 6;			# ID tag for combined behavior for 3D model
uniaxialMaterial Elastic $CapBeamSecTagTorsion $CapBeamTorsionalStiffness;	# define elastic torsional stiffness
section Aggregator $CapBeamSecTag3D $CapBeamSecTagTorsion T -section $CapBeamSecTag;	# combine section properties
####------------------------------------------------------------------------------------------------------------





################################## Prestressed Pile section definition-------------------------------------
# Should be designed or use existing georgia bridges 
# section GEOMETRY -------------------------------------------------------------
#set PSCPileHSec 1.2192; 		# Beam Depth
#set PSCPileBSec 1.0668;		# Beam Width
#set PSCPilecoverH 0.0762;		# Beam cover to reinforcing steel NA, parallel to H
#set PSCPilecoverB 0.0762;		# Beam cover to reinforcing steel NA, parallel to B
#set PSCPilenumBarsTop 6;		# number of longitudinal-reinforcement bars in steel layer. -- top
#set PSCPilenumBarsBot 9;		# number of longitudinal-reinforcement bars in steel layer. -- bot
#set PSCPilenumBarsIntTot 4;			# number of longitudinal-reinforcement bars in steel layer. -- total intermediate skin reinforcement, symm about y-axis
set PSCPileStrandAreaTop [expr $PSCPileTopStrandDia*$PSCPileTopStrandDia*3.1415*0.25];	# area of longitudinal-reinforcement bars -- top
set PSCPileStrandAreaBot [expr $PSCPileBottomStrandDia*$PSCPileBottomStrandDia*3.1415*0.25];	# area of longitudinal-reinforcement bars -- bot
set PSCPileStrandAreaInt [expr $PSCPileIntStrandDia*$PSCPileIntStrandDia*3.1415*0.25];	# area of longitudinal-reinforcement bars -- intermediate skin reinf
set PSCPileSecTag 7;			# set tag for symmetric section

# FIBER SECTION properties -------------------------------------------------------------
#
#                        y
#                        ^
#                        |     
#             ---------------------    --   --
#             |   o     o     o    |     |    -- coverH
#             |                      |     |
#             |   o            o    |     |
#    z <--- |          +          |     Hsec
#             |   o            o    |     |
#             |                      |     |
#             |   o o o o o o    |     |    -- coverH
#             ---------------------    --   --
#             |-------Bsec------|
#             |---| coverB  |---|
#
#                       y
#                       ^
#                       |    
#             ---------------------
#             |\      cover        /|
#             | \------Top------/ |
#             |c|                   |c|
#             |o|                   |o|
#  z <-----|v|       core      |v|  Hsec
#             |e|                   |e|
#             |r|                    |r|
#             | /-------Bot------\ |
#             |/      cover        \|
#             ---------------------
#                       Bsec
#
# Notes
#    The core concrete ends at the NA of the reinforcement
#    The center of the section is at (0,0) in the local axis system

set PSCPilecoverY [expr $PSCPileHSec/2.0];	# The distance from the section z-axis to the edge of the cover concrete -- outer edge of cover concrete
set PSCPilecoverZ [expr $PSCPileBSec/2.0];	# The distance from the section y-axis to the edge of the cover concrete -- outer edge of cover concrete
set PSCPilecoreY [expr $PSCPilecoverY-$PSCPilecoverH];	# The distance from the section z-axis to the edge of the core concrete --  edge of the core concrete/inner edge of cover concrete
set PSCPilecoreZ [expr $PSCPilecoverZ-$PSCPilecoverB];	# The distance from the section y-axis to the edge of the core concrete --  edge of the core concrete/inner edge of cover concreteset nfY 16;			# number of fibers for concrete in y-direction
#set PSCPilenfY 14;			        # number of fibers for concrete in y-direction
#set PSCPilenfZ 14;				# number of fibers for concrete in z-direction
set PSCPilenumBarsInt [expr $PSCPilenumBarsIntTot/2];	# number of intermediate bars per side
section Fiber $PSCPileSecTag     {;	# Define the fiber section
	patch quadr 122 $PSCPilenfZ $PSCPilenfY -$PSCPilecoreY $PSCPilecoreZ -$PSCPilecoreY -$PSCPilecoreZ $PSCPilecoreY -$PSCPilecoreZ $PSCPilecoreY $PSCPilecoreZ; 	# Define the core patch
	patch quadr 121 1 $PSCPilenfY -$PSCPilecoverY $PSCPilecoverZ -$PSCPilecoreY $PSCPilecoreZ $PSCPilecoreY $PSCPilecoreZ $PSCPilecoverY $PSCPilecoverZ;	# Define the four cover patches
	patch quadr 121 1 $PSCPilenfY -$PSCPilecoreY -$PSCPilecoreZ -$PSCPilecoverY -$PSCPilecoverZ $PSCPilecoverY -$PSCPilecoverZ $PSCPilecoreY -$PSCPilecoreZ
	patch quadr 121 $PSCPilenfZ 1 -$PSCPilecoverY $PSCPilecoverZ -$PSCPilecoverY -$PSCPilecoverZ -$PSCPilecoreY -$PSCPilecoreZ -$PSCPilecoreY $PSCPilecoreZ
	patch quadr 121 $PSCPilenfZ 1 $PSCPilecoreY $PSCPilecoreZ $PSCPilecoreY -$PSCPilecoreZ $PSCPilecoverY -$PSCPilecoverZ $PSCPilecoverY $PSCPilecoverZ
	layer straight 124 $PSCPilenumBarsInt $PSCPileStrandAreaInt  -$PSCPilecoreY $PSCPilecoreZ $PSCPilecoreY $PSCPilecoreZ;	# intermediate skin reinf. +z
	layer straight 124 $PSCPilenumBarsInt $PSCPileStrandAreaInt  -$PSCPilecoreY -$PSCPilecoreZ $PSCPilecoreY -$PSCPilecoreZ;	# intermediate skin reinf. -z
	layer straight 124 $PSCPilenumBarsTop $PSCPileStrandAreaTop $PSCPilecoreY $PSCPilecoreZ $PSCPilecoreY -$PSCPilecoreZ;	# top layer reinfocement
	layer straight 124 $PSCPilenumBarsBot $PSCPileStrandAreaBot  -$PSCPilecoreY $PSCPilecoreZ  -$PSCPilecoreY -$PSCPilecoreZ;	# bottom layer reinforcement
};	# end of fibersection definition


######### assign torsional Stiffness for 3D Model
set PSCPileSecTagTorsion 31;		# ID tag for torsional section behavior
set PSCPileSecTag3D 8;			# ID tag for combined behavior for 3D model
uniaxialMaterial Elastic $PSCPileSecTagTorsion $PSCPileTorsionalStiffness;	# define elastic torsional stiffness
section Aggregator $PSCPileSecTag3D $PSCPileSecTagTorsion T -section $PSCPileSecTag;	# combine section properties
####------------------------------------------------------------------------------------------------------------

