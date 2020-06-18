clear all; close all;

[snum,sstr,scell] = xlsread('Nearshore prawns.xlsx','A2:D941');

nDates = datenum(sstr(:,1),'dd/mm/yyyy');
nNames = sstr(:,2);
nPeriod = scell(:,3);
nRegion = sstr(:,4);

[snum,sstr,scell] = xlsread('Offshore prawns.xlsx','A2:D753');
oDates = datenum(sstr(:,1),'dd/mm/yyyy');
oNames = sstr(:,2);
oPeriod = scell(:,3);
oRegion = sstr(:,4);

[~,sstr] = xlsread('prawn_names.xlsx');

oldnames = sstr(:,1);
newnames = sstr(:,4);
zone = sstr(:,2);


load ../Export_Locations.mat;

int = 1;

for i = 1:length(shp)
    
    if strcmpi(shp(i).Project,'Prawns') == 1
        
        prawn(int).X = shp(i).X;
        prawn(int).Y = shp(i).Y;
        prawn(int).Name = shp(i).Name;
        prawn(int).Type = shp(i).Type;
        prawn(int).Code = shp(i).Code;
        prawn(int).Project = shp(i).Project;
        prawn(int).Geometry = shp(i).Geometry;
        prawn(int).Dates = shp(i).Dates;
        prawn(int).Depth = shp(i).Depth;
        
        type = shp(i).Type;
        
        switch type
            case 'Nearshore'
                sss = find(strcmpi(oldnames,shp(i).Name) == 1 & ...
                    strcmpi(zone,'Nearshore') == 1);
                
                prawn(int).NewName = newnames{sss};
                
                sss = find(strcmpi(nNames,prawn(int).NewName) == 1);
                
                prawn(int).Dates = [];
                prawn(int).Dates = nDates(sss);
                prawn(int).Period = nPeriod(sss);
                prawn(int).Region = nRegion(sss);
                prawn(int).Depth = 1.5;
                int = int + 1;
                
                
                
            case 'Offshore'
                
                sss = find(strcmpi(oldnames,shp(i).Name) == 1 & ...
                    strcmpi(zone,'Offshore') == 1);
                
                prawn(int).NewName = newnames{sss};
                
                sss = find(strcmpi(oNames,prawn(int).NewName) == 1);
                
                prawn(int).Dates = [];
                prawn(int).Dates = oDates(sss);
                prawn(int).Period = oPeriod(sss);
                prawn(int).Region = oRegion(sss);
                prawn(int).Depth = 20;
                int = int + 1;
                
            otherwise
                
        end
        
    end
end
                
save ../prawn_export.mat prawn -mat;                
                
                
                
                
                
                
                
                
                % fid = fopen('existing.csv','wt');
                % for i = 1:length(shp)
                %     fprintf(fid,'%s,%s,%s\n',regexprep(shp(i).Name,',','_'),shp(i).Type,shp(i).Project);
                % end
                % fclose(fid);
                
                % [~,sstr] = xlsread('Nearshore prawns.xlsx','B2:B1000');
                %
                % near = unique(sstr);
                %
                % [~,sstr] = xlsread('Offshore prawns.xlsx','B2:B1000');
                %
                % off = unique(sstr);
                %
                % fid = fopen('existing.csv','wt');
                % for i = 1:length(shp)
                %     fprintf(fid,'%s,%s,%s\n',regexprep(shp(i).Name,',','_'),shp(i).Type,shp(i).Project);
                % end
                %
                % fprintf(fid,'Nearshore\n');
                % for i = 1:length(near)
                %     fprintf(fid,'%s\n',near{i});
                % end
                % fprintf(fid,'Offshore\n');
                % for i = 1:length(off)
                %     fprintf(fid,'%s\n',off{i});
                % end
                %
                % fclose(fid);
                % int = 1;
                % for i = 1:length(shp)
                %     if strcmpi(shp(i).Project,'Prawns') == 1
                %         prawns(int) = shp(i);
                %         int = int + 1;
                %     end
                % end
                
                
