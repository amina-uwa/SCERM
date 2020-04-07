function Download_DAFWA_Met_Data_v1(Site_ID,data_dir,year_array)
outdir = data_dir;

options = weboptions('Timeout',Inf);


if ~exist(outdir,'dir')
    mkdir(outdir);
end

address_part_A   = ['https://api.agric.wa.gov.au/v1/weatherstations/hourrecordings.csv?stationId=',Site_ID,'&fromDate='];
address_part_B   = '&api_key=0CEFB4534E1C6B6716418A0F.apikey';


month_array = [1:1:12];

for i = 1:length(year_array)
    for j = 1:length(month_array)
        
        sdate = datenum(year_array(i),month_array(j),01);
        %sdate = datenum(year_array(i),01,01);
        disp(datestr(sdate));
        
        %edate = datenum(year_array(i),month_array(j)+1,01);
        edate = datenum(year_array(i),month_array(j),eomday(year_array(i),month_array(j)));
        %edate = datenum(year_array(i),21,31);
        
        mid_string = [datestr(sdate,'yyyy-mm-dd'),'&toDate=',datestr(edate,'yyyy-mm-dd')];
        
        address = [address_part_A,mid_string,address_part_B];
%         address
%         stop
        filename = [outdir,datestr(sdate,'yyyymmdd'),'.csv'];
        
        try
            outfilename = websave(filename,address,options);
        catch
            % Continue on error
        end
        
        if exist(filename,'file')
            fl = dir(filename);

            filesize = fl(1).bytes;

            if filesize<10
                delete(filename);
            end
        end
        % urlwrite(address,filename);
        
    end
end