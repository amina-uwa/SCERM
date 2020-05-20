clear all; close all;

shp = shaperead('InflowPoints.shp');

datearray = [datenum(2016,01,01):01:datenum(2019,01,01)];

outdir = 'BC/';

if ~exist(outdir,'dir')
    mkdir(outdir);
end

for i = 1:length(shp)
    
    disp(shp(i).SubCat);
    fid = fopen([outdir,shp(i).SubCat,'.csv'],'wt');
    fprintf(fid,'ISOTime,Flow,Sal,Temp,zeroes,TSS\n');

    
    
    for j = 1:length(datearray)

        fprintf(fid,'%s,%4.4f,%4.4f,%4.4f,%s\n',datestr(datearray(j),'dd/mm/yyyy'),rand,0.5,20,'0','1');

    end
    
    
    fclose(fid);
    
    
    
    
    
end
            
    
    
    
    