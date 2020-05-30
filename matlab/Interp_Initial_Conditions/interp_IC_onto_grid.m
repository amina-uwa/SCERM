clear all; close all;

addpath(genpath('functions'));

existing = dir('old\*.csv');

[~,~,~,~,oldX,oldY,oldID] = tfv_get_node_from_2dm('swan_helena_v04a.2dm');

[~,~,~,~,newX,newY,newID] = tfv_get_node_from_2dm('swan_helena_v04a_NAR_MSB.2dm');

for i = 1:length(existing)
    filename = ['old\',existing(i).name];
    
    [headers,data] = load_IC_file(filename);
    
    newfile = regexprep(filename,'.csv','_RM.csv');
    
    newfile = regexprep(newfile,'old','new');
    
    data2 = interp_data(data,oldX,oldY,newX,newY,newID);
    
    write_IC(headers,data2,newfile);
end