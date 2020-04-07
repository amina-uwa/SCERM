
clear all; close all;

dirlist = dir(['Flux_proc/','*.mat']);

flux_all = [];

load(['Flux_proc/',dirlist(1).name]);

sites = fieldnames(flux);
vars = fieldnames(flux.(sites{1}));

flux_all = flux;

for ii = 2:length(dirlist)
    clear flux;
    load(['Flux_proc/',dirlist(ii).name]);
    
    for i = 1:length(sites)
        for j = 1:length(vars)
            
            
            
            flux_all.(sites{i}).(vars{j}) = [flux_all.(sites{i}).(vars{j});flux.(sites{i}).(vars{j})];
            
            
        end
        
        if length(flux_all.(sites{i}).mDate) ~= length(flux_all.(sites{i}).OGM_donr)
            stop;
        end
    end
end


for i = 1:length(sites)
    [flux_all.(sites{i}).mDate,ind] = unique(flux_all.(sites{i}).mDate);
    for j = 1:length(vars)
        if strcmpi(vars{j},'mDate') == 0
            flux_all.(sites{i}).(vars{j}) = flux_all.(sites{i}).(vars{j})(ind);
        end
    end
end

save flux_all.mat flux_all -mat;