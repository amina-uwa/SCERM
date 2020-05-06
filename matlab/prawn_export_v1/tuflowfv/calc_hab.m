function hab = calc_hab(V_x,V_y,Temp_Top,Temp_bot,Sal_Top,Sal_Bot,Amm,Nit,Frp,int)

[V_x,V_y,Temp_Top,Temp_bot,Sal_Top,Sal_Bot,Amm,Nit,Frp] = do_mean(V_x,V_y,Temp_Top,Temp_bot,Sal_Top,Sal_Bot,Amm,Nit,Frp);
%
Amm = Amm * 14/1000;
Nit = Nit * 14/1000;
Frp = Frp * 31/1000;

if int == 0    % CYANOBACTERIA - eg Nodularia
    k = 4.1102;
    a = 35.0623;
    b = 0.1071;
    v = 1.08;

    KP = 0.008;
    KN = 0.01;

    fSa = 1.;
    fSb = 1;
    fSc = 25;
    fSo = 15;

    fTa = 0.5;
    fTb = 1;
    fTc = 55;
    fTo = 23;

    fVc = 2;
    fVs = 1;

else           % DINOFLAGELLATE - eg Karlodinium
    k = 4.1102;
    a = 35.0623;
    b = 0.1071;
    v = 1.08;

    KP = 0.005; %g/m3
    KN = 0.045;

    fSa = 0.3;
    fSb = 1;
    fSc = 40;
    fSo = 25;

    fTa = 0.1;
    fTb = 1;
    fTc = 40;
    fTo = 28;

    fVc = 2;
    fVs = 3;
end


V = sqrt(power(V_x,2) + power(V_y,2));
%
%
%
% save hab.mat V Temp_Top Temp_bot Sal_Top Sal_Bot Amm Nit Frp -mat;

% load hab.mat

%------ stratification / velocity

strat = Sal_Bot - Sal_Top;
% ideally strat = dens(Sal_Bot,Temp_bot) - dens(Sal_Top,Temp_Top) ; but tell me if you do this

S = double(mean([Sal_Bot,Sal_Top],2));

mV = mean(V);
if mV < 0.05
    fV = 1;
else
    %fV = k*mV + n;
    fV = 1 - (mV*(fVc));
    fV(fV<0) = 0;
end
if (strat < fVs)
  fV = fV * ((fVs-strat)/fVs);
end


%------ salinity


if S < fSc   fS = fSb*exp(fSa*(S-fSo)) .* power(((fSc-S)/(fSc-fSo)),(fSa*(fSc-fSo)));

else
   fS = 0;
end



%------ temperature

T = double(Temp_Top);


% fT = v^(T-20)-v^(k*(T-a))+b;
%fT = power(v,T-20) - power(v,k*(T-a)) + b;

if T < (fTc)
   fT = fTb*exp(fTa*(T-fTo)) .* power ( ((fTc-T)/(fTc-fTo)),(fTa*(fTc-fTo)));
else
   fT = 0;
end


%------ nitrogen
N = max(Nit) + max(Amm);   % max in column
fN = N/(KN+N);

%------ phosphorus
P = max(Frp);%   max in column
fP = P/(KP+P);


%------ TOTAL RISK

hab = fV .* fS .* fT .* min(fN , fP);
