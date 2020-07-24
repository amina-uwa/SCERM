clear all; close all;

outdir = 'Dolphin_Export_v2_Midday/';

mkdir(outdir);

folders = dir('Test_v2/');


for bb = 3:length(folders)
    
    
    dirname = ['Test_v2/',folders(bb).name,'/'];
    
    filelist = dir([dirname,'*.csv']);
    
    outfile = [outdir,folders(bb).name,'.csv'];
    
    fid = fopen(outfile,'wt');
    
    edate = datenum(2007,04,01,00,00,00);
    
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
    
end
