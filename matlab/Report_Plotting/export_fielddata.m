clear all; close all;

load ../modeltools/matfiles/swan.mat;

shp = shaperead('../modeltools/gis/swan_erz_only.shp');

datearray = datenum(2008,01:01:124,01);


vars = {...
    'WQ_DIAG_TOT_TN',...
    'WQ_DIAG_TOT_TP',...
    'WQ_OXY_OXY',...
    'WQ_DIAG_PHY_TCHLA',...
    'SAL',...
    'TEMP',...
    };

nvars = {...
    'TN',...
    'TP',...
    'Oxy',...
    'TCHLA',...
    'SAL',...
    'TEMP',...
    };


conv = [14/1000 31/1000 32/1000 1 1 1];

type = {'Surface';'Bottom'};

for i = 1:length(shp)
    zones(i) = {['Zone',num2str(i)]};
end

sites = fieldnames(swan);

killswitch = 0;

for i = 1:length(vars)
    
    disp(vars{i})
    
    fid = fopen(['Field_Monthly_Mean_',vars{i},'.csv'],'wt');
    
    for k = 1:length(zones)
        
        for bb = 1:length(shp)
            if strcmpi(zones{k},shp(bb).Name) == 1
                X = shp(bb).X;
                Y = shp(bb).Y;
            end
        end
        
        for j = 1:length(type)
            fprintf(fid,'%s,%s\n',zones{k},type{j});
            
            fprintf(fid,'Fielddata,');
            
            for l = 1:length(datearray)
                fprintf(fid,'%s,',datestr(datearray(l),'mm/yyyy'));
            end
            fprintf(fid,'\n');
            
            field.(nvars{i}).(zones{k}).(type{j})(1:length(datearray)) = NaN;
            siteint = 1;
            sitei = [];
            for bb = 1:length(sites)
                accum(1:length(datearray)) = NaN;
                if isfield(swan.(sites{bb}),vars{i})
                    
                    XX = swan.(sites{bb}).(vars{i}).X;
                    YY = swan.(sites{bb}).(vars{i}).Y;
                    if inpolygon(XX,YY,X,Y)
                        fprintf(fid,'%s,',sites{bb});
                        
                        xdata = swan.(sites{bb}).(vars{i}).Date;
                        mv = datevec(xdata);
                        ydata = swan.(sites{bb}).(vars{i}).Data;
                        zdata = swan.(sites{bb}).(vars{i}).Depth;
                        
                        for m = 1:length(datearray)
                            %accum(1:length(datearray)) = NaN;
                            dv = datevec(datearray(m));
                            
                            sss = find(mv(:,1) == dv(:,1) & ...
                                mv(:,2) == dv(:,2));
                            themean = [];
                            int = 1;
                            if ~isempty(sss)
                                
                                switch type{j}
                                    case 'Surface'
                                        ttt = find(zdata(sss) > -1);
                                        if ~isempty(ttt)
                                            themean = mean(ydata(sss(ttt)));
                                            accum(m) = themean;
                                        end
                                    case 'Bottom'
                                        
                                        mindepth = min(zdata(sss));
                                        thechx = mindepth + 1;
                                        %                                         if mindepth > -3
                                        %                                             thechx = -1;
                                        %                                         else
                                        %                                             thechx = -2;
                                        %                                         end
                                        
                                        
                                        ttt = find(zdata(sss) < thechx);
                                        if ~isempty(ttt)
                                            themean = mean(ydata(sss(ttt)));
                                            accum(m) = themean;
                                            killswitch = 1;
                                            
                                        end
                                    otherwise
                                end
                            end
                            
                            if ~isempty(themean)
                                fprintf(fid,'%4.4f,',themean * conv(i));
                            else
                                fprintf(fid,',');
                                
                            end
                        end
                        fprintf(fid,'\n');
                    end
                end
                
                
                
                if sum(~isnan(accum)) > 0
                    sitei(siteint).accum = accum;siteint = siteint + 1;
                end
                
            end
            
%             if killswitch
%                 stop
%             end
            
            
            if ~isempty(sitei)
                for nb = 1:length(datearray)
                    for mb = 1:length(sitei)
                        
                        thedata(mb) = sitei(mb).accum(nb);
                        
                    end
                    
                    ttt = find(~isnan(thedata) == 1);
                    if ~isempty(ttt)
                        mdat = mean(thedata(ttt));
                        
                        field.(nvars{i}).(zones{k}).(type{j})(nb) = mdat * conv(i);
                        
                    end
                end
            end
            
            %               accum(int) = themean;int = int + 1;
            
            %             accum = accum * conv(i);
            %             ttt = find(~isnan(accum) == 1);
            %             field.(nvars{i}).(zones{k}).(type{j})(m) = mean(accum(ttt));
            %             field.(nvars{i}).(zones{k}).(type{j})(m) = NaN;
            %              field.(nvars{i}).(zones{k}).(type{j})(m) = NaN;
            fprintf(fid,'\n');
            fprintf(fid,'\n');
        end
        fprintf(fid,'\n');
        fprintf(fid,'\n');
    end
    fclose(fid);
end
save fielddata.mat field -mat;








