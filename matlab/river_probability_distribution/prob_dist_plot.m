clear all; close all;

load ../modeltools/matfiles/swan.mat;

datearray = datenum(2005:05:2020,01,01);

sss =find(swan.s616004.Level.Date >= datearray(1) & ...
    swan.s616004.Level.Date < datearray(end));

level = swan.s616004.Level.Data(sss);
ldate = swan.s616004.Level.Date(sss);
MA = calc_monthly(ldate,level);

pd = fitdist(level,'Normal');

x_pdf = [0:0.01:1];
y = pdf(pd,x_pdf);

P = prctile(level,[10 90]);

fig = figure

 set(fig,'defaultTextInterpreter','latex')
 set(fig,'DefaultAxesFontName','Times')
% 
% set(gca,'TickLabelInterpreter','latex')

ax2 = axes('position',[0.1 0.1 0.65 0.8]);

plot(ldate,level,'b');hold on
plot(MA.Date,MA.Level,'r');
ylim([-0.5 2]);
xlim([datearray(1) datearray(end)]);

set(gca,'xtick',datearray,'xticklabel',datestr(datearray,'yyyy'));

ylabel('Height (mAHD)','fontsize',8);
xlabel('Years','fontsize',8);

legend({'Daily Height';'Monthly Average'},'location','NW','fontsize',8);

ax2 = axes('position',[0.8 0.1 0.15 0.8]);

histogram(ax2,level,'Normalization','pdf','Orientation','horizontal');
line(ax2,y,x_pdf,'color','r');hold on
ylim([-0.5 2]);

plot(ax2,[0 2],[P(1) P(1)],'--','color',[0.6 0.6 0.6]);
plot(ax2,[0 2],[P(2) P(2)],'--','color',[0.6 0.6 0.6]);

text(ax2,1,P(1)-0.1,['\itP_{10}',' = ',num2str(P(1))],'fontsize',6,'interpreter','tex');
text(ax2,1,P(2)+0.1,['\itP_{90}',' = ',num2str(P(2))],'fontsize',6,'interpreter','tex');



set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'centimeters');
xSize = 16;
ySize = 10;
xLeft = (21-xSize)/2;
yTop = (30-ySize)/2;
set(gcf,'paperposition',[0 0 xSize ySize]);

saveas(gcf,'Basic_Hist.png');