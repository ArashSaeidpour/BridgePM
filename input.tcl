##########################################################
#                                                         #
#                 BridgePM                                #
#   Created by:   Arash Saeidpour                         #
#                 University of Georgia                   #
#                                                         #
#                                                         #
###########################################################





####### 
####### Input file
####### 
wipe;				        # clear memory of all past model definitions
set dataDir $dataline(2);	# set up name of data directory




#######  General Geometrical Properties

set columndivisions $dataline(3); ### Number of elements in a single column
set DeckDivisions $dataline(4); ## Number of longitudinal deck elements
set DeckWidth $dataline(5); ## Deck width (out to out)
set NumGirders $dataline(6); ## Number of girders 
set spansgap $dataline(7);### Gap between two consecutive spans (m)
set AbutGap $dataline(8); ## Gap between the abutment and end spans (m)
set numofcolumns $dataline(9); ## Number of columns per bent
set cantileverlength $dataline(10) ;   ## cantilever length between last outmost column and deck end point (m)
set LeftAbut $dataline(11)


set numberofspans $dataline(12); #### Total number of spans including end spans
set MiddleSpansLength $dataline(13)
set EndSpansLength $dataline(14)

 
set spanlengths(1) $EndSpansLength ;## First span length(m)
for {set i 2} {$i <= [expr $numberofspans-1]} {incr i} {
set spanlengths($i) $MiddleSpansLength
}
set spanlengths($numberofspans) $EndSpansLength ;## End span length(m)

#set spanlengths(2) 12; ## second span length(m)
#set spanlengths(3) 12
#set spanlengths(4) 12
#set spanlengths(5) 6
#set spanlengths(6) 30
#set spanlengths(7) 20
#set spanlengths(8) 50
#set spanlengths(9) 15
#set spanlengths(10) 20

set ConstantColumnHeight $dataline(15)

for {set i 1} {$i <= [expr $numberofspans-1]} {incr i} {
set ColumnHeigth($i) $ConstantColumnHeight
}

#set ColumnHeigth(1) 8 ; ## total height of columns on bent 1 , from middle of the pile cap height to the middle of the cap beam height
#set ColumnHeigth(2) 8
#set ColumnHeigth(3) 8
#set ColumnHeigth(4) 8
#set ColumnHeigth(5) 8
#set ColumnHeigth(6) 8

set MaxColumnHeigth $ColumnHeigth(1) ;#some large value
for {set i 1} {$i <= [expr $numberofspans-1]} {incr i} {
  if {$ColumnHeigth($i) > $MaxColumnHeigth} {
          set MaxColumnHeigth $ColumnHeigth($i)
                }
}  
puts "Max value is : $MaxColumnHeigth"
set DeckElevation $MaxColumnHeigth 


########## Model parameters
set contactelementswitch $dataline(16);  ### 1 use contact elements, 0 use rigid elements
set startnode    $dataline(17); ## First node number
set startelement $dataline(18); ## Firs element number
set counter $dataline(19); ## Temporary variable
set dampingrangecounter $dataline(20) ; ### Counter used to generate node and element ranges to assign damping
######################

################
################
################   Deck properties

set EndSpansUnitWeight $dataline(21); ### Weight per unit lenght of end spans
set MiddleSpansUnitWeight $dataline(22); ### Wieght per unit length of middle spans



set DeckWeigth(1) $EndSpansUnitWeight ;## First span weight per unit length (N/m)

for {set i 2} {$i <= [expr $numberofspans-1]} {incr i} {
set DeckWeigth($i) $MiddleSpansUnitWeight ; ### Middle spans weight per unit length (N/m)
}


set DeckWeigth($numberofspans) $EndSpansUnitWeight ;## End span Wieght per unit length (N/m)

#set DeckWeigth(1) 92.6e3; ### Weight of Span 1(N/m)
#set DeckWeigth(2) 127.3e3
#set DeckWeigth(3) 127.3e3
#set DeckWeigth(4) 127.3e3
#set DeckWeigth(5) 92.6e3
#set DeckWeigth(6) 127.3e3 
#set DeckWeigth(7) 127.3e3

set DeckElasticModulus $dataline(23) ; ## Deck elements Elastic Modulus (N/m^2)
set DeckShearModulus [expr 0.4*($DeckElasticModulus)]; ## Deck elements shear stiffnesst 0.4 * DeckElasticModulus 


set DeckTorsionalStiffness $dataline(24); ## Deck elements torsional stiffness 



set EndSpansDeckArea $dataline(25); ### Deck Area of end spans
set MiddleSpansDeckArea $dataline(26); ### Deck Area of middle spans

set DeckArea(1) $EndSpansDeckArea ;## First span weight per unit length m^2
for {set i 2} {$i <= [expr $numberofspans-1]} {incr i} {
set DeckArea($i) $MiddleSpansDeckArea ; ### Middle spans Deck Area m^2
}
set DeckArea($numberofspans) $EndSpansDeckArea ;## End span Deck Area m^2



#set DeckArea(1) 3.941; ## Deck elements area (m^2)
#set DeckArea(2) 5.407;
#set DeckArea(3) 5.407;
#set DeckArea(4) 5.407;
#set DeckArea(5) 3.941;
#set DeckArea(6) 3.941;
#set DeckArea(7) 3.941;
#set DeckArea(8) 3.941;
#set DeckArea(9) 3.941;


set EndSpansDeckIy $dataline(27); ### Iy of end spans
set MiddleSpansDeckIy $dataline(28); ### Iy of middle spans

set IyDeck(1) $EndSpansDeckIy ;## First span Iy m^4
for {set i 2} {$i <= [expr $numberofspans-1]} {incr i} {
set IyDeck($i) $MiddleSpansDeckIy ; ### Middle spans Iy m^4
}
set IyDeck($numberofspans) $EndSpansDeckIy ;## End span Iy m^4



#set IyDeck(1) 75.835 ; ### Deck elements moment of inertia about Y axis 
#set IyDeck(2) 103.760
#set IyDeck(3) 103.760
#set IyDeck(4) 103.760
#set IyDeck(5) 75.835
#set IyDeck(6) 75.835
#set IyDeck(7) 75.835
#set IyDeck(8) 75.835

set EndSpansDeckIz $dataline(29); ### Iz of end spans m^4
set MiddleSpansDeckIz $dataline(30); ### Iz of middle spans m^4

set IzDeck(1) $EndSpansDeckIz ;## First span Iz length m^4
for {set i 2} {$i <= [expr $numberofspans-1]} {incr i} {
set IzDeck($i) $MiddleSpansDeckIz ; ### Middle spans Iz m^4
}
set IzDeck($numberofspans) $EndSpansDeckIz ;## End span Iz m^4

#set IzDeck(1) 0.119; ## Deck elemenst moment of inertia about Z axis
#set IzDeck(2) 1.102
#set IzDeck(3) 1.102
#set IzDeck(4) 1.102
#set IzDeck(5) 0.119
#set IzDeck(6) 0.119
#set IzDeck(7) 0.119
#set IzDeck(8) 0.119
#set IzDeck(9) 0.119
#set IzDeck(10) 0.119


########################
########################
######################


##########
##########
###########  Elastomeric Bearing Material Data




##### Contact element parameters
#####################
################
set coh $dataline(31); ## Cohession of the contacts
set normdir $dataline(32) ;### normal direction of the contact elements 
set mu $dataline(33) ; ### Frictional coefficinet of the elements
set Kn $dataline(34) ; ## penalty value in normal direction
set Kt $dataline(35) ; ## penalty value in transverse direction
###################
#####################
##################  Material models parameters

#### Elastomer Parameters
set ElastomerZDirection $dataline(36) ; ## Material used for elastomer bearing pad in transverse direction
set VerImpMat $dataline(37) ;## Material used for elastomer bearings in vertical direction
set rotmat $dataline(38); ## Material used for elastomer bearings for rotation about x an y axis
set rotmatZ $dataline(153); ## Roattion around Z axis(3)
set ElastomerLength $dataline(39)
set ElastomerWidth $dataline(40)
###set ElastomerThickness 0.025; ## as implemented by nielson, only used when initial stiffness is estimated from K0= GA/h per Neilson, read Chio
##set GElastomer 1.38e6 ;### Suggested as a mean value by nielson, ranges 0.66mPa to 2.07 mPa per nielson, padgett student numbers different, only used when initial stiffness is estimated from K0= GA/h per Neilson, read Chio
set ElastomerInitialStiffness $dataline(41) ; ### Ranges from 130mPa to 160mPa per padgett 
set ElastomerbearingRotationalStiffness $dataline(42)
############# Dowel Parameters
set AnchorShearYieldStrength $dataline(43);  ## Anchor/Dowel shear yield force(failure) (N)
set AnchorShearDeltaYield $dataline(44) ; ## Anchor/Dowel shear tip displacmenet at yield(failure) (m)
set AnchorShearUltimateStrength $dataline(45);  ##  Anchor/Dowel maximum shear strength (N)
set AnchorShearDeltaUltimate $dataline(46)  ;## Anchor/Dowel maximum shear tip displacmenet before collapse (m)
set AnchorShearDeltaCollapse $dataline(47); ## Anchor/Dowel shear tip displacmenet at collapse

set AnchorTensionYieldStrength $dataline(48);  ## Anchor/Dowel shear yield force(failure) (N)
set AnchorTensileDeltaYield $dataline(49); ### Anchor/Dowel tip displacmenet at yield(failure) (m) 
set AnchorTensileUltimateStrength $dataline(50); ### Anchor/Dowel maximum strength (N)
set AnchorTensileDeltaUltimate $dataline(51); ## Anchor/Dowel maximum tip displacmenet before collapse (m)
set AnchorTensileDeltaCollapse $dataline(52); ### Anchor/Dowel tip displacmenet at collapse(m)

set DowelFixedGap $dataline(53); ## Gap before the dowel is engaged for fixed bearings, also in transverse direction
set DowelExpansionGap $dataline(54); ## Gap before the dowel is engaged for expansion bearings


##### Abutment soil and pile parameters
set k1psoilperunitwidth $dataline(55);   ## k1p soil per unit width of the bridge,K1p soil ranges 11.5 to 28.5 kN/mm per meter of the Abutment width
set HAbutment $dataline(56); ## Abutment height 
set NumberofPilesUnderAbutment $dataline(57)


#########Unconfined concrete material model - Kent-Scott-Park model--------------------------

set fpcuc $dataline(58); # concrete compressive strength at 28 days (compression is negative)
set epscuc $dataline(59); # concrete strain at maximum strength
set fpcuuc $dataline(60); # concrete crushing strength 
set epsuuc $dataline(61)

#########confined concrete material model - Kent-Scott-Park model--------------------------

set steeldensity $dataline(62); # Transverse steel ratio of the volume of the steel hoops to volume of concrete core measured to the outside of the peripheral hoop
set fyh $dataline(63); # yield strength of the steel hoops

set fpcuucc $dataline(64); # concrete crushing strength 
set epsuucc $dataline(65)

########### Reinforcing steel material model- bilinear material-----------------------------
set fys $dataline(66); ## rebar yeild strength
set es $dataline(67); ## rebar elasticity
set sthardening $dataline(68); ## strain hardening ratio


############3 Bent piles Parameters
set BentPileHorizontalStiffness $dataline(69) ; ### Horizontal stiffness x and y 
set BentPileVerticalStiffness $dataline(70) ; ###Vertical stiffness - 8piles X 175kn/mm/pile
set BentPileRotationalStiffness $dataline(71); ### ## rotational stiffness x-x and y-y

#### Rigid and soft material stiffness
set RigidMaterialStiffness $dataline(72)
set SoftMaterialStiffness $dataline(73)

################ Section Parameters
#####################
######################

################################## Column circular Fiber section parameters-------------------------------------
# section GEOMETRY 
set DenConc $dataline(74); # concrete density kg/m^3
set DSec $dataline(75); 		# Column Diameter in meter
set coverSec $dataline(76);		# Column cover to reinforcing steel NA.
set numBarsSec $dataline(77);		# number of uniformly-distributed longitudinal-reinforcement bars
set ColBarDia $dataline(78) ;         # Column longitudinal bars diameter


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
set ri $dataline(79);			# inner radius of the section, only for hollow sections
set nfCoreR $dataline(80);		# number of radial divisions in the core (number of "rings")
set nfCoreT $dataline(81);		# number of theta divisions in the core (number of "wedges")
set nfCoverR $dataline(82);		# number of radial divisions in the cover
set nfCoverT $dataline(83);		# number of theta divisions in the cover
#set ColumnTorsionalStiffness $dataline(84); ### Column Torsional stiffness

####### Cap beam  Fiber section parameters

################################## Bent Beam Fiber section definition-------------------------------------
# Should be designed or use existing georgia bridges 
# section GEOMETRY -------------------------------------------------------------
set DenConc $dataline(85);              # Concrete Density , kg/m^3
set HSec $dataline(86); 		# Beam Depth
set BSec $dataline(87);		# Beam Width
set coverH $dataline(88);		# Beam cover to reinforcing steel NA, parallel to H
set coverB $dataline(89);		# Beam cover to reinforcing steel NA, parallel to B
set numBarsTop $dataline(90);		# number of longitudinal-reinforcement bars in steel layer. -- top
set numBarsBot $dataline(91);		# number of longitudinal-reinforcement bars in steel layer. -- bot
set numBarsIntTot $dataline(92);	        # number of longitudinal-reinforcement bars in steel layer. -- total intermediate skin reinforcement, symm about y-axis
set CapBeamTopBarDia $dataline(93);    # Diameter of the longitudinal bars in top of the cap beam
set CapBeamBottomBarDia $dataline(94); # Diameter of the longitudinal bars in bottom of the cap beam
set CapBeamIntBarDia $dataline(95);    # Diameter of the bars in Intermediate of the cap beam
set nfY $dataline(96);			# number of fibers for concrete in y-direction
set nfZ $dataline(97);		        # number of fibers for concrete in z-direction
#set CapBeamTorsionalStiffness $dataline(98)  ;## torsional stiffness of the capbeam
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

		                
###########################################  Wave, surge and loading parameters parameters
################################################
######################################################

set d $dataline(99); ## average water depth over the fetch lengthincluding surge, astronomical tide, and local wind set up (m)
set F $dataline(100); ## Fetch length in the direction of the wind from the upwind shore(m)
set U3sec $dataline(101); ## Design wind velocity at the standard 10m(32.8ft) elevation and averaged for a duration of 3 seconds(m/s)
set ds $dataline(102); # water depth at or near the bridge, including surge, astronimical tide, and local wind set-up (m)
set windduration(1) $dataline(103) 

################### Laod intensity parameters


set RailHeigth $dataline(104); ## Railheight(m)
set PercentAirSwitch $dataline(105) ; ## Switch between minimum and maximum values for trapped air, 1 for maximum, 0 for minimum
set db $dataline(106); # Girder height plus slab thickness for girder bridges(m)
set dg $dataline(107) ; ## Girder height for girder bridges (m)


################### Loadding Time History Parameters
set LoadingDT $dataline(108);  ### Time steps for which loading values will be generated
set s $dataline(109) ;### Damping factor for time history loading

#################################### Analysis Parameters
######################################
##########################################

###### Display parameters
#########################
#### PRP: Projector reference point (prp), This point defines the center of projection,Usually it is placed at the center of the object that is to be graphically presented
set prpx $dataline(110)
set prpy $dataline(111)
set prpz $dataline(112)
### VUP : View-UP vector
set vupx $dataline(113)
set vupy $dataline(114)
set vupz $dataline(115)
### Viewwindow: define the size of the viewing window relative to the prp
set viewwindowx1 $dataline(116)
set viewwindowx2 $dataline(117)
set viewwindowy1 $dataline(118)
set viewwindowy2 $dataline(119)
#### display argument
set displaymode  $dataline(120) ;#### which mode shape to show, -1 for the first mode shape and -2 for the second
set displaymagnodes  $dataline(121) ;#### Magnification factor for nodes
set displaymagres  $dataline(122) ;### Magnification factor for the response

####### Static analysis parameters

set StaticNumberer $dataline(123) ; ### Defines numberer for static analysis
set StaticConstraints $dataline(124) ; ### Static constraint
set StaticAlphaS $dataline(125) ; ### Defines penalty factor Alphas for single point constraints
set StaticAlphaM $dataline(126) ; ### Defines penalty factor Alpham for multi points constraints
set StatisSystem $dataline(127); ### Defines system for static analysis
set StatistestTestType $dataline(128); ######
set StaticTestTol $dataline(129) ; ### Tolerance criteria for static analysis
set StaticTestIterations $dataline(130) ; ### Maximim number of iterations per increment
###set StaticAlgorithm Newton -initial ; ### static Algorithm type
set StaticIntegrator $dataline(131) ; #### static Integrator type
set StaticIncrement $dataline(132) ; #### static Load increment


###### Eigenvalue analysis
set numModes $dataline(133) ; ### Number of eigenmodes

###### Dynamic analysis

set zeta $dataline(134);		# percentage of critical damping assigned to structure
set DynamicTestType $dataline(135); #### Test type used to test the convergence in each inceremtn
set DynamicTestTol $dataline(136) ; ### Tolerance by which convergence is measured
set DynamicTelMaxIte $dataline(137) ; ### Maximum number of iterations for each increment
set DynamicNumberer $dataline(138) ; ## Numberer for dynamic analysis
set DynamicConstriants $dataline(139); ## Contraints used for dunamic analysis
###set DynamicSystem  ; ## in analysis file
###set DynamicIntegrator ; ## in analysis file
set DT $dataline(140); ## Dynamic analysis time steps
set DynamicAlgorithm $dataline(141) ; ### Algorithm used for dynamic analysis
set timeStepReduction $dataline(142); ## Factor multiplied by DT to decrease the time steps when needed



set BentSectionSwitch $dataline(143); ## 1=RC column, 2=PRC pile

### Prestressing material properties
set StrandElasticModulus $dataline(144); ## Strand modulus of elasticity , 200e9
set StrandFy $dataline(145); ## Strand FY, 1660Mpa
set StrandHardeningRatio $dataline(146); ### Strand hardening ratio 0.018
set StrandInitailStrain $dataline(147) ; ## Strand initial strain
set PSCInitialStrain $dataline(148) ; ## unconfined cocn initial strain
set PSCInitialStrain $dataline(149) ; # confined conc initial strain


############## Prestressed pile section properties

set PSCPileType $dataline(150); # enter Georgia standard PSC pile section dimension here, valid entries : 12, 14, 16, 18, 20 ( in inch)
set PileExposedLength $dataline(154);    ; # Length of the pile that is extended above the ground
# soil unit weight (N/m^3)
set gamma  $dataline(155)
# soil internal friction angle (degrees)
set phi    $dataline(156)
# soil shear modulus at pile tip (Pa)
set Gsoil  $dataline(157)
 
# select pult definition method for p-y curves
# API (default) --> 1
# Brinch Hansen --> 2
set puSwitch $dataline(158) 
 
# variation in coefficent of subgrade reaction with depth for p-y curves
# API linear variation (default)   --> 1
# modified API parabolic variation --> 2
set kSwitch $dataline(159)
 
# effect of ground water on subgrade reaction modulus for p-y curves
# above gwt --> 1
# below gwt --> 2
set gwtSwitch $dataline(160)

### Set soil type for PySimple1 material model 
### soilType = 1 Backbone of p-y curve approximates Matlock (1970) soft clay relation.
### soilType = 2 Backbone of p-y curve approximates API (1993) sand relation.
set PySoilType $dataline(161)

### ### Set soil type for TzSimple1 material model 
#### soilType = 1 Backbone of t-z curve approximates Reese and O'Neill (1987).
#### soilType = 2 Backbone of t-z curve approximates Mosher (1984) relation.
set TzSoilType $dataline(162)

### ### Set soil type for QzSimple1 material model 
#### qzType = 1 Backbone of q-z curve approximates Reese and O'Neill's (1987) relation for drilled shafts in clay.
#### qzType = 2 Backbone of q-z curve approximates Vijayvergiya's (1977) relation for piles in sand.
set QzSoilType $dataline(163)


