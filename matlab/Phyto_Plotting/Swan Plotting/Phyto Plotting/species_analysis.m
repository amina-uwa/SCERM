clear all; close all;

load swan_bio.mat;

[sNum,sStr] = xlsread('../Data/Import Bio/Conversions/Alice_Headers_20151120.xlsx','A2:F1000');

old_headers = sStr(:,1);
new_headers = sStr(:,2);
group = sStr(:,3);
conv = sNum(:,3);

fid = fopen('Species by Site.csv','wt');
fprintf(fid,'Species over entire dataset\n');
sites = fieldnames(swan_bio);

for i = 1:length(sites)
    
    fprintf(fid,'Sites: %s\n',sites{i});
    
    
    vars = fieldnames(swan_bio.(sites{i}));
    
    ID = [];
    Count = [];
    Mass  =[];
    nGroup = [];
    inc = 1;
    
    for j = 1:length(vars)
        
        ss = find(strcmpi(new_headers,vars{j}) == 1);
        
        if strcmpi(group{ss(1)},'Ignore') == 0
            
            ID{inc} = vars{j};
            nGroup{inc}  = group{ss(1)};
            Count(inc) = sum(swan_bio.(sites{i}).(vars{j}).Cells(~isnan(swan_bio.(sites{i}).(vars{j}).Cells)));
            Mass(inc) = sum(swan_bio.(sites{i}).(vars{j}).Data(~isnan(swan_bio.(sites{i}).(vars{j}).Data)));
            inc = inc + 1;
            
        end
        
    end
    
    [sortCount,ind] = sort(Count,'descend');
    
    sortID = ID(ind);
    
    sortGroup = nGroup(ind);
    
    fprintf(fid,'Cell Count\n');
    
    fprintf(fid,'ID,');
    for iii = 1:10
        fprintf(fid,'%s (%s),',sortID{iii},sortGroup{iii});
    end
    
    fprintf(fid,'\n');
    
    fprintf(fid,'Cell (cell/ml),');
    for iii = 1:10
        fprintf(fid,'%10.5f,',sortCount(iii));
    end
    
    fprintf(fid,'\n');
    
    %______________________________________________________________________
    
    [sortMass,ind] = sort(Mass,'descend');
    
    sortmID = ID(ind);
    
    sortmGroup = nGroup(ind);
    
    fprintf(fid,'Mass\n');
    
    fprintf(fid,'ID,');
    for iii = 1:10
        fprintf(fid,'%s (%s),',sortmID{iii},sortmGroup{iii});
    end
    
    fprintf(fid,'\n');
    
    fprintf(fid,'Mass (ug/ml),');
    for iii = 1:10
        fprintf(fid,'%10.5f,',sortMass(iii));
    end
    
    fprintf(fid,'\n');
    
        fprintf(fid,'\n\n');
        
end

fclose(fid);        
 
