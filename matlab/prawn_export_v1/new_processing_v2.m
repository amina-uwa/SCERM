clear all; close all;
addpath(genpath('tuflowfv'));

%load Export_Locations.mat;
load prawn_export.mat;

shp = prawn;

modlist = dir('E:\SCERM_Proc_Region_v2/');


vars = {...
    'SAL',1;...
    'TEMP',1;...
    'WQ_DIAG_TOT_TN',14/1000;...
    'WQ_DIAG_TOT_TP',31/1000;...
    'WQ_NIT_AMM',14/1000;...
    'WQ_NIT_NIT',14/1000;...
    'WQ_PHS_FRP',31/1000;...
    'WQ_TRC_AGE',1/86400;...
    'WQ_OXY_OXY',32/1000;...
    'WQ_PHY_GRN',1;...
    'WQ_PHY_BGA',1;...
    'WQ_PHY_CRYPT',1;...
    'WQ_PHY_DIATOM',1;...
    'WQ_PHY_DINO',1;...
    'WQ_PHY_DIATOM',1;...
    'WQ_DIAG_MAC_GPP',1;...
    'WQ_DIAG_NCS_D_TAUB',1;...
    'WQ_DIAG_OXY_ATM_OXY_FLUX',1;...
    'WQ_DIAG_OXY_SAT',1;...
    'WQ_DIAG_MAC_MAC',1;...
    'WQ_DIAG_OXY_SED_OXY',32/1000;...
    'WQ_DIAG_PHY_GPP',1;...
    'WQ_DIAG_PHY_NCP',1;...
    'WQ_DIAG_PHY_TPHYS',50/12;...
    'WQ_DIAG_PHY_MPB',1;...
    'WQ_DIAG_PHY_BPP',1;...
    'WQ_DIAG_TOT_TSS',1;...
    'WQ_DIAG_TOT_TURBIDITY',1;...
    'WQ_DIAG_TOT_LIGHT',1;...
    'WQ_DIAG_TOT_PAR',1;...
    };

% Processing types...

% Daily
% Mean of surface and Bottom
% Strat value (bot - surface
% Strat % Area
% Hypoxia % Area
% Hypoxia total Area

% Period
% Average Surface Temp
% Max Surface Temp
% Days strat
% Days lowoxygen <4
% Days Hypoxia <2
% Days Anoxia < 0.5

for ccc = 3:length(modlist)
    
    maindir = ['E:\SCERM_Proc_Region_v2/',modlist(ccc).name,'/'];
    outdir = 'Prawn_v16/New_Template_v6/';
    
    
    disp(maindir);
    
    numhours = 24/24;
    numdays = 20;
    
    model_time_interval = 2/24;
    
    if ~exist(outdir,'dir')
        mkdir(outdir);
    end
    line_chx = 0;
    
    
    fid = fopen([outdir,modlist(ccc).name,'.csv'],'wt');
    
    headers_str = ['Site Code,Project,Name,Region,Type,Region,Year,mm,dd,ID,area,num_cells,num_outputs,'];
    
    fprintf(fid,'%s',headers_str);
    
    for k = 1:length(vars)
        fprintf(fid,'%s Surf,%s Bottom,',vars{k,1},vars{k,1});
    end
    
    fprintf(fid,'sal_strat,sal_strat_area,lowoxygen_area,hypoxia_area,');
    fprintf(fid,'temp_surface_avg,temp_surface_max,sal_strat_history,lowoxygen_frequency,hypoxia_frequency,anoxia_frequency,');
    
    fprintf(fid,'\n');
    
    for i = 1:length(shp)
        
        mdata = [];
        
        load([maindir,shp(i).Code,'/D.mat']);
        
        mdata.depth = savedata.D;
        mdata.Time = savedata.Time;
        load([maindir,shp(i).Code,'/cell_A.mat']);
        
        mdata.area = savedata.cell_A;
        
        clear savedata;
        
        for k = 1:length(vars)
            load([maindir,shp(i).Code,'/',vars{k,1},'.mat']);
            mdata.(vars{k,1}).Top  = savedata.(vars{k,1}).Top * vars{k,2};
            mdata.(vars{k,1}).Bot  = savedata.(vars{k,1}).Bot * vars{k,2};
            mdata.(vars{k,1}).Time = savedata.Time;
        end
        
        for k = 1:length(shp(i).Dates)
            
            line_chx = line_chx + 1;
            
            fprintf(fid,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,',shp(i).Code,shp(i).Project,regexprep(shp(i).Name,',',' '),...
                shp(i).Type,shp(i).Type,shp(i).Type,...
                datestr(shp(i).Dates(k),'yyyy'),...
                datestr(shp(i).Dates(k),'mm'),...
                datestr(shp(i).Dates(k),'dd'),...
                shp(i).Code);
            
            
            if ~isempty(mdata.depth)
                hour_array = find(mdata.Time > (shp(i).Dates(k)-numhours) & mdata.Time <= shp(i).Dates(k));
                day_array  = find(mdata.Time >= (shp(i).Dates(k)-numdays) & mdata.Time <= (shp(i).Dates(k)));
                fprintf(fid,'%4.4f,%4.4f,,',sum(mdata.area),length(mdata.area));
                
                if ~isempty(hour_array)
                    
                    for bb = 1:length(vars)
                        
                        mT = [];
                        mB = [];
                        
                        for l = 1:length(hour_array)
                            [~,age_ind] = min(abs(mdata.(vars{bb,1}).Time - mdata.Time(hour_array(l))));
                            d_chx =  find(mdata.depth(:,hour_array(l)) <= shp(i).Depth);
                            
                            if isempty(d_chx)
                                
                                d_chx =  find(mdata.depth(:,hour_array(l)) <= 10);
                                if isempty(d_chx)
                                    stop
                                end
                            end
                            
                            
                            mT(l) = mean(mdata.(vars{bb,1}).Top(d_chx,age_ind));
                            mB(l) = mean(mdata.(vars{bb,1}).Bot(d_chx,age_ind));
                            
                            if strcmpi(vars{bb,1},'SAL') == 1
                                sal_strat(l) = mB(l) - mT(l);
                            end
                            
                        end
                        
                        fprintf(fid,'%5.5f,%5.5f,',mean(mT),mean(mB));
                        
                    end
                    
                    
                    for l = 1:length(hour_array)
                        
                        [~,oxy_ind] = min(abs(mdata.WQ_OXY_OXY.Time - mdata.Time(hour_array(l))));
                        [~,sal_ind] = min(abs(mdata.SAL.Time - mdata.Time(hour_array(l))));
                        
                        % Area calcs - replace with total area....
                        sss = find((mdata.SAL.Bot(d_chx,sal_ind) - mdata.SAL.Top(d_chx,sal_ind)) > 6);
                        
                        
                        
                        
                        if ~isempty(sss)
                            strat_area(l) = sum(mdata.area(d_chx(sss)));
                            
                        else
                            strat_area(l) = 0;
                        end
                        strat_total(l) = sum(mdata.area(d_chx));
                        
                        ttt = find(mdata.WQ_OXY_OXY.Bot(d_chx,oxy_ind) < 2);
                        if ~isempty(ttt)
                            hypox_area(l) = sum(mdata.area(d_chx(ttt)));
                            
                        else
                            hypox_area(l) = 0;
                        end
                        hypox_total(l) = sum(mdata.area(d_chx));
                        
                        uuu = find((mdata.WQ_OXY_OXY.Bot(d_chx,oxy_ind)) < 4);
                        if ~isempty(uuu)
                            lowoxygen_area(l) = sum(mdata.area(d_chx(uuu)));
                            
                        else
                            lowoxygen_area(l) = 0;
                        end
                        lowoxygen_total(l) = sum(mdata.area(d_chx));
                        
                        
                    end
                    
                    fprintf(fid,'%4.4f,',mean(sal_strat));
                    fprintf(fid,'%4.4f,',(sum(strat_area) / sum(strat_total)*100));
                    fprintf(fid,'%4.4f,',(sum(lowoxygen_area) / sum(lowoxygen_total)*100));
                    fprintf(fid,'%4.4f,',(sum(hypox_area) / sum(hypox_total)*100));
                    
                    for l = 1:length(day_array)
                        [~,temp_ind] = min(abs(mdata.TEMP.Time - mdata.Time(day_array(l))));
                        
                        temp_top_days(l) = mean(mdata.TEMP.Top(d_chx,temp_ind));
                        
                        [~,sal_ind] = min(abs(mdata.SAL.Time - mdata.Time(day_array(l))));
                        sal_strat_days(l) = mean(mdata.SAL.Bot(d_chx,sal_ind) - mdata.SAL.Top(d_chx,sal_ind));
                        
                        [~,oxy_ind] = min(abs(mdata.WQ_OXY_OXY.Time - mdata.Time(day_array(l))));
                        oxy_bot_days(l) = mean(mdata.WQ_OXY_OXY.Bot(d_chx,oxy_ind));
                        
                        
                        %                         [~,amm_ind] = min(abs(mdata.WQ_NIT_AMM.Time - depth.Time(day_array(l))));
                        %                         [~,diag_ind] = min(abs(maghsi.Time - depth.Time(day_array(l))));
                        
                        %                         mag_bot_days(l) = mean(maghsi.WQ_DIAG_PHY_MPB.Bot(d_chx,diag_ind));
                        %
                        %                         %%% Calc HAB (Carp) CYANO
                        %                         hab(l) = calc_hab(Vx.V_x.Bot(d_chx,day_array(l)),Vy.V_y.Bot(d_chx,day_array(l)),...
                        %                             temp.TEMP.Top(d_chx,temp_ind),temp.TEMP.Bot(d_chx,temp_ind),...
                        %                             sal.SAL.Top(d_chx,sal_ind),sal.SAL.Bot(d_chx,sal_ind),...
                        %                             amm.WQ_NIT_AMM.Bot(d_chx,amm_ind),nit.WQ_NIT_NIT.Bot(d_chx,amm_ind),...
                        %                             frp.WQ_PHS_FRP.Bot(d_chx,amm_ind),0);
                        %
                        %                         %DINO
                        %                         hab2(l) = calc_hab(Vx.V_x.Bot(d_chx,day_array(l)),Vy.V_y.Bot(d_chx,day_array(l)),...
                        %                             temp.TEMP.Top(d_chx,temp_ind),temp.TEMP.Bot(d_chx,temp_ind),...
                        %                             sal.SAL.Top(d_chx,sal_ind),sal.SAL.Bot(d_chx,sal_ind),...
                        %                             amm.WQ_NIT_AMM.Bot(d_chx,amm_ind),nit.WQ_NIT_NIT.Bot(d_chx,amm_ind),...
                        %                             frp.WQ_PHS_FRP.Bot(d_chx,amm_ind),1);
                        %
                        %                         %%% WQI Catherines
                        %                         wqi(l) = calc_hsi(oxy.WQ_OXY_OXY.Bot(d_chx,oxy_ind),tchla.WQ_DIAG_PHY_TPHYS.Top(d_chx,diag_ind),...
                        %                             max(tn.WQ_DIAG_TOT_TN.Bot(d_chx,diag_ind),tn.WQ_DIAG_TOT_TN.Top(d_chx,diag_ind)),...
                        %                             max(tp.WQ_DIAG_TOT_TP.Bot(d_chx,diag_ind),tp.WQ_DIAG_TOT_TP.Top(d_chx,diag_ind)));
                        %
                        %
                        %
                    end
                    
                    fprintf(fid,'%4.4f,',mean(temp_top_days));
                    fprintf(fid,'%4.4f,',max(temp_top_days));
                    
                    num_ts_strat = length(find(sal_strat_days > 6));
                    
                    num_days_strat = num_ts_strat * (mdata.SAL.Time(2) - mdata.SAL.Time(1));%model_time_interval;
                    
                    num_ts_lowoxy = length(find(oxy_bot_days <  4));
                    num_days_lowoxy = num_ts_lowoxy * (mdata.WQ_OXY_OXY.Time(2) - mdata.WQ_OXY_OXY.Time(1));% model_time_interval;
                    
                    
                    num_ts_oxy = length(find(oxy_bot_days <  2));
                    num_days_oxy = num_ts_oxy *(mdata.WQ_OXY_OXY.Time(2) - mdata.WQ_OXY_OXY.Time(1));%model_time_interval;
                    
                    num_ts_oxy2 = length(find(oxy_bot_days <  0.5));
                    num_days_oxy2 = num_ts_oxy2 * (mdata.WQ_OXY_OXY.Time(2) - mdata.WQ_OXY_OXY.Time(1));%model_time_interval;
                    
                    fprintf(fid,'%4.4f,',num_days_strat);
                    fprintf(fid,'%4.4f,',num_days_lowoxy);
                    fprintf(fid,'%4.4f,',num_days_oxy);
                    fprintf(fid,'%4.4f,',num_days_oxy2);
                    
                    
                    
                end
            end
            fprintf(fid,'\n');
        end
    end
    
    fclose(fid);
    
end

