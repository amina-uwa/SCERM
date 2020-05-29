clear all; close all;

filename = 'DOW_Data/Search_Date_From_Export2008-2014.xlsx';

[~,sites] = xlsread(filename,'B2:B66000');

[~,sDate] = xlsread(filename,'E2:E66000');

mdate = datenum(sDate,'dd/mm/yyyy');

[~,Species] = xlsread(filename,'F2:F66000');
[~,Group] = xlsread(filename,'H2:H66000');


[nData,~] = xlsread(filename,'I2:I66000');

[u_species,ind] = unique(Species);
u_group = Group(ind);

swan_dow = [];


[snum,sstr]  =xlsread('Conversions/Species_Conversion_BB.xlsx','A2:F10000');

oldname = sstr(:,1);
var_name = sstr(:,3);
AEDgroup = sstr(:,4);
conv = snum(:,1);

u_sites = unique(sites);

for i = 1:length(u_sites)
    
    ss = find(strcmpi(sites,u_sites{i}) == 1);
    
    if strcmpi(u_sites{i},'6163159') == 1
        sitename = 's6163159';
    else
        sitename = u_sites{i};
    end
    
    sitename = regexprep(sitename,' ','_');
    
    vars = Species(ss);
    
    site_data = nData(ss);
    
    site_date = mdate(ss);
    
    u_vars = unique(vars);
    
    for j = 1:length(u_vars)
        
        tt = find(strcmpi(vars,u_vars{j}) == 1);
        
        gg = find(strcmpi(oldname,u_vars{j})==1);
        varname = var_name{gg};
        
        
        temp_date = site_date(tt);
        temp_data = site_data(tt);
        
        [sort_date,ind]  = unique(temp_date,'sorted');
        sort_data = temp_data(ind);
        
        
        swan_dow.(sitename).(varname).Date = sort_date;
        swan_dow.(sitename).(varname).Data = sort_data;
        swan_dow.(sitename).(varname).Variable_Name = u_vars{j};
    end
end

save swan_dow.mat swan_dow -mat;
    

