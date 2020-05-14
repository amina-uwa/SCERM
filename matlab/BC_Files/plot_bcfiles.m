clear all; close all;

basedir = '../../BCs/Met/';

dirlist = dir([basedir,'*.csv']);

for k = 1:length(dirlist)
    disp(dirlist(k).name);
    outdir = [basedir,'Images/',regexprep(dirlist(k).name,'.csv',''),'/'];
    
    if ~exist(outdir,'dir')
        mkdir(outdir);
    end
    
    data = tfv_readBCfile([basedir,dirlist(k).name]);
    
    datearray = [min(data.Date):(max(data.Date) - min(data.Date))/5:max(data.Date)];
    
    
    vars = fieldnames(data);
    
    for i = 1:length(vars)
        figure
        if strcmpi(vars{i},'Date') == 0
            
%             for j = 1:length(sites)
                name = regexprep(vars{i},'_','');
                
%                 if isfield(data.(sites{j}),vars{i})
                    
                    xdata = data.Date;
                    ydata = data.(vars{i});
                    
                    plot(xdata,ydata,'displayname',name);hold on
                    
                    
%                 end
%             end
            
            xlim([datearray(1) datearray(end)]);
            
            set(gca,'XTick',datearray,'XTickLabel',datestr(datearray,'dd-mm-yy'),'fontsize',6);
            
            ylabel(upper(name),'fontsize',8);
            
            title(name);
            
            legend('location','NW');
            
            %--% Paper Size
            set(gcf, 'PaperPositionMode', 'manual');
            set(gcf, 'PaperUnits', 'centimeters');
            xSize = 21;
            ySize = 8;
            xLeft = (21-xSize)/2;
            yTop = (30-ySize)/2;
            set(gcf,'paperposition',[0 0 xSize ySize])
            
            %print(gcf,['Images_All/Guaged/',vars{i},'.eps'],'-depsc2','-painters');
            print(gcf,[outdir,vars{i},'.png'],'-dpng','-zbuffer');
            
            close all;
            
        end
    end
    
    
    
    
    
    
end

create_html_for_directory([basedir,'Images/']);

