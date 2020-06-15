clear all; close all;



modeldir = 'D:\Cloud\Dropbox\SCERM_Proc_More\';

sX = 385172;
sY = 6457020;

dirlist = dir(modeldir);

Hdata = load('D:\Cloud\Dropbox\SCERM_Proc_More\swan_2015_2016_ALL\H.mat');


outdir = 'Test_output/';

mkdir(outdir);

for i = 3:length(dirlist)
    
    outfile = [outdir,dirlist(i).name,'.csv'];
    
    fid = fopen(outfile,'wt');
    
    fprintf(fid,'Date,Depth (m),Salinity (psu),Temperature (C),Oxygen (mg/L)\n');
    
    data.SAL = load([modeldir,dirlist(i).name,'\SAL.mat']);
    
    data.SAL.savedata.idx2 = Hdata.savedata.idx2;
    data.SAL.savedata.idx3 = Hdata.savedata.idx3;
    
    xX = data.SAL.savedata.X;
    xY = data.SAL.savedata.Y;
    
    dtri = DelaunayTri(double(xX),double(xY));
    
    pt_id = nearestNeighbor(dtri,[sX sY]);
    
    thecells = find(data.SAL.savedata.idx2 == pt_id);
    
    NL = data.SAL.savedata.NL(pt_id);
    NL_s = sum(data.SAL.savedata.NL(1:pt_id-1));
    offset = pt_id;
    spoint = NL_s + offset;
    
    
    
    %___________________________________________________________________
    
    tdata = load([modeldir,dirlist(i).name,'\TEMP.mat']);
    
    data.SAL.savedata.TEMP = tdata.savedata.TEMP; clear tdata;
    
    tdata = load([modeldir,dirlist(i).name,'\WQ_OXY_OXY.mat']);
    
    data.SAL.savedata.WQ_OXY_OXY = tdata.savedata.WQ_OXY_OXY * 32/1000; clear tdata;
    
    %____________________________________________________________________
    
    max_depths = min(data.SAL.savedata.layerface_Z(spoint:spoint + NL-1,:));
    
    depth_array = 0:-0.5:max_depths-1;
    
    for j = 1:length(data.SAL.savedata.Time)
        
        
        thedepths = data.SAL.savedata.layerface_Z(spoint:spoint + NL-1,j);
        thedepths = thedepths - thedepths(1);
        
        for k = 1:length(depth_array)
            [~,ind] = min(abs(thedepths - depth_array(k)));
            
            if depth_array(k) > min(thedepths)
                fprintf(fid,'%s,',datestr(data.SAL.savedata.Time(j),'dd-mm-yyyy HH:MM:SS'));
                fprintf(fid,'%2.2f,%4.4f,%4.4f,%4.4f\n',depth_array(k),...
                    data.SAL.savedata.SAL(thecells(ind),j),...
                    data.SAL.savedata.TEMP(thecells(ind),j),...
                    data.SAL.savedata.WQ_OXY_OXY(thecells(ind),j));
            end
               
        end
    end
    
    fclose(fid);
    
    clear data NL NL_s offset spoint thecells;
end