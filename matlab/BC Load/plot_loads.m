clear all; close all;

load Load.mat;

sss = find(Load.Canning_Inflow.Date >= datenum(2018,04,01) & ...
    Load.Canning_Inflow.Date < datenum(2018,07,01));

plot(Load.Canning_Inflow.Date(sss),Load.Canning_Inflow.FRP_kg(sss),'r');
hold on;

ttt = find(Load.Bayswater_Inflow.Date >= datenum(2018,04,01) & ...
    Load.Bayswater_Inflow.Date < datenum(2018,07,01));
plot(Load.Bayswater_Inflow.Date(ttt),Load.Bayswater_Inflow.FRP_kg(ttt),'b');

www = find(Load.Bennet_Inflow.Date >= datenum(2018,04,01) & ...
    Load.Bennet_Inflow.Date < datenum(2018,07,01));
plot(Load.Bennet_Inflow.Date(www),Load.Bennet_Inflow.FRP_kg(www),'k');
legend({'Canning';'Bayswater';'Bennett'});

ylabel('FRP kg/day');

datetick('x','dd-mm');