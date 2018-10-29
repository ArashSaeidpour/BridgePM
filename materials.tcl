##########################################################
#                                                         #
#                 BridgePM                                #
#   Created by:   Arash Saeidpour                         #
#                 University of Georgia                   #
#                                                         #
#                                                         #
###########################################################


puts " Materials module start"


set pi [expr acos(-1)]




 



#####--------------------------------------------

# MAterial models for elastomeric pads - middle span
set sigmam1 [expr ($spanlengths(2)*$DeckWeigth(2))/($ElastomerWidth*$ElastomerLength*$NumGirders*2)];  ## Configs of the second span is considered as the general config of all middle spans as it is the case in this project 
set miu1 [expr 0.05+0.4/($sigmam1/1000000)]
set fyelastomer1 [expr (($spanlengths(2)*$DeckWeigth(2))/($NumGirders*2))*$miu1]
puts $fyelastomer1

# uniaxialMaterial Steel01 $matTag $Fy $E0 $b <$a1 $a2 $a3 $a4>
# Due to concergence problems hardening ratio set to 0.00001 rather than 0.
##set ElastomerInitialStiffness [expr ($GElastomer*$ElastomerWidth*$ElastomerLength)/($ElastomerThickness)] ; ### K0= GA/h per Neilson, read Chio
uniaxialMaterial Steel01 1 $fyelastomer1 $ElastomerInitialStiffness 0.0; #0.000001   
###-------------------------------------------------

## MAterial models for elastomeric pads- end span
set sigmam2 [expr ($spanlengths(1)*$DeckWeigth(1))/($ElastomerWidth*$ElastomerLength*$NumGirders*2)];  ### Configs of first span is considered for the first and last span
set miu2 [expr 0.05+0.4/($sigmam2/1000000)]
set fyelastomer2 [expr (($spanlengths(1)*$DeckWeigth(1))/($NumGirders*2))*$miu2]
# uniaxialMaterial Steel01 $matTag $Fy $E0 $b <$a1 $a2 $a3 $a4>
# Due to concergence problems hardening ratio set to 0.00001 rather than 0.
uniaxialMaterial Steel01 2 $fyelastomer2 $ElastomerInitialStiffness 0;  #0.000001    


#######---------------------------------------------------------

# MAterial modeles for dowel - SHEAR


puts "$AnchorShearYieldStrength $AnchorShearDeltaYield $AnchorShearUltimateStrength $AnchorShearDeltaUltimate 0 $AnchorShearDeltaCollapse -$AnchorShearYieldStrength -$AnchorShearDeltaYield -$AnchorShearUltimateStrength -$AnchorShearDeltaUltimate 0 -$AnchorShearDeltaCollapse "


set AnchorShearDeltaYieldFixed	        [expr $DowelFixedGap+$AnchorShearDeltaYield]
set AnchorShearDeltaUltimateFixed	[expr $DowelFixedGap+$AnchorShearDeltaUltimate]
set AnchorShearDeltaCollapse	        [expr $DowelFixedGap+$AnchorShearDeltaCollapse]



#uniaxialMaterial Hysteretic $matTag $s1p $e1p $s2p $e2p <$s3p $e3p> $s1n $e1n $s2n $e2n <$s3n $e3n> $pinchX $pinchY $damage1 $damage2 <$beta>
uniaxialMaterial Hysteretic 40 $AnchorShearYieldStrength  $AnchorShearDeltaYieldFixed $AnchorShearUltimateStrength $AnchorShearDeltaUltimateFixed  0  $AnchorShearDeltaCollapse -$AnchorShearYieldStrength -$AnchorShearDeltaYieldFixed -$AnchorShearUltimateStrength -$AnchorShearDeltaUltimateFixed 0 -$AnchorShearDeltaCollapse 1 0 0 0



set AnchorShearDeltaYieldExpansion	[expr $DowelExpansionGap+$AnchorShearDeltaYield]
set AnchorShearDeltaUltimatEExpansion	[expr $DowelExpansionGap+$AnchorShearDeltaUltimate]
set AnchorShearDeltaCollapse	        [expr $DowelExpansionGap+$AnchorShearDeltaCollapse]


puts  "$AnchorShearYieldStrength"
puts "  $AnchorShearDeltaYieldExpansion "
puts "  $AnchorShearUltimateStrength"
puts "  $AnchorShearDeltaUltimatEExpansion  "
puts "0"
puts   "$AnchorShearDeltaCollapse"
 
#set AnchorShearDeltaCollapse 0.04 

#uniaxialMaterial Hysteretic $matTag $s1p $e1p $s2p $e2p <$s3p $e3p> $s1n $e1n $s2n $e2n <$s3n $e3n> $pinchX $pinchY $damage1 $damage2 <$beta>
uniaxialMaterial Hysteretic 41 $AnchorShearYieldStrength  $AnchorShearDeltaYieldExpansion $AnchorShearUltimateStrength $AnchorShearDeltaUltimatEExpansion  0  $AnchorShearDeltaCollapse -$AnchorShearYieldStrength -$AnchorShearDeltaYieldExpansion -$AnchorShearUltimateStrength -$AnchorShearDeltaUltimatEExpansion 0 -$AnchorShearDeltaCollapse 1 0 0 0





#####-------------------------------------------------------


#######---------------------------------------------------------

# MAterial modeles for dowel - TENSION



 





#uniaxialMaterial Hysteretic $matTag $s1p $e1p $s2p $e2p <$s3p $e3p> $s1n $e1n $s2n $e2n <$s3n $e3n> $pinchX $pinchY $damage1 $damage2 <$beta>
#uniaxialMaterial Hysteretic 62 $AnchorTensionYieldStrength $AnchorTensileDeltaYield $AnchorTensileUltimateStrength $AnchorTensileDeltaUltimate 0 $AnchorTensileDeltaCollapse -5.2e5 -1.0e-4 -10.4e5 -2.0e-4 -20.8e5 -4.0e-4 1 0 0 0 

#uniaxialMaterial Hysteretic 62 $AnchorTensionYieldStrength $AnchorTensileDeltaYield $AnchorTensileUltimateStrength $AnchorTensileDeltaUltimate 0 $AnchorTensileDeltaCollapse -10e10 -1 -20e10 -2 -30e10 -3  1 0 0 0

#uniaxialMaterial ElasticPP 62 [expr $AnchorTensionYieldStrength/$AnchorTensileDeltaYield] $AnchorTensileDeltaYield  20.0




#uniaxialMaterial Hysteretic 62 $AnchorTensionYieldStrength $AnchorTensileDeltaYield $AnchorTensileUltimateStrength $AnchorTensileDeltaUltimate  -1.0e6 -1.0e-4 -2.0e6 -2.0e-4  1 0 0 0 
uniaxialMaterial Elastic 1062 [expr $AnchorTensionYieldStrength/$AnchorTensileDeltaYield] 0.0 10e6
 

 uniaxialMaterial MinMax 62 1062 -min -1.0 -max $AnchorTensileDeltaYield 

## uniaxialMaterial ElasticPPGap 622 1e9 1e12 1.0
## uniaxialMaterial Parallel 62 621 622

### uniaxialMaterial ElasticPP 62 [expr $AnchorTensionYieldStrength/$AnchorTensileDeltaYield]  $AnchorTensileDeltaYield -1.0


#uniaxialMaterial ElasticMultiLinear 62  -strain -1.0e-3 0.0 $AnchorTensileDeltaYield $AnchorTensileDeltaUltimate    -stress -1e9 0.0 $AnchorTensionYieldStrength $AnchorTensileUltimateStrength 
#uniaxialMaterial ElasticMultiLinear 62  -strain 1.0e-3 0.0 -$AnchorTensileDeltaYield -$AnchorTensileDeltaUltimate    -stress 1e10 0.0 -$AnchorTensionYieldStrength -$AnchorTensileUltimateStrength 


#uniaxialMaterial ENT 621 1e11
#uniaxialMaterial ElasticPPGap 622 [expr $AnchorTensionYieldStrength/$AnchorTensileDeltaYield]  $AnchorTensionYieldStrength 1e-8
#uniaxialMaterial Parallel 62 621 622



#####-------------------------------------------------------


####---------------------------------------------------------------
# MAterial modeles for modeling GAP in dowel material model- FIXED dowels
#uniaxialMaterial Hysteretic $matTag $s1p $e1p $s2p $e2p <$s3p $e3p> $s1n $e1n $s2n $e2n <$s3n $e3n> $pinchX $pinchY $damage1 $damage2 <$beta>
uniaxialMaterial Hysteretic 3 0.000001 $DowelFixedGap [expr ($AnchorShearUltimateStrength+1)*10000]  [expr (($AnchorShearUltimateStrength+1.0)*10000.0)/(200.0e9)+$DowelFixedGap] -0.000001 -$DowelFixedGap [expr -($AnchorShearUltimateStrength+1)*10000]  [expr -(($AnchorShearUltimateStrength+1.0)*10000.0)/(200.0e9)-$DowelFixedGap] 1 0 0 0 

##### ---------------------------------
# inserting gap in dowels material model-FIXED
# uniaxialMaterial Series $matTag $tag1 $tag2
uniaxialMaterial Series 5 3 40

###----------------------------------------


####---------------------------------------------------------------
# MAterial modeles for modeling GAP in dowel material model- Expansion dowels
#uniaxialMaterial Hysteretic $matTag $s1p $e1p $s2p $e2p <$s3p $e3p> $s1n $e1n $s2n $e2n <$s3n $e3n> $pinchX $pinchY $damage1 $damage2 <$beta>
uniaxialMaterial Hysteretic 6 0.000001 $DowelExpansionGap [expr ($AnchorShearUltimateStrength+1)*10000] [expr (($AnchorShearUltimateStrength+1.0)*10000.0)/(200.0e9)+$DowelExpansionGap] -0.000001 -$DowelExpansionGap [expr -($AnchorShearUltimateStrength+1)*10000] [expr -(($AnchorShearUltimateStrength+1.0)*10000.0)/(200.0e9)-$DowelExpansionGap] 1 0 0 0 

#######---------------------------------------------------------


# inserting gap in dowels material model-EXPANSION
# uniaxialMaterial Series $matTag $tag1 $tag2
uniaxialMaterial Series 7 6 41

###----------------------------------------
# composite material model = dowel+elastomer-EXPANSION bearing-middle span
#uniaxialMaterial Parallel $matTag $tag1 $tag2 
uniaxialMaterial Parallel 8 1 7



# composite material model = dowel+elastomer-FIXED bearing-middle span
#uniaxialMaterial Parallel $matTag $tag1 $tag2 
uniaxialMaterial Parallel 9 1 5

###----------------------------------------
# composite material model = dowel+elastomer-EXPANSION bearing-end span
#uniaxialMaterial Parallel $matTag $tag1 $tag2 
uniaxialMaterial Parallel 10 2 7



# composite material model = dowel+elastomer-FIXED bearing-end span
#uniaxialMaterial Parallel $matTag $tag1 $tag2 
uniaxialMaterial Parallel 11 2 5

#####-----------------------------------------------------




########## The overal pasive soil stiffness is a function of the abutment WIDTH--------------------------------

#set k1psoil 11.5e6   
set k1psoil [expr ($k1psoilperunitwidth)]; ## K1p soil ranges 11.5 to 28.5 kN/mm per meter of the Abutment width   
# Total height of the abutment back-wall
#set h 6.0   
# defines the ultimate deformation between initial stifness and the ultimate deformation
set delta3psoil [expr (0.06+(($k1psoil/1000000.0-11.5)/(28.8-11.5))*0.04)*$HAbutment] 
#puts $delta3psoil
# Defines deformation at first yield
set delta1psoil [expr 0.05*$delta3psoil]   
#puts $delta1psoil
# Defines second yield deformation
set delta2psoil [expr 0.250*$delta3psoil] 
#puts $delta2psoil
# Defines yield force
set f1psoil [expr $k1psoil*$delta1psoil*$DeckWidth*($HAbutment/1.7)] 
#puts $f1psoil
# Defines ultimate force
set f3psoil [expr 239000*$HAbutment*$DeckWidth*($HAbutment/1.7)] 
#puts $f3psoil
# Defines second yield force
set f2psoil [expr ($f1psoil+0.55*($f3psoil-$f1psoil))] 
#puts $f2psoil
# MAterial modeles for backfill soil passive reaction
#uniaxialMaterial Hysteretic $matTag $s1p $e1p $s2p $e2p <$s3p $e3p> $s1n $e1n $s2n $e2n <$s3n $e3n> $pinchX $pinchY $damage1 $damage2 <$beta>



#uniaxialMaterial Hysteretic 13 0.000001 0.001 0.000002 0.002 0 5.0 -$f1psoil -$delta1psoil -$f2psoil -$delta2psoil -$f3psoil -$delta3psoil 0 0 0 0 0
uniaxialMaterial MultiLinear 13 [expr $delta1psoil] [expr $f1psoil] [expr $delta2psoil] [expr $f2psoil] [expr $delta3psoil] [expr $f3psoil] [expr $delta3psoil*10] [expr 1.01*$f3psoil]



set deltaf23 [expr $f3psoil-$f2psoil]
set deltadelta23 [expr 2*$delta3psoil-$delta2psoil]

#### In order to include the perfect plastic portion of the stress/strain envelope, new material defined and parallelized with
#uniaxialMaterial Hysteretic 14 0.000001 0.001 0.000002 0.002 0 5.0 -0.0000001 -$delta2psoil -0.0000002 -$delta3psoil $deltaf23 -$deltadelta23 0 0 0 0 0

uniaxialMaterial ENT 14 1e18
uniaxialMaterial Series 15 13 14


#uniaxialMaterial Parallel 15 13 14


#####---------------------------

##########Material model for pile contribution------------------------------------------
# 7kN/mm/m per pile - 3 piles assumed
set keffpile [expr $NumberofPilesUnderAbutment*7000000]; 
set k1pile [expr 2.333*$keffpile] 
set k2pile [expr 0.428*$keffpile]
set delta1pile 7.62e-3
#puts $delta1pile
set delta2pile 25.4e-3
#puts $delta2pile
set sigma1pile [expr $k1pile*$delta1pile]
#puts $sigma1pile
set sigma2pile [expr $sigma1pile+$k2pile*$delta2pile]
#puts $sigma2pile
set sigma3pile [expr $sigma2pile+0.1]

#uniaxialMaterial Hysteretic $matTag $s1p $e1p $s2p $e2p <$s3p $e3p> $s1n $e1n $s2n $e2n <$s3n $e3n> $pinchX $pinchY $damage1 $damage2 <$beta>
uniaxialMaterial Hysteretic 16 $sigma1pile $delta1pile $sigma2pile $delta2pile $sigma3pile 10.0 -$sigma1pile -$delta1pile -$sigma2pile -$delta2pile -$sigma3pile -10.0 0 0 0 0 0

####### parallel material model Soil+pile- longitidual------------------------
uniaxialMaterial Parallel 17 15 16 

######-----------------

######### Pounding (impact) element material model- horizontal impact --------------------------
#### low elasticity material model defined to solve the convergence problems
###uniaxialMaterial Steel01 $matTag $Fy $E0 $b
uniaxialMaterial Steel01 18 0.000001 1.666e-6 0


set kt1 1116e6
set kt2 384e6
set initialgap 0.6
set yielddisp 25.4e-3
# uniaxialMaterial ImpactMaterial $matTag $K1 $K2 $deltay $gap
uniaxialMaterial ImpactMaterial 19 $kt1 $kt2 -$yielddisp -$initialgap 

  
####---------------------------------------------------------------------------------------

uniaxialMaterial Parallel 20 18 19
  
####---------------------------------------------------------------------------------------


######-----------------

######### Pounding (impact) element material model- horizontal impact --------------------------
#### low elasticity material model defined to solve the convergence problems
###uniaxialMaterial Steel01 $matTag $Fy $E0 $b
uniaxialMaterial Steel01 1040 10e10 1e-3 0


set kt1 1116e6
set kt2 384e6
set initialgap 0.018
set yielddisp 25.4e-3
# uniaxialMaterial ImpactMaterial $matTag $K1 $K2 $deltay $gap
uniaxialMaterial ImpactMaterial 1041 $kt1 $kt2 -$yielddisp -$initialgap 

  
####---------------------------------------------------------------------------------------

uniaxialMaterial Parallel 42 1040 1041
  
####---------------------------------------------------------------------------------------



#########Unconfined concrete material model - Kent-Scott-Park model--------------------------
#uniaxialMaterial Concrete01 $matTag $fpc $epsc0 $fpcu $epsU
#set fpcuc -27.6e6; # concrete compressive strength at 28 days (compression is negative)
#set epscuc -0.002; # concrete strain at maximum strength
#set fpcuuc 0; # concrete crushing strength 
#set epsuuc -0.0055
####uniaxialMaterial Concrete01 21 $fpcuc $epscuc $fpcuuc $epsuuc

#########confined concrete material model - Kent-Scott-Park model--------------------------
#uniaxialMaterial Concrete01 $matTag $fpc $epsc0 $fpcu $epsU
#set steeldensity 2.04e-3; # Transverse steel ratio of the volume of the steel hoops to volume of concrete core measured to the outside of the peripheral hoop
#set fyh 414e6; # yield strength of the steel hoops
#set fpcuc -27.6e6; # concrete compressive strength at 28 days (compression is negative) for unconfined strength
#####set kconfined [expr -(-1+($steeldensity*$fyh)/($fpcuc))];# Coefficient to consider increase in strength and strain of confined concrete
#####set fpcc [expr $kconfined*$fpcuc];# confined concrte strength
#set epscuc -0.002; # unconfined concrete strain at maximum strength
####set epscc [expr $kconfined*$epscuc];# confined concrete yield strain
#set fpcuucc -8.0e6; # concrete crushing strength 
#set epsuucc -0.05
####uniaxialMaterial Concrete01 22 $fpcc $epscc $fpcuucc $epsuucc

########### Reinforcing steel material model- bilinear material-----------------------------
## uniaxialMaterial Steel01 $matTag $Fy $E0 $b <$a1 $a2 $a3 $a4>
#set fys 414e6; ## rebar yeild strength
#set es 200e9; ## rebar stiffness
#set sthardening 0.018; ## strain hardening ratio
######uniaxialMaterial Steel01 23 $fys $es $sthardening

set IDconcCore 21; 				# material ID tag -- confined core concrete
set IDconcCover 22; 				# material ID tag -- unconfined cover concrete
set IDreinf 23; 				# material ID tag -- reinforcement


set fc $fpcuc;   ### 
set SteelYieldStressMPa $fys    ;   ### 



puts "fc=$fc"
puts "control2"

set Ec 	[expr 57000*sqrt(-$fc*0.000145038)*6894.76];	# Concrete Elastic Modulus
puts $Ec
puts "control2"

# confined concrete
set Kfc 		1.3;			# ratio of confined to unconfined concrete strength
set fc1C 		[expr $Kfc*$fc];		# CONFINED concrete (mander model), maximum stress
set eps1C	[expr 2.*$fc1C/$Ec];	# strain at maximum stress 
set fc2C 		[expr 0.2*$fc1C];		# ultimate stress
set eps2C 	[expr 5*$eps1C];		# strain at ultimate stress 

# unconfined concrete
set fc1U 		$fc;			# UNCONFINED concrete (todeschini parabolic model), maximum stress4147493
set eps1U	-0.003;			# strain at maximum strength of unconfined concrete
set fc2U 		[expr 0.2*$fc1U];		# ultimate stress
set eps2U	-0.01;			# strain at ultimate stress
set lambda 0.1;				# ratio between unloading slope at $eps2 and initial slope $Ec

# tensile-strength properties
set ftC [expr -0.14*$fc1C];			# tensile strength +tension
set ftU [expr -0.14*$fc1U];			# tensile strength +tension
set Ets [expr $ftU/0.002];			# tension softening stiffness

# steel properties 
set Fy 		[expr $SteelYieldStressMPa];		# STEEL yield stress
set Es		[expr 2e11];		# modulus of steel
set Bs		0.01;			# strain-hardening ratio 
set R0 18;				# control the transition from elastic to plastic branches
set cR1 0.925;				# control the transition from elastic to plastic branches
set cR2 0.15;				# control the transition from elastic to plastic branches

uniaxialMaterial Concrete02 $IDconcCore  $fc1C $eps1C $fc2C $eps2C $lambda $ftC $Ets;	# build core concrete (confined)
uniaxialMaterial Concrete02 $IDconcCover $fc1U $eps1U $fc2U $eps2U $lambda $ftU $Ets;	# build cover concrete (unconfined)
uniaxialMaterial Steel02 $IDreinf $Fy $Es $Bs $R0 $cR1 $cR2;				      # build reinforcement material










########## Defining material models for foundation springs - All bridge types except slab bridges
###### uniaxialMaterial Steel01 $matTag $Fy $E0 $b <$a1 $a2 $a3 $a4>

uniaxialMaterial Steel01 24 9e9 $BentPileHorizontalStiffness 0 ;  ## Horizontal stiffness x and y
uniaxialMaterial Steel01 25 9e9 $BentPileRotationalStiffness 0 ;  ## rotational stiffness x-x and y-y
uniaxialMaterial Steel01 26 9e9 $BentPileVerticalStiffness 0 ;  ## Vertical stiffness - 8piles X 175kn/mm/pile






##----------------------------------------
# High Stiff material
# uniaxialMaterial Elastic $matTag $E <$eta>
##set RigidMaterialStiffness 9e13
  uniaxialMaterial Elastic 27 $RigidMaterialStiffness 

####------------------------------


# Low Stiff material
# uniaxialMaterial Elastic $matTag $E <$eta>
##set SoftMaterialStiffness 1e-3
uniaxialMaterial Elastic 28 $SoftMaterialStiffness

###

#####--------------------------------------------

# MAterial models for elastomeric pads - rotational

# uniaxialMaterial Steel01 $matTag $Fy $E0 $b <$a1 $a2 $a3 $a4>
# Due to concergence problems hardening ratio set to 0.00001 rather than 0.
uniaxialMaterial Steel01 52 9e11 $ElastomerbearingRotationalStiffness 0.00001   
###-------------------------------------------------


############# Material models for prestressed strands and concrete



uniaxialMaterial ElasticPPGap 123 $StrandElasticModulus $StrandFy 0.0001 $StrandHardeningRatio ; ## Material model for strand
uniaxialMaterial InitStrainMaterial 124 123 $StrandInitailStrain ; ## impose initial strain to strands

uniaxialMaterial InitStrainMaterial 121 21 $PSCInitialStrain ; ## prestrained unconfined concrete
uniaxialMaterial InitStrainMaterial 122 22 $PSCInitialStrain ; ## prestrained confined concrete





