hel = shaperead('GIS/Helena_Pnt.shp');
ben = shaperead('gis/Bennett_Pnt.SHP');





hel_ID = nearestNeighbor(dtri,[hel(1).X hel(1).Y]); 
ben_ID = nearestNeighbor(dtri,[ben(1).X ben(1).Y]); 

hel_S(1,1) = Sc_raw(hel_ID);
hel_X(1,1) = hel(1).X;
hel_Y(1,1) = hel(1).Y;

ben_S(1,1) = Sc_raw(ben_ID);
ben_X(1,1) = ben(1).X;
ben_Y(1,1) = ben(1).Y;


for i = 2:length(hel)
    hel_S(i,1) = hel_S(i-1,1) * 0.995;
    hel_X(i,1) = hel(i).X;
    hel_Y(i,1) = hel(i).Y;
end
for i = 2:length(ben)
    ben_S(i,1) = ben_S(i-1,1) * 0.995;
    ben_X(i,1) = ben(i).X;
    ben_Y(i,1) = ben(i).Y;
end

geo_x = [geo_x;hel_X;ben_X];
geo_y = [geo_y;hel_Y;ben_Y];
Sc_raw = [Sc_raw;hel_S;ben_S];