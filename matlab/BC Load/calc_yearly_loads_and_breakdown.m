clear all; close all;

load Load.mat;


years = 2007:1:2018;

sites = fieldnames(Load);


%______________________________

fid1 = fopen('Yearly_Flow_ML_April_to_April.csv','wt');

fprintf(fid1,'Year,');
for i = 1:length(sites)
    fprintf(fid1,'%s,',sites{i});
end
fprintf(fid1,'\n');


fid2 = fopen('Yearly_TN_KG_April_to_April.csv','wt');
fprintf(fid2,'Year,');
for i = 1:length(sites)
    fprintf(fid2,'%s,',sites{i});
end
fprintf(fid2,'\n');

fid3 = fopen('Yearly_TP_KG_April_to_April.csv','wt');
fprintf(fid3,'Year,');
for i = 1:length(sites)
    fprintf(fid3,'%s,',sites{i});
end
fprintf(fid3,'\n');


for i = 1:length(years)
    fprintf(fid1,'%s,',num2str(years(i)));
    fprintf(fid2,'%s,',num2str(years(i)));
    fprintf(fid3,'%s,',num2str(years(i)));
    for j = 1:length(sites)
        
        sss = find(Load.(sites{j}).Date >= datenum(years(i),04,01) & Load.(sites{j}).Date < datenum(years(i)+1,04,01));
        
        fprintf(fid1,'%5.5f,',sum(Load.(sites{j}).ML(sss)));
        fprintf(fid2,'%5.5f,',sum(Load.(sites{j}).TN_kg(sss)));
        fprintf(fid3,'%5.5f,',sum(Load.(sites{j}).TP_kg(sss)));
        
    end
    fprintf(fid1,'\n');
    fprintf(fid2,'\n');
    fprintf(fid3,'\n');
end
fclose(fid1);fclose(fid2);fclose(fid3);
        
        


