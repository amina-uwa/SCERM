clear all; close all;

tic

%shp = shaperead('GIS/pnt_20km_4m_vals.shp');
shp = shaperead('GIS/Helena_region_vals.shp');



matfile_dir = '~/';

load('../modeltools/matfiles/swan.mat');

level = swan.s616004.Level.Data;
ldate = swan.s616004.Level.Date;

domain = shaperead('GIS/Domain.shp');

theyear = 2015; % This model runs from 01/12/2014 - 01/07/2016

% This is a whatever range



 the_daterange = [datenum(theyear,04,01) datenum(theyear,05,01)];


switch theyear
    case 2015
        data = load([matfile_dir,'Matfiles/',num2str(theyear-1),'/SAL.mat']);

    case 2008
        data = load([matfile_dir,'Matfiles/',num2str(theyear),'/SAL.mat']);

    case 2050
        data = load([matfile_dir,'Matfiles/',num2str(theyear),'/SAL.mat']);

        dvec = datevec(data.savedata.Time);
        dvec(:,1) = 2010;
        data.savedata.Time = datenum(dvec);

        level = level + 0.2;

    otherwise
end

outdir = ['Images_1/',datestr(the_daterange(1),'yyyy-mm-dd'),'_',datestr(the_daterange(end),'yyyy-mm-dd'),'/'];


if ~exist(outdir,'dir')
    mkdir(outdir);
end

%Now switch daterange to 2010 for 2050 sim

if theyear == 2050

    the_daterange = [datenum(2010,02,01) datenum(2010,03,01)];

end


ttt = find(data.savedata.Time >= the_daterange(1) & ...
    data.savedata.Time <= the_daterange(end));

Sc_raw = mean(data.savedata.SAL.Bot(:,ttt),2);




geo_x = double(data.savedata.X);
geo_y = double(data.savedata.Y);
dtri = DelaunayTri(geo_x,geo_y);

% Adding the pnt data
add_pnt_data_HD;

% geo_x = double(data.savedata.X);
% geo_y = double(data.savedata.Y);
dtri = DelaunayTri(geo_x,geo_y);


Hc(1:length(shp),1) = NaN;
pnt(1:length(shp),1:2) = NaN;
Lc(1:length(shp),1) = NaN;

% Import in the shapefile data
for i = 1:length(shp)
    Hc(i,1) = shp(i).GRID_CODE;
    pnt(i,1) = shp(i).X;
    pnt(i,2) = shp(i).Y;
    Lc(i,1) = shp(i).RASTERVALU;
end



pt_id = nearestNeighbor(dtri,pnt);

%Calculate distances for each point
Dc(1:length(shp),1) = NaN;
for i = 1:length(shp)
    Dc(i) = sqrt(power(pnt(i,1) - geo_x(pt_id(i)),2) + power(pnt(i,2) - geo_y(pt_id(i)),2));
end


Sc = Sc_raw(pt_id);


Scrit = 10;
Smax = 25;

H90 = 0.33;
ZrZ = 1.5;
Hrz = H90 + ZrZ;
%Hrz = 1; %

Dmax = 1000;





HSI_salt(1:length(Hc),1) = NaN;
HSI_depth(1:length(Hc),1) = NaN;
HSI_dist(1:length(Hc),1) = NaN;
HSI_veg(1:length(Hc),1) = NaN;



for i = 1:length(Hc)

    if inpolygon(pnt(i,1),pnt(i,2),domain.X,domain.Y)
        % Cell is in the water
        % So HSI = 1;
        HSI_salt(i,1) = 0;
        HSI_depth(i,1) = 0;
        HSI_dist(i,1) = 0;
        HSI_veg(i,1) = 0;
    else

        % Salt______________________________________

        if Sc(i) > Smax

            HSI_salt(i,1) = 1;

        else
            if Sc(i) < Smax & ...
                    Sc(i) >= Scrit

                HSI_salt(i,1) = 1 - ((Smax-Sc(i))/(Smax-Scrit));

            else
                HSI_salt(i,1) = 0;
            end
        end

        % Height______________________________________

        if Hc(i,1) < H90
            HSI_depth(i,1) = 1;
        else
            if Hc(i,1) < Hrz & ...
                    Hc(i) >= H90

                HSI_depth(i,1) = (Hrz - Hc(i,1))/(Hrz-H90);

            else
                HSI_depth(i,1) = min([(Hc(i,1)-Hrz)/(5-Hrz),0.5]);
            end
        end

        % Distance______________________________________

        
        if Dc(i) >= Dmax
            HSI_dist(i,1) = 0;
        else
            HSI_dist(i,1) = (Dmax - Dc(i))/Dmax;
        end
        
        % low lying cells always high HSI.
        if Hc(i,1) < H90
            HSI_dist(i,1) = 1;
        end

        % Landcover___________________________________

        % Landcover

        % -9999 = No Data
        % 1 = Trees
        % 2 = Sandy
        % 3 = grass
        % 4 = Concrete
        % 5 = roads
        % 6 = water
        % 7 = pavement / roof / misc


        switch Lc(i)
            case -9999
                HSI_veg(i,1) = 0;
            case 1
                HSI_veg(i,1) = 0.8;
            case 2
                HSI_veg(i,1) = 0.5;
            case 3
                HSI_veg(i,1) = 0.5;
            case 4
                HSI_veg(i,1) = 0;
            case 5
                HSI_veg(i,1) = 0.1;
            case 6
                HSI_veg(i,1) = 0.1;
            case 7
                HSI_veg(i,1) = 0.1;
            otherwise
        end

    end

end

HSI = HSI_salt.*HSI_depth.*HSI_dist.*HSI_veg;

%HSI = min([HSI_salt,HSI_depth,HSI_dist,HSI_veg],[],2);

figure % HSI

axes('position',[0 0 1 1]);
mapshow('GIS/Background.png');hold on

scatter(pnt(:,1),pnt(:,2),2,HSI,'s','filled');

caxis([0 0.75]);

axis off

cb = colorbar('southoutside');
title(cb,'HSI');

set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'centimeters');
xSize = 20;
ySize = 21;
xLeft = (21-xSize)/2;
yTop = (30-ySize)/2;
set(gcf,'paperposition',[0 0 xSize ySize])

saveas(gcf,[outdir,'HSI.png']);close all;


figure % HSI_salt

axes('position',[0 0 1 1]);
mapshow('GIS/Background.png');hold on

scatter(pnt(:,1),pnt(:,2),2,HSI_salt,'s','filled');

axis off

cb = colorbar('southoutside');
title(cb,'HSI salt');

set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'centimeters');
xSize = 20;
ySize = 21;
xLeft = (21-xSize)/2;
yTop = (30-ySize)/2;
set(gcf,'paperposition',[0 0 xSize ySize])

saveas(gcf,[outdir,'HSI_salt.png']);close all;

figure %HSI_depth

axes('position',[0 0 1 1]);
mapshow('GIS/Background.png');hold on

scatter(pnt(:,1),pnt(:,2),2,HSI_depth,'s','filled');

axis off

cb = colorbar('southoutside');
title(cb,'HSI depth');

set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'centimeters');
xSize = 20;
ySize = 21;
xLeft = (21-xSize)/2;
yTop = (30-ySize)/2;
set(gcf,'paperposition',[0 0 xSize ySize])

saveas(gcf,[outdir,'HSI_depth.png']);close all;


figure %HSI_dist

axes('position',[0 0 1 1]);
mapshow('GIS/Background.png');hold on

scatter(pnt(:,1),pnt(:,2),2,HSI_dist,'s','filled');

axis off

cb = colorbar('southoutside');
title(cb,'HSI dist');

set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'centimeters');
xSize = 20;
ySize = 21;
xLeft = (21-xSize)/2;
yTop = (30-ySize)/2;
set(gcf,'paperposition',[0 0 xSize ySize])

saveas(gcf,[outdir,'HSI_dist.png']);close all;

figure %HSI_veg

axes('position',[0 0 1 1]);
mapshow('GIS/Background.png');hold on

scatter(pnt(:,1),pnt(:,2),2,HSI_veg,'s','filled');

axis off

cb = colorbar('southoutside');
title(cb,'HSI veg');

set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'centimeters');
xSize = 20;
ySize = 21;
xLeft = (21-xSize)/2;
yTop = (30-ySize)/2;
set(gcf,'paperposition',[0 0 xSize ySize])

saveas(gcf,[outdir,'HSI_veg.png']);close all;

   toc
