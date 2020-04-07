clear all; close all;

dirlist = dir('Inflows/');

addpath(genpath('tuflowfv'));

[snum,sstr] = xlsread('TFV_Inflow_Locations.xlsx','A2:C100');

inf_name = sstr(:,1);
inf_X = snum(:,1);
inf_Y = snum(:,2);

for i = 3:length(dirlist);
    
    site = regexprep(dirlist(i).name,'.csv','');
    
    ssss = find(strcmpi(inf_name,site) == 1);
    
    if isempty(ssss)
        stop;
        
    else
        Load.(site).X = inf_X(ssss);
        Load.(site).Y = inf_Y(ssss);
    end
    
    data.(site) = tfv_readBCfile(['Inflows/',dirlist(i).name]);
    
    Load.(site).ML = data.(site).FLOW * (86400/1000);
    Load.(site).L = Load.(site).ML * 1e6;
    Load.(site).Date = data.(site).ISOTIME;
    
    
    tnconv = 14/1000;
    tpconv = 31/1000;
    oxyconv = 32/1000;
    
    Load.(site).TN_mg = ...
        ((data.(site).AMM * tnconv) .* Load.(site).L) + ...
        ((data.(site).NIT * tnconv) .* Load.(site).L) + ...
        ((data.(site).DON * tnconv) .* Load.(site).L) + ...
        ((data.(site).PON * tnconv) .* Load.(site).L);% + ...
        ((data.(site).DONR * tnconv) .* Load.(site).L);
        ((data.(site).PON * tnconv) .* Load.(site).L) + ...
        ((data.(site).DONR * tnconv) .* Load.(site).L);

        Load.(site).TN_mgL = ...
        (data.(site).AMM * tnconv) + ...
        (data.(site).NIT * tnconv)+ ...
        (data.(site).DON * tnconv) + ...
        (data.(site).PON * tnconv)+ ...
        (data.(site).DONR * tnconv) ;
    
    
    
    Load.(site).AMM_mg = (data.(site).AMM * tnconv) .* Load.(site).L;
    Load.(site).NIT_mg = (data.(site).NIT * tnconv) .* Load.(site).L;
    Load.(site).DON_mg = (data.(site).DON * tnconv) .* Load.(site).L;
    Load.(site).PON_mg = (data.(site).PON * tnconv) .* Load.(site).L;
    Load.(site).DONR_mg = (data.(site).DONR * tnconv) .* Load.(site).L;
    
        Load.(site).OXY_mg = (data.(site).OXY * oxyconv) .* Load.(site).L;

    
    
    
    
    
    Load.(site).TP_mg = ...
        ((data.(site).FRP * tpconv) .* Load.(site).L) + ...
        ((data.(site).FRP_ADS * tpconv) .* Load.(site).L) + ...
        ((data.(site).DOP * tpconv) .* Load.(site).L) + ...
        ((data.(site).POP * tpconv) .* Load.(site).L) + ...
        ((data.(site).DOPR * tpconv) .* Load.(site).L);
    
    Load.(site).TP_mgL = ...
        ((data.(site).FRP * tpconv)) + ...
        ((data.(site).FRP_ADS * tpconv)) + ...
        ((data.(site).DOP * tpconv)) + ...
        ((data.(site).POP * tpconv)) + ...
        ((data.(site).DOPR * tpconv));    
    
    Load.(site).FRP_mg = (data.(site).FRP * tpconv) .* Load.(site).L;
    Load.(site).FRP_ADS_mg = (data.(site).FRP_ADS * tpconv) .* Load.(site).L;
    Load.(site).DOP_mg = (data.(site).DOP * tpconv) .* Load.(site).L;
    Load.(site).POP_mg = (data.(site).POP * tpconv) .* Load.(site).L;
    Load.(site).DOPR_mg = (data.(site).DOPR * tpconv) .* Load.(site).L;
    
    
    
    
    
    Load.(site).TN_kg = Load.(site).TN_mg *1e-6;
    Load.(site).TP_kg = Load.(site).TP_mg *1e-6;
    
    Load.(site).AMM_kg = Load.(site).AMM_mg *1e-6;
    Load.(site).NIT_kg = Load.(site).NIT_mg *1e-6;
    Load.(site).DON_kg = Load.(site).DON_mg *1e-6;
    Load.(site).PON_kg = Load.(site).PON_mg *1e-6;
    Load.(site).DONR_kg = Load.(site).DONR_mg *1e-6;
    
    Load.(site).FRP_kg = Load.(site).FRP_mg *1e-6;
    Load.(site).FRP_ADS_kg = Load.(site).FRP_ADS_mg *1e-6;
    Load.(site).DOP_kg = Load.(site).DOP_mg *1e-6;
    Load.(site).POP_kg = Load.(site).POP_mg *1e-6;
    Load.(site).DOPR_kg = Load.(site).DOPR_mg *1e-6;
    
    Load.(site).OXY_kg = Load.(site).OXY_mg *1e-6;
    
end

save Load.mat Load -mat;
save('../WQ_Response_Plots/Load.mat','Load','-mat');

sites = fieldnames(Load);

fid = fopen('Flow.csv','wt');

fprintf(fid,'Date,');

for i = 1:length(sites)
    fprintf(fid,'%s (ML/day),',sites{i});
end
fprintf(fid,'\n');

for j = 1:length(Load.(sites{1}).Date);
    fprintf(fid,'%s,',datestr(Load.(sites{1}).Date(j),'dd/mm/yyyy'));
    
    for i = 1:length(sites)
        if Load.(sites{i}).Date(j) == Load.(sites{1}).Date(j)
            fprintf(fid,'%4.10f,',Load.(sites{i}).ML(j));
        else
            stop;
        end
    end
    fprintf(fid,'\n');
end

fclose(fid);


%________________________

fid = fopen('TN.csv','wt');

fprintf(fid,'Date,');

for i = 1:length(sites)
    fprintf(fid,'%s (KG/day),',sites{i});
end
fprintf(fid,'\n');

for j = 1:length(Load.(sites{1}).Date);
    fprintf(fid,'%s,',datestr(Load.(sites{1}).Date(j),'dd/mm/yyyy'));
    
    for i = 1:length(sites)
        if Load.(sites{i}).Date(j) == Load.(sites{1}).Date(j)
            fprintf(fid,'%4.10f,',Load.(sites{i}).TN_kg(j));
        else
            stop;
        end
    end
    fprintf(fid,'\n');
end

fclose(fid);

%________________________

fid = fopen('TP.csv','wt');

fprintf(fid,'Date,');

for i = 1:length(sites)
    fprintf(fid,'%s (KG/day),',sites{i});
end
fprintf(fid,'\n');

for j = 1:length(Load.(sites{1}).Date);
    fprintf(fid,'%s,',datestr(Load.(sites{1}).Date(j),'dd/mm/yyyy'));
    
    for i = 1:length(sites)
        if Load.(sites{i}).Date(j) == Load.(sites{1}).Date(j)
            fprintf(fid,'%4.10f,',Load.(sites{i}).TP_kg(j));
        else
            stop;
        end
    end
    fprintf(fid,'\n');
end

fclose(fid);

