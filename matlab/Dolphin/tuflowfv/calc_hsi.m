function wqi = calc_hsi(oxy,tchla,tn,tp)
%
oxy = oxy * 32/1000;
%
tn = tn * 14/1000;
tp = tp * 31/1000;



% save hsi.mat oxy tchla tn tp -mat;

% load hsi.mat
%
% oxy(1:3) = oxy(1:3) - 4;
% oxy1 = oxy.WQ_OXY_OXY.Bot(d_chx,day_array(l));
% tchla1 = tchla.WQ_DIAG_PHY_TCHLA.Top(d_chx,day_array(l));
% tn1 = max(tn.WQ_DIAG_TOT_TN.Bot(d_chx,day_array(l)),tn.WQ_DIAG_TOT_TN.Top(d_chx,day_array(l)));
% tp1 = max(tp.WQ_DIAG_TOT_TP.Bot(d_chx,day_array(l)),tp.WQ_DIAG_TOT_TP.Top(d_chx,day_array(l)));
%
% clear oxy tychla tn tp

% oxy = oxy1* 32/1000;
% tchla = tchla1;
% tn = tn1;
% tp = tp1;
%
% oxy = oxy - 4;
%assumes oxy, tchla, tn, tp vectors
%oxy = oxy * 32/1000;
%BOTTOM
do_trigger = 5;  do_wev = 2;
do_exceed = length(find(oxy(:) < do_trigger)) / length(oxy);      % fraction of entries > trigger
%oxy(:) = max(min(oxy(:),do_wev),do_trigger);
oxy(oxy < do_wev) = do_wev;
oxy(oxy > do_trigger) = do_trigger;
% clip entries to wev or trigger
oooo = find(oxy < do_trigger);
if ~isempty(oooo)% find exceedences
    do_distance = mean((do_trigger-oxy(oooo))./(do_trigger-do_wev));  % distance severity above the trigger
    oo = sqrt(do_exceed*do_distance);
else
    oo = 0;
end


%SURFACE
chla_trigger = 3;  chla_wev = 40;
chla_exceed = length(find(tchla(:) > chla_trigger)) / length(tchla);
%tchla(:) = max(min(tchla(:),chla_wev),chla_trigger);
tchla(tchla > chla_wev) = chla_wev;
tchla(tchla < chla_trigger) = chla_trigger;

cccc = find(tchla > chla_trigger);
if ~isempty(cccc)% find exceedences
    chla_distance = mean((tchla(cccc)-chla_trigger)./(chla_wev-chla_trigger));
    cc = sqrt(chla_exceed*chla_distance);
else
    cc = 0;
end

%MAX
tn_trigger = 0.5;  tn_wev = 2;
tn_exceed = length(find(tn(:) > tn_trigger)) / length(tn);
%tn(:) = max(min(tn(:),tn_wev),tn_trigger);
tn(tn > tn_wev) = tn_wev;
tn(tn < tn_trigger) = tn_trigger;

nnnn = find(tn > tn_trigger);
if ~isempty(nnnn)% find exceedences
    tn_distance = mean((tn(nnnn)-tn_trigger)./(tn_wev-tn_trigger));
    nn = sqrt(tn_exceed*tn_distance);
else
    nn = 0;
end




%MAX
tp_trigger = 0.025;  tp_wev = 0.15;
tp_exceed = length(find(tp(:) > tp_trigger)) / length(tp);
%tp(:) = max(min(tp(:),tp_wev),tp_trigger);
tp(tp > tp_wev) = tp_wev;
tp(tp < tp_trigger) = tp_trigger;
pppp = find(tp > tp_trigger);
if ~isempty(pppp)% find exceedences
    tp_distance = mean((tp(pppp)-tp_trigger)./(tp_wev-tp_trigger));
    pp = sqrt(tp_exceed*tp_distance);
else
    pp = 0;
end



wqi = 0.33*(1-cc) + 0.33*(1-oo) + 0.17*(1-nn) + 0.17*(1-pp) ;
