clear all; close all;

[snum,sstr] = xlsread('Prawn_Sites.xlsx','A2:F1000');

lat_a = regexprep(sstr(:,3),' |"|S','');
lon_a = regexprep(sstr(:,4),' |"|E','');

for i = 1:length(lat_a)


lat_s = split(lat_a{i},{'°',''''});
lon_s = split(lon_a{i},{'°',''''});

lat_deg = dms2degrees([str2num(lat_s{1})*-1,str2num(lat_s{2}),str2num(lat_s{3})]);
lon_deg = dms2degrees([str2num(lon_s{1}),str2num(lon_s{2}),str2num(lon_s{3})]);

[shp(i).X,shp(i).Y] = ll2utm(lat_deg,lon_deg);

shp(i).Name = sstr{i,1};
shp(i).Type = sstr{i,2};
shp(i).Geometry = 'Point';


T = nsidedpoly(360,'Center',[shp(i).X shp(i).Y],'Radius',500);

pol(i).X = T.Vertices(:,1);
pol(i).Y = T.Vertices(:,2);
pol(i).Name = sstr{i,1};
pol(i).Type = sstr{i,2};
pol(i).Geometry = 'Polygon';


end
shapewrite(shp,'Prawn_Locations.shp');
shapewrite(pol,'Prawn_Polygons.shp');

