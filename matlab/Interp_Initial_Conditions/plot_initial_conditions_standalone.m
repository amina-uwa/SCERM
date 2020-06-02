clear all; close all;
addpath(genpath('functions'));

[XX,YY,nodeID,faces,newX,newY,ID] = tfv_get_node_from_2dm('swan_helena_v04a_NAR_MSB.2dm');

vert(:,1) = XX;
vert(:,2) = YY;

[data,headers] = xlsread('new/IC_a_NAR_MSB.csv');

outdir = 'Images/';
    mkdir(outdir);



for i = 1:length(headers)
    
    figure
    
    axes('position',[0.05 0.05 0.4 0.8]);
    
    cdata = data(:,i);
    fig.ax = patch('faces',faces','vertices',vert,'FaceVertexCData',cdata);shading flat
    axis equal
    
    set(gca,'Color','None',...
        'box','on');
    
    set(findobj(gca,'type','surface'),...
        'FaceLighting','phong',...
        'AmbientStrength',.3,'DiffuseStrength',.8,...
        'SpecularStrength',.9,'SpecularExponent',25,...
        'BackFaceLighting','unlit');
    
    axis off
    set(gca,'box','off');
    
    
    cb = colorbar;
    
    set(cb,'position',[0.45 0.2 0.01 0.4],...
        'units','normalized');
    
   
    
    text(0.2,0.95,regexprep(headers{i},'_',' '),...
        'Units','Normalized',...
        'Fontname','Candara',...
        'Fontsize',16);
    
    
    set(gcf, 'PaperPositionMode', 'manual');
    set(gcf, 'PaperUnits', 'centimeters');
    xSize = 18;
    ySize = 10;
    xLeft = (21-xSize)/2;
    yTop = (30-ySize)/2;
    set(gcf,'paperposition',[0 0 xSize ySize])
    
    print(gcf,'-dpng',[outdir,headers{i},'.png'],'-opengl');
    
    close;
    
end