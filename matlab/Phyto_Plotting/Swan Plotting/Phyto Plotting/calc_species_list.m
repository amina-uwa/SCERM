function [out] = calc_species_list(data,site)

% data = swan_bio;
% site = 'ARM';

[sNum,sStr] = xlsread('../Data/Import Bio/Conversions/Alice_Headers_20151120.xlsx','A2:F1000');

old_headers = sStr(:,1);
new_headers = sStr(:,2);
group = sStr(:,3);
conv = sNum(:,3);


vars = fieldnames(data.(site));

cal.sum = [];
cal.aut = [];
cal.win = [];
cal.spr = [];

mon.sum = upper({'dec';'jan';'feb'});
mon.aut = upper({'mar';'apr';'may'});
mon.win = upper({'jun';'jul';'aug'});
mon.spr = upper({'sep';'oct';'nov'});

seasons = fieldnames(mon);

for i = 1:length(seasons)
    for j = 1:length(vars)
        
        for jj = 1:length(data.(site).(vars{j}).Date)
            m_month{jj} = datestr(data.(site).(vars{j}).Date(jj),'mmm');
        end
        
        ss = find(strcmpi(new_headers,vars{j}) == 1);
        
        if strcmpi(group{ss(1)},'Ignore') == 0
            for k = 1:length(mon.(seasons{i}))
                
                ttt = find(strcmpi(m_month,mon.(seasons{i}){k}) == 1);
                
                if ~isempty(ttt)
                    
                    if isfield(cal.(seasons{i}),vars{j})
                        
                        tdata = data.(site).(vars{j}).Cells(ttt);
                        tdata1 = data.(site).(vars{j}).Data(ttt);
                        cal.(seasons{i}).(vars{j}).total = cal.(seasons{i}).(vars{j}).total + sum(tdata(~isnan(tdata)));
                        cal.(seasons{i}).(vars{j}).mass = cal.(seasons{i}).(vars{j}).mass + sum(tdata1(~isnan(tdata1)));
                        clear tdata;
                    else
                        tdata = data.(site).(vars{j}).Data(ttt);
                        tdata1 = data.(site).(vars{j}).Data(ttt);
                        cal.(seasons{i}).(vars{j}).oldname = old_headers{ss(1)};
                        cal.(seasons{i}).(vars{j}).group = group{ss(1)};
                        
                        cal.(seasons{i}).(vars{j}).total = sum(tdata(~isnan(tdata)));
                        cal.(seasons{i}).(vars{j}).mass = sum(tdata1(~isnan(tdata1)));
                    end
                end
            end
        end
    end
end

%__________________________________________________________________________

for i = 1:length(seasons)
    vars = fieldnames(cal.(seasons{i}));
    ID = [];
    Cells = [];
    Group = [];
    for j = 1:length(vars)
        Cells(j) = cal.(seasons{i}).(vars{j}).total;
        ID{j} = cal.(seasons{i}).(vars{j}).oldname;
        Group{j} = cal.(seasons{i}).(vars{j}).group;
    end
    
    [out.(seasons{i}).Cells,ind] = sort(Cells,'descend');
    out.(seasons{i}).ID = ID(ind);
    out.(seasons{i}).Group = Group(ind);
    
end

for i = 1:length(seasons)
    vars = fieldnames(cal.(seasons{i}));
    mID = [];
    mCells = [];
    mGroup = [];

    for j = 1:length(vars)
        mCells(j) = cal.(seasons{i}).(vars{j}).mass;
        mID{j} = cal.(seasons{i}).(vars{j}).oldname;
        mGroup{j} = cal.(seasons{i}).(vars{j}).group;

    end
    
    [out.(seasons{i}).mCells,ind] = sort(mCells,'descend');
    out.(seasons{i}).mID = mID(ind);
    out.(seasons{i}).mGroup = mGroup(ind);
    
end
    
    
    



                    
                    
                
                
                
                
                
                
        
    
    
    










