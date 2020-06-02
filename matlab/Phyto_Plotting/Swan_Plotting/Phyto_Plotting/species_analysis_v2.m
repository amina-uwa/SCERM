clear all; close all;

load swan_bio.mat;
load ../Plotting/Matfiles/swan_all.mat;


fid = fopen('Species by Cell Count.csv','wt');
f_sites = fieldnames(swan_bio);

order = [];

for i = 1:length(f_sites)
    vars = fieldnames(swan.(f_sites{i}));
    order(i) = swan.(f_sites{i}).(vars{1}).Order;
end
    
[~,ind] = sort(order);
sites = f_sites(ind);



for i = 1:length(sites)
    
    fprintf(fid,'Sites: %s,,Summer,Autumn,Winter,Spring\n',sites{i});
    
    
    [out] = calc_species_list(swan_bio,sites{i});
    
    
    for j = 1:10
        fprintf(fid,',,%s (%s) %4.2f%%,%s (%s) %4.2f%%,%s (%s) %4.2f%%,%s (%s) %4.2f%%)\n',out.sum.ID{j},out.sum.Group{j},((out.sum.Cells(j)/sum(out.sum.Cells))*100),...
            out.aut.ID{j},out.aut.Group{j},((out.aut.Cells(j)/sum(out.aut.Cells))*100),...
            out.win.ID{j},out.win.Group{j},((out.win.Cells(j)/sum(out.win.Cells))*100),...
            out.spr.ID{j},out.spr.Group{j},((out.spr.Cells(j)/sum(out.spr.Cells))*100));
    end
    
    fprintf(fid,'\n\n');
    
    %clear out
end


fid = fopen('Species by Mass.csv','wt');

for i = 1:length(sites)
    
    fprintf(fid,'Sites: %s,,Summer,Autumn,Winter,Spring\n',sites{i});
    
    
    [out] = calc_species_list(swan_bio,sites{i});
    
    
    for j = 1:10
        fprintf(fid,',,%s (%s) %4.2f%%,%s (%s) %4.2f%%,%s (%s) %4.2f%%,%s (%s) %4.2f%%)\n',out.sum.mID{j},out.sum.mGroup{j},((out.sum.mCells(j)/sum(out.sum.mCells))*100),...
            out.aut.mID{j},out.aut.mGroup{j},((out.aut.mCells(j)/sum(out.aut.mCells))*100),...
            out.win.mID{j},out.win.mGroup{j},((out.win.mCells(j)/sum(out.win.mCells))*100),...
            out.spr.mID{j},out.spr.mGroup{j},((out.spr.mCells(j)/sum(out.spr.mCells))*100));
    end
    
    fprintf(fid,'\n\n');
    
    %clear out
end
    
          
 
