clear all; close all;

load Toolibin.mat;

xdata = Toolibin.Toolibin.Flow.Date;
ydata = Toolibin.Toolibin.Flow.Data;

xarray = min(xdata):01:max(xdata);

for i = 1:length(xarray)
    ss = find(xdata == xarray(i));
    if ~isempty(ss)
        yarray(i) = ydata(ss);
    else
        yarray(i) = 0;
    end
end

fid = fopen('Toolibin Flow.csv','wt');
fprintf(fid,'Date,Flow (m3/s)\n');
for i = 1:length(xarray)
    fprintf(fid,'%s,%4.4f\n',datestr(xarray(i),'dd/mm/yyyy'),yarray(i));
end
fclose(fid);