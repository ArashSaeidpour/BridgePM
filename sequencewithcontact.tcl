##########################################################
#                                                         #
#                 BridgePM                                #
#   Created by:   Arash Saeidpour                         #
#                 University of Georgia                   #
#                                                         #
#                                                         #
###########################################################


####### --------------------------------------------------------------------------------------------------
####### Sequence 
####### 
# SET UP ----------------------------------------------------------------------------

####### Constants
set g 9.81;  ### Gravitional Constant
set pi [expr acos(-1)]

source math.tcl
#source statistics.tcl
source input.tcl

setMaxOpenFiles 1024;                   # Increase number of fiels that can be open

model basic -ndm 3 -ndf 6;	        # Define the model builder, ndm=#dimension, ndf=#dofs


file mkdir  $dataDir;                                        # create data directory
file mkdir "$dataDir/Columns";                              # Folder in which column output files are stores
file mkdir "$dataDir/Elastomer Bearings";                   # Folder in which elastomeric bearings output files are stores
file mkdir "$dataDir/Foundation nodes";                     # Folder in which foundation output files are stores
file mkdir "$dataDir/Abutment";                             # Folder in which soil nodes output files are stores
file mkdir "$dataDir/Deck Nodes";                           # Folder in which deck longitudinal nodes output files are stores
file mkdir "$dataDir/Contact Elements";                     # Folder in which soil nodes output files are stores
file mkdir "$dataDir/Loading time histories";               # Folder in which input time histories are stored
file mkdir "$dataDir/Column Critical Nodes";               # Folder in which critical column nodes outputs are recorded
file mkdir "$dataDir/Column Critical Elements";             # Folder in which critical column elements outputs are recorded




set counter $RecorderCounter
for {set i 2} {$i <= [expr $numberofspans]} {incr i} {
                  for {set j 1} {$j <= [expr $numofcolumns]} {incr j} {
file mkdir [append $counter "$dataDir/Columns/" "Span " [expr $i-1] " Column " $j];     ### Fiber sections for each column are saved in this directory 
                  set counter [expr $counter+1]       
file mkdir [append $counter "$dataDir/Column Critical Nodes/" "Span " [expr $i-1] " Column " $j];     ### Colum critical nodes - moment and curvature                                
                  set counter [expr $counter+1]
file mkdir [append $counter "$dataDir/Column Critical Elements/" "Span " [expr $i-1] " Column " $j];     ### Column critical element- moement and curvature                                
                  set counter [expr $counter+1]
                  }
   }


set GirderSpacing [expr double($DeckWidth)/($NumGirders-1)]


for {set i 1} {$i <= $numberofspans} {incr i} {
set MassDeck($i) [expr $DeckWeigth($i)/$g];
} 




source materials.tcl



set DeckStart $AbutGap 


for {set spancounter 1} {$spancounter <= [expr $numberofspans]} {incr spancounter} {

set DeckEnd [expr $DeckStart+double($spanlengths($spancounter))]
set SpanLength $spanlengths($spancounter)
set DeckNodesSpacing [expr double($SpanLength)/$DeckDivisions]

#source mNodes.tcl
source mNodeswithcontact.tcl
#source mElements.tcl
source melementswithcontact.tcl
set start($spancounter) $DeckStart
set DeckStart [expr double($DeckEnd)+$spansgap]

}



set RightAbut [expr $DeckEnd+$AbutGap]

source mAbutment.tcl 




puts "decks are generated"

set ConcreteModulusofElasticity [expr (2*$fpcuc)/$epscuc ] ; ### Ec=2fc/ec

#######################
##########################
######Column properties

set ColMassDen [expr $DSec*$DSec*3.1415*0.25*$DenConc];# column mass per unit length
## Geometry of coloumn elements
set ColTrans 2
geomTransf Linear $ColTrans 0. 0. 1.
##element dispBeamColumn $eleTag $iNode $jNode $numIntgrPts $secTag $transfTag <-mass $massDens> <-integration $intType>

set ColumnTorsionalStiffness [expr 0.4*$ConcreteModulusofElasticity*0.5*(1-0.63*($DSec/$DSec))*(1.0/3.0)*pow($DSec,3.0)*$DSec*(1.0/$ConstantColumnHeight)];
#puts "cocn Ec =$ConcreteModulusofElasticity"
#puts [expr pow($DSec,3.0)]


#puts "Col tor: $ColumnTorsionalStiffness"

set ColumnTorsionalStiffness 36000000. 
############# cap beam properties

set CapBeamMassDen [expr $HSec*$BSec*$DenConc];# Cap beam mass per unit length
## Geometry of Cap beam elements
set CapBeamTrans 3
geomTransf Linear $CapBeamTrans 1 0 0
##element dispBeamColumn $eleTag $iNode $jNode $numIntgrPts $secTag $transfTag <-mass $massDens> <-integration $intType>
set CapBeamTorsionalStiffness [expr 0.4*$ConcreteModulusofElasticity*0.5*(1-0.63*($HSec/$BSec))*(1.0/3.0)*pow($HSec,3.0)*$BSec*(1.0/$DeckWidth)];
#puts "cap beam tor: $CapBeamTorsionalStiffness"
#after 10000
set CapBeamTorsionalStiffness 96000000.
################### PSCPile Properties

if {$PSCPileType==12} {

set PSCPileTopStrandDia 0.0111125
set PSCPileBottomStrandDia 0.0111125
set PSCPileIntStrandDia 0.0111125
set PSCPileHSec 0.3048
set PSCPileBSec 0.3048
set PSCPilecoverH $coverSec
set PSCPilecoverB $coverSec
set PSCPilenfZ 10
set PSCPilenfY 10
set PSCPilenumBarsIntTot 2
set PSCPilenumBarsTop 3
set PSCPilenumBarsBot 3
set PSCPileTorsionalStiffness [expr 0.4*$ConcreteModulusofElasticity*0.5*(1-0.63*($PSCPileHSec/$PSCPileBSec))*(1.0/3.0)*pow($PSCPileHSec,3.0)*$PSCPileBSec*(1.0/$ConstantColumnHeight)];

}


if {$PSCPileType==14} {

set PSCPileTopStrandDia 0.0111125
set PSCPileBottomStrandDia 0.0111125
set PSCPileIntStrandDia 0.0111125
set PSCPileHSec 0.3556
set PSCPileBSec 0.3556
set PSCPilecoverH $coverSec
set PSCPilecoverB $coverSec
set PSCPilenfZ 10
set PSCPilenfY 10
set PSCPilenumBarsIntTot 4
set PSCPilenumBarsTop 4
set PSCPilenumBarsBot 4
set PSCPileTorsionalStiffness [expr 0.4*$ConcreteModulusofElasticity*0.5*(1-0.63*($PSCPileHSec/$PSCPileBSec))*(1.0/3.0)*pow($PSCPileHSec,3.0)*$PSCPileBSec*(1.0/$ConstantColumnHeight)];

}


if {$PSCPileType==16} {

set PSCPileTopStrandDia 0.0111125
set PSCPileBottomStrandDia 0.0111125
set PSCPileIntStrandDia 0.0111125
set PSCPileHSec 0.4064
set PSCPileBSec 0.4064
set PSCPilecoverH $coverSec
set PSCPilecoverB $coverSec
set PSCPilenfZ 10
set PSCPilenfY 10
set PSCPilenumBarsIntTot 4
set PSCPilenumBarsTop 4
set PSCPilenumBarsBot 4
set PSCPileTorsionalStiffness [expr 0.4*$ConcreteModulusofElasticity*0.5*(1-0.63*($PSCPileHSec/$PSCPileBSec))*(1.0/3.0)*pow($PSCPileHSec,3.0)*$PSCPileBSec*(1.0/$ConstantColumnHeight)];

}


if {$PSCPileType==18} {

set PSCPileTopStrandDia 0.0111125
set PSCPileBottomStrandDia 0.0111125
set PSCPileIntStrandDia 0.0111125
set PSCPileHSec 0.4572
set PSCPileBSec 0.4472
set PSCPilecoverH $coverSec
set PSCPilecoverB $coverSec
set PSCPilenfZ 10
set PSCPilenfY 10
set PSCPilenumBarsIntTot 4
set PSCPilenumBarsTop 4
set PSCPilenumBarsBot 4
set PSCPileTorsionalStiffness [expr 0.4*$ConcreteModulusofElasticity*0.5*(1-0.63*($PSCPileHSec/$PSCPileBSec))*(1.0/3.0)*pow($PSCPileHSec,3.0)*$PSCPileBSec*(1.0/$ConstantColumnHeight)];

}

if {$PSCPileType==20} {

set PSCPileTopStrandDia 0.0111125
set PSCPileBottomStrandDia 0.0111125
set PSCPileIntStrandDia 0.0111125
set PSCPileHSec 0.508
set PSCPileBSec 0.508
set PSCPilecoverH $coverSec
set PSCPilecoverB $coverSec
set PSCPilenfZ 10
set PSCPilenfY 10
set PSCPilenumBarsIntTot 6
set PSCPilenumBarsTop 5
set PSCPilenumBarsBot 5
set PSCPileTorsionalStiffness [expr 0.4*$ConcreteModulusofElasticity*0.5*(1-0.63*($PSCPileHSec/$PSCPileBSec))*(1.0/3.0)*pow($PSCPileHSec,3.0)*$PSCPileBSec*(1.0/$ConstantColumnHeight)];

}



puts "control 1"
source msections.tcl 



#### Switching between RC column and PSC pile for bents
if {$BentSectionSwitch==1} {

set BentSec $colSecTag3D
set ColSecHeight $ro

} elseif {$BentSectionSwitch==2} {

set GroundElevation [expr $DeckElevation-$PileExposedLength]
set PileEmbededLength $GroundElevation
set PileMaterialsCOunter 2000;

source get_pyParam.tcl
source get_tzParam.tcl
source get_qzParam.tcl

set BentSec $PSCPileSecTag3D
set ColSecHeight [expr $PSCPileHSec/2]
set ColMassDen [expr $PSCPileHSec*$PSCPileBSec*$DenConc];# pile mass per unit length
}





set criticalelementnodes [open "$dataDir/Critical column element nodes.txt" w+] ; ### This file records critical column elements near the groudn elevation and their node numbers


for {set spancounter 2} {$spancounter <=  $numberofspans} {incr spancounter} {
set longcoord [expr $start($spancounter)-double($spansgap)/2]
set FoundationElevation [expr $MaxColumnHeigth-$ColumnHeigth([expr $spancounter-1])]

if {$BentSectionSwitch==1} {
source mBents.tcl
} elseif {$BentSectionSwitch==2} {
source mBentsWithEmbededPiles.tcl
}

}

###set spancounter [expr $spancounter+1]
#set longcoord [expr $DeckEnd+double($spansgap)/2]
#source mbents.tcl

close $criticalelementnodes

puts "Bents are generated"

source connection.tcl



source WaveSurgeParameters.tcl
source LoadIntensity.tcl
source loadingtimehistories.tcl
source StaticAnalysis.tcl
source EigenvalueAnalysis.tcl
#source DynamicAnalysis.tcl
source DynamicAnalysis.tcl


puts "All Done!"








