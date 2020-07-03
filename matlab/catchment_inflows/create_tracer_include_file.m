clear all; close all;

shp = shaperead('../../../Source_to_SCERM/Maps/InflowPoints.shp');


fid = fopen('include_catchment_tracer.fvc','wt');

outdir = 'Flow_Catch\';

tidename = '..\BCs\Tide_v2\Fremantle_Inflow_2019_ARMS_filtered.csv';

fprintf(fid,'! Fremantle___________________________________________________________\n');
fprintf(fid,'! Tide is tracer 1 & 2\n');
fprintf(fid,'bc == WL,1,%s\n',tidename);
  fprintf(fid,'bc header ==  ISOTime,wl,Sal,Temp,TN,TP\n');
fprintf(fid,'end bc');

fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,'! Catchment___________________________________________________________\n');
fprintf(fid,'\n');
fprintf(fid,'\n');

for i = 1:length(shp)
    

filename = ['..\BCs\',outdir,shp(i).SubCat,'.csv'];

X = shp(i).X;
Y = shp(i).Y;

fprintf(fid,'bc == QC,%10.4f,%10.4f,%s\n',X,Y,filename);
  fprintf(fid,'bc header ==  ISOTime,Flow,Sal,Temp,zeroes,zeroes');
  for j = 1:12
      if j == shp(i).ERZ_new
          fprintf(fid,',TN,TP');
      else
          fprintf(fid,',zeroes,zeroes');
      end
  end
  fprintf(fid,'\n');
  if strcmpi(shp(i).SubCat,'Upper Swan01 Outflow') == 1
      fprintf(fid,'bc scale == 1\n');
  else
      fprintf(fid,'bc scale == 0.95\n');
  end
  
fprintf(fid,'end bc\n');

fprintf(fid,'\n');
fprintf(fid,'\n');

end
fclose(fid);