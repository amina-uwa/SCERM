function prototype_hexplot

load Load.mat;
load swan_din.mat;
shp = shaperead('ERZnew.shp');

addpath(genpath('honeycomb'));
addpath(genpath('hexscatter'));


% The configuration stuff.

% Polygon to use
the_poly = 4;

%Check spreadsheet ERZ ID and Inflows to be sure which shapefile ID and
%inflows to use.

%Order to Use | Actual Polygon Region
%
%	1					9
%	2                   1
%	3                   2
%	4                   3
%	5                   4
%	6                   5
%	7                   6
%	8                   7
%	9                   8
%	10                  10
%	11                  11
%	12                  12

filename = 'DIN_TN_Zone 3_SH';

outdir = 'DIN_TN/';

fvar = 'DIN';
lvar = 'TN_kg';

fvar_conv = 31/1000;

years = 2007:01:2018;

mbins(1).val = [1 2 3];
mbins(2).val = [4 5 6];
mbins(3).val = [7 8 9];
mbins(4).val = [10 11 12];

the_season_name = {'Summer';'Autumn';'Winter';'Spring'};


deltaT_Text = '3 Months';

% for i = 1:12
%     mbins(i).val =  [ i i ];
% end


lsites = fieldnames(Load);
fsites = fieldnames(swan);

% List of all inflows INSIDE and UPSTREAM of polygon region
allsites = {...
    'Bennett_Inflow',...
    'Helena_Inflow',...
    'Ellenbrook_Inflow',...
    'Jane_Inflow',...
    'Susannah_Inflow',...
    'Upper_Swan_Inflow',...
    %'Bayswater_Inflow';
    };


% Plot 1 configs................................................

xtext_1 = 'TN (kg)';
ytext_1 = 'DIN (mg/L)';
xlim_1 = [0 7000];
ylim_1 = [0 10];
honeybins_1 = [600 25]; % [100 500];
title_1 = 'Zone 3 (Local + Upstream)';
zlim_1 = [0 350];

% Plot 2 configs.................................................

ytext_2 = 'DIN (mg/L)';
xtext_2 = '$$\overline{TN}^*_{inf}$$';
honeybins_2 = [25 25];
xlim_2 = [0 2.5];
ylim_2 = [0 10];
title_2 = 'Zone 3 (Local + Upstream)';
zlim_2 = [0 350];
% Plot 3 configs..................................................

ytext_3 = 'DIN (mg/L)';
xtext_3 = '$$\overline{TN}^*_{inf}$$';
xlim_3 = [0 2.5];
ylim_3 = [0 10];
honeybins_3 = [25 25]; % [20 500];
title_3 = 'Zone 3 (Local)';
zlim_3 = [0 350];

% The runtime stuff

if ~exist(outdir,'dir')
    mkdir(outdir);
end

int = 1;
the_lsites = [];
for i = 1:length(lsites)
    if inpolygon(Load.(lsites{i}).X,Load.(lsites{i}).Y,shp(the_poly).X,shp(the_poly).Y)
        the_lsites{int,1} = lsites{i};
        int = int + 1;
    end
end


%the_lsites{int} = 'Upper_Swan_Inflow';

int = 1;
the_fsites = [];
for i = 1:length(fsites)
    
    if isfield(swan.(fsites{i}),fvar)
        if inpolygon(swan.(fsites{i}).(fvar).X,swan.(fsites{i}).(fvar).Y,shp(the_poly).X,shp(the_poly).Y)
            the_fsites{int,1} = fsites{i};
            int = int + 1;
        end
    end
end

the_field = [];
the_field_counter = [];
int = 1;
%Field Loop

for i = 1:length(years)
    for j = 1:length(mbins)
        
        % Get the field data for ALL the sites inside the polygon for the
        % specific 3 month period
        [the_field_Mon,field_count] = get_field_data(swan,the_fsites,fvar,years(i),mbins(j).val);
        
        % Counts up the number of field samples found in all sites for the
        % year/month bin.
        the_field_counter(int,1) = field_count;
        
        % The final variable that will be plotted
        the_field = [the_field;the_field_Mon];
        
        int = int + 1;
    end
end

the_field = the_field * fvar_conv;

% Inflow Loop This is disconnected as we might look at different period of
% inflow vs field data

the_load_local = [];
the_load_local_Q = [];
the_load_region_Q = [];
the_load_region = [];
the_season = [];
int = 1;

for i = 1:length(years)
    for j = 1:length(mbins)
        % Get the inflow data for ALL the sites inside the polygon for the
        % specific 3 month period & all data from region as specified by
        % allsites
        [local_total,region_load,local_QF,group_QF] = get_inflow_data(Load,the_lsites,allsites,lvar,years(i),mbins(j).val);
        
        
        % Match the number of field samples in this date range
        td = [];% local load
        tq = [];% region load
        tdn = [];% local load/flow
        tda = [];% region load/flow
        tg  = {};
        
        % Creating the arrays the same size as the field data for that date
        % range
        td(1:the_field_counter(int),1) = local_total;
        tq(1:the_field_counter(int),1) = region_load;
        tdn(1:the_field_counter(int),1) = local_QF;
        tda(1:the_field_counter(int),1) = group_QF;
        
        
        tg(1:the_field_counter(int),1) = the_season_name(j);
        
        % The final variables that will be plotted.
        the_load_local = [the_load_local;td];
        the_load_local_Q = [the_load_local_Q;tdn];
        the_load_region_Q = [the_load_region_Q;tda];
        the_load_region = [the_load_region;tq];
        the_season = [the_season;tg];
        
        int = int + 1;
    end
end


disp(['Limit Local Load: ',num2str(min(the_load_local)),' ',num2str(max(the_load_local))]);
disp(['Limit Local Q: ',num2str(min(the_load_local_Q)),' ',num2str(max(the_load_local_Q))]);
disp(['Limit Region Load: ',num2str(min(the_load_region)),' ',num2str(max(the_load_region))]);
disp(['Limit Region Q: ',num2str(min(the_load_region_Q)),' ',num2str(max(the_load_region_Q))]);

disp(['Limit Field Conc: ',num2str(min(the_field)),' ',num2str(max(the_field))]);





% Plotting.......................................................



% Subplot 1_______________________________
%subplot(1,3,1)

fig = figure('position',[1004         627         834         351]);
set(fig,'defaultTextInterpreter','latex')
set(0,'DefaultAxesFontName','Times')

set(gca,'TickLabelInterpreter','latex')
% if ~isempty(honeybins_1)
%     H = honeycomb(the_load_region,the_field,honeybins_1);
% else
%     H = honeycomb(the_load_region,the_field);
% end

scatterhist(the_load_region,the_field,'group',the_season);


% set(gca,'ylim',ylim_1);
% set(gca,'xlim',xlim_1);
%caxis(zlim_1);
ylabel(ytext_1,'fontsize',8);
xlabel(xtext_1,'fontsize',8);
title(title_1,'fontsize',8);

text(0.1,0.9,['  $$\Delta$$T = ',deltaT_Text],'units','normalized','FontSize',6);
text(0.1,0.85,['\#','$$\Delta$$T = ',num2str(length(years)*length(mbins))],'units','normalized','FontSize',6);
text(0.1,0.8,['n = ',num2str(length(the_field)),' Samples'],'units','normalized','FontSize',6);

% cb = colorbar;
% set(cb,'position',[0.3 0.6 0.01 0.3],'fontsize',6);
saveas(gcf,[outdir,'Plot1_',filename,'.png']);close


% Subplot 3_______________________________
%subplot(1,3,2)
fig = figure('position',[1004         627         834         351]);
set(fig,'defaultTextInterpreter','latex')
set(0,'DefaultAxesFontName','Times')

set(gca,'TickLabelInterpreter','latex')% if ~isempty(honeybins_2)
%     H = honeycomb(the_load_region_Q,the_field,honeybins_2);
% else
%     H = honeycomb(the_load_region_Q,the_field);
% end

scatterhist(the_load_region_Q,the_field,'group',the_season);

% set(gca,'ylim',ylim_2);
% set(gca,'xlim',xlim_2);
%caxis(zlim_2);
ylabel(ytext_2,'fontsize',8);
h = xlabel(xtext_2,'fontsize',8);
title(title_2,'fontsize',8);

text(0.1,0.9,['  $$\Delta$$T = ',deltaT_Text],'units','normalized','FontSize',6);
text(0.1,0.85,['\#','$$\Delta$$T = ',num2str(length(years)*length(mbins))],'units','normalized','FontSize',6);
text(0.1,0.8,['n = ',num2str(length(the_field)),' Samples'],'units','normalized','FontSize',6);

% cb = colorbar;
% set(cb,'position',[0.575 0.6 0.01 0.3],'fontsize',6);
saveas(gcf,[outdir,'Plot2_',filename,'.png']);close

% Subplot 3_______________________________
%subplot(1,3,3)
fig = figure('position',[1004         627         834         351]);
set(fig,'defaultTextInterpreter','latex')
set(0,'DefaultAxesFontName','Times')

set(gca,'TickLabelInterpreter','latex')% if ~isempty(honeybins_3)
%     H = honeycomb(the_load_local_Q,the_field,honeybins_3);
% else
%     H = honeycomb(the_load_local_Q,the_field);
% end

scatterhist(the_load_local_Q,the_field,'group',the_season);


% set(gca,'ylim',ylim_3);
% set(gca,'xlim',xlim_3);
%caxis(zlim_3);
ylabel(ytext_3,'fontsize',8);
h = xlabel(xtext_2,'fontsize',8);
title(title_3,'fontsize',8);

% cb = colorbar;
% set(cb,'position',[0.8625 0.6 0.01 0.3],'fontsize',6);


text(0.1,0.9,['  $$\Delta$$T = ',deltaT_Text],'units','normalized','FontSize',6);
text(0.1,0.85,['\#','$$\Delta$$T = ',num2str(length(years)*length(mbins))],'units','normalized','FontSize',6);
text(0.1,0.8,['n = ',num2str(length(the_field)),' Samples'],'units','normalized','FontSize',6);

% set(gcf, 'PaperPositionMode', 'manual');
% set(gcf, 'PaperUnits', 'centimeters');
% xSize = 21;
% ySize = 6;
% xLeft = (21-xSize)/2;
% yTop = (30-ySize)/2;
% set(gcf,'paperposition',[0 0 xSize ySize])

saveas(gcf,[outdir,'Plot3_',filename,'.png']);close

%close all;


end

% Internal Functions

function [the_field,field_count] = get_field_data(swan,the_fsites,var,theyear,themonths)
% Function to find and append all field data found with a region, for a
% particular daterange


the_field = [];
field_count = 0;

for k = 1:length(the_fsites)
    
    % Find all samples in a date range
    sss = find(swan.(the_fsites{k}).(var).Date >= datenum(theyear,themonths(1),1) & ...
        swan.(the_fsites{k}).(var).Date < datenum(theyear,themonths(end)+1,1));
    
    xdata = [];
    % If there is data within range
    if ~isempty(sss)
        
        %Select all data and remove NaN's. This section needs to become
        %smarter to select for surface or bottom data
        thedata = swan.(the_fsites{k}).(var).Data(sss);
        
        gg = find(~isnan(thedata) == 1);
        
        xdata = thedata(gg);
        
    end
    
    if ~isempty(xdata)
        % If there is data within range, and it's ~NaN, add it to the pile
        the_field = [the_field;xdata];
        
        field_count = field_count + length(xdata);
        
    end
end

end

function [local_load,group_load,local_Q,group_Q] = get_inflow_data(Load,the_lsites,alsites,lvar,theyear,themonths)
% Function to find and calculate load and Q for each of the inflow sites
% specified in the variable alsites (group), or found within the specified
% polygon region (local)


local_load = 0;
local_Q = 0;
local_Flow = 0;


for k = 1:length(the_lsites)
    %Find data for each site within the date range
    ttt = find(Load.(the_lsites{k}).Date >= datenum(theyear,themonths(1),1) & ...
        Load.(the_lsites{k}).Date < datenum(theyear,themonths(1)+1,1));
    
    % Get the pre-computed load dat
    local_load = local_load + sum(Load.(the_lsites{k}).(lvar)(ttt));
    % Get the pre-computed flow (ML)
    local_Flow =     local_Flow     + (sum(Load.(the_lsites{k}).ML(ttt)));
    
end

local_Q = local_load / local_Flow;


group_Q = 0;
group_load = 0;
group_flow = 0;
for k = 1:length(alsites)
    %Find data for each site within the date range
    ttt = find(Load.(alsites{k}).Date >= datenum(theyear,themonths(1),1) & ...
        Load.(alsites{k}).Date < datenum(theyear,themonths(1)+1,1));
    % Get the pre-computed load dat
    group_load = group_load + (sum(Load.(alsites{k}).(lvar)(ttt)));
    % Get the pre-computed flow (ML)
    group_flow = group_flow + (sum(Load.(alsites{k}).ML(ttt)));
    
end
group_Q = group_load / group_flow;
end



