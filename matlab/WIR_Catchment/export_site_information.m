clear all; close all;

load swan.mat;

[snum,sstr] = xlsread('WIR Supporting Data.xlsx','Site_Information','A2:E20000');

shp = shaperead('GIS/ReportingCats.shp');
bound = shaperead('GIS/Swan_Boundary.shp');

write_vars = {...
    'Flow',...
    'SAL',...
    'TEMP',...
    'WQ_NIT_NIT',...
    'WQ_NIT_AMM',...
    'WQ_OXY_OXY',...
    'WQ_DIAG_TOT_TN',...
    'WQ_DIAG_TOT_TP',...
    'WQ_OGM_DON',...
    'WQ_OGM_DOP',...
    'WQ_OGM_PON',...
    'WQ_OGM_POP',...
    };
shp_vars = {...
    'Flow',...
    'SAL',...
    'TEMP',...
    'NIT',...
    'AMM',...
    'OXY',...
    'TN',...
    'TP',...
    'DON',...
    'DOP',...
    'PON',...
    'POP',...
    };


S = [];

site_ID = snum(:,2);
full_name = sstr(:,2);
full_name_2 = sstr(:,3);
crap_name = sstr(:,4);

fid = fopen('Swan Data Review.csv','wt');

sites = fieldnames(swan);

years = [1970:01:2019];

fprintf(fid,'Site ID,Catchment,Name,Name 2,Var,');
for i = 1:length(years)
    fprintf(fid,'%d,',years(i));
end
fprintf(fid,'\n');

for i = 1:length(sites)
    vars = fieldnames(swan.(sites{i}));
    
    sss = find(strcmpi(crap_name,sites{i}));
    X = swan.(sites{i}).(vars{1}).X;
    Y = swan.(sites{i}).(vars{1}).Y;
    cat = [];
    for bb = 1:length(shp)
        if inpolygon(X,Y,shp(bb).X,shp(bb).Y)
            cat = shp(bb).CATCH_NAME;
        end
    end
    
    if inpolygon(X,Y,bound(1).X,bound(1).Y)
        cat = 'Esturary';
    end
    if isempty(cat)
        cat = 'Esturary';
    end
    
    S(i).X = X;
    S(i).Y = Y;
    S(i).Geometry = 'Point';
    S(i).Site = regexprep(sites{i},'s','');
    S(i).Subcat = cat;
    S(i).FullName = full_name{sss(1)};
    S(i).FullName2 = full_name_2{sss(1)};
    
    G(i).Site = S(i).Site;
    G(i).Subcat = S(i).Subcat;
    
    
    for j = 1:length(write_vars)
        fprintf(fid,'%d,%s,%s,%s,%s,',site_ID(sss(1)),cat,full_name{sss(1)},full_name_2{sss(1)},write_vars{j});
        
        if isfield(swan.(sites{i}),write_vars{j})
            S(i).(shp_vars{j}) = length(swan.(sites{i}).(write_vars{j}).Date);
        else
            S(i).(shp_vars{j}) = 0;
        end
        
        
        for k = 1:length(years)
            
            
            
            if isfield(swan.(sites{i}),write_vars{j})
                ttt = find(swan.(sites{i}).(write_vars{j}).Date >= datenum(years(k),01,01) & ...
                    swan.(sites{i}).(write_vars{j}).Date < datenum(years(k)+1,01,01));
                
                if ~isempty(ttt)
                    fprintf(fid,'%d,',length(ttt));
                    G(i).(write_vars{j})(k) = length(ttt);
                else
                    fprintf(fid,',');
                    G(i).(write_vars{j})(k) = 0;
                end
            else
                G(i).(write_vars{j})(k) = 0;
                fprintf(fid,',');
            end
        end
        fprintf(fid,'\n');
    end
end
fclose(fid);

shapewrite(S,'WIR_Data.shp');

save G.mat G -mat;


