hel = shaperead('GIS/Helena_Pnt.shp');
ben = shaperead('GIS/Bennett_Pnt.SHP');
bay = shaperead('GIS/Bayswater_Pnt.shp');
jan = shaperead('GIS/Jane_Pnt.SHP');
sus = shaperead('GIS/Susannah_Pnt.shp');
ell = shaperead('GIS/Ellenbrook_Pnt.SHP');


%__________________________________________
hel_ID = nearestNeighbor(dtri,[hel(1).X hel(1).Y]); 
hel_S(1,1) = Sc_raw(hel_ID);
hel_X(1,1) = hel(1).X;
hel_Y(1,1) = hel(1).Y;

for i = 2:length(hel)
    hel_S(i,1) = hel_S(i-1,1) * 0.995;
    hel_X(i,1) = hel(i).X;
    hel_Y(i,1) = hel(i).Y;
end
%__________________________________________
ben_ID = nearestNeighbor(dtri,[ben(1).X ben(1).Y]); 
ben_S(1,1) = Sc_raw(ben_ID);
ben_X(1,1) = ben(1).X;
ben_Y(1,1) = ben(1).Y;

for i = 2:length(ben)
    ben_S(i,1) = ben_S(i-1,1) * 0.995;
    ben_X(i,1) = ben(i).X;
    ben_Y(i,1) = ben(i).Y;
end

%__________________________________________
jan_ID = nearestNeighbor(dtri,[jan(1).X jan(1).Y]); 
jan_S(1,1) = Sc_raw(jan_ID);
jan_X(1,1) = jan(1).X;
jan_Y(1,1) = jan(1).Y;

for i = 2:length(jan)
    jan_S(i,1) = jan_S(i-1,1) * 0.995;
    jan_X(i,1) = jan(i).X;
    jan_Y(i,1) = jan(i).Y;
end
%__________________________________________
bay_ID = nearestNeighbor(dtri,[bay(1).X bay(1).Y]); 
bay_S(1,1) = Sc_raw(bay_ID);
bay_X(1,1) = bay(1).X;
bay_Y(1,1) = bay(1).Y;

for i = 2:length(bay)
    bay_S(i,1) = bay_S(i-1,1) * 0.995;
    bay_X(i,1) = bay(i).X;
    bay_Y(i,1) = bay(i).Y;
end

%__________________________________________
sus_ID = nearestNeighbor(dtri,[sus(1).X sus(1).Y]); 
sus_S(1,1) = Sc_raw(sus_ID);
sus_X(1,1) = sus(1).X;
sus_Y(1,1) = sus(1).Y;

for i = 2:length(sus)
    sus_S(i,1) = sus_S(i-1,1) * 0.995;
    sus_X(i,1) = sus(i).X;
    sus_Y(i,1) = sus(i).Y;
end
%__________________________________________
ell_ID = nearestNeighbor(dtri,[ell(1).X ell(1).Y]); 
ell_S(1,1) = Sc_raw(ell_ID);
ell_X(1,1) = ell(1).X;
ell_Y(1,1) = ell(1).Y;

for i = 2:length(ell)
    ell_S(i,1) = ell_S(i-1,1) * 0.995;
    ell_X(i,1) = ell(i).X;
    ell_Y(i,1) = ell(i).Y;
end



%__________________________________________________
geo_x = [geo_x;hel_X;ben_X;jan_X;bay_X;sus_X;ell_X];
geo_y = [geo_y;hel_Y;ben_Y;jan_Y;bay_Y;sus_Y;ell_Y];
Sc_raw = [Sc_raw;hel_S;ben_S;jan_S;bay_S;sus_S;ell_S];
