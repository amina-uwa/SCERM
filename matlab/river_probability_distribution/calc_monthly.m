function  MA = calc_monthly(ldate,level)

dv = datevec(ldate);

uyears = unique(dv(:,1));
umonths = unique(dv(:,2));

int = 1;

for i = 1:length(uyears)
    for j = 1:length(umonths)
        
        sss = find(dv(:,1) == uyears(i) & dv(:,2) == umonths(j));
        
        MA.Date(int,1) = datenum(uyears(i),umonths(j),01);
        MA.Level(int,1) = mean(level(sss));
        int = int + 1;
    end
end