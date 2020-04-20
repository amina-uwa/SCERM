clear all; close all;

addpath(genpath('functions'));
addpath(genpath('tuflowfv'));


load swan.mat;

load Oxy.mat;


headers = {...
    'ISOTime',...
    'wl',...
    'Sal',...
    'Temp',...
    'ones',...
    'zeroes',...
    'TSS',...
    'Oxy',...
    'Sil',...
    'Amm',...
    'Nit',...
    'FRP',...
    'DOC_T',...
    'POC_T',...
    'DON_T',...
    'PON_T',...
    'OP',...
    'CHLA',...
    };



%
%
%
datearray(:,1) = datenum(2007,01,01,00,00,00):60/(60*24):datenum(2020,01,01,00,00,00);
%
% % 0 for no HD shift, 1 for shift

% Tidal BC files
create_interpolated_BC_for_inflow_NAR_v1(swan,headers,datearray,0);disp('NAR'); close all;
create_interpolated_BC_for_inflow_Fremantle(swan,headers,datearray,0); disp('Fremantle');close all;




clear headers;

headers = {...
    'ISOTime',...
    'Flow',...
    'Sal',...
    'Temp',...
    'ones',...
    'zeroes',...
    'TSS',...
    'Oxy',...
    'Sil',...
    'Amm',...
    'Nit',...
    'FRP',...
    'DOC_T',...
    'POC_T',...
    'DON_T',...
    'PON_T',...
    'OP',...
    'CHLA',...
    };


clear datearray;
datearray(:,1) = datenum(2007,01,01,00,00,00):1:datenum(2020,01,01,00,00,00);

create_interpolated_BC_for_inflow_Helena(swan,headers,datearray);   disp('Helena');close all;%DONE
create_interpolated_BC_for_inflow_Bennet(swan,headers,datearray); disp('Bennet');close all;%DONE
% %
% % %
% %
% %
create_interpolated_BC_for_inflow_Ellenbrook(swan,headers,datearray); disp('Ellenbrook');close all;
create_interpolated_BC_for_inflow_Susannah(swan,headers,datearray);   disp('Susannah');close all;
 create_interpolated_BC_for_inflow_UpperSwan_2000(swan,headers,datearray);disp('UpperSwan');close all;

create_interpolated_BC_for_inflow_Bayswater(swan,headers,datearray);disp('Bayswater');close all; %DONE
create_interpolated_BC_for_inflow_Jane(swan,headers,datearray);disp('Jane');close all;
create_interpolated_BC_for_inflow_Canning(swan,headers,datearray);disp('Canning');close all;

create_interpolated_oxygenation_plant_GFD(oxy,headers,datearray);disp('GFD Oxygenation Plants');close all;
create_interpolated_oxygenation_plant_CAV(oxy,headers,datearray);disp('CAV Oxygenation Plants');close all;


replace_flows_with_calculated;

merge_tidal_data_2019;

process_tide_filter;

plot_bcfiles('BCs/Flow/');

plot_bcfiles('BCs/OxyPlants/');
% 
plot_bcfiles('BCs/Tide/');


%create_interpolated_BC_for_inflow_Fremantle(swan,headers,datearray,shift_AHD)

