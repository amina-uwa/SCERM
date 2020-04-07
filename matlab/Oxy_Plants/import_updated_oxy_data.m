clear all; close all;

disp('GFD 2017');
[~,~,scell] = xlsread('Raw Data/Swan Plants Log 2016.17x.xlsx','Guildford 16.17','A2:D50223');

for i = 1:length(scell)
    
    if ~isnumeric(scell{i,2})
        
        md = datenum([scell{i,1},' ',scell{i,2}],'dd/mm/yyyy HH:MM:SS');
        
    else
        md = datenum([scell{i,1}],'dd/mm/yyyy') + scell{i,2};
    end
    flow_ind(i,1) = scell{i,3};
    Oxygen(i,1) = scell{i,4};
    mdate(i,1) = md;
end

save('Matfiles\GFD_2017.mat','mdate','Oxygen','flow_ind','-mat');

clear mdate Oxygen flow_ind scell;
disp('CAV 2017');

[~,~,scell] = xlsread('Raw Data/Swan Plants Log 2016.17x.xlsx','Caversham 16.17','A2:D50710');

for i = 1:length(scell)
    
    if ~isnumeric(scell{i,2})
        
        md = datenum([scell{i,1},' ',scell{i,2}],'dd/mm/yyyy HH:MM:SS');
        
    else
        md = datenum([scell{i,1}],'dd/mm/yyyy') + scell{i,2};
    end
    flow_ind(i,1) = scell{i,3};
    Oxygen(i,1) = scell{i,4};
    mdate(i,1) = md;
end

save('Matfiles\CAV_2017.mat','mdate','Oxygen','flow_ind','-mat');


%_________________________________________________________________
clear mdate Oxygen flow_ind scell;

disp('GFD 2018');
[~,~,scell] = xlsread('Raw Data/Swan Plant log 2017.18.xlsx','Guildford 17.18','A2:D50014');

for i = 1:length(scell)
    
    if ~isnumeric(scell{i,2})
        
        md = datenum([scell{i,1},' ',scell{i,2}],'dd/mm/yyyy HH:MM:SS');
        
    else
        md = datenum([scell{i,1}],'dd/mm/yyyy') + scell{i,2};
    end
    flow_ind(i,1) = scell{i,3};
    Oxygen(i,1) = scell{i,4};
    mdate(i,1) = md;
end

save('Matfiles\GFD_2018.mat','mdate','Oxygen','flow_ind','-mat');

clear mdate Oxygen flow_ind scell;
disp('CAV 2018');

[~,~,scell] = xlsread('Raw Data/Swan Plant log 2017.18.xlsx','Caversham 17.18','A2:D52411');

for i = 1:length(scell)
    
    if ~isnumeric(scell{i,2})
        
        md = datenum([scell{i,1},' ',scell{i,2}],'dd/mm/yyyy HH:MM:SS');
        
    else
        md = datenum([scell{i,1}],'dd/mm/yyyy') + scell{i,2};
    end
    flow_ind(i,1) = scell{i,3};
    Oxygen(i,1) = scell{i,4};
    mdate(i,1) = md;
end

save('Matfiles\CAV_2018.mat','mdate','Oxygen','flow_ind','-mat');
