clear all; close all;

addpath(genpath('tuflowfv'));

fid = fopen('..\..\..\Source_to_SCERM\SourceOutputs\40 - Scenario 1 - 2020-03-16T17-46-22.res.csv','rt');


isdata = 0;
linecount = 1;

while isdata == 0
    fline = fgetl(fid);
    
    sLine = strsplit(fline,',');
    
    if strcmpi(sLine{1},'Date') == 1
        isdata = 1;
    else
        
     linecount = linecount + 1;   
    end 
end
  
for i = 2:length(sLine)
    
    tt = strsplit(sLine{i},'>');
    header(i-1) = {[tt{2},'_',tt{3}]};
    header(i-1) = regexprep(header(i-1),' ','_');
    header(i-1) = regexprep(header(i-1),'@','_');
    header(i-1) = regexprep(header(i-1),'-','_');
    header(i-1) = regexprep(header(i-1),'_Outflow_Constituents','');
    header(i-1) = regexprep(header(i-1),'_Upstream_Flow_Concentration','');
    header(i-1) = regexprep(header(i-1),'Outflow_Upstream_','');
    header(i-1) = regexprep(header(i-1),'___','_');
end
    



frewind(fid)
x  = length(sLine);
textformat = [repmat('%s ',1,x)];
% read single line: number of x-values
datacell = textscan(fid,textformat,'Headerlines',linecount + 1,'Delimiter',',');
fclose(fid);


mdate = datenum(datacell{1},'yyyy-mm-dd');

for i = 1:length(header)
    
    ttt = regexprep(header{i},'_Flow','.Flow');
    ttt = regexprep(ttt,'_TN','.TN');
    ttt = regexprep(ttt,'_TP','.TP');
    sss = strsplit(ttt,'.');
    
    data.(sss{1}).(sss{2}).Date =  mdate;
    data.(sss{1}).(sss{2}).Data =str2double(datacell{i+1});
end


save data.mat data -mat;

sites = fieldnames(data);

fid = fopen('Sites.csv','wt');

for i = 1:length(sites)
    fprintf(fid,'%s\n',sites{i});
end
fclose(fid);


