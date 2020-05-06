clear all; close all;

addpath(genpath('Functions'));

%dirlist = dir(['../Historical/','*.nc']);
dirlist = dir(['J:\SCERM/','*.nc']);
for bdb = 1:length(dirlist)
    
    ncfile = ['J:\SCERM/',dirlist(bdb).name];
    outdir = ['J:\SCERM_Proc_Region/',regexprep(dirlist(bdb).name,'.nc',''),'/'];

    disp(ncfile);
    mkdir(outdir);
    
    shp = shaperead('Prawn_Polygons_500m.shp');
    
%     load Export_Locations.mat;
%     %shp = S;
    
    data = tfv_readnetcdf(ncfile,'names',{'idx2';'idx3';'cell_X';'cell_Y';'cell_A'});
    
    mdata = tfv_readnetcdf(ncfile,'time',1);
    Time = mdata.Time;
    %sites = {'Currency Creek';'Lake Albert WLR';'Lake Alex Middle'};
    
    %______________________________________________________________
    
    
    
    
    for i = 1:length(shp)
        
        

        inpol = inpolygon(data.cell_X,data.cell_Y,shp(i).X,shp(i).Y);
        
        ttt = find(inpol == 1);
        fsite(i).theID = ttt;
        fsite(i).Code = shp(i).Code;
        
        
    end

    
    vars = {...
    'cell_A',...
    'H',...
    'V_x',...
    'V_y',...
    'D',...
    'SAL',...
    'TEMP',...
    'WQ_DIAG_TOT_TN',...
    'WQ_DIAG_TOT_TP',...
    'WQ_NIT_AMM',...
    'WQ_NIT_NIT',...
    'WQ_PHS_FRP',...
    'WQ_TRC_AGE',...
    'WQ_OXY_OXY',...
    'WQ_DIAG_MAC_MAC',...
    'WQ_DIAG_OXY_SED_OXY',...
    'WQ_DIAG_OXY_ATM_OXY_FLUX',...
    'WQ_DIAG_OXY_SAT',...
    'WQ_DIAG_PHY_GPP',...
    'WQ_DIAG_PHY_TPHYS',...
    'WQ_DIAG_PHY_MPB',...
    'WQ_DIAG_PHY_BPP',...
    };
    
    for i = 1:length(vars)
        disp(['Importing ',vars{i}]);
        
        
        mod = tfv_readnetcdf(ncfile,'names',vars(i));clear functions;
        
        for j = 1:length(shp)
            savedata = [];
            
            findir = [outdir,shp(j).Code,'/'];
            if ~exist(findir,'dir')
                mkdir(findir);
            end
            %if ~exists([findir,vars{i},'.mat'],'file')
            
            savedata.X = data.cell_X(fsite(j).theID);
            savedata.Y = data.cell_Y(fsite(j).theID);
            
            if strcmpi(vars{i},'H') == 1 | strcmpi(vars{i},'D') == 1 | strcmpi(vars{i},'cell_A') == 1
                savedata.(vars{i}) = mod.(vars{i})(fsite(j).theID,:);
            else
                for k = 1:length(fsite(j).theID)
                    
                    ss = find(data.idx2 == fsite(j).theID(k));
                    
                    surfIndex = min(ss);
                    botIndex = max(ss);
                    savedata.(vars{i}).Top(k,:) = mod.(vars{i})(surfIndex,:);
                    savedata.(vars{i}).Bot(k,:) = mod.(vars{i})(botIndex,:);
                end
            end
            
            savedata.Time = Time;
            
            save([findir,vars{i},'.mat'],'savedata','-mat','-v7.3');
            clear savedata;
            % end
        end
        
    end
    
    % end
end


