clear all; close all;

load Interp_GFD.mat;

flow_rate = 0.109;

hour_factor = 3600;

unit_conversion = (1000 / 32) * 1000;

oxy.GFD.mdate = datearray;
oxy.GFD.flow(1:length(datearray),1) = 0;
oxy.GFD.oxy(1:length(datearray),1) = 0;

oxy.GFD.oxy = filled_oxygen ./ hour_factor ./ flow_rate .* unit_conversion;

for i = 1:length(datearray)
    
    if filled_flow(i) == 1
        oxy.GFD.flow(i,1) = flow_rate;
        oxy.GFD.oxy(i,1) = filled_oxygen(i) / hour_factor / flow_rate * unit_conversion;
    else
        oxy.GFD.oxy(i,1) = 0;
    end
end

clear datearray filled_flow filled_oxygen;

load Interp_CAV.mat;
oxy.CAV.mdate = datearray;
oxy.CAV.flow(1:length(datearray),1) = 0;
oxy.CAV.oxy(1:length(datearray),1) = NaN;
for i = 1:length(datearray)
    
    if filled_flow(i) == 1
        oxy.CAV.flow(i,1) = flow_rate;
        oxy.CAV.oxy(i,1) = filled_oxygen(i) / hour_factor / flow_rate * unit_conversion;
    else
        oxy.CAV.oxy(i,1) = 0;
    end
end

save Oxy.mat oxy -mat;
%save Check/Oxy.mat oxy -mat;
save ../Inflows/Oxy.mat oxy -mat;

%cd Check
%check_oxy_calc
