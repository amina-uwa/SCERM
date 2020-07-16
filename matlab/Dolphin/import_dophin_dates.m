clear all; close all;

%shp = shaperead('Dolphin_Points.shp');

[snum,sstr] = xlsread('DWDates.csv','A2:A10000');

dolphin_dates = datenum(sstr,'dd/mm/yyyy');

save dolphin_dates.mat dolphin_dates -mat;