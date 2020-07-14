clear all; close all;

addpath(genpath('..\..\..\aed_matlab_modeltools\TUFLOWFV\tuflowfv\'));

metfile = '..\..\models\SCERM_v6\BCs\Met\South_Perth_2007_2020_Median_Cloud_Cover.csv';

metdata = tfv_readBCfile(metfile);

Rel_Hum_Change = [
    -5.7
    -7.9
    -7.1
    -8.0
    -2.4
    -1.5
    -2.9
    -3.7
    -0.7
    -3.7
    -7.2
    -8.0
    ];


Air_Temp_Change = [
    2.4
    2.4
    2.7
    1.9
    2.2
    1.6
    1.4
    1.4
    1.5
    1.7
    2.4
    2.5
    ];

Rel_Hum_Change = (100 + Rel_Hum_Change) / 100;
Air_Temp_Change = (100 + Air_Temp_Change) / 100;


dvec = datevec(metdata.Date);

outfile = regexprep(metfile,'.csv','_DRY.csv');

headers = fieldnames(metdata);

fid = fopen(outfile,'wt');
fprintf(fid,'ISOTime,');
for i = 2:length(headers)
    if i == length(headers)
        fprintf(fid,'%s\n',headers{i});
    else
        fprintf(fid,'%s,',headers{i});
    end
end

for j = 1:length(metdata.Date)
    
    metdata.Atemp(j,1) = metdata.Atemp(j,1) * Air_Temp_Change(dvec(j,2));
    metdata.Rel_Hum(j,1) = metdata.Rel_Hum(j,1) * Rel_Hum_Change(dvec(j,2));
    
    fprintf(fid,'%s,',datestr(metdata.Date(j),'dd/mm/yyyy HH:MM:SS'));
    for i = 2:length(headers)
        if i == length(headers)
            fprintf(fid,'%4.4f\n',metdata.(headers{i})(j));
        else
            fprintf(fid,'%4.4f,',metdata.(headers{i})(j));
        end
    end
end

fclose(fid);
    
plot_bcfiles('..\..\models\SCERM_v6\BCs\Met\');    
    



