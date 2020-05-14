%function create_spreadsheet_from_sites
clear all; close all;
addpath(genpath('tuflowfv'));

load Export_Locations.mat;


modlist = dir('I:\SCERM_Proc_Region/ALL/');

for ccc = 3:length(modlist)
    
    %maindir = 'Matfiles/Peel_WQ_Model_v5_2016_2017_3D_Murray/';
    maindir = ['I:\SCERM_Proc_Region/ALL/',modlist(ccc).name,'/'];
    outdir = 'Spreadsheets v13/New_Template_v6/';
    
    
    disp(maindir);
    
    numhours = 24/24;
    numdays = 20;
    
    model_time_interval = 2/24;
    
    if ~exist(outdir,'dir')
        mkdir(outdir);
    end
    
    
    fid = fopen([outdir,modlist(ccc).name,'.csv'],'wt');
    
    headers_str = ['Site Code,Project,Name,Region,Type,Region,Year,mm,dd,ID,area,num_cells,num_outputs,',...
        'age_surface,age_bottom,salinity_surface,salinity_ bottom,',...
        'temp_surface,temp_bottom,oxygen_surface,oxygen_bottom,nh4_surface,nh4_bottom,',...
        'CHLA,sal_strat,sal_strat_area,'...
        'lowoxygen_area,hypoxia_area,temp_surface_avg,temp_surface_max,sal_strat_history,lowoxygen_frequency,hypoxia_frequency,anoxia_frequency,cyano_hab_index_avg,dino_hab_index_avg,mag_hsi_avg,wqi_avg'];
    
    
    
    
    fprintf(fid,'%s\n',headers_str);
    
    
    
    line_chx = 0;
    
    
    
    
    
    
    
    for i = 1:length(shp)
        
        load([maindir,shp(i).Code,'/D.mat']);
        
        depth = savedata;
        
        load([maindir,shp(i).Code,'/cell_A.mat']);
        
        area = savedata;
        
        load([maindir,shp(i).Code,'/TEMP.mat']);
        
        temp = savedata;
        
        load([maindir,shp(i).Code,'/SAL.mat']);
        
        sal = savedata;
        
        load([maindir,shp(i).Code,'/WQ_OXY_OXY.mat']);
        
        oxy = savedata;
        
        load([maindir,shp(i).Code,'/WQ_TRC_AGE.mat']);
        
        age = savedata;
        
        
        load([maindir,shp(i).Code,'/WQ_NIT_AMM.mat']);
        
        amm = savedata;
        
        load([maindir,shp(i).Code,'/WQ_NIT_NIT.mat']);
        
        nit = savedata;
        
        load([maindir,shp(i).Code,'/WQ_DIAG_PHY_MPB.mat']);
        
        maghsi = savedata;
        
        
        load([maindir,shp(i).Code,'/WQ_DIAG_PHY_TPHYS.mat']);
        
        tchla = savedata;
        
        load([maindir,shp(i).Code,'/WQ_DIAG_TOT_TN.mat']);
        
        tn = savedata;
        
        load([maindir,shp(i).Code,'/WQ_DIAG_TOT_TP.mat']);
        
        tp = savedata;
        
        load([maindir,shp(i).Code,'/WQ_PHS_FRP.mat']);
        
        frp = savedata;
        
        load([maindir,shp(i).Code,'/V_x.mat']);
        
        Vx = savedata;
        
        load([maindir,shp(i).Code,'/V_y.mat']);
        
        Vy = savedata;
        
        
%             if strcmpi(shp(i).Name,'Val44') == 1
%                     stop
%                 end
        
        
        
        for k = 1:length(shp(i).Dates)
            
            line_chx = line_chx + 1;
            
            fprintf(fid,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,',shp(i).Code,shp(i).Project,regexprep(shp(i).Name,',',' '),...
                shp(i).Type,shp(i).Type,shp(i).Type,...
                datestr(shp(i).Dates(k),'yyyy'),...
                datestr(shp(i).Dates(k),'mm'),...
                datestr(shp(i).Dates(k),'dd'),...
                shp(i).Code);
            
            
%             
%             for i = 1:length(shp)
%                 if strcmpi(shp(i).Name,'Val44') == 1
%                     stop
%                 end
%             end
            
            if ~isempty(depth.D)
                hour_array = find(depth.Time > (shp(i).Dates(k)-numhours) & depth.Time <= shp(i).Dates(k));
                hour_array_diag = find(maghsi.Time > (shp(i).Dates(k)-numhours) & maghsi.Time <= shp(i).Dates(k));
                day_array  = find(depth.Time >= (shp(i).Dates(k)-numdays) & depth.Time <= (shp(i).Dates(k)));
                
                thedepth = find(depth.D(:,hour_array) <= shp(i).Depth);
                
                fprintf(fid,'%4.4f,%4.4f,,',sum(area.cell_A),length(area.cell_A));
                
                
                if ~isempty(hour_array)
                    
                    for l = 1:length(hour_array)
                        
                        d_chx =  find(depth.D(:,hour_array(l)) <= shp(i).Depth);
                        
                        if isempty(d_chx)
                            
                            d_chx =  find(depth.D(:,hour_array(l)) <= 10);
                            if isempty(d_chx)
                                stop
                            end
                        end
                        
                        [~,age_ind] = min(abs(age.Time - depth.Time(hour_array(l))));
                        
                        age_top(l) = mean(age.WQ_TRC_AGE.Top(d_chx,age_ind)) * 1/86400;
                        age_bot(l) = mean(age.WQ_TRC_AGE.Bot(d_chx,age_ind)) * 1/86400;
                        
                        [~,sal_ind] = min(abs(sal.Time - depth.Time(hour_array(l))));
                        sal_top(l) = mean(sal.SAL.Top(d_chx,sal_ind));
                        sal_bot(l) = mean(sal.SAL.Bot(d_chx,sal_ind));
                        
                        [~,temp_ind] = min(abs(temp.Time - depth.Time(hour_array(l))));
                        
                        temp_top(l) = mean(temp.TEMP.Top(d_chx,temp_ind));
                        temp_bot(l) = mean(temp.TEMP.Bot(d_chx,temp_ind));
                        
                        [~,oxy_ind] = min(abs(oxy.Time - depth.Time(hour_array(l))));
                        
                        oxy_top(l) = mean(oxy.WQ_OXY_OXY.Top(d_chx,oxy_ind)) * 32/1000;
                        oxy_bot(l) = mean(oxy.WQ_OXY_OXY.Bot(d_chx,oxy_ind)) * 32/1000;
                        
                        [~,amm_ind] = min(abs(amm.Time - depth.Time(hour_array(l))));
                        
                        amm_top(l) = mean(amm.WQ_NIT_AMM.Top(d_chx,amm_ind)) * 14/1000;
                        amm_bot(l) = mean(amm.WQ_NIT_AMM.Bot(d_chx,amm_ind)) * 14/1000;
                        
                        sal_strat(l) = sal_bot(l) - sal_top(l);
                        
                        
                        % Area calcs - replace with total area....
                        sss = find((sal.SAL.Bot(d_chx,sal_ind) - sal.SAL.Top(d_chx,sal_ind)) > 6);
                        
                        
                        if ~isempty(sss)
                            strat_area(l) = sum(area.cell_A(d_chx(sss)));
                            
                        else
                            strat_area(l) = 0;
                        end
                        strat_total(l) = sum(area.cell_A(d_chx));
                        
                        ttt = find((oxy.WQ_OXY_OXY.Bot(d_chx,oxy_ind)* 32/1000) < 2);
                        if ~isempty(ttt)
                            hypox_area(l) = sum(area.cell_A(d_chx(ttt)));
                            
                        else
                            hypox_area(l) = 0;
                        end
                        hypox_total(l) = sum(area.cell_A(d_chx));
                        
                        uuu = find((oxy.WQ_OXY_OXY.Bot(d_chx,oxy_ind)* 32/1000) < 4);
                        if ~isempty(uuu)
                            lowoxygen_area(l) = sum(area.cell_A(d_chx(uuu)));
                            
                        else
                            lowoxygen_area(l) = 0;
                        end
                        lowoxygen_total(l) = sum(area.cell_A(d_chx));
                        
                        
                    end
                    
                    max_tchla = max(tchla.WQ_DIAG_PHY_TPHYS.Top(d_chx,hour_array_diag),tchla.WQ_DIAG_PHY_TPHYS.Bot(d_chx,hour_array_diag));
                    
                    
                    fprintf(fid,'%4.4f,%4.4f,',mean(age_top),mean(age_bot));
                    fprintf(fid,'%4.4f,%4.4f,',mean(sal_top),mean(sal_bot));
                    fprintf(fid,'%4.4f,%4.4f,',mean(temp_top),mean(temp_bot));
                    fprintf(fid,'%4.4f,%4.4f,',mean(oxy_top),mean(oxy_bot));
                    fprintf(fid,'%4.4f,%4.4f,',mean(amm_top),mean(amm_bot));
                    fprintf(fid,'%4.4f,',max(max_tchla(:)));% CHLA Holding place
                    
                    fprintf(fid,'%4.4f,',mean(sal_strat));
                    
                    %                     fprintf(fid,'%4.4f,',sum(strat_area));
                    %                     fprintf(fid,'%4.4f,',sum(hypox_area));
                    
                    fprintf(fid,'%4.4f,',(sum(strat_area) / sum(strat_total)*100));
                    fprintf(fid,'%4.4f,',(sum(lowoxygen_area) / sum(lowoxygen_total)*100));
                    fprintf(fid,'%4.4f,',(sum(hypox_area) / sum(hypox_total)*100));
                    
                    
                    
                    for l = 1:length(day_array)
                        [~,temp_ind] = min(abs(temp.Time - depth.Time(day_array(l))));
                        
                        temp_top_days(l) = mean(temp.TEMP.Top(d_chx,temp_ind));
                        
                        [~,sal_ind] = min(abs(sal.Time - depth.Time(day_array(l))));
                        sal_strat_days(l) = mean(sal.SAL.Bot(d_chx,sal_ind) - sal.SAL.Top(d_chx,sal_ind));
                        
                        [~,oxy_ind] = min(abs(oxy.Time - depth.Time(day_array(l))));
                        oxy_bot_days(l) = mean(oxy.WQ_OXY_OXY.Bot(d_chx,oxy_ind) * 32/1000);
                        
                        
                        [~,amm_ind] = min(abs(amm.Time - depth.Time(day_array(l))));
                        [~,diag_ind] = min(abs(maghsi.Time - depth.Time(day_array(l))));
                        
                        mag_bot_days(l) = mean(maghsi.WQ_DIAG_PHY_MPB.Bot(d_chx,diag_ind));
                        
                        %%% Calc HAB (Carp) CYANO
                        hab(l) = calc_hab(Vx.V_x.Bot(d_chx,day_array(l)),Vy.V_y.Bot(d_chx,day_array(l)),...
                            temp.TEMP.Top(d_chx,temp_ind),temp.TEMP.Bot(d_chx,temp_ind),...
                            sal.SAL.Top(d_chx,sal_ind),sal.SAL.Bot(d_chx,sal_ind),...
                            amm.WQ_NIT_AMM.Bot(d_chx,amm_ind),nit.WQ_NIT_NIT.Bot(d_chx,amm_ind),...
                            frp.WQ_PHS_FRP.Bot(d_chx,amm_ind),0);
                        
                        %DINO
                        hab2(l) = calc_hab(Vx.V_x.Bot(d_chx,day_array(l)),Vy.V_y.Bot(d_chx,day_array(l)),...
                            temp.TEMP.Top(d_chx,temp_ind),temp.TEMP.Bot(d_chx,temp_ind),...
                            sal.SAL.Top(d_chx,sal_ind),sal.SAL.Bot(d_chx,sal_ind),...
                            amm.WQ_NIT_AMM.Bot(d_chx,amm_ind),nit.WQ_NIT_NIT.Bot(d_chx,amm_ind),...
                            frp.WQ_PHS_FRP.Bot(d_chx,amm_ind),1);
                        
                        %%% WQI Catherines
                        wqi(l) = calc_hsi(oxy.WQ_OXY_OXY.Bot(d_chx,oxy_ind),tchla.WQ_DIAG_PHY_TPHYS.Top(d_chx,diag_ind),...
                            max(tn.WQ_DIAG_TOT_TN.Bot(d_chx,diag_ind),tn.WQ_DIAG_TOT_TN.Top(d_chx,diag_ind)),...
                            max(tp.WQ_DIAG_TOT_TP.Bot(d_chx,diag_ind),tp.WQ_DIAG_TOT_TP.Top(d_chx,diag_ind)));
                        
                        
                        
                    end
                    
                    fprintf(fid,'%4.4f,',mean(temp_top_days));
                    fprintf(fid,'%4.4f,',max(temp_top_days));
                    
                    num_ts_strat = length(find(sal_strat_days > 6));
                    
                    num_days_strat = num_ts_strat * (sal.Time(2) - sal.Time(1));%model_time_interval;
                    
                    num_ts_lowoxy = length(find(oxy_bot_days <  4));
                    num_days_lowoxy = num_ts_lowoxy * (oxy.Time(2) - oxy.Time(1));% model_time_interval;
                    
                    
                    num_ts_oxy = length(find(oxy_bot_days <  2));
                    num_days_oxy = num_ts_oxy *(oxy.Time(2) - oxy.Time(1));%model_time_interval;
                    
                    num_ts_oxy2 = length(find(oxy_bot_days <  0.5));
                    num_days_oxy2 = num_ts_oxy2 * (oxy.Time(2) - oxy.Time(1));%model_time_interval;
                    
                    fprintf(fid,'%4.4f,',num_days_strat);
                    fprintf(fid,'%4.4f,',num_days_lowoxy);
                    fprintf(fid,'%4.4f,',num_days_oxy);
                    fprintf(fid,'%4.4f,',num_days_oxy2);
                    
                    fprintf(fid,'%4.4f,',mean(hab));
                    fprintf(fid,'%4.4f,',mean(hab2));
                    fprintf(fid,'%4.4f,',mean(mag_bot_days));
                    fprintf(fid,'%4.4f,',mean(wqi));
                    
                    clear wqi mag_bot_days hab oxy_bot_days oxy_bot_days sal_strat_days temp_top_days hypox_area strat_area strat_total hypox_total hab2 lowoxygen_area lowoxygen_total;
                    clear amm_top amm_bot sal_top sal_bot temp_top temp_bot oxy_top oxy_bot age_top age_bot;
                end
                
                % fprintf(fid,',Depth Issues');
            end
            fprintf(fid,'\n');
            
            
            
        end
    end
    
    fclose(fid);
    
    
    
    
end

join_spreadasheets;