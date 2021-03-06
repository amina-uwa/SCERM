clear all; close all;

load bcdata.mat;
load fielddata.mat;
load simdata.mat;

types = {'Surface';'Bottom'};

shp = shaperead('../modeltools/gis/swan_erz_only.shp');

for i = 1:length(shp)
    zones(i) = {['Zone',num2str(i)]};
end

outdir = 'Export_v7/';

if ~exist(outdir,'dir')
    mkdir(outdir);
end

datearray = datenum(2008,01:01:124,01);

%            SCERM44_2015_2016_ALL: [1×1 struct]
%     SCERM44_2015_2016_Capped_ALL: [1×1 struct]
%        SCERM44_2015_2016_Dry_ALL: [1×1 struct]
%     SCERM44_2015_2016_Target_ALL: [1×1 struct]
%            SCERM44_2017_2018_ALL: [1×1 struct]
%        SCERM44_2017_2018_Wet_ALL: [1×1 struct]
%             SCERM8_2015_2016_ALL: [1×1 struct]
%             SCERM8_2017_2018_ALL: [1×1 struct]

theheader =  ['Date,'...
    'BC BASE Flow Local (ML),BC BASE Flow Local + Upstream (ML),'...
    'BC BASE TN Local (KG),BC BASE TN Local + Upstream (KG),'...
    'BC BASE TP Local (KG),BC BASE TP Local + Upstream (KG),'...
    'BC BASE OXY Local (KG),BC BASE OXY Local + Upstream (KG),'...
    'BC Capped Flow Local (ML),BC Capped Flow Local + Upstream (ML),'...
    'BC Capped TN Local (KG),BC Capped TN Local + Upstream (KG),'...
    'BC Capped TP Local (KG),BC Capped TP Local + Upstream (KG),'...
    'BC Capped OXY Local (KG),BC Capped OXY Local + Upstream (KG),'... 
    'BC Dry Flow Local (ML),BC Dry Flow Local + Upstream (ML),'...
    'BC Dry TN Local (KG),BC Dry TN Local + Upstream (KG),'...
    'BC Dry TP Local (KG),BC Dry TP Local + Upstream (KG),'...
    'BC Dry OXY Local (KG),BC Dry OXY Local + Upstream (KG),'...  
    'BC Wet Flow Local (ML),BC Wet Flow Local + Upstream (ML),'...
    'BC Wet TN Local (KG),BC Wet TN Local + Upstream (KG),'...
    'BC Wet TP Local (KG),BC Wet TP Local + Upstream (KG),'...
    'BC Wet OXY Local (KG),BC Wet OXY Local + Upstream (KG),'...  
    'BC Targets Flow Local (ML),BC Targets Flow Local + Upstream (ML),'...
    'BC Targets TN Local (KG),BC Targets TN Local + Upstream (KG),'...
    'BC Targets TP Local (KG),BC Targets TP Local + Upstream (KG),'...
    'BC Targets OXY Local (KG),BC Targets OXY Local + Upstream (KG),'...
    'Field Mean TN (mg/L),Field Mean TP (mg/L),',...
    'Field Mean TCHLA (ug/L),Field Mean Oxygen (mg/L),',...
    'Field Mean TEMP (C),Field Mean Salinity (psu),',...
    'SCERM44_2015_2016_ALL Mean TN (mg/L),SCERM44_2015_2016_ALL Mean TP (mg/L),',...
    'SCERM44_2015_2016_ALL Mean Oxy (mg/L),SCERM44_2015_2016_ALL Mean TCHLA (ug/L),',...
    'SCERM44_2015_2016_ALL Mean Salinity (psu),',...
    'SCERM44_2015_2016_Capped_ALL Mean TN (mg/L),SCERM44_2015_2016_Capped_ALL Mean TP (mg/L,)',...
    'SCERM44_2015_2016_Capped_ALL Mean Oxy (mg/L),SCERM44_2015_2016_Capped_ALL Mean TCHLA (ug/L),',...
    'SCERM44_2015_2016_Capped_ALL Mean Salinity (psu),',...
    'SCERM44_2015_2016_Dry_ALL Mean TN (mg/L),SCERM44_2015_2016_Dry_ALL Mean TP (mg/L),',...
    'SCERM44_2015_2016_Dry_ALL Mean Oxy (mg/L),SCERM44_2015_2016_Dry_ALL Mean TCHLA (ug/L),',...
    'SCERM44_2015_2016_Dry_ALL Mean Salinity (psu),',...
    'SCERM44_2015_2016_Target_ALL Mean TN (mg/L),SCERM44_2015_2016_Target_ALL Mean TP (mg/L),',...
    'SCERM44_2015_2016_Target_ALL Mean Oxy (mg/L),SCERM44_2015_2016_Target_ALL Mean TCHLA (ug/L),',...
    'SCERM44_2015_2016_Target_ALL Mean Salinity (psu),',...
    'SCERM44_2017_2018_ALL Mean TN (mg/L),SCERM44_2017_2018_ALL Mean TP (mg/L),',...
    'SCERM44_2017_2018_ALL Mean Oxy (mg/L),SCERM44_2017_2018_ALL Mean TCHLA (ug/L),',...
    'SCERM44_2017_2018_ALL Mean Salinity (psu),',...
    'SCERM44_2017_2018_Wet_ALL Mean TN (mg/L),SCERM44_2017_2018_Wet_ALL Mean TP (mg/L),',...
    'SCERM44_2017_2018_Wet_ALL Mean Oxy (mg/L),SCERM44_2017_2018_Wet_ALL Mean TCHLA (ug/L),',...
    'SCERM44_2017_2018_Wet_ALL Mean Salinity (psu),'];


    
for i = 1:length(types)
    for j = 1:length(zones)
        
        fid = fopen([outdir,zones{j},'_',types{i},'.csv'],'wt');
        fprintf(fid,'%s\n',theheader);
        
        for k = 1:length(datearray)
            fprintf(fid,'%s,',datestr(datearray(k),'mm/yyyy'));
            
            %BC's
            fprintf(fid,'%4.4f,',BC.Flow_Catch.(zones{j}).ML.local(k));
            fprintf(fid,'%4.4f,',BC.Flow_Catch.(zones{j}).ML.Upstream(k));
            fprintf(fid,'%4.4f,',BC.Flow_Catch.(zones{j}).TN.local(k));
            fprintf(fid,'%4.4f,',BC.Flow_Catch.(zones{j}).TN.Upstream(k));
            fprintf(fid,'%4.4f,',BC.Flow_Catch.(zones{j}).TP.local(k));
            fprintf(fid,'%4.4f,',BC.Flow_Catch.(zones{j}).TP.Upstream(k));
            fprintf(fid,'%4.4f,',BC.Flow_Catch.(zones{j}).OXY.local(k));
            fprintf(fid,'%4.4f,',BC.Flow_Catch.(zones{j}).OXY.Upstream(k));
        
            fprintf(fid,'%4.4f,',BC.Capped_44.(zones{j}).ML.local(k));
            fprintf(fid,'%4.4f,',BC.Capped_44.(zones{j}).ML.Upstream(k));
            fprintf(fid,'%4.4f,',BC.Capped_44.(zones{j}).TN.local(k));
            fprintf(fid,'%4.4f,',BC.Capped_44.(zones{j}).TN.Upstream(k));
            fprintf(fid,'%4.4f,',BC.Capped_44.(zones{j}).TP.local(k));
            fprintf(fid,'%4.4f,',BC.Capped_44.(zones{j}).TP.Upstream(k));
            fprintf(fid,'%4.4f,',BC.Capped_44.(zones{j}).OXY.local(k));
            fprintf(fid,'%4.4f,',BC.Capped_44.(zones{j}).OXY.Upstream(k));       
        
            fprintf(fid,'%4.4f,',BC.Dry_44.(zones{j}).ML.local(k));
            fprintf(fid,'%4.4f,',BC.Dry_44.(zones{j}).ML.Upstream(k));
            fprintf(fid,'%4.4f,',BC.Dry_44.(zones{j}).TN.local(k));
            fprintf(fid,'%4.4f,',BC.Dry_44.(zones{j}).TN.Upstream(k));
            fprintf(fid,'%4.4f,',BC.Dry_44.(zones{j}).TP.local(k));
            fprintf(fid,'%4.4f,',BC.Dry_44.(zones{j}).TP.Upstream(k));
            fprintf(fid,'%4.4f,',BC.Dry_44.(zones{j}).OXY.local(k));
            fprintf(fid,'%4.4f,',BC.Dry_44.(zones{j}).OXY.Upstream(k));        

            fprintf(fid,'%4.4f,',BC.Wet_44.(zones{j}).ML.local(k));
            fprintf(fid,'%4.4f,',BC.Wet_44.(zones{j}).ML.Upstream(k));
            fprintf(fid,'%4.4f,',BC.Wet_44.(zones{j}).TN.local(k));
            fprintf(fid,'%4.4f,',BC.Wet_44.(zones{j}).TN.Upstream(k));
            fprintf(fid,'%4.4f,',BC.Wet_44.(zones{j}).TP.local(k));
            fprintf(fid,'%4.4f,',BC.Wet_44.(zones{j}).TP.Upstream(k));
            fprintf(fid,'%4.4f,',BC.Wet_44.(zones{j}).OXY.local(k));
            fprintf(fid,'%4.4f,',BC.Wet_44.(zones{j}).OXY.Upstream(k));
            
            fprintf(fid,'%4.4f,',BC.Targets_44.(zones{j}).ML.local(k));
            fprintf(fid,'%4.4f,',BC.Targets_44.(zones{j}).ML.Upstream(k));
            fprintf(fid,'%4.4f,',BC.Targets_44.(zones{j}).TN.local(k));
            fprintf(fid,'%4.4f,',BC.Targets_44.(zones{j}).TN.Upstream(k));
            fprintf(fid,'%4.4f,',BC.Targets_44.(zones{j}).TP.local(k));
            fprintf(fid,'%4.4f,',BC.Targets_44.(zones{j}).TP.Upstream(k));
            fprintf(fid,'%4.4f,',BC.Targets_44.(zones{j}).OXY.local(k));
            fprintf(fid,'%4.4f,',BC.Targets_44.(zones{j}).OXY.Upstream(k)); 
            
            % Field
            fprintf(fid,'%4.4f,',field.TN.(zones{j}).(types{i})(k));
            fprintf(fid,'%4.4f,',field.TP.(zones{j}).(types{i})(k));
            fprintf(fid,'%4.4f,',field.TCHLA.(zones{j}).(types{i})(k));
            fprintf(fid,'%4.4f,',field.Oxy.(zones{j}).(types{i})(k));
            fprintf(fid,'%4.4f,',field.TEMP.(zones{j}).(types{i})(k));
            fprintf(fid,'%4.4f,',field.SAL.(zones{j}).(types{i})(k));
            
            % Model
            fprintf(fid,'%4.4f,',simdata.SCERM44_2015_2016_ALL.(zones{j}).TN.(types{i})(k));
            fprintf(fid,'%4.4f,',simdata.SCERM44_2015_2016_ALL.(zones{j}).TP.(types{i})(k));
            fprintf(fid,'%4.4f,',simdata.SCERM44_2015_2016_ALL.(zones{j}).Oxy.(types{i})(k));
            fprintf(fid,'%4.4f,',simdata.SCERM44_2015_2016_ALL.(zones{j}).TCHLA.(types{i})(k));
            fprintf(fid,'%4.4f,',simdata.SCERM44_2015_2016_ALL.(zones{j}).SAL.(types{i})(k));
            
            fprintf(fid,'%4.4f,',simdata.SCERM44_2015_2016_Capped_ALL.(zones{j}).TN.(types{i})(k));
            fprintf(fid,'%4.4f,',simdata.SCERM44_2015_2016_Capped_ALL.(zones{j}).TP.(types{i})(k));
            fprintf(fid,'%4.4f,',simdata.SCERM44_2015_2016_Capped_ALL.(zones{j}).Oxy.(types{i})(k));
            fprintf(fid,'%4.4f,',simdata.SCERM44_2015_2016_Capped_ALL.(zones{j}).TCHLA.(types{i})(k));
            fprintf(fid,'%4.4f,',simdata.SCERM44_2015_2016_Capped_ALL.(zones{j}).SAL.(types{i})(k));
            
            fprintf(fid,'%4.4f,',simdata.SCERM44_2015_2016_Dry_ALL.(zones{j}).TN.(types{i})(k));
            fprintf(fid,'%4.4f,',simdata.SCERM44_2015_2016_Dry_ALL.(zones{j}).TP.(types{i})(k));
            fprintf(fid,'%4.4f,',simdata.SCERM44_2015_2016_Dry_ALL.(zones{j}).Oxy.(types{i})(k));
            fprintf(fid,'%4.4f,',simdata.SCERM44_2015_2016_Dry_ALL.(zones{j}).TCHLA.(types{i})(k));
            fprintf(fid,'%4.4f,',simdata.SCERM44_2015_2016_Dry_ALL.(zones{j}).SAL.(types{i})(k));
            
            fprintf(fid,'%4.4f,',simdata.SCERM44_2015_2016_Target_ALL.(zones{j}).TN.(types{i})(k));
            fprintf(fid,'%4.4f,',simdata.SCERM44_2015_2016_Target_ALL.(zones{j}).TP.(types{i})(k));
            fprintf(fid,'%4.4f,',simdata.SCERM44_2015_2016_Target_ALL.(zones{j}).Oxy.(types{i})(k));
            fprintf(fid,'%4.4f,',simdata.SCERM44_2015_2016_Target_ALL.(zones{j}).TCHLA.(types{i})(k));
            fprintf(fid,'%4.4f,',simdata.SCERM44_2015_2016_Target_ALL.(zones{j}).SAL.(types{i})(k));
            
            fprintf(fid,'%4.4f,',simdata.SCERM44_2017_2018_ALL.(zones{j}).TN.(types{i})(k));
            fprintf(fid,'%4.4f,',simdata.SCERM44_2017_2018_ALL.(zones{j}).TP.(types{i})(k));
            fprintf(fid,'%4.4f,',simdata.SCERM44_2017_2018_ALL.(zones{j}).Oxy.(types{i})(k));
            fprintf(fid,'%4.4f,',simdata.SCERM44_2017_2018_ALL.(zones{j}).TCHLA.(types{i})(k));
            fprintf(fid,'%4.4f,',simdata.SCERM44_2017_2018_ALL.(zones{j}).SAL.(types{i})(k));
            
            fprintf(fid,'%4.4f,',simdata.SCERM44_2017_2018_Wet_ALL.(zones{j}).TN.(types{i})(k));
            fprintf(fid,'%4.4f,',simdata.SCERM44_2017_2018_Wet_ALL.(zones{j}).TP.(types{i})(k));
            fprintf(fid,'%4.4f,',simdata.SCERM44_2017_2018_Wet_ALL.(zones{j}).Oxy.(types{i})(k));
            fprintf(fid,'%4.4f,',simdata.SCERM44_2017_2018_Wet_ALL.(zones{j}).TCHLA.(types{i})(k));
            fprintf(fid,'%4.4f,',simdata.SCERM44_2017_2018_Wet_ALL.(zones{j}).SAL.(types{i})(k));
            
            fprintf(fid,'\n');
            
        end
        fclose(fid);
    end
end