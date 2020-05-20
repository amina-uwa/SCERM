clear all; close all;
addpath(genpath('../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv'));

ncfile = 'F:/swan_2017_2018_tracer_ALL.nc';

shp = shaperead('ERZ_v2.shp');

data = tfv_readnetcdf(ncfile);

%%

zone.Ocean.TN = 1;
zone.Ocean.TP = 2;

for i = 1:12
    zone.(['ERZ_',num2str(i)]).TN = (i*2)+1;
    zone.(['ERZ_',num2str(i)]).TP = (i*2)+2;
end


%%

zone.ERZ_1.Upstream = [];
zone.ERZ_1.Downstream = [2:1:12];

zone.ERZ_2.Upstream = [1];
zone.ERZ_2.Downstream = [3:1:12];

zone.ERZ_3.Upstream = [1:2];
zone.ERZ_3.Downstream = [4:1:12];

zone.ERZ_4.Upstream = [1:3];
zone.ERZ_4.Downstream = [5:1:12];

zone.ERZ_5.Upstream = [1:4];
zone.ERZ_5.Downstream = [6:1:12];

zone.ERZ_6.Upstream = [];
zone.ERZ_6.Downstream = [1:5 7:12];

zone.ERZ_7.Upstream = [6];
zone.ERZ_7.Downstream = [1:5 8:12];

zone.ERZ_8.Upstream = [6:7];
zone.ERZ_8.Downstream = [1:5 9:12];

zone.ERZ_9.Upstream = [1:8];
zone.ERZ_9.Downstream = [10:12];

zone.ERZ_10.Upstream = [1:9];
zone.ERZ_10.Downstream = [11:12];

zone.ERZ_11.Upstream = [1:10];
zone.ERZ_11.Downstream = [12];

zone.ERZ_12.Upstream = [1:11];
zone.ERZ_12.Downstream = [];

%%
data1 = [];

data1.TN.ocean = data.TRACE_1;
data1.TP.ocean = data.TRACE_2;

data1.TN.local(1:size(data.TRACE_1,1),1:size(data.TRACE_1,2)) = 0;
data1.TP.local(1:size(data.TRACE_1,1),1:size(data.TRACE_1,2)) = 0;

data1.TN.upstream(1:size(data.TRACE_1,1),1:size(data.TRACE_1,2)) = 0;
data1.TP.upstream(1:size(data.TRACE_1,1),1:size(data.TRACE_1,2)) = 0;

data1.TN.downstream(1:size(data.TRACE_1,1),1:size(data.TRACE_1,2)) = 0;
data1.TP.downstream(1:size(data.TRACE_1,1),1:size(data.TRACE_1,2)) = 0;

%%

for i = 1:length(data.cell_X)
    disp(i);
    erz_zone = [];
    for k = 1:length(shp)
        inpol = find(inpolygon(data.cell_X(i),data.cell_Y(i),shp(k).X,shp(k).Y)==1);
        
        if ~isempty(inpol)
            
            erz_zone = shp(k).Id;
        end
    end
        
    sss = find(data.idx2 == i);
    
    data1.TN.local(sss,:) = data.(['TRACE_',num2str(zone.(['ERZ_',num2str(erz_zone)]).TN)])(sss,:);
    data1.TP.local(sss,:) = data.(['TRACE_',num2str(zone.(['ERZ_',num2str(erz_zone)]).TP)])(sss,:);
    
    ups = zone.(['ERZ_',num2str(erz_zone)]).Upstream;
    dws = zone.(['ERZ_',num2str(erz_zone)]).Downstream;
    
    if ~isempty(ups)
        for k = 1:length(ups)
            data1.TN.upstream(sss,:) = data1.TN.upstream(sss,:) + ...
                data.(['TRACE_',num2str(zone.(['ERZ_',num2str(ups(k))]).TN)])(sss,:);
            data1.TP.upstream(sss,:) = data1.TP.upstream(sss,:) + ...
                data.(['TRACE_',num2str(zone.(['ERZ_',num2str(ups(k))]).TP)])(sss,:);
        end
    end
    if ~isempty(dws)
        for k = 1:length(dws)
            data1.TN.downstream(sss,:) = data1.TN.downstream(sss,:) + ...
                data.(['TRACE_',num2str(zone.(['ERZ_',num2str(dws(k))]).TN)])(sss,:);
            data1.TP.downstream(sss,:) = data1.TP.downstream(sss,:) + ...
                data.(['TRACE_',num2str(zone.(['ERZ_',num2str(dws(k))]).TP)])(sss,:);
        end
    end
    
end

save data1.mat data1 -mat -v7.3;
    
%%
figure

pdata = [];

testid = 3129;

sss = find(data.idx2 == testid);

pdata(:,1) = data1.TN.ocean(sss(1),:);
pdata(:,2) = data1.TN.local(sss(1),:);
pdata(:,3) = data1.TN.upstream(sss(1),:);
pdata(:,4) = data1.TN.downstream(sss(1),:);

area(pdata)
title('ERZ 9');

legend({'Ocean';'Local';'Upstrea';'Downstream'});

%%
figure

pdata = [];

testid = 12007;

sss = find(data.idx2 == testid);

pdata(:,1) = data1.TN.ocean(sss(1),:);
pdata(:,2) = data1.TN.local(sss(1),:);
pdata(:,3) = data1.TN.upstream(sss(1),:);
pdata(:,4) = data1.TN.downstream(sss(1),:);

area(pdata)
title('ERZ 2');

legend({'Ocean';'Local';'Upstrea';'Downstream'});

%%
figure

pdata = [];

testid = 12826;

sss = find(data.idx2 == testid);

pdata(:,1) = data1.TN.ocean(sss(1),:);
pdata(:,2) = data1.TN.local(sss(1),:);
pdata(:,3) = data1.TN.upstream(sss(1),:);
pdata(:,4) = data1.TN.downstream(sss(1),:);

area(pdata)
title('ERZ 1');

legend({'Ocean';'Local';'Upstrea';'Downstream'});

%%
figure

pdata = [];

testid = 4397;

sss = find(data.idx2 == testid);

pdata(:,1) = data1.TN.ocean(sss(1),:);
pdata(:,2) = data1.TN.local(sss(1),:);
pdata(:,3) = data1.TN.upstream(sss(1),:);
pdata(:,4) = data1.TN.downstream(sss(1),:);

area(pdata)
title('ERZ 5');

legend({'Ocean';'Local';'Upstrea';'Downstream'});

%%
figure

pdata = [];

testid = 6577;

sss = find(data.idx2 == testid);

pdata(:,1) = data1.TN.ocean(sss(1),:);
pdata(:,2) = data1.TN.local(sss(1),:);
pdata(:,3) = data1.TN.upstream(sss(1),:);
pdata(:,4) = data1.TN.downstream(sss(1),:);

area(pdata)
title('ERZ 4');

legend({'Ocean';'Local';'Upstrea';'Downstream'});

%%
figure

pdata = [];

testid = 10024;

sss = find(data.idx2 == testid);

pdata(:,1) = data1.TN.ocean(sss(1),:);
pdata(:,2) = data1.TN.local(sss(1),:);
pdata(:,3) = data1.TN.upstream(sss(1),:);
pdata(:,4) = data1.TN.downstream(sss(1),:);

area(pdata)
title('ERZ 3');

legend({'Ocean';'Local';'Upstrea';'Downstream'});