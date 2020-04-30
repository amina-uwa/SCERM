clear all; close all;

shp = shaperead('GIS/pnt_20km_4m_vals.shp');  

mafile_dir = 'D:\Cloud\Cloudstor\Shared\Aquatic Ecodynamics (AED)\AED_Swan_BB\Salt HSI Calc\';

load('../modeltools/matfiles/swan.mat');

level = swan.s616004.Level.Data;
ldate = swan.s616004.Level.Date;


theyear = 2015;

% This is a whatever range

the_daterange = [datenum(theyear,02,01) datenum(theyear,03,01)];


if theyear == 2015
    
    data = load([mafile_dir,'Matfiles\',num2str(theyear-1),'\SAL.mat']);
    
else
    data = load([mafile_dir,'Matfiles\',num2str(theyear-1),'\SAL.mat']);
end

geo_x = double(data.savedata.X);
geo_y = double(data.savedata.Y);
dtri = DelaunayTri(geo_x,geo_y);


Height(1:length(shp),1) = NaN;
pnt(1:length(shp),1:2) = NaN;
LandCover(1:length(shp),1) = NaN;

% Import in the shapefile data
for i = 1:length(shp)
    Height(i,1) = shp(i).GRID_CODE;
    pnt(i,1) = shp(i).X;
    pnt(i,2) = shp(i).Y;
    LandCover(i,1) = shp(i).RASTERVALU;
end



pt_id = nearestNeighbor(dtri,pnt);

%Calculate distances for each point
dist(1:length(shp),1) = NaN;
for i = 1:length(shp)
    dist(i) = sqrt(power(pnt(i,1) - geo_x(pt_id(i)),2) + power(pnt(i,2) - geo_y(pt_id(i)),2));
end



