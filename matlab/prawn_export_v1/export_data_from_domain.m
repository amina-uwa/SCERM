%clear all; close all;

addpath(genpath('tuflowfv'));

ncdir = 'Q:\SCERM\SCERM\Output\ALL/';
savedir = 'F:\Dropbox\SCERM_Proc_More/';

dirlist = dir([ncdir,'*.nc']);

% vars = {...
%     'cell_A',...
%     'H',...
%     'V_x',...
%     'V_y',...
%     'D',...
%     'SAL',...
%     'TEMP',...
%     'WQ_DIAG_TOT_TN',...
%     'WQ_DIAG_TOT_TP',...
%     'WQ_NIT_AMM',...
%     'WQ_NIT_NIT',...
%     'WQ_PHS_FRP',...
%     'WQ_TRC_AGE',...
%     'WQ_OXY_OXY',...
%     'WQ_DIAG_MAC_MAC',...
%     'WQ_DIAG_OXY_SED_OXY',...
%     'WQ_DIAG_OXY_ATM_OXY_FLUX',...
%     'WQ_DIAG_OXY_SAT',...
%     'WQ_DIAG_PHY_GPP',...
%     'WQ_DIAG_PHY_TPHYS',...
%     'WQ_DIAG_PHY_MPB',...
%     'WQ_DIAG_PHY_BPP',...
%     };
% vars = {...
%     'SAL',...
%     'TEMP',...
%     'WQ_OXY_OXY',...
%     };

vars = {...
    'SAL',...
    'TEMP',...
    'WQ_OXY_OXY',...
    'V_x',...
    'V_y',...
    'WQ_DIAG_TOT_TSS',...
    'WQ_DIAG_TOT_TURBIDITY',...
    'WQ_DIAG_TOT_LIGHT',...
    'WQ_DIAG_TOT_PAR',...
    'WQ_DIAG_OXY_SAT',...
    };





for bdb = 9:length(dirlist)%1:length(dirlist)
    
    ncfile = [ncdir,dirlist(bdb).name];
    %ncfile = 'Z:\Busch\Studysites\Peel\2018_Modelling\Peel_WQ_Model_v5_2016_2017_3D_Murray\Output\sim_2016_2017_Open.nc';
    outdir = [savedir,regexprep(dirlist(bdb).name,'.nc',''),'/'];
    %     if exist(outdir,'dir')
    %
    %     else
    
    the_vars = tfv_infonetcdf(ncfile);
    
    
    
    disp(ncfile);
    
    %if ~exist(outdir,'dir')
    
    mkdir(outdir);
    %outdir = 'I:\Peel\Matfiles/Peel_WQ_Model_v5_2016_2017_3D_Murray/';
    
    %load Export_Locations.mat;
    %shp = S;
    
    
    mdata = tfv_readnetcdf(ncfile,'time',1);
    Time = mdata.Time;
    %sites = {'Currency Creek';'Lake Albert WLR';'Lake Alex Middle'};
    
    %______________________________________________________________
    
    
%     surf_ind = data.idx3;
%     
%     bottom_ind(1:length(data.idx3)-1) = data.idx3(2:end) - 1;
%     bottom_ind(length(data.idx3)) = length(data.idx3);
    
    
    for i = 1:length(vars)
        
        
        if strcmpi(vars{i},'SAL') == 1
            data = tfv_readnetcdf(ncfile,'names',{'idx2';'idx3';'cell_X';'cell_Y';'cell_A';'D';'cell_Zb';'layerface_Z';'NL';});
        end
        
        disp(['Importing ',vars{i}]);
        
        
        if sum(strcmpi(the_vars,vars{i})) == 1 | ...
                strcmpi(vars{i},'WQ_DIAG_PHY_TCHLA') == 1
            
            if strcmpi(vars{i},'WQ_DIAG_PHY_TCHLA') == 0
                mod = tfv_readnetcdf(ncfile,'names',vars(i));
                
                if strcmpi(vars{i},'SAL') == 1
                    savedata.X = data.cell_X;
                    savedata.Y = data.cell_Y;
                    savedata.Area = data.cell_A;
                    savedata.Time = Time;
                    savedata.(vars{i}) = mod.(vars{i});
                    savedata.D = data.D;
                    savedata.Zb = data.cell_Zb;
                    savedata.layerface_Z = data.layerface_Z;
                    savedata.NL = data.NL;
                    savedata.idx3 = data.idx3;
                    savedata.idx2 = data.idx2;
                else
                    savedata.(vars{i}) = mod.(vars{i});
                end
            end
            
            %                 switch vars{i}
            %
            %                     case 'H'
            %                         savedata.(vars{i}) = mod.(vars{i});
            %                     case 'D'
            %                         savedata.(vars{i}) = mod.(vars{i});
            %                     case 'cell_A'
            %                         savedata.(vars{i}) = mod.(vars{i});
            %                     case  'WQ_DIAG_PHY_TCHLA'
            %                         savedata = run_tchla_cal(outdir);
            %                     otherwise
            %                         savedata.(vars{i}).Top = mod.(vars{i})(surf_ind,:);
            %                         savedata.(vars{i}).Bot = mod.(vars{i})(bottom_ind,:);
            %
            %                 end
            
            
            
            save([outdir,vars{i},'.mat'],'savedata','-mat','-v7.3');
            clear savedata;
        end
        
    end
    %end
end


