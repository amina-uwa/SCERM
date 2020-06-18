clear all; close all;

dirname = 'Test_output/';

filelist = dir([dirname,'*.csv']);

outfile = 'BLA_2015_2019_DRAFT_v0.2.csv';

fid = fopen(outfile,'wt');

edate = datenum(2016,04,01,00,00,00);

for i = 1:length(filelist)
    
    fidread = fopen([dirname,filelist(i).name],'rt');
    
    fline = fgetl(fidread);
    
    if i == 1
        fprintf(fid,'%s\n',fline);
    end
    
    
    
    while ~feof(fidread)
        fline = fgetl(fidread);
        
        if i > 1
            
            str = split(fline,',');
            
            d_chx = datenum(str{1},'dd-mm-yyyy HH:MM:SS');
            
            if d_chx >= edate
               fprintf(fid,'%s\n',fline);
               edate = d_chx;
            end
            
        else
            fprintf(fid,'%s\n',fline);
        end
        
    end
    fclose(fidread);
    
end

fclose all;
        