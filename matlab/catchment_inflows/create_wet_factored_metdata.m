clear all; close all;

addpath(genpath('..\..\..\aed_matlab_modeltools\TUFLOWFV\tuflowfv\'));

metfile = '..\..\models\SCERM_v6\BCs\Met\South_Perth_2007_2020_Median_Cloud_Cover.csv';

metdata = tfv_readBCfile(metfile);

Rel_Hum_Change = [
    -1.77
    -0.08
    1.65
    -2.82
    2.88
    0.61
    0.77
    -0.09
    -0.37
    -3.78
    -1.51
    -0.29
    ];


Air_Temp_Change = [
      1.15
    0.85
    1.35
    0.59
    0.90
    0.71
    0.80
    0.47
    0.98
    1.34
    1.22
    1.13
    ];

Rel_Hum_Change = (100 + Rel_Hum_Change) / 100;
Air_Temp_Change = (100 + Air_Temp_Change) / 100;


dvec = datevec(metdata.Date);

outfile = regexprep(metfile,'.csv','_WET.csv');

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
    



