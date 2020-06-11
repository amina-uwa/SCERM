clear all; close all;

shp = shaperead('GIS/Helena_region_vals.shp');

% Import in the shapefile data
for i = 1:length(shp)
    Hc(i,1) = shp(i).GRID_CODE;
    pnt(i,1) = shp(i).X;
    pnt(i,2) = shp(i).Y;
    Lc(i,1) = shp(i).RASTERVALU;
end

data1 = load('Matfiles\savedata_2008.mat');
data2 = load('Matfiles\savedata_2050.mat');

HSI = data2.HSI - data1.HSI;

figure %HSI_depth

axes('position',[0 0 1 1]);
mapshow('GIS/Background.png');hold on

scatter(pnt(:,1),pnt(:,2),2,HSI,'s','filled');
colormap default;

axis off

caxis([0 0.5]);

cb = colorbar('southoutside','position',[0.1 0.06 0.8 0.05]);
title(cb,'$\Delta{HSR}$','Interpreter','latex');


set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'centimeters');
xSize = 21;
ySize = 21;
xLeft = (21-xSize)/2;
yTop = (30-ySize)/2;
set(gcf,'paperposition',[0 0 xSize ySize])

saveas(gcf,['HSI_Delmap.png']);close all;