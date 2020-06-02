%% Demo of the cross wavelet and wavelet coherence toolbox 
% This example illustrates how simple it is to do
% continuous wavelet transform (CWT), Cross wavelet transform (XWT)
% and Wavelet Coherence (WTC) plots of your own data.
%
% The time series we will be analyzing are the winter
% Arctic Oscillation index (AO) and
% the maximum sea ice extent in the Baltic (BMI).
%


%% Load the data
% First we load the two time series into the matrices d1 and d2.
clear all; close all;
addpath(genpath('.\wavelet-coherence-master\'))

outdir='.\Wavelet_Coherence\';
load('datafile_1994-2018.mat');
vars={'INFLOW','TN','TP','TOXY','TCHLA'};

for ii=1:length(vars)-1
    for jj=ii+1:length(vars)
        
seriesname={vars{ii} vars{jj}}; %{'TN' 'TP'};
d1= swan_ron.(vars{ii}); %'TN';       %load('swandataTPbottom');
d2= swan_ron.(vars{jj}); %'TP';      %load('faq\jbaltic.txt');

%% Continuous wavelet transform (CWT)
% The CWT expands the time series into time
% frequency space.

figure(1);
def.dimensions = [20 8]; % Width & Height in cm
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'centimeters','PaperOrientation', 'Portrait');
xSize = def.dimensions(1);
ySize = def.dimensions(2);
xLeft = (21-xSize)/2;
yTop = (30-ySize)/2;
set(gcf,'paperposition',[0 0 xSize ySize])  ;
fs=10;

%figure('color',[1 1 1])
tlim=[min(d1(1,1),d2(1,1)) max(d1(end,1),d2(end,1))];
wt(d1);
title(seriesname{1});
set(gca,'xlim',tlim);
print(gcf,'-dpng',[outdir,'singleVar_',vars{ii},'.png']);

figure(2);
def.dimensions = [20 8]; % Width & Height in cm
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'centimeters','PaperOrientation', 'Portrait');
xSize = def.dimensions(1);
ySize = def.dimensions(2);
xLeft = (21-xSize)/2;
yTop = (30-ySize)/2;
set(gcf,'paperposition',[0 0 xSize ySize])  ;
fs=10;

wt(d2)
title(seriesname{2})
set(gca,'xlim',tlim)

print(gcf,'-dpng',[outdir,'singleVar_',vars{jj},'.png']);
%% Cross wavelet transform (XWT)
% The XWT finds regions in time frequency space where
% the time series show high common power.

figure(3);
def.dimensions = [20 8]; % Width & Height in cm
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'centimeters','PaperOrientation', 'Portrait');
xSize = def.dimensions(1);
ySize = def.dimensions(2);
xLeft = (21-xSize)/2;
yTop = (30-ySize)/2;
set(gcf,'paperposition',[0 0 xSize ySize])  ;
fs=10;

xwt(d1,d2)
title(['XWT: ' seriesname{1} '-' seriesname{2} ] )
print(gcf,'-dpng',[outdir,'XWT_',vars{ii},'_',vars{jj},'.png']);

figure(4);
def.dimensions = [20 8]; % Width & Height in cm
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'centimeters','PaperOrientation', 'Portrait');
xSize = def.dimensions(1);
ySize = def.dimensions(2);
xLeft = (21-xSize)/2;
yTop = (30-ySize)/2;
set(gcf,'paperposition',[0 0 xSize ySize])  ;
fs=10;
clf;

axes('position',[0.05 0.05 0.75 0.8]);
wtc(d1,d2)
title(['WTC: ' seriesname{1} '-' seriesname{2} ] );

axes('position',[0.78 0.05 0.15 0.8]);
clear Rsq;
load tmp.mat;
Yticks = 2.^(fix(log2(min(period))):fix(log2(max(period))));
global_spc1=mean(Rsq(:,1:779),2);
global_spc2=mean(Rsq(:,780:end),2);
plot(global_spc1,log2(period),'k');hold on;
plot(global_spc2,log2(period),'r');hold on;
hl=legend('1996-2010','2011-2018');
set(hl,'position',[0.75 0.88 0.2 0.1]);

        set(gca,'YLim',log2([min(period),max(period)]), ...
            'YDir','reverse', 'layer','top', ...
            'YTick',log2(Yticks(:)), ...
            'YTickLabel',[],... %num2str(Yticks'), ...
            'layer','top');
        set(gca,'XLim',[0 1], ...
            'XTick',0:0.2:1)
        
print(gcf,'-dpng',[outdir,'WTC_',vars{ii},'_',vars{jj},'.png']);

    end
end
