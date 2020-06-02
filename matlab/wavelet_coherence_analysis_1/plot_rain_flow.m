
clear all; close all;

metfile='E:\database\Github\SCERM\BCs\Met\SP_Rain_2007_2019.csv';
flowfile='E:\database\Github\SCERM\BCs\Flow\Upper_Swan_Inflow.csv';

data1=tfv_readBCfile(metfile);
data2=tfv_readBCfile(flowfile);

%%
dvec1=datevec(data1.Date);
dvec2=datevec(data2.Date);

for yy=2007:2019
    ind1=find(dvec1(:,1)==yy);
    ind2=find(dvec2(:,1)==yy);
    
    pre(yy-2006)=sum(data1.Precip(ind1));
    flow(yy-2006)=sum(data2.Flow(ind2))*86400;
end

%%
fig=figure(1);clf;
def.dimensions = [30 20]; % Width & Height in cm
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'centimeters','PaperOrientation', 'Portrait');
xSize = def.dimensions(1);
ySize = def.dimensions(2);
xLeft = (21-xSize)/2;
yTop = (30-ySize)/2;
set(gcf,'paperposition',[0 0 xSize ySize])  ;

subplot(2,1,1);

bar(2007:2019,pre);
ylabel('Rain (m/year)');

subplot(2,1,2);


bar(2007:2019,flow);
ylabel('Inflow (m^3/year)');
print(fig,'-dpng','history.png');

