clear all; close all;

addpath(genpath('Functions'));

% ncdir = 'T:\PEEL/';
% savedir = 'T:\Processed/';
% 
% dirlist = dir([ncdir,'*.nc']);

ncfile = 'R:\Swan\Sim9\Output\swan_fd_sim9.nc';
outdir = 'F:\Cloudstor\Shared\Aquatic Ecodynamics (AED)\AED_Swan_BB\Salt HSI Calc\Matfiles\2050/';
vars = {...
    'SAL',...
    };



%for bdb = 1:length(dirlist)
    
    %ncfile = [ncdir,dirlist(bdb).name];
    %ncfile = 'Z:\Busch\Studysites\Peel\2018_Modelling\Peel_WQ_Model_v5_2016_2017_3D_Murray\Output\sim_2016_2017_Open.nc';
    %outdir = [savedir,regexprep(dirlist(bdb).name,'.nc',''),'/'];
    %     if exist(outdir,'dir')
    %
    %     else
    
    the_vars = tfv_infonetcdf(ncfile);
    
    disp(ncfile);
    mkdir(outdir);
    %outdir = 'I:\Peel\Matfiles/Peel_WQ_Model_v5_2016_2017_3D_Murray/';
    
    %load Export_Locations.mat;
    %shp = S;
    
    data = tfv_readnetcdf(ncfile,'names',{'idx2';'idx3';'cell_X';'cell_Y';'cell_A'});
    
    mdata = tfv_readnetcdf(ncfile,'time',1);
    Time = mdata.Time;
    %sites = {'Currency Creek';'Lake Albert WLR';'Lake Alex Middle'};
    
    %______________________________________________________________
    
    
    surf_ind = data.idx3;
    
    bottom_ind(1:length(data.idx3)-1) = data.idx3(2:end) - 1;
    bottom_ind(length(data.idx3)) = length(data.idx3);
    
    
    for i = 1:length(vars)
        disp(['Importing ',vars{i}]);
        
        
        if sum(strcmpi(the_vars,vars{i})) == 1 | ...
                strcmpi(vars{i},'WQ_DIAG_PHY_TCHLA') == 1
            
            if strcmpi(vars{i},'WQ_DIAG_PHY_TCHLA') == 0
                mod = tfv_readnetcdf(ncfile,'names',vars(i));
                
                
                savedata.X = data.cell_X;
                savedata.Y = data.cell_Y;
                savedata.Area = data.cell_A;
                savedata.Time = Time;
            end
            
            switch vars{i}
                
                case 'H'
                    savedata.(vars{i}) = mod.(vars{i});
                case 'D'
                    savedata.(vars{i}) = mod.(vars{i});
                case 'cell_A'
                    savedata.(vars{i}) = mod.(vars{i});
                case  'WQ_DIAG_PHY_TCHLA'
                    savedata = run_tchla_cal(outdir);
                otherwise
                    savedata.(vars{i}).Top = mod.(vars{i})(surf_ind,:);
                    savedata.(vars{i}).Bot = mod.(vars{i})(bottom_ind,:);
                    
            end
            
            
            
            save([outdir,vars{i},'.mat'],'savedata','-mat','-v7.3');
            clear savedata;
        end
        
    end
    
%end


