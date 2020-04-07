clear all; close all;

load load.mat;

shp = shaperead('ERZnew.shp');


% The configuration stuff.

% Polygon to use
%the_poly = 3;

%Order to Use | Actual Polygon Region
%
%	1					9
%	2                   1
%	3                   2
%	4                   3
%	5                   4
%	6                   5
%	7                   6
%	8                   7
%	9                   8
%	10                  10
%	11                  11
%	12                  12

fid = fopen('ERZ ID and Inflows.csv','wt');

fprintf(fid,'Shapefile ID,Zone ID,Inflow Files\n');

for i = 1:length(shp)
    
 
    fprintf(fid,'%s,%s,',num2str(i),num2str(shp(i).Id));
    
    
the_poly = i;

lsites = fieldnames(Load);


int = 1;
the_lsites = [];
for i = 1:length(lsites)
    if inpolygon(Load.(lsites{i}).X,Load.(lsites{i}).Y,shp(the_poly).X,shp(the_poly).Y)
        the_lsites{int,1} = lsites{i};
        int = int + 1;
    end
end

for j = 1:length(the_lsites)
    fprintf(fid,'%s,',the_lsites{j});
end

fprintf(fid,'\n');
end
fclose(fid);