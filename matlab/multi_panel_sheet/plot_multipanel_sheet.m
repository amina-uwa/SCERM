clear all; close all;

addpath(genpath('../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));

ncfile = 'Z:\SCERM_HFP\Output\swan_helena_v4i_NAR_MSB.nc';

dat = tfv_readnetcdf(ncfile,'time',1);


pdate = [datenum(2008,01,20) datenum(2008,05,10)];

for i = 1:length(pdate)
    [~,ts(i)] = min(abs(dat.Time - pdate(i)));
end

data1 = tfv_readnetcdf(ncfile,'timestep',ts(1));
data2 = tfv_readnetcdf(ncfile,'timestep',ts(2));

vert(:,1) = data1.node_X;
vert(:,2) = data1.node_Y;
faces = data1.cell_node';
%--% Fix the triangles
faces(faces(:,4)== 0,4) = faces(faces(:,4)== 0,1);


sal1 = data1.SAL;
dep1 = data1.D;

ssss = find(dep1 < 0.02);

sal1(ssss) = NaN;
dep1(ssss) = NaN;


sal2 = data2.SAL;
dep2 = data2.D;

ssss = find(dep2 < 0.02);

sal2(ssss) = NaN;
dep2(ssss) = NaN;

figure('position',[680   387   718   591]);

axes('position',[0 0.5 0.5 0.5])


%mapshow('../Salt_HSI_Calc/GIS/Background.png');hold on

fig.ax = patch('faces',faces,'vertices',vert,'FaceVertexCData',sal1);shading flat;hold on
  axis off; axis equal;
xlim([401089.16300969          402731.199984315]);
ylim([6469208.45813874          6470432.30352783]);
caxis([0 35]);

      
cb = colorbar('position',[0.35 0.75 0.01 0.2]);
title(cb,'Salinity (psu)');

text(0.1,0.8,datestr(dat.Time(ts(1)),'dd/mm/yyyy'),'fontsize',8,'units','normalized');

axes('position',[0.5 0.5 0.5 0.5])
%mapshow('../Salt_HSI_Calc/GIS/Background.png');hold on

fig.ax = patch('faces',faces,'vertices',vert,'FaceVertexCData',dep1);shading flat;hold on

caxis([0 1]);
  axis off; axis equal;box on
xlim([401089.16300969          402731.199984315]);
ylim([6469208.45813874          6470432.30352783]);

cb = colorbar('position',[0.85 0.75 0.01 0.2]);
title(cb,'Depth (m)');

text(0.1,0.8,datestr(dat.Time(ts(1)),'dd/mm/yyyy'),'fontsize',8,'units','normalized');

%____________________________________________________________________

axes('position',[0 0 0.5 0.5])


%mapshow('../Salt_HSI_Calc/GIS/Background.png');hold on

fig.ax = patch('faces',faces,'vertices',vert,'FaceVertexCData',sal2);shading flat;hold on
  axis off; axis equal;
xlim([401089.16300969          402731.199984315]);
ylim([6469208.45813874          6470432.30352783]);
caxis([0 35]);

 cb = colorbar('position',[0.35 0.3 0.01 0.2]);
title(cb,'Salinity (psu)');     

text(0.1,0.8,datestr(dat.Time(ts(2)),'dd/mm/yyyy'),'fontsize',8,'units','normalized');


axes('position',[0.5 0 0.5 0.5])
%mapshow('../Salt_HSI_Calc/GIS/Background.png');hold on

fig.ax = patch('faces',faces,'vertices',vert,'FaceVertexCData',dep2);shading flat;hold on

caxis([0 1]);
  axis off; axis equal;
xlim([401089.16300969          402731.199984315]);
ylim([6469208.45813874          6470432.30352783]);

cb = colorbar('position',[0.85 0.3 0.01 0.2]);
title(cb,'Depth (m)');
text(0.1,0.8,datestr(dat.Time(ts(2)),'dd/mm/yyyy'),'fontsize',8,'units','normalized');

saveas(gcf,'Multisheet_Helena.png');
