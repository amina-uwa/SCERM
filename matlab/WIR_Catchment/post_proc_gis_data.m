clear all; close all;

shp = shaperead('WIR_Data.shp');
pnt = shaperead('GIS/catchment_outlet.shp');
cats = shaperead('GIS/ReportingCats.shp');

a_cats = [];

for i = 1:length(shp)
    a_cats = [a_cats,{shp(i).Subcat}];
end

u_cats = unique(a_cats);


fid = fopen('Catchment Distances.csv','wt');
fprintf(fid,'Catchment,Site,Distance\n');



for i = 1:length(u_cats)
    
    for kk = 1:length(cats)
        if strcmpi(u_cats{i},cats(kk).CATCH_NAME) == 1
            catX = cats(kk).X;
            catY = cats(kk).Y;
        end
    end
    
    
    
    if strcmpi(u_cats{i},'Esturary') == 0
        
        sites = [];
        X = [];
        Y = [];
        dist = [];
        
        distX = [];
        distY = [];
        
        for kk = 1:length(pnt)
            if strcmpi(pnt(kk).name,u_cats{i}) == 1
                distX = pnt(kk).X;
                distY = pnt(kk).Y;
            end
        end
        
        if isempty(distX)
            for kk = 1:length(pnt)
                if inpolygon(pnt(kk).X,pnt(kk).Y,catX,catY)
                    
                    distX = pnt(kk).X;
                    distY = pnt(kk).Y;
                end
            end
        end
        
        if isempty(distX)
            stop
        end
        
        int = 1;
        for jj = 1:length(shp)
            if strcmpi(shp(jj).Subcat,u_cats{i}) == 1
                sites = [sites;{shp(jj).Site}];
                X = [X;shp(jj).X];
                Y = [Y;shp(jj).Y];
            end
        end
        
        
        for jj = 1:length(sites)
            dist(jj) = sqrt(power((X(jj) - distX),2) + power((Y(jj)-distY),2));
        end
        
        dist = dist / 1000;
        
        [dist,ind] = sort(dist,'descend');
        
        for j = 1:length(ind)
            fprintf(fid,'%s,%s,%4.4f\n',u_cats{i},sites{ind(j)},dist(j));
        end
        
    end
    
end
fclose(fid);




