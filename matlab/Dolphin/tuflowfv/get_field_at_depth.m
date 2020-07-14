function [xdata,ydata] = get_field_at_depth(mDate,mData,mDepth,level)

xdata = [];
ydata = [];

inc = 1;

if strcmpi(level,'surface')
    
    sss = find(mDepth > -5);
    
    if ~isempty(sss)
        
        mDate_b = mDate(sss);
        mData_b = mData(sss);
        mDepth_b = mDepth(sss);
        
        
        fdate = floor(mDate_b);
        
        udate = unique(fdate);
        
        for j = 1:length(udate)
            if ~isnan(udate(j))
                sss2 = find(fdate == udate(j));
                
                [~,tt] = max(mDepth_b(sss2));
                
                ggg = find(mDepth_b(sss2) == mDepth_b(sss2(tt(1))));
                
                if length(ggg) > 3
                    
                    xdata(inc,1) = mean(mDate_b(sss2(ggg)));
                    ydata(inc,1) = mean(mData_b(sss2(ggg)));
                    
                else
                    xdata(inc,1) = mDate_b(sss2(tt(1)));
                    ydata(inc,1) = mData_b(sss2(tt(1)));
                end
                
                inc = inc + 1;
            end
        end
    end
    
else
    
    sss = find(mDepth < -2);
    
    if ~isempty(sss)
        
        mDate_b = mDate(sss);
        mData_b = mData(sss);
        mDepth_b = mDepth(sss);
        
        
        fdate = floor(mDate_b);
        
        udate = unique(fdate);
        
        for j = 1:length(udate)
            if ~isnan(udate(j))
                sss2 = find(fdate == udate(j));
                
                [~,tt] = min(mDepth_b(sss2));
                
                xdata(inc,1) = mDate_b(sss2(tt(1)));
                ydata(inc,1) = mData_b(sss2(tt(1)));
                inc = inc + 1;
            end
        end
    end
end