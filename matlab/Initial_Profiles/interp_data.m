function prof = interp_data(fdata,site,mdate,varname,thedepths)

    udates = unique(floor(fdata.(site).(varname).Date));
    
    [~,ind] = min(abs(udates - mdate));
    
    sss = find(floor(fdata.(site).(varname).Date) == udates(ind));
    
    mydepths = fdata.(site).(varname).Depth(sss);
    mydata = fdata.(site).(varname).Data(sss);
    
%     mydepths(1) = 0;
%     mydepths = mydepths * -1;
%     
%     [mydepths,ind] = unique(mydepths);
%     mydata = mydata(ind);
%     
%     
%     mydepths(end+1) = 50;
%     mydata(end+1) = mydata(end);
%     
%     
%     disp([site,': ',varname,': ',num2str(length(mydepths))]);
%     disp([site,': ',varname,': ',num2str(length(mydata))]);
    
    if length(mydepths) > 1
        
        [~,mind] = max(mydepths);
        [~,mind_1] = min(mydepths)
    
        %prof = interp1(mydepths,mydata,thedepths,'linear',mean(mydata));
        prof(1) = mydata(mind);
        prof(2) = mydata(mind_1);
    else
        prof(1:length(thedepths)) = mydata;
    end