clear all; close all;

addpath(genpath('../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv'));
%%
met = tfv_readBCfile('../../models/SCERM_v6/BCs/Met/South_Perth_2007_2020_Median_Cloud_Cover.csv');

maxmet = tfv_readBCfile('South_Perth_2007_2020_Median_Cloud_Cover_Max_Wind.csv');

%%

fid = fopen('Melville_water.dat','rt');

headers = fgetl(fid);
int = 1;
while ~feof(fid)
    line = fgetl(fid);
    spt = split(line,',');
    
    mw.Date(int,1) = datenum(spt{1},'yyyy-mm-dd HH:MM:SS');
    mw.ws(int,1) = str2num(spt{2});
    int = int + 1;
    
end
fclose(fid);

mw_ind = find(mw.Date >= datenum(2018,08,01) & ...
    mw.Date <= datenum(2019,05,02));


%%

sp.Date = met.Date;
sp.ws = sqrt(power(met.Wx,2) + power(met.Wy,2));

sp1.Date = maxmet.Date;
sp1.ws = sqrt(power(maxmet.Wx,2) + power(maxmet.Wy,2));


%%
mw_ind = find(mw.Date >= datenum(2018,2,01) & ...
    mw.Date <= datenum(2018,3,02));

sp_ind = find(sp.Date >= datenum(2018,2,01) & ...
    sp.Date <= datenum(2018,3,02));

figure
plot(mw.Date(mw_ind),mw.ws(mw_ind));hold on
plot(sp1.Date(sp_ind),sp1.ws(sp_ind));hold on
plot(sp.Date(sp_ind),sp.ws(sp_ind));hold on

legend({'MW';'SP Max';'SP Ave'});

datetick('x');

mw_ind = find(mw.Date >= datenum(2018,2,01) & ...
    mw.Date <= datenum(2018,9,02));

sp_ind = find(sp.Date >= datenum(2018,2,01) & ...
    sp.Date <= datenum(2018,9,02));

figure
plot(mw.Date(mw_ind),mw.ws(mw_ind));hold on
plot(sp1.Date(sp_ind),sp1.ws(sp_ind));hold on
plot(sp.Date(sp_ind),sp.ws(sp_ind));hold on

legend({'MW';'SP Max';'SP Ave'});

datetick('x');


%stop
% 
% figure
% plot(mw.Date(mw_ind),mw.ws(mw_ind));hold on
% plot(sp.Date(sp_ind),(sp.ws(sp_ind) * 3));hold on
% 
% legend({'MW';'SP'});
% 
% 
% 
% datearray = [datenum(2018,02,01):5/(60*24):datenum(2018,03,01)];
% 
% mw.interp = interp1(mw.Date(mw_ind),mw.ws(mw_ind),datearray);
% sp.interp = interp1(sp.Date(sp_ind),sp.ws(sp_ind),datearray);
% 
% 
% figure
% plot(datearray,mw.interp);hold on
% plot(datearray,sp.interp);hold on
% 
% figure
% 
% scatter(mw.interp,(sp.interp*3));
% 
% 
% sss = find(mw.ws(mw_ind) > 12)




