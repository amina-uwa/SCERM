clear all; close all;

sites = shaperead('Dolphin_Points.shp');

modeldir = 'D:\Cloud\Dropbox\SCERM_Proc_Dolphin\';

load dolphin_dates.mat;

dirlist = dir(modeldir);

%Hdata = load('D:\Cloud\Dropbox\SCERM_Proc_More\swan_2015_2016_ALL\H.mat');




mvar = 'SAL';

vars = {...
   'H',...
    'V_x',...
    'V_y',...
    'D',...
    'SAL',...
    'TEMP',...
    'WQ_TRC_AGE',...
    'WQ_OXY_OXY',...
    'WQ_PHY_GRN',...
    'WQ_PHY_CRYPT',...
    'WQ_PHY_DIATOM',...
    'WQ_PHY_DINO',...
    'WQ_DIAG_MAC_MAC',...
    'WQ_DIAG_OXY_SED_OXY',...
    'WQ_DIAG_OXY_ATM_OXY_FLUX',...
    'WQ_DIAG_OXY_SAT',...
    'WQ_DIAG_PHY_GPP',...
    'WQ_DIAG_PHY_TPHYS',...
    'WQ_DIAG_PHY_MPB',...
    'WQ_DIAG_PHY_BPP',...
    };


varlabel = {...
    'H (mAHD)',...
    'Vx (m/s)',...
    'Vy (m/s)',...
    'D (m)',...
    'Salinity (psu)',...`
    'Temperature (C)',...
    'Water Age (days)',...
    'Oxygen (mg/L)',...
    'GRN (mmol/m^3)',...
    'CRYPT (mmol/m^3)',...
    'DIATOM (mmol/m^3)',...
    'DINO (mmol/m^3)',...
    'MAC (mmol/m^3)',...
    'Sed Oxy Demand (mmol/m^3)',...
    'Atmos Oxy Flux (mmol/m^3)',...
    'Oxy Sat (%)',...
    'Phy GPP (mmol/m^3)',...
    'TPHYS (mmol/m^3)',...
    'Phy MPB (mmol/m^3)',...
    'Phy BPP (mmol/m^3)',...
    };

varconv = [1 1 1 1 1 1 1/86400 32/1000 1 1 1 1 1 1 1 1 1 1 1 1];

depth_array = [0:-0.25:-20];



for kk = 1:length(sites)
    outdir = ['Test_v1/',sites(kk).Name,'/'];
    
    mkdir(outdir);
    
    sX = sites(kk).X;
    sY = sites(kk).Y;
    
    disp(['Processing site ',sites(kk).Name]);
    
    for i = 3:length(dirlist)
        
        outfile = [outdir,dirlist(i).name,'.csv'];
        
        fid = fopen(outfile,'wt');
        
        fprintf(fid,'Date,Depth (m),');
        
        for bb = 1:length(varlabel)
            fprintf(fid,'%s,',varlabel{bb});
        end
        fprintf(fid,'\n');
        
        data.(mvar) = load([modeldir,dirlist(i).name,'\',mvar,'.mat']);
        
        xX = data.(mvar).savedata.X;
        xY = data.(mvar).savedata.Y;
        
        dtri = DelaunayTri(double(xX),double(xY));
        
        pt_id = nearestNeighbor(dtri,[sX sY]);
        
        thecells = find(data.(mvar).savedata.idx2 == pt_id);
        
        NL = data.(mvar).savedata.NL(pt_id);
        NL_s = sum(data.(mvar).savedata.NL(1:pt_id-1));
        offset = pt_id;
        spoint = NL_s + offset;
        
        
        
        %___________________________________________________________________
        
        for bb = 1:length(vars)
            
            %if strcmpi(vars{bb},mvar) == 0
            
            tdata = load([modeldir,dirlist(i).name,'\',vars{bb},'.mat']);
            if strcmpi(vars{bb},'H') == 0 & strcmpi(vars{bb},'D') == 0
            data.(mvar).savedata.(vars{bb}) = tdata.savedata.(vars{bb})(thecells,:) * varconv(bb); clear tdata;
            else
            data.(mvar).savedata.(vars{bb}) = tdata.savedata.(vars{bb})(pt_id,:) * varconv(bb); clear tdata;
            end
            %end
            
        end
        
        %____________________________________________________________________
        
        %max_depths = min(data.(mvar).savedata.layerface_Z(spoint:spoint + NL-1,:));
        
        
        
        for j = 1:length(data.(mvar).savedata.Time)
            
            [~,time_ind] = min(abs(dolphin_dates - data.(mvar).savedata.Time(j)));
            
            if (dolphin_dates(time_ind) - data.(mvar).savedata.Time(j)) < 2/24
            
            
            
            thedepths = data.(mvar).savedata.layerface_Z(spoint:spoint + NL-1,j);
            thedepths = thedepths - thedepths(1);
            
            the = find(depth_array >= min(thedepths));
            
            
            
            for k = 1:2%length(the)
                fprintf(fid,'%s,',datestr(data.(mvar).savedata.Time(j),'dd-mm-yyyy HH:MM:SS'));
                if k == 1
                    fprintf(fid,'0,');
                else
                    fprintf(fid,'%2.2f,',data.(mvar).savedata.D(j) * -1);
                end
                for bb = 1:length(vars)
                    if k == 1
                        thevals(k) = data.(mvar).savedata.(vars{bb})(1,j);
                    else
                        thevals(k) = data.(mvar).savedata.(vars{bb})(end,j);
                    end
                    fprintf(fid,'%4.4f,',thevals(k));%data.(mvar).savedata.(vars{bb})(k,j));
                end
                fprintf(fid,'\n');
            end
                        
            end
        end
        
        fclose(fid);
        
        clear data NL NL_s offset spoint thecells;
    end
    
end