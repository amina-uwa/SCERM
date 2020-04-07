clear all; close all;

load swan.mat;

theSearch = [-7 7];

sites =fieldnames(swan);

filled = [];
raw = [];

datearray = [datenum(1970,01,01):01:datenum(2019,11,01)];

var = 'WQ_DIAG_TOT_TN';

for i = 1:length(sites)
    
    if isfield(swan.(sites{i}),var) == 1
        
        disp(sites{i});
        
        filled.(sites{i}).mdate(:,1) = datearray;
        filled.(sites{i}).(var)(1:length(datearray),1) = NaN;
        
        raw.(sites{i}).mdate(:,1) = datearray;
        raw.(sites{i}).(var)(1:length(datearray),1) = NaN;
        
        
        for j = 1:length(datearray)
            
            %Search for data on that day
            ss = find(floor(swan.(sites{i}).(var).Date) == datearray(j));
            
            if ~isempty(ss)
                filled.(sites{i}).(var)(j,1) = swan.(sites{i}).(var).Data(ss(1));
                raw.(sites{i}).(var)(j,1) = swan.(sites{i}).(var).Data(ss(1));
            else
                sss = find(floor(swan.(sites{i}).(var).Date) >= (datearray(j) + theSearch(1)) & ...
                    floor(swan.(sites{i}).(var).Date) <= (datearray(j) + theSearch(2)));
                
                if ~isempty(sss)
                    filled.(sites{i}).(var)(j,1) = mean(swan.(sites{i}).(var).Data(sss));
                end
            end
        end
    end
end
                
        
sites = fieldnames(filled);
fid1 = fopen('Filled_TN.csv','wt');
fid2 = fopen('Raw_TN.csv','wt');

fprintf(fid1,'Date,');
fprintf(fid2,'Date,');

for i = 1:length(sites)
    fprintf(fid1,'%s,',sites{i});
    fprintf(fid2,'%s,',sites{i});
end
fprintf(fid1,'\n');
fprintf(fid2,'\n');

for i = 1:length(datearray)
    fprintf(fid1,'%s,',datestr(datearray(i),'dd/mm/yyyy'));
    fprintf(fid2,'%s,',datestr(datearray(i),'dd/mm/yyyy'));
    for j = 1:length(sites)
        if ~isnan(filled.(sites{j}).(var)(i))
            fprintf(fid1,'%4.4f,',filled.(sites{j}).(var)(i));
        else
            fprintf(fid1,',');
        end
        
        if ~isnan(raw.(sites{j}).(var)(i))
            fprintf(fid2,'%4.4f,',raw.(sites{j}).(var)(i));
        else
            fprintf(fid2,',');
        end
    end
    fprintf(fid1,'\n');
    fprintf(fid2,'\n');
end
fclose(fid1);
fclose(fid2);
        
        




        
        
        
        
        
        


