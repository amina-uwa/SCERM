function [V_x,V_y,Temp_Top,Temp_bot,Sal_Top,Sal_Bot,Amm,Nit,Frp] = do_mean(V_x1,V_y1,Temp_Top1,Temp_bot1,Sal_Top1,Sal_Bot1,Amm1,Nit1,Frp1)

V_x = mean(V_x1);
V_y = mean(V_y1);
Temp_Top = mean(Temp_Top1);
Temp_bot = mean(Temp_bot1);
Sal_Top = mean(Sal_Top1);
Sal_Bot = mean(Sal_Bot1);
Amm = mean(Amm1);
Nit = mean(Nit1);
Frp = mean(Frp1);