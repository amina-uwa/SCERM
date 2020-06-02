clear all; close all;

addpath(genpath('Functions'));

%########################################################
%{ 
Import Script on OSX for the importation of the Swan RIver Data

Data is kept in the ../Data/Dat directory in a formatted Txt file.

Raw Data found in ../Data/Spreadsheets/SwamTrimmed.xls
%}
clear all;
close all;
%########################################################
physicalFile = 'Alice_Data/Dat/swanPhysical.dat';
bioFile = 'Alice_Data/Dat/swanBio.dat';
novFile = 'Alice_Data/Dat/swanNovember.dat';
%########################################################
% Physical Import Routine
fid = fopen(physicalFile,'rt');
a = textscan(fid, '%s	%s	%n	%n	%s	%s	%n	%n	%n	%n	%n	%n	%n	%n	%n	%n	%n	%n	%n	%n	%n	%n	%n	%n	%n	%n');
fclose(fid);
%########################################################
col(1).name= 'Site';
col(2).name= 'Date';
col(3).name= 'Month';
col(4).name= 'Year';
col(5).name= 'Method';
col(6).name= 'Depth';
col(7).name= 'DepthMetre';
col(8).name = 'Bottom';
col(9).name = 'Secchi';
col(10).name= 'Conductivity';
col(11).name= 'DO';
col(12).name= 'SALINITY';
col(13).name= 'SALINITYPPT';
col(14).name= 'TEMPERATURE';
col(15).name= 'pH';
col(16).name= 'ChlA';
col(17).name= 'DON';
col(18).name= 'NO3';
col(19).name= 'TKN';
col(20).name= 'TN';
col(21).name= 'NH4';
col(22).name= 'TP';
col(23).name= 'PO4';
col(24).name= 'SiO2';
col(25).name= 'Alkalinity';
col(26).name= 'DOC';
% Import in Data
for ii = 1:length(col)
    eval(['holding.',col(ii).name,'=a{ii};']);
end
% Code for Date Conversion
holding.Date = datenum(holding.Date,'dd/mm/yyyy');
% Load Site information
swanNames
% Arrays for Grid Data
for ii = 1:length(col);
    eval(['Swan.Physical.',col(ii).name,'=a{ii};'])
end
Swan.Physical.Distance(1:length(Swan.Physical.Site)) = NaN;
for ii = 1:length(infoS)
    cmp = strcmp(Swan.Physical.Site,infoS(ii).name);
    Swan.Physical.Distance(cmp > 0) = infoS(ii).Dist;
end
Swan.Physical.Date = holding.Date;
clear a ans cmp fid holding ii  jj ss col;
%########################################################
%########################################################
% Physical Import Routine
fid = fopen(bioFile,'rt');
a = textscan(fid, '%s	%s	%n	%n	%s	%s	%n	%n	%n	%n	%n	%n	%n	%n	%n	%n	%n	%n	%n	%n	%n	%n');
fclose(fid);
%########################################################
col(1).name='Site';
col(2).name='Date';
col(3).name='Month';
col(4).name='Year';
col(5).name='Method';
col(6).name='Depth';
col(7).name='DepthMetre';
col(8).name='Bottom';
col(9).name='Pico';
col(10).name='Synecho';
col(11).name='SynePercent';
col(12).name='HLSynecho';
col(13).name='LLSynecho';
col(14).name='NANO';
col(15).name = 'TotalBac';
col(16).name = 'BacterialC';
col(17).name = 'VLP_1';
col(18).name = 'VLP_2';
col(19).name = 'VLPRatio';
col(20).name = 'VLP_1RelAb';
col(21).name = 'VLP_2RelAb';
col(22).name = 'TotalVLP';
% Import in Data
for ii = 1:length(col)
    eval(['holding.',col(ii).name,'=a{ii};']);
end
% Code for Date Conversion
holding.Date = datenum(holding.Date,'dd/mm/yyyy');
% Load Site information
swanNames
% Arrays for Grid Data
for ii = 1:length(col);
    eval(['Swan.Bio.',col(ii).name,'=a{ii};'])
end
Swan.Bio.Distance(1:length(Swan.Bio.Site)) = NaN;
for ii = 1:length(infoS)
    cmp = strcmp(Swan.Bio.Site,infoS(ii).name);
    Swan.Bio.Distance(cmp > 0) = infoS(ii).Dist;
end
Swan.Bio.Date = holding.Date;
clear a ans cmp fid holding ii  jj ss col;
%########################################################
%########################################################
% Physical Import Routine
fid = fopen(novFile,'rt');
a = textscan(fid, '%s	%s	%n	%n	%s	%s	%n	%n	%n	%n	%n	%n	%n	%n	%n	%n	%n	%n');
fclose(fid);
%########################################################
col(1).name='Site';
col(2).name='Date';
col(3).name='Month';
col(4).name='Year';
col(5).name='Method';
col(6).name='Depth';
col(7).name='DepthMetre';
col(8).name='Bottom';
col(9).name = 'Diatoms ';
col(10).name = 'Dinoglagellates';
col(11).name = 'Chlorophytes';
col(12).name = 'Cryptophytes';
col(13).name = 'Chrysophytes';
col(14).name = 'Euglenophytes';
col(15).name = 'Dicthoyophytes';
col(16).name = 'Raphidophytes ';
col(17).name = 'Haptophytes';
col(18).name = 'BlueGreenAlgae';
% Import in Data
for ii = 1:length(col)
    eval(['holding.',col(ii).name,'=a{ii};']);
end
% Code for Date Conversion
holding.Date = datenum(holding.Date,'dd/mm/yyyy');
% Load Site information
swanNames
% Arrays for Grid Data
for ii = 1:length(col);
    eval(['Swan.Nov.',col(ii).name,'=a{ii};'])
end
Swan.Nov.Distance(1:length(Swan.Nov.Site)) = NaN;
for ii = 1:length(infoS)
    cmp = strcmp(Swan.Nov.Site,infoS(ii).name);
    Swan.Nov.Distance(cmp > 0) = infoS(ii).Dist;
end
Swan.Nov.Date = holding.Date;
clear a ans cmp fid holding ii  jj ss col;
%########################################################