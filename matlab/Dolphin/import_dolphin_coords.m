clear all; close all;

[snum,sstr]  = xlsread('Centroids.csv','A2:C100');

for i = 1:length(snum)
    S(i).Name = ['Zone_',num2str(snum(i,1))];
    [S(i).X,S(i).Y] = ll2utm(snum(i,2),snum(i,3));
    S(i).Geometry = 'Point';
end
shapewrite(S,'Dolphin_Points.shp');