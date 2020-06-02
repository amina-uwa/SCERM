clear all; close all;

load ../modeltools/matfiles/swan.mat;
%load ../WIR_Catchment/swan.mat;
%MSB = s6161086;
%SUC == s6161879;
%KIN == s6161821;

outdir = 'Data_Export/';

mkdir(outdir);

sites = {...
    's6161086',...
    's6161879',...
    's6161821',...
    };

site_n = {...
    'MSB',...
    'SUC',...
    'KIN',...
    };

titles = {...
    'Middle Swan Bridge',...
    'Success Hill',...
    'Kingsley Rd',...
    };
    

datearray = datenum(1995:05:2020,01,01);
%datearray = datenum(1995,01:06:26,01);

surface_edge_color = [ 30  50  53]./255;
surface_face_color = [ 68 108 134]./255;


bottom_edge_color = [33  33  33]./255;
bottom_face_color = [141 110 99]./255;



for j = 1:length(sites)
    
    
    site = sites{j};
    sitename = site_n{j};
    
    
    
    
    
    
    mdata = swan.(site).SAL.Data;
    mdate = swan.(site).SAL.Date;
    mdepth = swan.(site).SAL.Depth;
    
    udate = unique(floor(mdate));
    
    fid = fopen([outdir,sitename,'.csv'],'wt');
    fprintf(fid,'Date,Surface,Bottom\n');
    
    int = 1;
    
    sur_val = [];
    bot_val = [];
    plot_date = [];
    for i = 1:length(udate)
        sss = find(floor(mdate) == udate(i));
        
        if ~isempty(sss)
            
            [~,bot] = min(mdepth(sss));
            [~,sur] = max(mdepth(sss));
            
            sur_val(int,1) = mdata(sss(sur));
            bot_val(int,1) = mdata(sss(bot));
            plot_date(int,1) = udate(i);
            if sur_val(int,1) < 100
                
                fprintf(fid,'%s,%4.4f,%4.4f\n',datestr(mdate(sss(1)),'dd/mm/yyyy HH:MM'),...
                    sur_val(int,1),bot_val(int,1));
            end
            
            int = int + 1;
        end
    end
    fclose(fid);
    
    figure
    
    plot(plot_date,sur_val,'o','markerfacecolor',surface_face_color,'markersize',3,'markeredgecolor',surface_edge_color); hold on
    
    plot(plot_date,bot_val,'o','markerfacecolor',bottom_face_color,'markersize',3,'markeredgecolor',bottom_edge_color);
    
    
    xlim([datearray(1) datearray(end)]);
    ylim([0 40]);
    
    set(gca,'xtick',datearray,'xticklabel',datestr(datearray,'yyyy'));
    
    grid on;
    
    title(titles{j});
    xlabel('Date');
    ylabel('Salinity (psu)');
    
    legend({'Surface Data';'Bottom Data'});
    
    print(gcf,[outdir,sitename,'.png'],'-dpng');
    
    close;
    
end


