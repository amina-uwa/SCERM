clear all; close all;


mdate = datenum(2017,03,15);

outdir = 'BCs/Profiles/';


fielddata_matfile = '../../../SCERM/matlab/modeltools/matfiles/swan.mat';
fielddata = 'swan';

grid = 'Swan_Canning_v4_ERZ_seagrass_NS.2dm';

[XX,YY,nodeID,faces,cellX,cellY,cellZ,ID] = tfv_get_node_from_2dm(grid);


boundaryfile = 'swan_boundary.shp';

headers = {...
    'Sal',...
    'Temp',...
    'ones',...
    'zeroes',...
    'TSS',...
    'Oxy',...
    'Sil',...
    'Amm',...
    'Nit',...
    'FRP',...
    'DOC_T',...
    'POC_T',...
    'DON_T',...
    'PON_T',...
    'OP',...
    'CHLA',...
    'TN',...
    'TP',...
    };



include_file = 'initial_profiles.fvc';



%_________________________________________

field = load(fielddata_matfile);
fdata = field.(fielddata);

shp = shaperead(boundaryfile);


sites = fieldnames(fdata);


if ~exist(outdir,'dir')
    mkdir(outdir);
end
fid = fopen(include_file,'wt');
for i = 1:length(sites)
    
    
    
    
    
    vars = fieldnames(fdata.(sites{i}));
    
    X = fdata.(sites{i}).(vars{1}).X;
    Y = fdata.(sites{i}).(vars{1}).Y;
    
    if inpolygon(X,Y,shp.X,shp.Y)
        
        [isfile,prof] =  process_site_profile(fdata,mdate,sites{i},headers,outdir);
        
        if isfile == 1
            
            
            outdata.(sites{i}).prof = prof;
            outdata.(sites{i}).X = X;
            outdata.(sites{i}).Y = Y;
            
            fprintf(fid,'bc == CP,%10.4f,%10.4f,%s\n',X,Y,['../',outdir,'initial_profile_',sites{i},'.csv']);
            fprintf(fid,'bc header ==  Depth,Sal,Temp,zeroes,zeroes,TSS,TSS,Oxy,Sil,Amm,Nit,FRP,FRP,DOC_T,POC_T,DON_T,PON_T,OP,OP,DOC_T,DON_T,OP,POC_T,CHLA,CHLA,CHLA,CHLA,CHLA,CHLA\n');
            fprintf(fid,'bc scale == 1,1,1,1,1,0.3,0.7,1,1,1,1,1,0.1,0.1,0.5,0.1,1,0.3,0.5,0.9,0.1,0.2,0.5,0.625,0.417,0.417,0.625,2.083,0.00754717\n');
            fprintf(fid,'end bc\n');
            fprintf(fid,'\n');
            
        end
        
    end
end

mkdir('BCs/Profiles_All/');

sites = fieldnames(outdata);

for i = 1:length(sites)
    names(i) = sites(i);
    pX(i,1) = outdata.(sites{i}).X;
    pY(i,1) = outdata.(sites{i}).Y;
end

dtri = DelaunayTri(pX,pY);

pt_id = nearestNeighbor(dtri,[cellX cellY]);

fid2 = fopen('include_profiles_all.fvc','wt');

for ii = 1:10:length(cellX)
    
    prof = outdata.(sites{pt_id(ii)}).prof;
    if cellZ(ii) < 0
         thedepths(2) = cellZ(ii)*-1;
    end
    
    fid = fopen(['BCs/Profiles_All/initial_profile_',num2str(ii),'.csv'],'wt');
        
        fprintf(fid,'Depth,');
        
        for i = 1:length(headers)
            if i == length(headers)
                fprintf(fid,'%s\n',headers{i});
            else
                fprintf(fid,'%s,',headers{i});
            end
        end
        
        for i = 1:length(thedepths)
            fprintf(fid,'%4.4f,',thedepths(i));
            for j = 1:length(headers)
                if j == length(headers)
                    fprintf(fid,'%4.4f\n',prof.(headers{j})(i));
                else
                    fprintf(fid,'%4.4f,',prof.(headers{j})(i));
                end
            end
        end
        
        fclose(fid);

           fprintf(fid2,'bc == CP,%10.4f,%10.4f,%s\n',cellX(ii),cellY(ii),['../BCs/Profiles_All/initial_profile_',num2str(ii),'.csv']);
            fprintf(fid2,'bc header ==  Depth,Sal,Temp,zeroes,zeroes,TSS,TSS,Oxy,Sil,Amm,Nit,FRP,FRP,DOC_T,POC_T,DON_T,PON_T,OP,OP,DOC_T,DON_T,OP,POC_T,CHLA,CHLA,CHLA,CHLA,CHLA,CHLA\n');
            fprintf(fid2,'bc scale == 1,1,1,1,1,0.3,0.7,1,1,1,1,1,0.1,0.1,0.5,0.1,1,0.3,0.5,0.9,0.1,0.2,0.5,0.625,0.417,0.417,0.625,2.083,0.00754717\n');
            fprintf(fid2,'end bc\n');
            fprintf(fid2,'\n');
end
fclose(fid2);








