% a script to compare a model and field data (phyto data) staked area plot.

addpath(genpath('tuflowfv'));

clear all; close all;

%load swan_group.mat;
load Matfiles/peel.mat;

ncfile = 'K:\Peel_Scenarios\run_2016_2017_Tidal_Test.nc';


outdir = ('Peel_Test/');

if ~exist(outdir,'dir')
    mkdir(outdir);
end

sites = {'ph1','ph31','ph58','ph2','ph4','ph7'};
xtick_array = datenum(2015,11:01:14,01);

n_group = {...
    'WQ_PHY_GRN',...
    'WQ_PHY_CRYPT',...
    'WQ_PHY_DIATOM',...
    'WQ_PHY_DINO',...
    'WQ_PHY_BGA',...
    };
n_cols = [1 1 0;1 0 1;0 1 1;1 0 0;0 1 0];

for i = 1:length(sites)
    
    s_vars = fieldnames(peel.(sites{i}));
    
    X = peel.(sites{i}).(s_vars{1}).X;
    Y = peel.(sites{i}).(s_vars{1}).Y;
    
      
    
    m_xdata_S = [];
    m_ydata_S = [];
    
    m_xdata_B = [];
    m_ydata_B = [];
    
    minc = 1;
    
    for j = 1:length(n_group)
        
%        

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
    
    m_ydata_B = bsxfun(@rdivide, m_ydata_B, sum(m_ydata_B,2));
    
    
    h = area(m_xdata_B,m_ydata_B,'edgecolor','none'); %Bottom
    
%     for ii = 1:length(n_group)
%         h(ii).FaceColor = n_cols(ii,:);
%     end
    
    
    set(gca,'Layer','top')
    
    ylim([0 1]);
    
    ytik = get(gca,'ytick');
    
    set(gca,'ytick',ytik,'yticklabel',ytik,'fontsize',8);
    
    set(gca,'xtick',xtick_array,'xticklabel',[],'fontsize',8);
    
    xlim([min(xtick_array) max(xtick_array)]);
    
    text(0.15,0.9,'Bottom','units','normalized','fontsize',8);
    
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