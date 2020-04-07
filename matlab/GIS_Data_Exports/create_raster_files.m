clear all; close all;

shp = shaperead('HSIdata.shp');

fulldir = 'Raster_Export/';


if ~exist(fulldir,'dir')
    mkdir(fulldir);
end

BB = shaperead('GIS/Swan_Bound.shp');

B = BB(1);


for i = 1:length(shp)
    [ geom, iner, cpmo ] = polygeom( shp(i).X(~isnan(shp(i).X)), shp(i).Y(~isnan(shp(i).X)) );
    
    shp(i).Cen_X = geom(2);
    shp(i).Cen_Y = geom(3);
    
    
    
end




[XX,YY] = meshgrid([min(B.X):20:max(B.X)],[min(B.Y):20:max(B.Y)]);



inpol = inpolygon(XX,YY,B.X,B.Y);

vars = fieldnames(shp);



for i = 7:length(vars)
    for j = 1:length(shp)
        X(j,1) = shp(j).Cen_X;
        Y(j,1) = shp(j).Cen_Y;
        Z(j,1) = shp(j).(vars{i});
    end
    
    F = scatteredInterpolant(X,Y,Z,'linear','nearest');
    
    outfile = [fulldir,vars{i},'.asc'];
    
    ZZ = F(XX,YY);
    
    ZZ(~inpol) = NaN;
    
    write_raster(XX,YY,ZZ,outfile);
    
    extdata.(vars{i}) = ZZ;
    
    clear ZZ;
    
end



