clear all; close all;

load load.mat;


fid = fopen('Avon_from_TFV.csv','wt');
fprintf(fid,'Date,Flow,TN,TP\n');

mdate = Load.Upper_Swan_Inflow.Date;
flow = Load.Upper_Swan_Inflow.ML * (1000/86400);
tn = Load.Upper_Swan_Inflow.TN_mgL;
tp = Load.Upper_Swan_Inflow.TP_mgL;

for i = 1:length(mdate)
    fprintf(fid,'%s,%4.4f,%4.4f,%4.4f\n',datestr(mdate(i),'dd/mm/yyyy'),flow(i),tn(i),tp(i));
end
fclose(fid);

