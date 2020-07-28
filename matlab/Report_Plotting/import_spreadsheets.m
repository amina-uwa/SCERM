clear all; close all;

simlist = dir('Export/');

vars = {...
    'TN',...
    'TP',...
    'Oxy',...
    'TCHLA',...
    'Turbidity',...
    'TEMP',...
    'SAL',...
    };


for i = 3:length(simlist)
    
    for j = 1:12
        
        zone = ['Zone',num2str(j)];
        
        filename = ['Export/',simlist(i).name,'/Zone',num2str(j),'.csv'];
        
        
        [snum,sstr] = xlsread(filename,'A2:BE10000');
        
        mTime = datestr(sstr(:,1),'dd/mm/yyyy HH:MM:SS');
        
        int = 1;
        for k = 1:length(vars)
            
            data.(simlist(i).name).(zone).(vars{k}).Surface.Date = mTime;
            data.(simlist(i).name).(zone).(vars{k}).Surface.Min = snum(:,int);int = int + 1;
            data.(simlist(i).name).(zone).(vars{k}).Surface.Mean = snum(:,int);int = int + 1;
            data.(simlist(i).name).(zone).(vars{k}).Surface.Median = snum(:,int);int = int + 1;
            data.(simlist(i).name).(zone).(vars{k}).Surface.Max = snum(:,int);int = int + 1;
        
            data.(simlist(i).name).(zone).(vars{k}).Bottom.Date = mTime;
            data.(simlist(i).name).(zone).(vars{k}).Bottom.Min = snum(:,int);int = int + 1;
            data.(simlist(i).name).(zone).(vars{k}).Bottom.Mean = snum(:,int);int = int + 1;
            data.(simlist(i).name).(zone).(vars{k}).Bottom.Median = snum(:,int);int = int + 1;
            data.(simlist(i).name).(zone).(vars{k}).Bottom.Max = snum(:,int);int = int + 1;   
            
        end
    end
end
            
        save data.mat data -mat;
    
    