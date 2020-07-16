function hab = calc_hab(V_x,V_y,Temp_Top,Temp_bot,Sal_Top,Sal_Bot,Amm,Nit,Frp,int)


%
Amm = Amm * 14/1000;
Nit = Nit * 14/1000;
Frp = Frp * 31/1000;

if int == 0
    k = 4.1102;
    a = 35.0623;
    b = 0.1071;
    v = 1.08;
else
    k = 4.1102;
    a = 35.0623;
    b = 0.1071;
    v = 1.08;
end


V = sqrt(power(V_x,2) + power(V_y,2));
%
%
%
% save hab.mat V Temp_Top Temp_bot Sal_Top Sal_Bot Amm Nit Frp -mat;

%load hab.mat

%------ stratification
strat = Temp_Top - Temp_bot;

mV = mean(V);





if mV < 0.01
    fS = 1;
else
    %fS = k*mV + n;
    fS = 1 - (mV*(1/0.1));
    fS(fS<0) = 0;
end



T = double(Temp_Top);

%fT = v^(T-20)-v^(k*(T-a))+b;

fT = power(v,T-20) - power(v,k*(T-a)) + b;


%------ nitrogen
N = max(Nit) + max(Amm);   % max in column
KN = 4;                %   in mmol/m3
fN = N/(KN+N);

%------ phosphorus
P = max(Frp);%   max in column
KP = 0.15;    % in mmol/m3
fP = P/(KP+P);


%------ TOTAL RISK

hab = mean(fS * fT * min(fN , fP));

