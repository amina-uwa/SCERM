clear all; close all;

load swan.mat;

load G.mat;

[snum,sstr]= xlsread('Sequence.xlsx','A2:D10000');
cats = sstr(:,1);
sites = snum(:,3);
dist = snum(:,4);

u_cats = unique(cats,'stable');

num_pnt = [];

datearray = [1970:01:2020];
catarray = 1:1:31;



[X,Y] = meshgrid(datearray,catarray);




outdir = 'Images/';

mkdir(outdir);

for i = 1:length(u_cats)
    %%
    the_index_Q(1:length(catarray),1:length(datearray)) = NaN;
    the_index_TN(1:length(catarray),1:length(datearray)) = NaN;
    the_index_TP(1:length(catarray),1:length(datearray)) = NaN;
    
    xt_array = 1975:05:2020;
    yt_array = 1.5:1:30.5;
    yt_lab_Q(1:length(yt_array)) = {''};
    yt_lab_TN(1:length(yt_array)) = {''};
    yt_lab_TP(1:length(yt_array)) = {''};
    yt_lab_Q_D(1:length(yt_array)) = {''};
    yt_lab_TN_D(1:length(yt_array)) = {''};
    yt_lab_TP_D(1:length(yt_array)) = {''};
    
    figure_name = [outdir,u_cats{i},'.png'];
    
    the_sites = find(strcmpi(cats,u_cats{i}) == 1);
    
    rev_sites = flip(the_sites);
    
    for j = 1:length(rev_sites)
        
        one_site = sites(rev_sites(j));
        one_dist = dist(rev_sites(j));
        for k = 1:length(G)
            if one_site == str2num(G(k).Site)
                the_index_TP(j,1:length(G(k).WQ_DIAG_TOT_TP)) = G(k).WQ_DIAG_TOT_TP;
                the_index_TN(j,1:length(G(k).WQ_DIAG_TOT_TN)) = G(k).WQ_DIAG_TOT_TN;
                the_index_Q(j,1:length(G(k).Flow)) = G(k).Flow;
                
                if sum(G(k).Flow) > 0
                    yt_lab_Q(j) = {num2str(one_site)};
                    yt_lab_Q_D(j) = {sprintf('%2.2f',one_dist)};
                end
                if sum(G(k).WQ_DIAG_TOT_TN) > 0
                    yt_lab_TN(j) = {num2str(one_site)};
                    yt_lab_TN_D(j) = {sprintf('%2.2f',one_dist)};
                    
                end
                
                if sum(G(k).WQ_DIAG_TOT_TP) > 0
                    yt_lab_TP(j) = {num2str(one_site)};
                    yt_lab_TP_D(j) = {sprintf('%2.2f',one_dist)};
                end
            end
        end
    end
    the_index_Q(the_index_Q == 0) = NaN;
    the_index_TN(the_index_TN == 0) = NaN;
    the_index_TP(the_index_TP == 0) = NaN;
    
    
    
    figure('position',[1000.33333333333          59.6666666666667                      1404                      1278]);
    
    colormap(jet);
    
    axes('position',[0.1 0.65 0.8 0.28]);
    pcolor(X,Y,the_index_Q);shading flat
    set(gca,'xtick',xt_array,'xticklabel',[]);
    set(gca,'ytick',yt_array,'yticklabel',yt_lab_Q,'fontsize',6, 'YAxisLocation', 'left');
%     yyaxis right
%     pcolor(X,Y,the_index_Q);shading flat
%     set(gca,'ytick',yt_array,'yticklabel',yt_lab_Q_D,'fontsize',6);
    
    text(0,1.025,'Flow','units','normalized','fontsize',12,'fontweight','bold');
    
    text(0.5,1.025,u_cats{i},'units','normalized','fontsize',14,'fontweight','bold','HorizontalAlignment','center');
    cb = colorbar;
    set(cb,'position',[0.91 0.65 0.01 0.28]);
    
    
    axes('position',[0.1 0.35 0.8 0.28]);
    pcolor(X,Y,the_index_TN);shading flat
    set(gca,'xtick',xt_array,'xticklabel',[]);
    set(gca,'ytick',yt_array,'yticklabel',yt_lab_TN,'fontsize',6);
%     yyaxis right
%     pcolor(X,Y,the_index_TN);shading flat
%     set(gca,'ytick',yt_array,'yticklabel',yt_lab_TN_D,'fontsize',6);
    text(0,1.025,'TN','units','normalized','fontsize',12,'fontweight','bold');
    
    cb = colorbar;
    set(cb,'position',[0.91 0.35 0.01 0.28]);
    
    
    axes('position',[0.1 0.05 0.8 0.28]);
    pcolor(X,Y,the_index_TP);shading flat
    set(gca,'xtick',xt_array,'xticklabel',num2str(xt_array'),'fontsize',8);
    set(gca,'ytick',yt_array,'yticklabel',yt_lab_TP,'fontsize',6);
%     yyaxis right
%     pcolor(X,Y,the_index_TP);shading flat
%     set(gca,'ytick',yt_array,'yticklabel',yt_lab_TP_D,'fontsize',6);
    text(0,1.025,'TP','units','normalized','fontsize',12,'fontweight','bold');
    
    cb = colorbar;
    set(cb,'position',[0.91 0.05 0.01 0.28]);
    
    %--% Paper Size
    set(gcf, 'PaperPositionMode', 'manual');
    set(gcf, 'PaperUnits', 'centimeters');
    xSize = 21;
    ySize = 27;
    xLeft = (21-xSize)/2;
    yTop = (30-ySize)/2;
    set(gcf,'paperposition',[0 0 xSize ySize])
    
    
    saveas(gcf,figure_name);
    close;
    %%
    
end




