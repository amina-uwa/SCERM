%BB
clear all; close all;

[snum,sstr] = xlsread('Prawn_Sites.xlsx','A2:F1000');

lat_a = regexprep(sstr(:,5),' |"|S|’’','');
lon_a = regexprep(sstr(:,6),' |"|E|’’','');


dates = datenum(2007,04:01:148,01);


for i = 1:length(lat_a)


lat_s = split(lat_a{i},{'°','''','’'});
lon_s = split(lon_a{i},{'°','''','’'});

lat_deg = dms2degrees([abs(str2num(lat_s{1}))*-1,str2num(lat_s{2}),str2num(lat_s{3})]);
lon_deg = dms2degrees([str2num(lon_s{1}),str2num(lon_s{2}),str2num(lon_s{3})]);

[shp(i).X,shp(i).Y] = ll2utm(lat_deg,lon_deg);

shp(i).Name = sstr{i,1};
shp(i).Type = sstr{i,2};
shp(i).Code = sstr{i,3};
shp(i).Project = sstr{i,4};
shp(i).Geometry = 'Point';


T = nsidedpoly(360,'Center',[shp(i).X shp(i).Y],'Radius',50);

pol(i).X = T.Vertices(:,1);
pol(i).Y = T.Vertices(:,2);
pol(i).Name = sstr{i,1};
pol(i).Type = sstr{i,2};
pol(i).Code = sstr{i,3};
pol(i).Project = sstr{i,4};

pol(i).Geometry = 'Polygon';

T = nsidedpoly(360,'Center',[shp(i).X shp(i).Y],'Radius',500);

pol2(i).X = T.Vertices(:,1);
pol2(i).Y = T.Vertices(:,2);
pol2(i).Name = sstr{i,1};
pol2(i).Type = sstr{i,2};
pol2(i).Code = sstr{i,3};
pol2(i).Project = sstr{i,4};
pol2(i).Geometry = 'Polygon';


end
shapewrite(shp,'Prawn_Locations.shp');
shapewrite(pol,'Prawn_Polygons.shp');
shapewrite(pol2,'Prawn_Polygons_500m.shp');


clear shp;

shp = pol2;
for i = 1:length(pol2)
    shp(i).Dates = dates;
    
    if strcmpi(shp(i).Type,'Nearshore') == 1
        shp(i).Depth = 2;
    else
        shp(i).Depth = 20;
    end
    
    disp(shp(i).Type);
        
end

save Export_Locations.mat shp -mat;

