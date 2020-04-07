%clear all; close all;

load swan_all.mat;


%datearray(:,1) = datenum(2007,01,01):1:datenum(2014,12,31,11,59,00);

datearray(:,1) = datenum(2007,01:1:96,01);


swan_small = [];

newsites = {...
    'NAR',...
    'NIL',...
    'STJ',...
    'MAY',...
    'RON',...
    'KIN',...
    'SUC',...
    'SWN12',...
    'WMP',...
    'MSB',...
    'SWN3',...
     'BLA',...
    'RIV',...
    'HEA',...
    'ARM',...
    };

% newsites = {...
%     'NAR',...
%     'STJ',...
%     'KIN',...
%     'SUC',...
%     'WMP',...
%     'MSB',...
%     };

for i = 1:length(newsites)
    swan_small.(newsites{i}) = swan.(newsites{i});
end

load swan_all.mat;


% swan_small.SWN5 = swan.SWN5;
% 
% vars = fieldnames(swan_small.SWN5);
% vars1 = fieldnames(swan_small.SWN3);

% for i = 1:length(vars)
%     swan_small.SWN5.(vars{i}).X = swan_small.SWN3.(vars1{1}).X;
%     swan_small.SWN5.(vars{i}).Y = swan_small.SWN3.(vars1{1}).Y;
% end

sites = fieldnames(swan_small);

for i = 1:length(sites)
    if isfield(swan_small.(sites{i}),'TRC_SS1')
        swan_small.(sites{i}).WQ_TRC_SS1 = swan_small.(sites{i}).TRC_SS1;
    end
end

sites = fieldnames(swan_small);
for i = 1:length(sites)
    
    if isfield(swan_small.(sites{i}),'WQ_PHS_FRP')
        
        WQ_PHS_FRP = create_interpolated_dataset(swan_small,'WQ_PHS_FRP',sites{i},'Surface',datearray);
        
        swan_small.(sites{i}).WQ_PHS_FRP_ADS = swan_small.(sites{i}).WQ_PHS_FRP;
        
        mData = WQ_PHS_FRP .* 0.1;
        good_var = 'WQ_PHS_FRP';
        
        [cdata,cdate,cdepth] = fix_data(mData,datearray,swan_small.(sites{i}).(good_var).Data,swan_small.(sites{i}).(good_var).Date,swan_small.(sites{i}).(good_var).Depth);
        
        swan_small.(sites{i}).WQ_PHS_FRP_ADS.Data = cdata;
        swan_small.(sites{i}).WQ_PHS_FRP_ADS.Date = cdate;
        swan_small.(sites{i}).WQ_PHS_FRP_ADS.Depth= cdepth;
        
         swan_small.(sites{i}).WQ_PHS_FRP_ADS.Variable_Name = 'FRP ADS';
    end
    
    if isfield(swan_small.(sites{i}),'WQ_DIAG_TOT_TN') & isfield(swan_small.(sites{i}),'WQ_NIT_AMM') & isfield(swan_small.(sites{i}),'WQ_NIT_NIT') & isfield(swan_small.(sites{i}),'WQ_OGM_DON')
        
        TN = create_interpolated_dataset(swan_small,'WQ_DIAG_TOT_TN',sites{i},'Surface',datearray);
        Amm = create_interpolated_dataset(swan_small,'WQ_NIT_AMM',sites{i},'Surface',datearray);
        Nit = create_interpolated_dataset(swan_small,'WQ_NIT_NIT',sites{i},'Surface',datearray);
        DON = create_interpolated_dataset(swan_small,'WQ_OGM_DON',sites{i},'Surface',datearray);
        
        swan_small.(sites{i}).WQ_OGM_PON = swan_small.(sites{i}).WQ_OGM_DON;
        mData = TN - Amm - Nit - DON;
        
        good_var = 'WQ_NIT_AMM';
        
        [cdata,cdate,cdepth] = fix_data(mData,datearray,swan_small.(sites{i}).(good_var).Data,swan_small.(sites{i}).(good_var).Date,swan_small.(sites{i}).(good_var).Depth);
        
        swan_small.(sites{i}).WQ_OGM_PON.Data = cdata;
        swan_small.(sites{i}).WQ_OGM_PON.Date = cdate;
        swan_small.(sites{i}).WQ_OGM_PON.Depth= cdepth;
        
        swan_small.(sites{i}).WQ_OGM_PON.Variable_Name = 'PON';

    end
    
    if isfield(swan_small.(sites{i}),'WQ_DIAG_TOT_TP') & isfield(swan_small.(sites{i}),'WQ_PHS_FRP') & isfield(swan_small.(sites{i}),'WQ_PHS_FRP_ADS')
        
        TP = create_interpolated_dataset(swan_small,'WQ_DIAG_TOT_TP',sites{i},'Surface',datearray);
        FRP = create_interpolated_dataset(swan_small,'WQ_PHS_FRP',sites{i},'Surface',datearray);
        FRP_ADS = create_interpolated_dataset(swan_small,'WQ_PHS_FRP_ADS',sites{i},'Surface',datearray);
        
        swan_small.(sites{i}).WQ_OGM_DOP = swan_small.(sites{i}).WQ_PHS_FRP;
        mData = (TP-FRP-FRP_ADS).* 0.4;
        
        good_var = 'WQ_PHS_FRP';
        
        [cdata,cdate,cdepth] = fix_data(mData,datearray,swan_small.(sites{i}).(good_var).Data,swan_small.(sites{i}).(good_var).Date,swan_small.(sites{i}).(good_var).Depth);
        
        swan_small.(sites{i}).WQ_OGM_DOP.Data = cdata;
        swan_small.(sites{i}).WQ_OGM_DOP.Date = cdate;
        swan_small.(sites{i}).WQ_OGM_DOP.Depth= cdepth;
        swan_small.(sites{i}).WQ_OGM_DOP.Variable_Name = 'DOP';

    end
    
    if isfield(swan_small.(sites{i}),'WQ_DIAG_TOT_TP') & isfield(swan_small.(sites{i}),'WQ_PHS_FRP') & isfield(swan_small.(sites{i}),'WQ_PHS_FRP_ADS')
        
        TP = create_interpolated_dataset(swan_small,'WQ_DIAG_TOT_TP',sites{i},'Surface',datearray);
        FRP = create_interpolated_dataset(swan_small,'WQ_PHS_FRP',sites{i},'Surface',datearray);
        FRP_ADS = create_interpolated_dataset(swan_small,'WQ_PHS_FRP_ADS',sites{i},'Surface',datearray);
        
        swan_small.(sites{i}).WQ_OGM_POP = swan_small.(sites{i}).WQ_PHS_FRP;
        mData = (TP-FRP-FRP_ADS).* 0.5;
        
      good_var = 'WQ_PHS_FRP';
        
        [cdata,cdate,cdepth] = fix_data(mData,datearray,swan_small.(sites{i}).(good_var).Data,swan_small.(sites{i}).(good_var).Date,swan_small.(sites{i}).(good_var).Depth);
        
        swan_small.(sites{i}).WQ_OGM_POP.Data = cdata;
        swan_small.(sites{i}).WQ_OGM_POP.Date = cdate;
        swan_small.(sites{i}).WQ_OGM_POP.Depth = cdepth;
        
        swan_small.(sites{i}).WQ_OGM_POP.Variable_Name = 'POP';
       
    end
    if isfield(swan_small.(sites{i}),'WQ_DIAG_TOT_TP')
        swan_small.(sites{i}).TP = swan_small.(sites{i}).WQ_DIAG_TOT_TP;
    end
    
        if isfield(swan_small.(sites{i}),'WQ_DIAG_TOT_TN')
        swan_small.(sites{i}).TN = swan_small.(sites{i}).WQ_DIAG_TOT_TN;
        end
    
         if isfield(swan_small.(sites{i}),'WQ_DIAG_TOT_TURBIDITY')
        swan_small.(sites{i}).Turbidity = swan_small.(sites{i}).WQ_DIAG_TOT_TURBIDITY;
    end
    
    if isfield(swan_small.(sites{i}),'WQ_DIAG_PHY_TCHLA')
        
        TCHLA = create_interpolated_dataset(swan_small,'WQ_DIAG_PHY_TCHLA',sites{i},'Surface',datearray);
%         
%         swan_small.(sites{i}).WQ_PHY_GRN = swan_small.(sites{i}).WQ_DIAG_PHY_TCHLA;
%         swan_small.(sites{i}).WQ_PHY_GRN.Data = TCHLA * 0.15;
%         swan_small.(sites{i}).WQ_PHY_GRN.Date = datearray;
%         swan_small.(sites{i}).WQ_PHY_GRN.Depth(1:length(datearray),1) = 0;
%         swan_small.(sites{i}).WQ_PHY_GRN.Variable_Name = 'GRN';
%         
%         swan_small.(sites{i}).WQ_PHY_BGA = swan_small.(sites{i}).WQ_DIAG_PHY_TCHLA;
%         swan_small.(sites{i}).WQ_PHY_BGA.Data = TCHLA * 0.10;
%         swan_small.(sites{i}).WQ_PHY_BGA.Date = datearray;
%         swan_small.(sites{i}).WQ_PHY_BGA.Depth(1:length(datearray),1) = 0;
%         swan_small.(sites{i}).WQ_PHY_BGA.Variable_Name = 'BGA';
%         
%         
%         swan_small.(sites{i}).WQ_PHY_FDIAT = swan_small.(sites{i}).WQ_DIAG_PHY_TCHLA;
%         swan_small.(sites{i}).WQ_PHY_FDIAT.Data = TCHLA * 0.10;
%         swan_small.(sites{i}).WQ_PHY_FDIAT.Date = datearray;
%         swan_small.(sites{i}).WQ_PHY_FDIAT.Depth(1:length(datearray),1) = 0;
%         swan_small.(sites{i}).WQ_PHY_FDIAT.Variable_Name = 'FDIAT';
%         
%         swan_small.(sites{i}).WQ_PHY_MDIAT = swan_small.(sites{i}).WQ_DIAG_PHY_TCHLA;
%         swan_small.(sites{i}).WQ_PHY_MDIAT.Data = TCHLA * 0.15;
%         swan_small.(sites{i}).WQ_PHY_MDIAT.Date = datearray;
%         swan_small.(sites{i}).WQ_PHY_MDIAT.Depth(1:length(datearray),1) = 0;
%         swan_small.(sites{i}).WQ_PHY_MDIAT.Variable_Name = 'MDIAT';
%         
%         swan_small.(sites{i}).WQ_PHY_KARLO = swan_small.(sites{i}).WQ_DIAG_PHY_TCHLA;
%         swan_small.(sites{i}).WQ_PHY_KARLO.Data = TCHLA * 0.5;
%         swan_small.(sites{i}).WQ_PHY_KARLO.Date = datearray;
%         swan_small.(sites{i}).WQ_PHY_KARLO.Depth(1:length(datearray),1) = 0;
%         swan_small.(sites{i}).WQ_PHY_KARLO.Variable_Name = 'KARLO';
%         
%         
%         swan_small.(sites{i}).WQ_PHY_CRYPT = swan_small.(sites{i}).WQ_PHY_FDIAT; 
% 
%         swan_small.(sites{i}).WQ_PHY_DIATOM = swan_small.(sites{i}).WQ_PHY_MDIAT;
% 
%         swan_small.(sites{i}).WQ_PHY_DINO = swan_small.(sites{i}).WQ_PHY_KARLO; 
        
        
        
    end
    
%     if isfield(swan_small.(sites{i}),'WQ_OGM_DON')
%         
%         DON = create_interpolated_dataset(swan_small,'WQ_OGM_DON',sites{i},'Surface',datearray);
%         
%         swan_small.(sites{i}).WQ_OGM_DONR = swan_small.(sites{i}).WQ_OGM_DON;
%         
%         
%         swan_small.(sites{i}).WQ_OGM_DONR.Data = DON * 0.6;
%         swan_small.(sites{i}).WQ_OGM_DONR.Date = datearray;
%         swan_small.(sites{i}).WQ_OGM_DONR.Depth(1:length(datearray),1) = 0;
%         swan_small.(sites{i}).WQ_OGM_DONR.Variable_Name = 'DONR';
%     end
    
%     if isfield(swan_small.(sites{i}),'WQ_DIAG_TOT_TP') & isfield(swan_small.(sites{i}),'WQ_PHS_FRP') & isfield(swan_small.(sites{i}),'WQ_PHS_FRP_ADS')
%         
%         
%         TP = create_interpolated_dataset(swan_small,'WQ_DIAG_TOT_TP',sites{i},'Surface',datearray);
%         FRP = create_interpolated_dataset(swan_small,'WQ_PHS_FRP',sites{i},'Surface',datearray);
%         FRP_ADS = create_interpolated_dataset(swan_small,'WQ_PHS_FRP_ADS',sites{i},'Surface',datearray);
%         
%         swan_small.(sites{i}).WQ_OGM_DOPR = swan_small.(sites{i}).WQ_PHS_FRP;
%         swan_small.(sites{i}).WQ_OGM_DOPR.Data = (TP-FRP-FRP_ADS).* 0.1;
%         swan_small.(sites{i}).WQ_OGM_DOPR.Date = datearray;
%         swan_small.(sites{i}).WQ_OGM_DOPR.Depth(1:length(datearray),1) = 0;
%         swan_small.(sites{i}).WQ_OGM_DOPR.Variable_Name = 'DOPR';
%         
%     end
%     
%     if isfield(swan_small.(sites{i}),'WQ_OGM_POC')
%         
%         POC = create_interpolated_dataset(swan_small,'WQ_OGM_POC',sites{i},'Surface',datearray);
%         
%         swan_small.(sites{i}).WQ_OGM_CPOM = swan_small.(sites{i}).WQ_OGM_POC;
%         swan_small.(sites{i}).WQ_OGM_CPOM.Data = POC * 0.05;
%         swan_small.(sites{i}).WQ_OGM_CPOM.Date = datearray;
%         swan_small.(sites{i}).WQ_OGM_CPOM.Depth(1:length(datearray),1) = 0;
%         swan_small.(sites{i}).WQ_OGM_CPOM.Variable_Name = 'CPOM';
%     end
%     
%     if isfield(swan_small.(sites{i}),'WQ_OGM_DOC')
%         
%         DOC = create_interpolated_dataset(swan_small,'WQ_OGM_DOC',sites{i},'Surface',datearray);
%         
%         swan_small.(sites{i}).WQ_OGM_DOCR = swan_small.(sites{i}).WQ_OGM_DOC;
%         swan_small.(sites{i}).WQ_OGM_DOCR.Data = DOC * 0.6;
%         swan_small.(sites{i}).WQ_OGM_DOCR.Date = datearray;
%         swan_small.(sites{i}).WQ_OGM_DOCR.Depth(1:length(datearray),1) = 0;
%         swan_small.(sites{i}).WQ_OGM_DOCR.Variable_Name = 'DOCR';
%     end
    
if isfield(swan_small.(sites{i}),'WQ_PHS_FRP_ADS')
    swan_small.(sites{i}) = rmfield(swan_small.(sites{i}),'WQ_PHS_FRP_ADS');
end

end

%swan_small = rmfield(swan_small,'SWN3');




save swan_small.mat swan_small -mat
save ('../../Initial Conditions/swan_small.mat','swan_small','-mat');