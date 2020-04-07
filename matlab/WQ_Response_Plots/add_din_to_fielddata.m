clear all; close all;

load swan.mat;

sites = fieldnames(swan);

for i = 1:length(sites)
    
    
    if isfield(swan.(sites{i}),'WQ_NIT_NIT') & ...
            isfield(swan.(sites{i}),'WQ_NIT_AMM');
        
        
        nDate = swan.(sites{i}).WQ_NIT_NIT.Date;
        nData = swan.(sites{i}).WQ_NIT_NIT.Data;
        nDepth = swan.(sites{i}).WQ_NIT_NIT.Depth;
        
        aDate = swan.(sites{i}).WQ_NIT_AMM.Date;
        aData = swan.(sites{i}).WQ_NIT_AMM.Data;
        aDepth = swan.(sites{i}).WQ_NIT_AMM.Depth;
        
        int = 1;
        dDate = [];
        dData = [];
        dDepth = [];
        
        for j = 1:length(nDate)
            
            sss = find(aDate == nDate(j) & ...
                aDepth == nDepth(j));
            disp(['Data Found: ',sites{i}]);
            if ~isempty(sss)
                dDate(int,1) = nDate(j);
                dDepth(int,1) = nDepth(j);
                dData(int,1) = nData(j) + aData(sss(1));
                
                int = int + 1;
            end
           
            
        end
        
        if int > 1
            swan.(sites{i}).DIN = swan.(sites{i}).WQ_NIT_NIT;
            swan.(sites{i}).DIN.Date = dDate;
            swan.(sites{i}).DIN.Data = dData;
            swan.(sites{i}).DIN.Depth = dDepth;
        end
        
        
    end
    
    
    
end

save swan_din.mat swan -mat;
            
            
            
        
        
        
        
        
        
        
    

