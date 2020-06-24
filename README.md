BridgePM1 Instructions:

BridgePM (Bridge Parametric Model) is a parametric finite element model, developed in OpenSees, for nonlinear time-history analysis of bridges subjected to wave forces. BridgePM makes it possible to generate numerous bridges samples and analyze them sequentially without having to manually configuring the input files. To generate bridge samples using BridgePM and analyzing them, follow the proceeding steps:

1. To generate bridge samples, open the “Input Data Sheet.xlsm”. Each column represents an individual bridge sample and each row represents an input variable. There total 153 input variables. First column of the Excel files describes the input variables and their units. After Inserting all input variables values~~, open “Main” macro and replace the following values:~~

~~Path: Insert the address of directory in which bridge samples should be generated. ~~
~~Column: Insert the number of first and last columns of the Excel sheet in which bridge samples values are stored.~~

~~Run the macro to generate bridge samples. A separate directory will be generated for each bridge samples inside the Path directory. ~~

Using the Excel macro is deprecated. Instead, use the "Generating_simulation_folders.ipynb" to generate simulation input folders.

2. Open the Path directory in which bridges samples are generated. Open the “MultiRun.tcl” file. Change “RunCounter” values in the 3rd line to run the analysis for your desired samples (Insert the number of first and last sample files that you desire to run).

3. Copy “OpenSees.exe” in the path directory and open it. Type “run Multirun.tcl” and wait until analysis is finished. Output files for each sample will be stored in the sample directory.

