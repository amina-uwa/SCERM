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
%     for k = 1:14
%         if k == 14
%             fprintf(fid,'%s\n',['WQ_NCS_',num2str(k)]);
%         else
%             fprintf(fid,'%s,',['WQ_NCS_',num2str(k)]);
%         end
%     end
    
    
    for j = 1:length(datearray)

        fprintf(fid,'%s,%4.4f,%4.4f,%4.4f,%s\n',datestr(datearray(j),'dd/mm/yyyy'),rand,0.5,20,'0','1');
%         for k = 1:14
%             if k == shp(i).ERZ
%                 fprintf(fid,'%s,','1');
%             else
%                 fprintf(fid,'%s,','0');
%             end
% 
%         end
%         fprintf(fid,'\n');
    end
    
    
    fclose(fid);
    
    
    
    
    
end
            
    
    
    
    