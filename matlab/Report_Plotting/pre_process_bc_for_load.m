clear all; close all;

basedir = 'D:\Github\SCERM\models\SCERM_v6\BCs\';

shp = shaperead('../../../Source_to_SCERM/Maps/InflowPoints.shp');


scen_list = {...
    'Capped_44',...
    'Dry_44',...
    'Flow_Catch',...
    'Targets_44',...
    'Wet_44',...
    };
for bb = 1:length(scen_list)    


dirlist = dir([basedir,scen_list{bb},'/','*.csv']);

addpath(genpath('tuflowfv'));

[snum,sstr] = xlsread('TFV_Inflow_Locations.xlsx','A2:C100');

inf_name = sstr(:,1);
inf_X = snum(:,1);
inf_Y = snum(:,2);

for i = 1:length(dirlist);
    
    disp([scen_list{bb},':',dirlist(i).name]);
    
    site = regexprep(dirlist(i).name,'.csv','');
    inf_X = [];
    inf_Y = [];
    for kk = 1:length(shp)
        if strcmpi(site,shp(kk).SubCat) == 1
        inf_X = shp(kk).X;
        inf_Y = shp(kk).Y;
        end
    end
    
    site = regexprep(site,' ','_');
    site = regexprep(site,'-','_');
    if isempty(inf_X)
        stop;
        
    else
        Load.(scen_list{bb}).(site).X = inf_X;
        Load.(scen_list{bb}).(site).Y = inf_Y;
    end
    
    data.(site) = tfv_readBCfile([basedir,scen_list{bb},'/',dirlist(i).name]);
    
    Load.(scen_list{bb}).(site).ML = data.(site).Flow * (86400/1000);
    Load.(scen_list{bb}).(site).L = Load.(scen_list{bb}).(site).ML * 1e6;
    Load.(scen_list{bb}).(site).Date = data.(site).Date;
    
    
    tnconv = 14/1000;
    tpconv = 31/1000;
    oxyconv = 32/1000;
    
    Load.(scen_list{bb}).(site).TN_mg = (data.(site).TN * tnconv) .* Load.(scen_list{bb}).(site).L;
    Load.(scen_list{bb}).(site).TN_mgL = (data.(site).TN * tnconv);
    Load.(scen_list{bb}).(site).OXY_mg = (data.(site).Oxy * oxyconv) .* Load.(scen_list{bb}).(site).L;
    Load.(scen_list{bb}).(site).TP_mg = (data.(site).TP * tpconv) .* Load.(scen_list{bb}).(site).L;
    Load.(scen_list{bb}).(site).TP_mgL = (data.(site).TP * tpconv);
    Load.(scen_list{bb}).(site).TN_kg = Load.(scen_list{bb}).(site).TN_mg *1e-6;
    Load.(scen_list{bb}).(site).TP_kg = Load.(scen_list{bb}).(site).TP_mg *1e-6;
    Load.(scen_list{bb}).(site).OXY_kg = Load.(scen_list{bb}).(site).OXY_mg *1e-6;
    
end


end
save Load.mat Load -mat;


% save('../WQ_Response_Plots/Load.(scen_list{bb}).mat','Load','-mat');
% 
% sites = fieldnames(Load);
% 
% fid = fopen('Flow.csv','wt');
% 
% fprintf(fid,'Date,');
% 
% for i = 1:length(sites)
%     fprintf(fid,'%s (ML/day),',sites{i});
% end
% fprintf(fid,'\n');
% 
% for j = 1:length(Load.(scen_list{bb}).(sites{1}).Date);
%     fprintf(fid,'%s,',datestr(Load.(scen_list{bb}).(sites{1}).Date(j),'dd/mm/yyyy'));
%     
%     for i = 1:length(sites)
%         if Load.(scen_list{bb}).(sites{i}).Date(j) == Load.(scen_list{bb}).(sites{1}).Date(j)
%             fprintf(fid,'%4.10f,',Load.(scen_list{bb}).(sites{i}).ML(j));
%         else
%             stop;
%         end
%     end
%     fprintf(fid,'\n');
% end
% 
% fclose(fid);
% 
% 
% %________________________
% 
% fid = fopen('TN.csv','wt');
% 
% fprintf(fid,'Date,');
% 
% for i = 1:length(sites)
%     fprintf(fid,'%s (KG/day),',sites{i});
% end
% fprintf(fid,'\n');
% 
% for j = 1:length(Load.(scen_list{bb}).(sites{1}).Date);
%     fprintf(fid,'%s,',datestr(Load.(scen_list{bb}).(sites{1}).Date(j),'dd/mm/yyyy'));
%     
%     for i = 1:length(sites)
%         if Load.(scen_list{bb}).(sites{i}).Date(j) == Load.(scen_list{bb}).(sites{1}).Date(j)
%             fprintf(fid,'%4.10f,',Load.(scen_list{bb}).(sites{i}).TN_kg(j));
%         else
%             stop;
%         end
%     end
%     fprintf(fid,'\n');
% end
% 
% fclose(fid);
% 
% %________________________
% 
% fid = fopen('TP.csv','wt');
% 
% fprintf(fid,'Date,');
% 
% for i = 1:length(sites)
%     fprintf(fid,'%s (KG/day),',sites{i});
% end
% fprintf(fid,'\n');
% 
% for j = 1:length(Load.(scen_list{bb}).(sites{1}).Date);
%     fprintf(fid,'%s,',datestr(Load.(scen_list{bb}).(sites{1}).Date(j),'dd/mm/yyyy'));
%     
%     for i = 1:length(sites)
%         if Load.(scen_list{bb}).(sites{i}).Date(j) == Load.(scen_list{bb}).(sites{1}).Date(j)
%             fprintf(fid,'%4.10f,',Load.(scen_list{bb}).(sites{i}).TP_kg(j));
%         else
%             stop;
%         end
%     end
%     fprintf(fid,'\n');
% end
% 
% fclose(fid);

