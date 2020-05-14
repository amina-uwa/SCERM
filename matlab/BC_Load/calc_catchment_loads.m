clear all; close all;

addpath(genpath('tuflowfv'));

load data.mat;

sites =fieldnames(data);



for i = 1:length(sites)
    %Convert to ML
    data.(sites{i}).Flow.ML = data.(sites{i}).Flow.Data * (86400/1000);
    
    % Convert to KG
    data.(sites{i}).TN.kg = data.(sites{i}).TN.Data .* (data.(sites{i}).Flow.Data * 86400);
    % Convert to KG
    data.(sites{i}).TP.kg = data.(sites{i}).TP.Data .* (data.(sites{i}).Flow.Data * 86400);
    
end


total_TN = [];
total_TP = [];
total_Flow = [];

years = 2007:1:2018;


for i = 1:length(years)
    
    for j = 1:length(sites)
        ttn = 0;
        ttp = 0;
        tf = 0;
        
        sss = find(data.(sites{j}).Flow.Date >= datenum(years(i),04,01) &...
            data.(sites{j}).Flow.Date < datenum(years(i)+1,04,01));
        
        ttn = ttn + sum(data.(sites{j}).TN.kg(sss));
        ttp = ttp + sum(data.(sites{j}).TP.kg(sss));
        tf = tf + sum(data.(sites{j}).Flow.ML(sss));
        total_TN(i,j) = ttn;
    total_TP(i,j) = ttp;
    total_Flow(i,j) = tf;
        
    end
    
end

%_______________________________________________


fid1 = fopen('Catchment_Flow.csv','wt');
fid2 = fopen('Catchment_TN.csv','wt');
fid3 = fopen('Catchment_TP.csv','wt');

fprintf(fid1,'Date,');
for i = 1:length(sites)
    fprintf(fid1,'%s,',sites{i});
end
fprintf(fid1,'\n');
for i = 1:length(years)
    fprintf(fid1,'%d,',years(i));
    for j = 1:length(sites)
        fprintf(fid1,'%4.4f,',total_Flow(i,j));
    end
    fprintf(fid1,'\n');
end
fclose(fid1);

fprintf(fid2,'Date,');
for i = 1:length(sites)
    fprintf(fid2,'%s,',sites{i});
end
fprintf(fid2,'\n');
for i = 1:length(years)
    fprintf(fid2,'%d,',years(i));
    for j = 1:length(sites)
        fprintf(fid2,'%4.4f,',total_TN(i,j));
    end
    fprintf(fid2,'\n');
end
fclose(fid2);

fprintf(fid3,'Date,');
for i = 1:length(sites)
    fprintf(fid3,'%s,',sites{i});
end
fprintf(fid3,'\n');
for i = 1:length(years)
    fprintf(fid3,'%d,',years(i));
    for j = 1:length(sites)
        fprintf(fid3,'%4.4f,',total_TP(i,j));
    end
    fprintf(fid3,'\n');
end
fclose(fid3);










