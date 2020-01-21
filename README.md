# SCERM
Swan Canning Estuarine Response Model
<br> This sim have the updated files using with updates to MPB using seagrass material zones. 
<br>It also has updated flows for gauges that stopped reporting the flow. 
<br> sim start time == 01/05/2018 00:00:00 end time == 03/10/2018 00:00:00 
<br> All inflows are from  1/1/2013 to 1/1/2019
<br> Tide data are from 1/01/1984 to 30/09/2018
<br>
<br>Changed parameters in AED.nml<br>
<br>old
<br>Fsed_oxy = -40.0,-80.0,-50.0,-35.0,-50.0,-35.0,-30,-20.0,-10.0,-35.0
<br>R_mpbg       =   0.60 
<br>R_mpbr       =   0.06 
<br>I_Kmpb       = 140.00
<br>resuspension =   0.45, 0.0, 0.0, 0.0, 0.0


new 
<br>Fsed_oxy = -40.0,-80.0,-50.0,-35.0,-50.0,-35.0,-20,-20.0,-10.0,0.0
<br>R_mpbg       =   1.0 
<br>R_mpbr       =   0.1 
<br>I_Kmpb       = 100.00
<br>resuspension =   0.45, 0.45, 0.45, 0.45, 0.45,0.45, 0.45,0.45


<br> Initial value of 150 in PHY_mpb cells using material zones for seagrass 
