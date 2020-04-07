function [cdata,cdate,cdepth] = fix_data(mdata,mdate,gdata,gdate,gdepth)

days = unique(floor(gdate));
all_days = floor(gdate);


for i = 1:length(days)
    
    ss = find(all_days == days(i));
    
    [~,mind] = min(gdepth(ss));
    
    
    
    [~,ind] = min(abs(mdate - gdate(ss(mind))));
    
    cdata(i,1) = mdata(ind);
    cdate(i,1) = mdate(ind);
    cdepth(i,1) = gdepth(ss(mind));
    
end