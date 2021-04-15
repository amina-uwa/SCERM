clear all; close all;

sites = shaperead('SCAA_points.shp');

modeldir = 'D:\Cloud\Dropbox\SCERM_Proc_More\';



dirlist = dir(modeldir);

%Hdata = load('D:\Cloud\Dropbox\SCERM_Proc_More\swan_2015_2016_ALL\H.mat');




mvar = 'SAL';

vars = {...
    'H',...
    'V_x',...
    'V_y',...
    'SAL',...
    'TEMP',...
    'WQ_OXY_OXY',...
    'WQ_DIAG_OXY_SAT',...
    'WQ_DIAG_TOT_TSS',...
    'WQ_DIAG_TOT_TURBIDITY',...
    'WQ_DIAG_TOT_LIGHT',...
    'WQ_DIAG_TOT_PAR',...
    };


varlabel = {...
    'H (mAHD)',...
    'Vx (m/s)',...
    'Vy (m/s)',...
    'Salinity (psu)',...
    'Temperature (C)',...
    'Oxygen (mg/L)',...
    'Oxygen Saturation (%)',...
    'TSS (mg/L)',...
    'Turbidity (NTU)',...
    'Light (W/m2)',...
    'PAR (W/m2)',...
    };

varconv = [1 1 1 1 1 32/1000 1 1 1 1 1];

depth_array = [0:-0.5:-20];



for kk = 1:length(sites)
    outdir = ['Raw_Files_3/',sites(kk).Name,'/'];
    
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
            
            data.(mvar).savedata.(vars{bb}) = tdata.savedata.(vars{bb})(thecells,:) * varconv(bb); clear tdata;
            %end
            
        end
        
        %____________________________________________________________________
        
        %max_depths = min(data.(mvar).savedata.layerface_Z(spoint:spoint + NL-1,:));
        
        
        
        for j = 1:length(data.(mvar).savedata.Time)
            
            
            thedepths = data.(mvar).savedata.layerface_Z(spoint:spoint + NL-1,j);
            thedepths = thedepths - thedepths(1);
            
            the = find(depth_array >= min(thedepths));
            
            
            
            for k = 1:length(the)
                fprintf(fid,'%s,',datestr(data.(mvar).savedata.Time(j),'dd-mm-yyyy HH:MM:SS'));
                fprintf(fid,'%2.2f,',depth_array(the(k)));
                for bb = 1:length(vars)
                    thevals = interp1(thedepths,data.(mvar).savedata.(vars{bb})(:,j),depth_array(the));
                    fprintf(fid,'%4.4f,',thevals(k));%data.(mvar).savedata.(vars{bb})(k,j));
                end
                fprintf(fid,'\n');
            end
            
            
            %             for k = 1:length(depth_array)
            %                 [~,ind] = min(abs(thedepths - depth_array(k)));
            %
            %                 if depth_array(k) > min(thedepths)
            %                     fprintf(fid,'%s,',datestr(data.(mvar).savedata.Time(j),'dd-mm-yyyy HH:MM:SS'));
            %                     fprintf(fid,'%2.2f,',depth_array(k));
            %                     for bb = 1:length(vars)
            %                         fprintf(fid,'%4.4f,',data.(mvar).savedata.(vars{bb})(ind,j));
            %                     end
            %                     fprintf(fid,'\n');
            %
            %                 end
            %
            %             end
        end
        
        fclose(fid);
        
        clear data NL NL_s offset spoint thecells;
    end
    
end