% This script sets up the DAFWA download and file creation. See
% weatherstations.csv for Site information.
% This script requires Matlab 2014a to run.

Site_ID = 'SP';

data_dir = 'SP_2019/';

data_file = 'SP_2019.mat';

year_array = [2007:01:2020];

metfile = 'SP_2019/SP_Met_2007_2019.csv';
rainfile = 'SP_2019/SP_Rain_2007_2019.csv';
imagefile = 'SP_2019/SP_2007_2019';



% End of Configuration______________________________________

Download_DAFWA_Met_Data_v1(Site_ID,data_dir,year_array);

import_DAFWA_MET_Data(data_dir,data_file);

create_TFV_Met_From_DAFWA(metfile,rainfile,imagefile,data_file)