clear all; close all;

shp = shaperead('../../../Source_to_SCERM/Maps/InflowPoints.shp');


fid = fopen('include_catchment.fvc','wt');

outdir = 'Flow_Catch\';

tidename = '..\..\BCs\Tide_v2\Fremantle_Inflow_2019_ARMS_filtered.csv';

fprintf(fid,'! Fremantle___________________________________________________________\n');

fprintf(fid,'bc == WL,1,%s\n',tidename);
  fprintf(fid,'bc header ==  ISOTime,wl,Sal,Temp,zeroes,zeroes,TSS,TSS,Oxy,Sil,Amm,Nit,FRP,FRP,DOC_T,POC_T,DON_T,PON_T,OP,OP,DOC_T,DON_T,OP,POC_T,CHLA,CHLA,CHLA,CHLA,CHLA,CHLA\n');
  fprintf(fid,'bc scale == 1,1,1,1,1,0.3,0.7,1,1,1,1,1,0.1,0.1,0.5,0.3,1,0.3,0.5,0.9,0.7,0.2,0.5,0.167,0.125,0.333,2.292,1.25,0.00754717\n');
fprintf(fid,'end bc');

fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,'! Catchment___________________________________________________________\n');
fprintf(fid,'\n');
fprintf(fid,'\n');

for i = 1:length(shp)
    

filename = ['..\..\BCs\',outdir,shp(i).SubCat,'.csv'];

X = shp(i).X;
Y = shp(i).Y;

fprintf(fid,'bc == QC,%10.4f,%10.4f,%s\n',X,Y,filename);
  fprintf(fid,'bc header ==  ISOTime,Flow,Sal,Temp,zeroes,zeroes,TSS,TSS,Oxy,Sil,Amm,Nit,FRP,FRP,DOC_T,POC_T,DON_T,PON_T,OP,OP,DOC_T,DON_T,OP,POC_T,CHLA,CHLA,CHLA,CHLA,CHLA,CHLA\n');
  
  if strcmpi(shp(i).SubCat,'Upper Swan01 Outflow') == 1
    fprintf(fid,'bc scale == 1,1,1,1,1,0.3,0.7,1,1,1,1,1,0.1,0.1,0.5,0.3,1,0.3,0.5,0.9,0.7,0.2,0.5,0.625,0.417,0.417,0.625,2.083,0.00754717\n');
  else
    fprintf(fid,'bc scale == 0.95,1,1,1,1,0.3,0.7,1,1,1,1,1,0.1,0.1,0.5,0.3,1,0.3,0.5,0.9,0.7,0.2,0.5,0.625,0.417,0.417,0.625,2.083,0.00754717\n');  
  end
    fprintf(fid,'end bc\n');

fprintf(fid,'\n');
fprintf(fid,'\n');

end
fclose(fid);