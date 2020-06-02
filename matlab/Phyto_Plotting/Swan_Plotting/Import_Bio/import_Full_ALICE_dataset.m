clear all; close all;

filename = 'Alice_Data/20110728_Swan River Master Data_ all data P1 to P3-1.xlsx';

sheetname = 'P3 FCM Micro';

[~,headers] = xlsread(filename,sheetname,'A1:ZZ1');

[~,sDate] = xlsread(filename,sheetname,'B2:B10000');
[nDepth,~] = xlsread(filename,sheetname,'F2:F10000');
[~,sSite] = xlsread(filename,sheetname,'A2:A10000');

[data,~] = xlsread(filename,sheetname,'H2:ES289');

[sNum,sStr] = xlsread('Conversions/Alice_Headers_20151120.xlsx','A2:F1000');

old_headers = sStr(:,1);
new_headers = sStr(:,2);
group = sStr(:,3);
conv = sNum(:,3);




% [conv_num,conv_str] = xlsread('Alice_Data\Carbon Calculations species_master_Dec08_Nov09.xlsx','biovol and C','A2:H200');
% 
% spc_name = conv_str(:,2);
% spc_conv= conv_num(:,end);


u_sites = unique(sSite);

swan_bio = [];

for i = 1:length(u_sites);
    
    ss = find(strcmpi(sSite,u_sites{i}) == 1);
    
    for j = 1:length(new_headers)
        
%         sss = find(strcmpi(spc_name,new_headers{j})==1);
%         
%         if ~isempty(sss)
%             disp(['Converting the ugC/ml for:',new_headers{j}]);
%         
%             swan_bio.(u_sites{i}).(new_headers{j}).Data = data(ss,j) * spc_conv(sss);
%             swan_bio.(u_sites{i}).(new_headers{j}).Date = datenum(sDate(ss),'dd/mm/yyyy');
%             swan_bio.(u_sites{i}).(new_headers{j}).Depth = nDepth(ss);
%             
%         else
            
            disp(['Conversion for ',u_sites{i},':',new_headers{j},' == ',num2str(conv(j))]);
            swan_bio.(u_sites{i}).(new_headers{j}).Data = data(ss,j) * conv(j);
            swan_bio.(u_sites{i}).(new_headers{j}).Cells = data(ss,j);
            swan_bio.(u_sites{i}).(new_headers{j}).Date = datenum(sDate(ss),'dd/mm/yyyy');
            swan_bio.(u_sites{i}).(new_headers{j}).Depth = nDepth(ss);
            swan_bio.(u_sites{i}).(new_headers{j}).OldName = old_headers{j};
            
%         end
    end
    
end



swan_group = [];

sites = fieldnames(swan_bio);

u_groups = unique(group);

for m = 1:length(sites)
    
    for i = 1:length(u_groups)
        if strcmpi(u_groups{i},'Ignore')==0
            ss = find(strcmpi(group,u_groups{i}) == 1);
            
            var_group = new_headers(ss);
            
            tdata = [];
            tdate = [];
            tdepth = [];
            
            for j = 1:length(var_group)
                
                if isfield(swan_bio.(sites{m}),var_group{j})
                    
                    tdata = [tdata;swan_bio.(sites{m}).(var_group{j}).Data];
                    tdate = [tdate;swan_bio.(sites{m}).(var_group{j}).Date];
                    tdepth = [tdepth;swan_bio.(sites{m}).(var_group{j}).Depth];
                    
                end
                
            end
            
            u_dates = unique(tdate);
            inc = 1;
            for j = 1:length(u_dates)
                tt = find(tdate == u_dates(j));
                
                u_depth = unique(tdepth(tt));
                
                
                
                for k = 1:length(u_depth)
                    ww = find(tdepth(tt) == u_depth(k));
                    
                    % Currently summing the data into one variable.....
                    swan_group.(sites{m}).(u_groups{i}).Data(inc) = sum(tdata(tt(ww)));
                    swan_group.(sites{m}).(u_groups{i}).Date(inc) = u_dates(j);
                    swan_group.(sites{m}).(u_groups{i}).Depth(inc) = u_depth(k);
                    
                    inc = inc + 1;
                end
            end
            
            [swan_group.(sites{m}).(u_groups{i}).Date,ind] = sort(swan_group.(sites{m}).(u_groups{i}).Date);
            swan_group.(sites{m}).(u_groups{i}).Data = swan_group.(sites{m}).(u_groups{i}).Data(ind);
            swan_group.(sites{m}).(u_groups{i}).Depth = swan_group.(sites{m}).(u_groups{i}).Depth(ind);
            
        end
    end
end


save swan_bio.mat swan_bio -mat;
save('../../Phyto Plotting/swan_bio.mat','swan_bio','-mat');

save swan_group.mat swan_group -mat;
save('../../Phyto Plotting/swan_group.mat','swan_group','-mat');
