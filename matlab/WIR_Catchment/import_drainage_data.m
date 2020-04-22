clear all; close all;

load swan.mat;

shp = shaperead('GIS/WaterCorpGauges.shp');

filename = '20062019 -Drainage - Flow Daily Total - UWA.XLSX';

% 616015
site = 's616015';

vars = fieldnames(swan.(site));

[snum,sstr] = xlsread(filename,'Poison Gully Creek','B9:D100000');
swan.(site).Flow = [];
swan.(site).Flow.X = swan.(site).(vars{1}).X;
swan.(site).Flow.Y = swan.(site).(vars{1}).Y;
swan.(site).Flow.Agency = 'Water Corp';
swan.(site).Flow.Units =  {'m^3/s'};
swan.(site).Flow.Title =  swan.(site).(vars{1}).Title;
swan.(site).Flow.Variable_Name =  {'Flow'};

for i = 1:length(snum)
    td = strsplit(sstr{i,1},' ');
    swan.(site).Flow.Date(i,1) = datenum(td{1},'dd/mm/yyyy');
    swan.(site).Flow.Data(i,1) = snum(i,1)/86400;
    swan.(site).Flow.Depth(i,1) = 0;
end

% 616042
site = 's616042';
vars = fieldnames(swan.(site));

[snum,sstr] = xlsread(filename,'Yule Brook MD at Brixton St','B9:D100000');
swan.(site).Flow = [];
swan.(site).Flow.X = swan.(site).(vars{1}).X;
swan.(site).Flow.Y = swan.(site).(vars{1}).Y;
swan.(site).Flow.Agency = 'Water Corp';
swan.(site).Flow.Units =  {'m^3/s'};
swan.(site).Flow.Title =  swan.(site).(vars{1}).Title;
swan.(site).Flow.Variable_Name =  {'Flow'};

for i = 1:length(snum)
    td = strsplit(sstr{i,1},' ');
    swan.(site).Flow.Date(i,1) = datenum(td{1},'dd/mm/yyyy');
    swan.(site).Flow.Data(i,1) = snum(i,1)/86400;
    swan.(site).Flow.Depth(i,1) = 0;
end

% 616043
site = 's616043';
vars = fieldnames(swan.(site));

[snum,sstr] = xlsread(filename,'Mills Street MD at Palm Pl','B9:D100000');
swan.(site).Flow = [];
swan.(site).Flow.X = swan.(site).(vars{1}).X;
swan.(site).Flow.Y = swan.(site).(vars{1}).Y;
swan.(site).Flow.Agency = 'Water Corp';
swan.(site).Flow.Units =  {'m^3/s'};
swan.(site).Flow.Title =  swan.(site).(vars{1}).Title;
swan.(site).Flow.Variable_Name =  {'Flow'};

for i = 1:length(snum)
    td = strsplit(sstr{i,1},' ');
    swan.(site).Flow.Date(i,1) = datenum(td{1},'dd/mm/yyyy');
    swan.(site).Flow.Data(i,1) = snum(i,1)/86400;
    swan.(site).Flow.Depth(i,1) = 0;
end

% 616044
site = 's616044';
vars = fieldnames(swan.(site));

[snum,sstr] = xlsread(filename,'Neerigen Brook MD','B32:D100000');
swan.(site).Flow = [];
swan.(site).Flow.X = swan.(site).(vars{1}).X;
swan.(site).Flow.Y = swan.(site).(vars{1}).Y;
swan.(site).Flow.Agency = 'Water Corp';
swan.(site).Flow.Units =  {'m^3/s'};
swan.(site).Flow.Title =  swan.(site).(vars{1}).Title;
swan.(site).Flow.Variable_Name =  {'Flow'};

for i = 1:length(snum)
    td = strsplit(sstr{i,1},' ');
    swan.(site).Flow.Date(i,1) = datenum(td{1},'dd/mm/yyyy');
    swan.(site).Flow.Data(i,1) = snum(i,1)/86400;
    swan.(site).Flow.Depth(i,1) = 0;
end

% 616045
site = 's616045';
vars = fieldnames(swan.(site));

[snum,sstr] = xlsread(filename,'Mt Lawley MD at Mt Lawley','B9:D100000');
swan.(site).Flow = [];
swan.(site).Flow.X = swan.(site).(vars{1}).X;
swan.(site).Flow.Y = swan.(site).(vars{1}).Y;
swan.(site).Flow.Agency = 'Water Corp';
swan.(site).Flow.Units =  {'m^3/s'};
swan.(site).Flow.Title =  swan.(site).(vars{1}).Title;
swan.(site).Flow.Variable_Name =  {'Flow'};

for i = 1:length(snum)
    td = strsplit(sstr{i,1},' ');
    swan.(site).Flow.Date(i,1) = datenum(td{1},'dd/mm/yyyy');
    swan.(site).Flow.Data(i,1) = snum(i,1)/86400;
    swan.(site).Flow.Depth(i,1) = 0;
end

% 616047
site = 's616047';
vars = fieldnames(swan.(site));

[snum,sstr] = xlsread(filename,'Bickley Brook at Austin Ave','B9:D100000');
swan.(site).Flow = [];
swan.(site).Flow.X = swan.(site).(vars{1}).X;
swan.(site).Flow.Y = swan.(site).(vars{1}).Y;
swan.(site).Flow.Agency = 'Water Corp';
swan.(site).Flow.Units =  {'m^3/s'};
swan.(site).Flow.Title =  swan.(site).(vars{1}).Title;
swan.(site).Flow.Variable_Name =  {'Flow'};

for i = 1:length(snum)
    td = strsplit(sstr{i,1},' ');
    swan.(site).Flow.Date(i,1) = datenum(td{1},'dd/mm/yyyy');
    swan.(site).Flow.Data(i,1) = snum(i,1)/86400;
    swan.(site).Flow.Depth(i,1) = 0;
end


% 616232
site = 's616232';
vars = fieldnames(swan.(site));

[snum,sstr] = xlsread(filename,'Bickley Brook at Kumbaduru','B9:D100000');
swan.(site).Flow = [];
swan.(site).Flow.X = swan.(site).(vars{1}).X;
swan.(site).Flow.Y = swan.(site).(vars{1}).Y;
swan.(site).Flow.Agency = 'Water Corp';
swan.(site).Flow.Units =  {'m^3/s'};
swan.(site).Flow.Title =  swan.(site).(vars{1}).Title;
swan.(site).Flow.Variable_Name =  {'Flow'};

for i = 1:length(snum)
    td = strsplit(sstr{i,1},' ');
    swan.(site).Flow.Date(i,1) = datenum(td{1},'dd/mm/yyyy');
    swan.(site).Flow.Data(i,1) = snum(i,1)/86400;
    swan.(site).Flow.Depth(i,1) = 0;
end

save swan.mat swan -mat -v7;