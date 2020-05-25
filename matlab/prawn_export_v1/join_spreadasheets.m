clear all; close all;

maindir = 'Spreadsheets v16/New_Template_v6/';

filelist = dir([maindir,'*.csv']);

fid = fopen('Master Spreadsheet v10.csv','wt');

fidchx = fopen([maindir,filelist(1).name],'rt');

for i = 1:length(filelist)
    fidn(i).n = fopen([maindir,filelist(i).name],'rt');
end

while ~feof(fidchx)
    l_chx = fgetl(fidchx);
    
    mastersize = strsplit(l_chx,',');
    masterline = l_chx;
    
    for i = 1:length(filelist)
        fline = fgetl(fidn(i).n);
        lspt = strsplit(fline,',');
        

        
        if length(lspt) > length(mastersize)
            masterline = fline;
        end
    end
    fprintf(fid,'%s\n',masterline);
end
fclose(fidchx);
for i = 1:length(filelist)
    fclose(fidn(i).n);
end
fclose(fid);