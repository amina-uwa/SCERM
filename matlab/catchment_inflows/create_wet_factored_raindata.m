clear all; close all;

addpath(genpath('..\..\..\aed_matlab_modeltools\TUFLOWFV\tuflowfv\'));

metfile = '..\..\models\SCERM_v6\BCs\Met\South_Perth_2007_2020_Rain.csv';

metdata = tfv_readBCfile(metfile);

rain_Change = [
        -30.7
        124.8
        -34.9
        -41.4
        35.8
        7.9
        18.7
        -13.1
        -17.8
        -29.9
        8.7
        8.1
    ];



rain_Change = (100 + rain_Change) / 100;


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
    
    metdata.Precip(j,1) = metdata.Precip(j,1) * rain_Change(dvec(j,2));
    
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




