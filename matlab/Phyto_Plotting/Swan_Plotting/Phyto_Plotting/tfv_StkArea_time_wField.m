% A staked Area plot, only field data, with the X Axis being Time.

clear all; close all;

load swan_group.mat;

outdir = ('Stacked Area Field v2/');

if ~exist(outdir,'dir')
    mkdir(outdir);
end

sites = fieldnames(swan_group);

n_group = {...
    'WQ_PHY_BGA',...
    'WQ_PHY_FDIAT',...
    'WQ_PHY_GRN',...
    'WQ_PHY_KARLO',...
    'WQ_PHY_MDIAT',...
    'WQ_PHY_DINO',...
    };


for i = 1:length(sites)
    
    groups = n_group;
    
    xdata_S = [];
    ydata_S = [];
    
    xdata_B = [];
    ydata_B = [];
    
    
    for j = 1:length(groups)
        
        u_dates = unique(floor(swan_group.(sites{i}).(groups{j}).Date));
        inc = 1;
        for k = 1:length(u_dates)
            
            ss = find(floor(swan_group.(sites{i}).(groups{j}).Date) == u_dates(k));
            
            [~,surf] = min(swan_group.(sites{i}).(groups{j}).Depth(ss));
            [~,bot] = max(swan_group.(sites{i}).(groups{j}).Depth(ss));
            
            ydata_S(inc,j) = swan_group.(sites{i}).(groups{j}).Data(ss(surf));
            xdata_S(inc,j) = swan_group.(sites{i}).(groups{j}).Date(ss(surf));
            
            ydata_B(inc,j) = swan_group.(sites{i}).(groups{j}).Data(ss(bot));
            xdata_B(inc,j) = swan_group.(sites{i}).(groups{j}).Date(ss(bot));
            
            inc = inc + 1;
            
        end
        
        leg_ID{j} = regexprep(groups{j},'_',' ');
        
    end
    
    xtick_array = datenum(2009,01:02:12,01);
    
    
    %______________________________________________________________________
    figure
    axes('position',[0.05 0.1 0.4 0.8]);
    area(xdata_S,ydata_S,'edgecolor','none'); %Suface
    
    ytik = get(gca,'ytick');
    
    set(gca,'ytick',ytik,'yticklabel',ytik,'fontsize',8);
    
    set(gca,'xtick',xtick_array,'xticklabel',datestr(xtick_array,'mmm yy'),'fontsize',10);
    
    xlim([min(xtick_array) max(xtick_array)]);
    
    %text(0.15,0.9,'Surface','units','normalized','fontsize',8);
    
    ylabel('C (ug/ml)','fontsize',10);
    
    legend(leg_ID,'location','NE','fontsize',6)
    
    %______________________________________________________________________
    axes('position',[0.55 0.1 0.4 0.8]);
    
    ydata_S = bsxfun(@rdivide, ydata_S, sum(ydata_S,2));
    
    h = area(xdata_S,ydata_S,'edgecolor','none'); %Suface
    set(gca,'Layer','top')
    
    ylim([0 1]);
    
    xlim([min(xtick_array) max(xtick_array)]);

    set(gca,'xtick',xtick_array,'xticklabel',datestr(xtick_array,'mmm yy'),'fontsize',10);
    ylabel('% Total','fontsize',10);

    %text(0.15,0.8,'Bottom','units','normalized','fontsize',8);
    
    
    
    
    
    %--% Paper Size
    set(gcf, 'PaperPositionMode', 'manual');
    set(gcf, 'PaperUnits', 'centimeters');
    set(gcf,'paperposition',[0.6350    6.3500   15   7.5]);
    
    
    filename = [outdir,sites{i},'.png'];
    
    print(gcf,'-dpng',filename,'-opengl');
    
    print(gcf,'-depsc2',regexprep(filename,'.png','.eps'),'-painters');
    
    close
    
end




