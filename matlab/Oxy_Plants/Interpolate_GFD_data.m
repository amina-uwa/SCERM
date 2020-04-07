clear all; close all;

date_int = 10 / (60 * 24);
check_int = 5 / (60 * 24);

all_dates = [];
all_flow = [];
all_oxy = [];

load Matfiles/GFD_2009.mat;

all_dates = [all_dates;mdate];
all_flow = [all_flow;flow_ind];
all_oxy = [all_oxy;Oxygen];

load Matfiles/GFD_2010.mat;

all_dates = [all_dates;mdate];
all_flow = [all_flow;flow_ind];
all_oxy = [all_oxy;Oxygen];


load Matfiles/GFD_2011.mat;

all_dates = [all_dates;mdate];
all_flow = [all_flow;flow_ind];
all_oxy = [all_oxy;Oxygen];

clear mdate flow_ind Oxygen;

load Matfiles/GFD_2012.mat;

all_dates = [all_dates;mdate];
all_flow = [all_flow;flow_ind];
all_oxy = [all_oxy;Oxygen];

clear mdate flow_ind Oxygen;

load Matfiles/GFD_2013.mat;

all_dates = [all_dates;mdate];
all_flow = [all_flow;flow_ind];
all_oxy = [all_oxy;Oxygen];

clear mdate flow_ind Oxygen;

load Matfiles/GFD_2014.mat;

all_dates = [all_dates;mdate];
all_flow = [all_flow;flow_ind];
all_oxy = [all_oxy;Oxygen];

clear mdate flow_ind Oxygen;

load Matfiles/GFD_2016.mat;

all_dates = [all_dates;mdate];
all_flow = [all_flow;flow_ind];
all_oxy = [all_oxy;Oxygen];

clear mdate flow_ind Oxygen;

load Matfiles/GFD_2017.mat;

all_dates = [all_dates;mdate];
all_flow = [all_flow;flow_ind];
all_oxy = [all_oxy;Oxygen];

clear mdate flow_ind Oxygen;

load Matfiles/GFD_2018.mat;

all_dates = [all_dates;mdate];
all_flow = [all_flow;flow_ind];
all_oxy = [all_oxy;Oxygen];

clear mdate flow_ind Oxygen;

% Attempt of filling missing data with 0 flow.....

datearray(:,1) = min(all_dates): date_int : max(all_dates);

filled_flow(1:length(datearray),1) = 0;

filled_oxygen(1:length(datearray),1) = 0;

matched_data(1:length(datearray),1) = 0;


disp('Starting filling routine');


for i = 1:length(all_dates)
    
    % find the closest date array
    [~,ind] = min(abs(datearray - all_dates(i)));
    
    % check that the dates are less than 5 minutes apart
    if abs(datearray(ind) - all_dates(i)) < check_int
        
        filled_flow(ind) = all_flow(i);
        filled_oxygen(ind) = all_oxy(i);
        matched_data(ind) = 1;

    end
    
    if i == 50000
        disp(['25% Completed']);
    end
    if i == 100000
        disp(['50% Completed']);
    end
    
    if i == 150000
        disp(['75% Completed']);
    end
    
end

num_dates = length(all_dates);

ss = find(isnan(all_dates));

total_nans = length(ss);

ss = find(matched_data == 1);

matched = length(ss);

total_matched = matched + total_nans;

perc_matched = (matched / length(matched_data)) * 100;

disp(['Percentage of total interped data from matched data: ',num2str(perc_matched)]);

save Interp_GFD.mat filled_flow filled_oxygen datearray matched_data -mat -v7.3













