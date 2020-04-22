clear all; close all;

load swan.mat;

sites = fieldnames(swan);

for i = 1:length(sites)
    

     if isfield(swan.(sites{i}),'TRC_SS1') & ~isfield(swan.(sites{i}),'WQ_NCS_SS1')

        swan.(sites{i}).WQ_NCS_SS1 = swan.(sites{i}).TRC_SS1;
        swan.(sites{i}).WQ_TRC_SS1 = swan.(sites{i}).TRC_SS1;
     end  
     
     if isfield(swan.(sites{i}),'WQ_DIAG_TOT_TURBIDITY')
         stop
     end
    
end

save swan.mat swan -mat -v7;