clear all; close all;

shp = shaperead('Swan_100m_DEM.shp');


for i = 1:length(shp)
    D(i) = (shp(i).GRIDCODE / 10000) - 100;
end