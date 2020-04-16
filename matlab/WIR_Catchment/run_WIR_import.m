clear all; close all;

addpath(genpath('Functions'));
% This uses the latest version of the code, which requries

% Watch for the Version flag for files downloaded after Nov. 2017.

% Haven't checked if level flat file is also affected

%______________________________________________________________________________

% There is a zipped folder in Raw Zipped. Unzip that folder and add it to the Raw directory. It's too big for Github unzipped.



dirlist = dir('Raw');

for i = 52:length(dirlist)
    
    filelist = dir(['Raw/',dirlist(i).name,'/*.xlsx']);
    
    if strcmpi(filelist(1).name,'WaterQualityDiscreteForSiteCrossTab.xlsx')
        filename = ['Raw/',dirlist(i).name,'/WaterQualityDiscreteForSiteCrossTab.xlsx'];
        type = 'WQ';
        [rows,cols] = calculate_xls_size(filename);
    else
        filename = ['Raw/',dirlist(i).name,'/WaterLevelsContinuousForSiteCrossTab.xlsx'];
        type = 'Level';
        [rows,cols] = calculate_xls_size_l(filename);
    end
    
    if i == 9 
        cols = 'ACX';
        rows = 41003;
    end
%     if i == 32
%         cols = 'GH';
%         rows = 30000;
%     end 
%         if i == 33
%         cols = 'EV';
%         rows = 60117;
%     end   
    if i == 3
        import_wir_dataset_v2(filename,type,'Create','swan.mat','Row',rows,'Column',cols,...
            'Remove_NaN',1,'Summerise',0,'Version',2);
    else
        if i == length(dirlist)
            import_wir_dataset_v2(filename,type,'Append','swan.mat','Row',rows,'Column',cols,...
                'Remove_NaN',1,'Summerise',0,'Version',2);
        else
            import_wir_dataset_v2(filename,type,'Append','swan.mat','Row',rows,'Column',cols,...
                'Remove_NaN',1,'Summerise',0,'Version',2);
        end
    end
end




load swan.mat;
%
swan = sort_WIR_data(swan);
%
save swan.mat swan -mat;

%export_site_information
%




















%______________________________________________________________





