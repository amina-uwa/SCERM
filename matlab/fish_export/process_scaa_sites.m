clear all; close all;

[snum,sstr] = xlsread('Bream_Data_Export_Information_v1_UWA.xlsx','Stations','A2:C100');

for i = 1:length(sstr)
    S(i).Name = sstr{i,1};
    [X,Y] = ll2utm(snum(i,1),snum(i,2));
    S(i).X = X;
    S(i).Y = Y;
    S(i).Geometry = 'Point';
end
shapewrite(S,'SCAA_points.shp');