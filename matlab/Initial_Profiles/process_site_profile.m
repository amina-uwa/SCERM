function [isfile,prof] = process_site_profile(fdata,mdate,site,headers,outdir)

% This function creates the initial profiles. It REALLY needs SAL as the
% main consistant variable between sites.
prof = [];
isfile = 0;
if isfield(fdata.(site),'SAL')
    disp(['Site ',site,' has salinity... starting processing']);
    
    udates = unique(floor(fdata.(site).SAL.Date));
    
    [~,ind] = min(abs(udates - mdate));
    
    if abs(udates(ind) - mdate) < 14
        
        disp([site,' has data within 14 days of requried date, processing']);
        
        
        sss = find(floor(fdata.(site).SAL.Date) == udates(ind));
        
        thedepths = fdata.(site).SAL.Depth(sss);
        
        thedepths(1) = 0;
        thedepths = thedepths * -1;
        
%         thedepths(end+1) = 50;
        thedepths = [0 (max(thedepths)+1)];

        
        %'Sal'
        
        varname = 'SAL';
        
        if isfield(fdata.(site),varname)
            prof.Sal = interp_data(fdata,site,mdate,varname,thedepths);
        else
            prof.Sal = interp_data(fdata,'s6160262',mdate,varname,thedepths);
        end
        
        %'Temp'
        varname = 'TEMP';
        
        if isfield(fdata.(site),varname)
            prof.Temp = interp_data(fdata,site,mdate,varname,thedepths);
        else
            prof.Temp = interp_data(fdata,'s6160262',mdate,varname,thedepths);
        end
        
        
        %'ones'
        prof.ones(1:length(thedepths)) = 1;
        
        
        %'zeroes'
        
        prof.zeroes(1:length(thedepths)) =0;
        
        %'TSS'
        
        varname = 'WQ_DIAG_TOT_TSS';
        
        if isfield(fdata.(site),varname)
            prof.TSS = interp_data(fdata,site,mdate,varname,thedepths);
        else
            prof.TSS = interp_data(fdata,'s6160262',mdate,varname,thedepths);
            %prof.TSS(1:length(thedepths)) = NaN;
        end
        
        %'Oxy'
        
        varname = 'WQ_OXY_OXY';
        
        if isfield(fdata.(site),varname)
            prof.Oxy = interp_data(fdata,site,mdate,varname,thedepths);
        else
            prof.Oxy = interp_data(fdata,'s6160262',mdate,varname,thedepths);
        end
        
        
        %'Sil'
        varname = 'WQ_SIL_RSI';
        
        if isfield(fdata.(site),varname)
            prof.Sil = interp_data(fdata,site,mdate,varname,thedepths);
        else
            prof.Sil = interp_data(fdata,'s6160262',mdate,varname,thedepths);
        end
        
        %'Amm'
        varname = 'WQ_NIT_AMM';
        
        if isfield(fdata.(site),varname)
            prof.Amm = interp_data(fdata,site,mdate,varname,thedepths);
        else
            prof.Amm = interp_data(fdata,'s6160262',mdate,varname,thedepths);
        end
        
        %'Nit'
        varname = 'WQ_NIT_NIT';
        
        if isfield(fdata.(site),varname)
            prof.Nit = interp_data(fdata,site,mdate,varname,thedepths);
        else
           prof.Nit = interp_data(fdata,'s6160262',mdate,varname,thedepths);
        end
        
        %'FRP'
        varname = 'WQ_PHS_FRP';
        
        if isfield(fdata.(site),varname)
            prof.FRP = interp_data(fdata,site,mdate,varname,thedepths);
        else
            prof.FRP = interp_data(fdata,'s6160262',mdate,varname,thedepths);
        end
        
        %'DOC_T'
        varname = 'WQ_OGM_DOC';
        
        if isfield(fdata.(site),varname)
            prof.DOC_T = interp_data(fdata,site,mdate,varname,thedepths);
        else
           prof.DOC_T = interp_data(fdata,'s6160262',mdate,varname,thedepths);
        end
        
        %'POC_T'
        varname = 'WQ_OGM_POC';
        
        if isfield(fdata.(site),varname)
            prof.POC_T = interp_data(fdata,site,mdate,varname,thedepths);
        else
           prof.POC_T = interp_data(fdata,'s6160262',mdate,varname,thedepths);
        end
        
        %'DON_T'
        varname = 'WQ_OGM_DON';
        
        if isfield(fdata.(site),varname)
            prof.DON_T = interp_data(fdata,site,mdate,varname,thedepths);
        else
            prof.DON_T = interp_data(fdata,'s6160262',mdate,varname,thedepths);
            %prof.DON_T(1:length(thedepths)) = NaN;
        end

        %'CHLA'
        varname = 'WQ_DIAG_PHY_TCHLA';
        
        if isfield(fdata.(site),varname)
            prof.CHLA = interp_data(fdata,site,mdate,varname,thedepths);
        else
            prof.CHLA = interp_data(fdata,'s6160262',mdate,varname,thedepths);
        end
        
        %'TN'
        varname = 'WQ_DIAG_TOT_TN';
        
        if isfield(fdata.(site),varname)
            prof.TN = interp_data(fdata,site,mdate,varname,thedepths);
        else
            prof.TN = interp_data(fdata,'s6160262',mdate,varname,thedepths);
        end        
        
        %'TP'
        varname = 'WQ_DIAG_TOT_TP';
        
        if isfield(fdata.(site),varname)
            prof.TP = interp_data(fdata,site,mdate,varname,thedepths);
        else
            prof.TP = interp_data(fdata,'s6160262',mdate,varname,thedepths);
        end          
        
        %'PON_T'
        prof.PON_T = prof.TN - prof.Amm - prof.Nit - prof.DON_T;
        
        
        %'OP'
        prof.OP = (prof.TP - prof.FRP - (prof.FRP * 0.1));
        
        
        fid = fopen([outdir,'initial_profile_',site,'.csv'],'wt');
        
        fprintf(fid,'Depth,');
        
        for i = 1:length(headers)
            if i == length(headers)
                fprintf(fid,'%s\n',headers{i});
            else
                fprintf(fid,'%s,',headers{i});
            end
        end
        
        for i = 1:length(thedepths)
            fprintf(fid,'%4.4f,',thedepths(i));
            for j = 1:length(headers)
                if j == length(headers)
                    fprintf(fid,'%4.4f\n',prof.(headers{j})(i));
                else
                    fprintf(fid,'%4.4f,',prof.(headers{j})(i));
                end
            end
        end
        
        fclose(fid);
                
        isfile = 1;
    else
        
        disp(['No file created for site ',site]);
    end
    
else
    disp(['No file created for site ',site]);
end
