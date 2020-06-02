clear all; close all;

matdir = 'D:\Cloud\Dropbox\SCERM_Proc\ALL\';

dirlist = dir(matdir);

% for i = 3:length(dirlist)
%     
%     filename = [matdir,dirlist(i).name,'/SAL.mat'];
%     
%     tt = regexprep(dirlist(i).name,'swan_','');
%     
%     gg = strsplit(tt,'_');
%     
%     theyear = str2num(gg{1});
%     
%     disp(['Running ',dirlist(i).name]);
    
    filename = ['F:\Cloudstor\Shared\Aquatic Ecodynamics (AED)\AED_Swan_BB\Salt HSI Calc\Matfiles\2050\SAL.mat'];
    
    theyear = 2050;

    Helena_Region_HSI_v1(filename,theyear)
    Full_Domain_Region_HSI_v1(filename,theyear)
    
    
% end
    