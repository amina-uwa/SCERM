clear all; close all;

addpath(genpath('functions'));

sdatearray = datenum(2007:01:2018,03,15);
%sdatearray = datenum(2017,03,15);
% Rsdatearray = datenum(2017,11,01);
for bdb = 1:length(sdatearray)
    
    
    sdate = sdatearray(bdb);%datenum(2018,05,01);
    
    
    IC = create_IC_matfile(sdate);
    
    grid = 'Swan_Canning_v3_001_Seagrass_Fremantle_NS_v3_BC.2dm';
    
    [XX,YY,nodeID,faces,X,Y,ID] = tfv_get_node_from_2dm(grid);
    
    
    outdir = ['Images/',datestr(sdate,'yyyymmdd'),'/'];;
    
    if ~exist(outdir)
        mkdir(outdir);
    end
    
    headers = {...
        'H',...
        'U',...
        'V',...
        'Sal',...
        'Temp',...
        'TRACE_1',...
        'AGE',...
        'SS1',...
        'SS2',...
        'Oxy',...
        'Sil',...
        'Amm',...
        'Nit',...
        'FRP',...
        'FRP_ADS',...
        'DOC',...
        'POC',...
        'DON',...
        'PON',...
        'DOP',...
        'POP',...
        'DOCR',...
        'DONR',...
        'DOPR',...
        'CPOM',...
        'GRN',...
        'BGA',...
        'CRYPT',...
        'DIATOM',...
        'DINO',...
        'DINO_IN',...
        };
    %   'GRN',...
    %         'CRYPT',...
    %         'DIATOM',...
    %         'DINO',...
    %         'DINO_IN',...
    %         'BGA',...
    %         'BGA_RHO',...
    %         'BGA_IN',...
    %         'BGA_IP',...
    headers_write = {...
        'WL',...
        'U',...
        'V',...
        'Sal',...
        'Temp',...
        'TRACE_1',...
        'WQ_1',...
        'WQ_2',...
        'WQ_3',...
        'WQ_4',...
        'WQ_5',...
        'WQ_6',...
        'WQ_7',...
        'WQ_8',...
        'WQ_9',...
        'WQ_10',...
        'WQ_11',...
        'WQ_12',...
        'WQ_13',...
        'WQ_14',...
        'WQ_15',...
        'WQ_16',...
        'WQ_17',...
        'WQ_18',...
        'WQ_19',...
        'WQ_20',...
        'WQ_21',...
        'WQ_22',...
        'WQ_23',...
        'WQ_24',...
        'WQ_25',...
        };
    
    % headers = {...
    %     'H',...
    %     'U',...
    %     'V',...
    %     'Sal',...
    %     'Temp',...
    %     'TRACE_1',...
    %     'SS1',...
    %     'RET',...
    %     'Oxy',...
    %     'Sil',...
    %     'Amm',...
    %     'Nit',...
    %     'FRP',...
    %     'FRP_ADS',...
    %     'DOC',...
    %     'POC',...
    %     'DON',...
    %     'PON',...
    %     'DOP',...
    %     'POP',...
    %     'GRN',...
    %     'BGA',...
    %     'FDIAT',...
    %     'MDIAT',...
    %     'KARLO',...
    %     };
    %
    % headers_write = {...
    %     'WL',...
    %     'U',...
    %     'V',...
    %     'Sal',...
    %     'Temp',...
    %     'TRACE_1',...
    %     'WQ_1',...
    %     'WQ_2',...
    %     'WQ_3',...
    %     'WQ_4',...
    %     'WQ_5',...
    %     'WQ_6',...
    %     'WQ_7',...
    %     'WQ_8',...
    %     'WQ_9',...
    %     'WQ_10',...
    %     'WQ_11',...
    %     'WQ_12',...
    %     'WQ_13',...
    %     'WQ_14',...
    %     'WQ_15',...
    %     'WQ_16',...
    %     'WQ_17',...
    %     'WQ_18',...
    %     'WQ_19',...
    %     };
    
    
    
    
    
    sites = fieldnames(IC);
    
    for i = 1:length(headers)
        
        data.(headers{i}).Data = [];
        data.(headers{i}).X = [];
        data.(headers{i}).Y = [];
        
        inc = 1;
        
        for j = 1:length(sites)
            
            if isfield(IC.(sites{j}),headers{i})
                
                ss = find(IC.(sites{j}).(headers{i}).Date == sdate);
                
                if ~isempty(ss)
                    
                    data.(headers{i}).Data(inc,1) = IC.(sites{j}).(headers{i}).Data(ss(1));
                    data.(headers{i}).X(inc,1) = IC.(sites{j}).(headers{i}).X;
                    data.(headers{i}).Y(inc,1) = IC.(sites{j}).(headers{i}).Y;
                    
                    inc = inc + 1;
                    
                end
            end
        end
        disp(headers{i});
        if length(data.(headers{i}).X) > 3
            F = scatteredInterpolant(data.(headers{i}).X,data.(headers{i}).Y,data.(headers{i}).Data,'linear','nearest');
            
            interp.(headers{i}) = F(X,Y);
        else
            interp.(headers{i})(1:length(ID)) = 0;
        end
        
        tfv_plot_init_condition(XX,YY,faces',interp.(headers{i}),[outdir,headers{i},'.png'],headers{i})
        
        
    end
    
    disp('Writing the file.....');
    fid = fopen(['IC_AED2_',datestr(sdate,'yyyymmdd'),'.csv'],'wt');
    fprintf(fid,'ID,');
    for i = 1:length(headers_write)
        if i == length(headers_write)
            fprintf(fid,'%s\n',headers_write{i});
        else
            fprintf(fid,'%s,',headers_write{i});
        end
    end
    
    for j = 1:length(ID)
        fprintf(fid,'%d,',ID(j));
        for i = 1:length(headers)
            
            if i == length(headers)
                fprintf(fid,'%4.4f\n',interp.(headers{i})(j));
            else
                fprintf(fid,'%4.4f,',interp.(headers{i})(j));
            end
        end
    end
    
    fclose(fid);
    
    
end
