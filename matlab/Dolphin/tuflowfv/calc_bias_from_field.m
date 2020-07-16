clear all; close all;

aed = shaperead('E:\Github 2018\AED_Scripts\Matlab\TFV\Polygon Region Plotting\GIS\peel_polygons.shp');

load Export_Locations.mat;

dirlist = dir('Y:\Peel Final Report\Processed_v12_joined/');


bias_vars = {'SAL';'TEMP';'WQ_NIT_AMM';'WQ_DIAG_TOT_TCHLA'};

for v = 1:length(bias_vars)
    
    thedate = [];
    theTop = [];
    theBot = [];
    for i = 3:length(dirlist)
        disp(dirlist(i).name);
        
        load(['Y:\Peel Final Report\Processed_v12_joined/',dirlist(i).name,'/',bias_vars{v},'.mat']);
        thedate = [thedate;savedata.Time];
        theTop = [theTop savedata.(bias_vars{v}).Top];
        theBot = [theBot savedata.(bias_vars{v}).Bot];
        
    end
    
    X = savedata.X;
    Y = savedata.Y;
    
    
    
    
    for j = 1:length(shp)
        
        for k = 1:length(aed)
            if strcmpi(aed(k).name,shp(j).AED_Name) == 1
                aed_inc = k;
            end
        end
        
        
        
        
        
        
        
        
        
                
                
   
        
        
        
        
        
        
        
    
    
    
    
    
    
    
    
    
    
end
    
    
    
    