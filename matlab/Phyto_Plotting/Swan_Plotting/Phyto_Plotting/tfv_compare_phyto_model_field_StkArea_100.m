% a script to compare a model and field data (phyto data) staked area plot.

addpath(genpath('tuflowfv'));

clear all; close all;

load swan_group.mat;
load Matfiles/swan_all.mat;

ncfile = 'E:\Swan Simulations\008_UpperSwan_2008_oxy_grid_AED2_MH\Output\swan.nc';


outdir = ('Stacked Area Field w Model 100/');

if ~exist(outdir,'dir')
    mkdir(outdir);
end

sites = fieldnames(swan_group);

xtick_array = datenum(2009,01:02:12,01);

n_group = {...
    'WQ_PHY_BGA',...
    'WQ_PHY_FDIAT',...
    'WQ_PHY_GRN',...
    'WQ_PHY_KARLO',...
    'WQ_PHY_MDIAT',...
    };
n_cols = [1 1 0;1 0 1;0 1 1;1 0 0;0 1 0];

for i = 1:length(sites)
    
    s_vars = fieldnames(swan.(sites{i}));
    
    X = swan.(sites{i}).(s_vars{1}).X;
    Y = swan.(sites{i}).(s_vars{1}).Y;
    
    
    groups = fieldnames(swan_group.(sites{i}));
    
    xdata_S = [];
    ydata_S = [];
    
    xdata_B = [];
    ydata_B = [];
    
    m_xdata_S = [];
    m_ydata_S = [];
    
    m_xdata_B = [];
    m_ydata_B = [];
    
    minc = 1;
    
    for j = 1:length(n_group)
        
        u_dates = unique(floor(swan_group.(sites{i}).(n_group{j}).Date));
        inc = 1;
        for k = 1:length(u_dates)
            
            ss = find(floor(swan_group.(sites{i}).(n_group{j}).Date) == u_dates(k));
            
            [~,surf] = min(swan_group.(sites{i}).(n_group{j}).Depth(ss));
            [~,bot] = max(swan_group.(sites{i}).(n_group{j}).Depth(ss));
            
            ydata_S(inc,j) = swan_group.(sites{i}).(n_group{j}).Data(ss(surf));
            xdata_S(inc,j) = swan_group.(sites{i}).(n_group{j}).Date(ss(surf));
            
            ydata_B(inc,j) = swan_group.(sites{i}).(groups{j}).Data(ss(bot));
            xdata_B(inc,j) = swan_group.(sites{i}).(groups{j}).Date(ss(bot));
            
            inc = inc + 1;
            
        end
        
        allvars = tfv_infonetcdf(ncfile);
        
        ss = find(strcmpi(allvars,n_group(j)) == 1);
        
        
        
        if ~isempty(ss)
            
            mleg_ID{minc} = regexprep(n_group{j},'_',' ');
            
            raw = tfv_readnetcdf(ncfile,'names',n_group(j));
            data = tfv_getmodeldatalocation(...
                ncfile,raw,X,Y,n_group(j));
            
            m_xdata_S(:,minc) = data.date;
            m_ydata_S(:,minc) = data.surface;
            
            m_xdata_B(:,minc) = data.date;
            m_ydata_B(:,minc) = data.bottom;
            
            minc = minc + 1;
        end
        
        leg_ID{j} = regexprep(n_group{j},'_',' ');
    end
    
    %______________________________________________________________________
    figure
    axes('position',[0.05 0.55 0.9 0.4]);
    
    ydata_S = bsxfun(@rdivide, ydata_S, sum(ydata_S,2));
    
    h = area(xdata_S,ydata_S,'edgecolor','none'); %Suface
    
%     for ii = 1:length(n_group)
%         h(ii).FaceColor = n_cols(ii,:);
%     end
    
    
    set(gca,'Layer','top')
    
    ylim([0 1]);
    
    ytik = get(gca,'ytick');
    
    set(gca,'ytick',ytik,'yticklabel',ytik,'fontsize',8);
    
    set(gca,'xtick',xtick_array,'xticklabel',[],'fontsize',8);
    
    xlim([min(xtick_array) max(xtick_array)]);
    
    text(0.15,0.9,'Surface','units','normalized','fontsize',8);
    
    ylabel('Total','fontsize',8);
    
    legend(leg_ID,'location','NE','fontsize',6)
    
    %______________________________________________________________________
    axes('position',[0.05 0.1 0.9 0.4]);
    
    m_ydata_S = bsxfun(@rdivide, m_ydata_S, sum(m_ydata_S,2));
    
    
    h = area(m_xdata_S,m_ydata_S,'edgecolor','none'); %Bottom
    
%     for ii = 1:length(n_group)
%         h(ii).FaceColor = n_cols(ii,:);
%     end
    
    
    set(gca,'Layer','top')
    
    ylim([0 1]);
    
    xlim([min(xtick_array) max(xtick_array)]);
    
    set(gca,'xtick',xtick_array,'xticklabel',datestr(xtick_array,'mmm yy'),'fontsize',8);
    ylabel('Total','fontsize',8);
    
    text(0.15,0.9,'Bottom','units','normalized','fontsize',8);
    
    legend(mleg_ID,'location','NE','fontsize',6)
    
    
    
    
    %--% Paper Size
    set(gcf, 'PaperPositionMode', 'manual');
    set(gcf, 'PaperUnits', 'centimeters');
    set(gcf,'paperposition',[0.6350    6.3500   30   15.2400]);
    
    
    filename = [outdir,sites{i},'.png'];
    
    print(gcf,'-dpng',filename,'-opengl');
    
    print(gcf,'-depsc2',regexprep(filename,'.png','.eps'),'-painters');
    
    close
    
 
    
end