function nc = convertNCdata(nc,currentVariable,var)
% Function to.....
for ii = 1:length(nc)
    
    if (strcmp(currentVariable,'Level') < 1)
        mainVar = zeros(length(nc(ii).data.Ordinal_Dates),1,length(nc(ii).data.S));
        depVar = zeros(size(mainVar));
        for zz = 1:length(nc(ii).data.Ordinal_Dates)
            for locs = 1:length(nc(ii).data.S)
                minval = min(abs(nc(ii).data.Z - nc(ii).data.FreeSurfHeights(zz,locs)));
                holding =  find ( abs(nc(ii).data.Z - nc(ii).data.FreeSurfHeights(zz,locs)) == minval);
                Sites(locs).zVec(zz) = holding(1);
                mainVar(zz,1,locs) = nc(ii).data.([var.([currentVariable]).ELCD])(zz,Sites(locs).zVec(zz),locs);
                if strcmp(var.([currentVariable]).Dependant,'None') <1
                    depVar(zz,1,locs) = nc(ii).data.([var.([currentVariable]).Dependant])(zz,Sites(locs).zVec(zz),locs);
                end
            end
        end
        nc(ii).data.crtdata = mainVar;
        if strcmp(var.([currentVariable]).Dependant,'None') <1
            nc(ii).([var.([currentVariable]).Dependant]) = depVar;
        end
    end
end

