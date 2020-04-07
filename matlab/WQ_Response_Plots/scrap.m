clear all; close all;

load load.mat;

lsites = {...
        'Bennett_Inflow',...
    'Helena_Inflow',...
    };



allsites = {...
    'Bennett_Inflow',...
    'Ellenbrook_Inflow',...
    'Helena_Inflow',...
    'Jane_Inflow',...
    'Susannah_Inflow',...
    'Upper_Swan_Inflow',...
    };


l_tot = 0;
for i = 1:length(lsites)
    l_tot = l_tot + Load.(lsites{i}).TP_mgL;
end

A_tot = 0;
for i = 1:length(allsites)
    A_tot = A_tot + Load.(allsites{i}).TP_mgL;
end

plot(l_tot);hold on
plot(A_tot);

legend('Bennett & Helena','6 Sites');


figure

for i = 1:length(allsites)
    plot(Load.(allsites{i}).TP_mgL,'displayname',allsites{i});hold on
end
legend
    