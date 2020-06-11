clear all; close all;

shp = shaperead('GIS/Helena_region_vals.shp');
% Import in the shapefile data
for i = 1:length(shp)
    Hc(i,1) = shp(i).GRID_CODE;
    pnt(i,1) = shp(i).X;
    pnt(i,2) = shp(i).Y;
    Lc(i,1) = shp(i).RASTERVALU;
end

loc = shaperead('GIS/zones.shp');


for i = 1:length(loc)
    cells(i).inpol = find(inpolygon(pnt(:,1),pnt(:,2),loc(i).X,loc(i).Y)==1);
end
    

dirlist = dir(['Matfiles/','*.mat']);

for i = 1:length(dirlist)
    
    tt = regexprep(dirlist(i).name,'savedata_','');
    ty = str2num(regexprep(tt,'.mat',''));
    
    data = load(['Matfiles/',dirlist(i).name]);
    
    for j = 1:length(cells)
        cells(j).Data(i) = mean(data.HSI(cells(j).inpol));
        cells(j).Date(i) = ty;
        if ty == 2050
           cells(j).Date(i) = 2020;
        end
    end
end

fig1 = figure('position',[680   561   826   417]);
%         set(fig1,'defaultTextInterpreter','latex')
%         set(0,'DefaultAxesFontName','Ariel')
        set(0,'DefaultAxesFontSize',6)
int = 1;

for i = [2 4 1 5 3 6]
    
    subplot(3,2,int)
    plot(cells(i).Date,cells(i).Data,'k','marker','o','markerfacecolor','k','linestyle','none');
    hold on
    plot(cells(i).Date(end),cells(i).Data(end),'r','marker','o','markerfacecolor','r','markeredgecolor','none','linestyle','none');
    title(loc(i).Name);
    ylim([0 1]);
    xlim([2006 2021]);
    set(gca,'xtick',[2008:02:2020],'xticklabel',[2008:02:2018 2050]);
    
    if i == 3 | i == 6
     xlabel('Years')
    end
    ylabel('$\overline{HSR}$','Interpreter','latex');
    
    grid on
    int = int + 1;
end
    
    
    