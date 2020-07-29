clear all; close all;

load Load.mat;

shp = shaperead('../modeltools/gis/swan_erz_only.shp');

datearray = datenum(2008,01:01:124,01);


vars = {...
    'ML',...
    'TN_kg',...
    'TP_kg',...
    'OXY_kg',...
    };

nvars = {...
    'ML',...
    'TN',...
    'TP',...
    'OXY',...
    };

zonel.Zone1.Upstream = [1];
zonel.Zone1.Downstream = [2:1:12];

zonel.Zone2.Upstream = [1 2];
zonel.Zone2.Downstream = [3:1:12];

zonel.Zone3.Upstream = [1:3];
zonel.Zone3.Downstream = [4:1:12];

zonel.Zone4.Upstream = [1:4];
zonel.Zone4.Downstream = [5:1:12];

zonel.Zone5.Upstream = [1:5];
zonel.Zone5.Downstream = [6:1:12];

zonel.Zone6.Upstream = [6];
zonel.Zone6.Downstream = [1:5 7:12];

zonel.Zone7.Upstream = [6 7];
zonel.Zone7.Downstream = [1:5 8:12];

zonel.Zone8.Upstream = [6:8];
zonel.Zone8.Downstream = [1:5 9:12];

zonel.Zone9.Upstream = [1:9];
zonel.Zone9.Downstream = [10:12];

zonel.Zone10.Upstream = [1:10];
zonel.Zone10.Downstream = [11:12];

zonel.Zone11.Upstream = [1:11];
zonel.Zone11.Downstream = [12];

zonel.Zone12.Upstream = [1:12];
zonel.Zone12.Downstream = [];


for i = 1:length(shp)
    zones(i) = {['Zone',num2str(i)]};
end

scen_list = fieldnames(Load);


for i = 1:length(vars)
    
    disp(vars{i})
    
    fid = fopen(['BC_Monthly_Mean_',vars{i},'_v2.csv'],'wt');
    
    for k = 1:length(zones)
        
        for bb = 1:length(shp)
            if strcmpi(zones{k},shp(bb).Name) == 1
                X = shp(bb).X;
                Y = shp(bb).Y;
            end
        end
        
        fprintf(fid,'%s\n',zones{k});
        
        fprintf(fid,'Scenario,Type,');
        
        for l = 1:length(datearray)
            fprintf(fid,'%s,',datestr(datearray(l),'mm/yyyy'));
        end
        fprintf(fid,'\n');
        for l = 1:length(scen_list)
            local_array = [];
            total_array = [];
            for j = 1:length(datearray)
                dv = datevec(datearray(j));
                
                
                thefiles = fieldnames(Load.(scen_list{l}));
                
                local = 0;
                total = 0;
                
                for m = 1:length(thefiles)
                    
                    mv = datevec(Load.(scen_list{l}).(thefiles{m}).Date);
                    
                    sss = find(mv(:,1) == dv(:,1) & ...
                        mv(:,2) == dv(:,2));
                    
                    thedata =  sum(Load.(scen_list{l}).(thefiles{m}).(vars{i})(sss));
                    if inpolygon(Load.(scen_list{l}).(thefiles{m}).X,Load.(scen_list{l}).(thefiles{m}).Y,X,Y)
                        local = local + thedata;
                    end
                    
                    upstream_ID = zonel.(zones{k}).Upstream;
                    
                    if ~isempty(upstream_ID)
                        for bdb = 1:length(upstream_ID)
                                thezone = ['Zone',num2str(upstream_ID(bdb))];
                                for mj = 1:length(shp)
                                    if strcmpi(shp(mj).Name,thezone)
                                        XX = shp(mj).X;
                                        YY = shp(mj).Y;
                                    end
                                end
                                if inpolygon(Load.(scen_list{l}).(thefiles{m}).X,Load.(scen_list{l}).(thefiles{m}).Y,XX,YY)
                                    total = total + thedata;
                                end
                        end
                    end
                        
                    
                end
                local_array(j) = local;
                total_array(j) = total;
            end
            fprintf(fid,'%s,Local,',scen_list{l});
            for j = 1:length(datearray)
                fprintf(fid,'%4.4f,',local_array(j));
                BC.(scen_list{l}).(zones{k}).(nvars{i}).local(j) = local_array(j);
                
            end
            fprintf(fid,'\n');
            fprintf(fid,'%s,Upstream + Local,',scen_list{l});
            for j = 1:length(datearray)
                fprintf(fid,'%4.4f,',total_array(j));
                BC.(scen_list{l}).(zones{k}).(nvars{i}).Upstream(j) = total_array(j);
            end
            fprintf(fid,'\n');
        end
        fprintf(fid,'\n');
        fprintf(fid,'\n');
    end
    fprintf(fid,'\n');
    fprintf(fid,'\n');
    fclose(fid);
end


save bcdata.mat BC -mat;








