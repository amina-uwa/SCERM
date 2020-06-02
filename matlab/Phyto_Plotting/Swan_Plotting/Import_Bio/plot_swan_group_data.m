clear all; close all;

load swan_group.mat;

load swan_bio.mat;

[sNum,sStr] = xlsread('Conversions/Alice_Headers.xlsx','A2:D1000');

vars = sStr(:,2);
group = sStr(:,3);

outputdir = 'Images/Line/';

u_group = unique(group);

sites = fieldnames(swan_bio);

for i = 1:length(u_group)
    
    ss = find(strcmpi(group,u_group{i}) == 1);
    
    u_vars = vars(ss);
    
    if strcmpi(u_group{i},'Ignore') == 0
    
        for j = 1:length(sites)
            
            full_dir = [outputdir,sites{j},'/'];
            
            if ~exist(full_dir,'dir')
                mkdir(full_dir);
            end
            
            %plot(swan_group.(sites{j}).(u_group{i}).Date,swan_group.(sites{j}).(u_group{i}).Data,'*k','displayname',u_group{i});hold on
            
            all_x = swan_group.(sites{j}).(u_group{i}).Date;
            all_y = swan_group.(sites{j}).(u_group{i}).Data;
            all_z = swan_group.(sites{j}).(u_group{i}).Depth;
            
            sss = find(all_z > 1);
            yyy = find(all_z < 1);
            plot(all_x(yyy),all_y(yyy),'k','displayname',[u_group{i},' Surface']);hold on
            plot(all_x(sss),all_y(sss),'b','displayname',[u_group{i},' Bottom']);hold on
            for k = 1:length(u_vars)
                if isfield(swan_bio.(sites{j}),u_vars{k})
                    plot(swan_bio.(sites{j}).(u_vars{k}).Date,swan_bio.(sites{j}).(u_vars{k}).Data,'.r','displayname',u_vars{k});

                end
            end
            
            xlim([datenum(2008,12,01) datenum(2010,03,01)]);
            
            datearray = datenum(2008,12:04:30,01);
            
            set(gca,'XTick',datearray,'XTickLabel',datestr(datearray,'mm/yyyy'),'fontsize',8);
            
            leg = legend('location','ne');
            set(leg,'fontsize',6);
            
            %--% Paper Size
            set(gcf, 'PaperPositionMode', 'manual');
            set(gcf, 'PaperUnits', 'centimeters');
            xSize = 24;
            ySize = 16;
            xLeft = (21-xSize)/2;
            yTop = (30-ySize)/2;
            set(gcf,'paperposition',[0 0 xSize ySize])
            
            print(gcf,'-dpng',[full_dir,u_group{i},'.png'],'-opengl');
            
            close
        end
    end
end
            
            
            
            
   
        
    
    
