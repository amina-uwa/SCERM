clear all; close all;

load swan.mat;

site = 'SWN10';
xdata = swan.(site).Level.Date;
ydata = swan.(site).Level.Data;

tt = find(ydata < 4);

outfile = 'SWN10.csv';

fid = fopen(outfile,'wt');
fprintf(fid,'Time,Data\n');

for i = 1:length(tt)
    fprintf(fid,'%s,%4.4f\n',datestr(xdata(tt(i)),'dd/mm/yyyy HH:MM:SS'),ydata(tt(i)));
end
fclose(fid);

swan