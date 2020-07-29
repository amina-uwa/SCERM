clear all; close all;

load data.mat;

datearray = datenum(2008,01:01:124,01);


vars = {...
    'TN',...
    'TP',...
    'Oxy',...
    'TCHLA',...
    'SAL',...
    };

type = {'Surface';'Bottom'};

sims = fieldnames(data);

zones = fieldnames(data.(sims{1}));

simdata = [];


for i = 1:length(vars)
    
    disp(vars{i})
    
    fid = fopen(['Simulation_Monthly_Mean_',vars{i},'_v2.csv'],'wt');
    for k = 1:length(zones)
        for j = 1:length(type)
            
            
            
            fprintf(fid,'%s,%s\n',zones{k},type{j});
            
            fprintf(fid,'Simulations,');
            
            for l = 1:length(datearray)
                fprintf(fid,'%s,',datestr(datearray(l),'mm/yyyy'));
            end
            fprintf(fid,'\n');
            
            for l = 1:length(sims)
                
                fprintf(fid,'%s,',sims{l});
                
                mv = datevec(data.(sims{l}).(zones{k}).(vars{i}).(type{j}).Date);
                
                for m = 1:length(datearray)
                    
                    dv = datevec(datearray(m));
                    
                    sss = find(mv(:,1) == dv(:,1) & ...
                        mv(:,2) == dv(:,2));
                    themean = [];
                    if ~isempty(sss)
                        
                        themean = mean(data.(sims{l}).(zones{k}).(vars{i}).(type{j}).Mean(sss));
                    end
                    
                    if ~isempty(themean)
                        fprintf(fid,'%4.4f,',themean);
                        simdata.(sims{l}).(zones{k}).(vars{i}).(type{j})(m) = themean;
                    else
                        fprintf(fid,',');
                        simdata.(sims{l}).(zones{k}).(vars{i}).(type{j})(m) = NaN;
                    end
                    
                    
                    
                end
                fprintf(fid,'\n');
            end
            fprintf(fid,'\n');
            fprintf(fid,'\n');
        end
        fprintf(fid,'\n');
        fprintf(fid,'\n');
    end
    fclose(fid);
end
save simdata.mat simdata -mat;







