function import_canning_flow(datearray)

addpath(genpath('tuflowfv'));


%
%datearray = datenum(2008,01,01): 1/24: datenum(2021,01,01);

load ../modeltools/matfiles/swan.mat;

[sDate,ind]  = unique(swan.s616027.Flow.Date);
sData = swan.s616027.Flow.Data(ind);

[aDate,ind]  = unique(swan.s616092.Flow.Date);
aData = swan.s616092.Flow.Data(ind);


flow_1 = interp1(sDate,sData,datearray);
flow_2 = interp1(aDate,aData,datearray);

canning.flow = flow_1 + flow_2;
canning.mdate = datearray;

save('Canning.mat','canning','-mat');