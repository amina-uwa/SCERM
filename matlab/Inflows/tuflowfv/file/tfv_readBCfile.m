function data = tfv_readBCfile(filename)
%--% a simple function to read in a TuflowFV BC file and return a
%structured type 'data', justing the headers as variable names.
%
% Created by Brendan Busch

if ~exist(filename,'file')
    disp('File Not Found');
    return
end

data = [];

fid = fopen(filename,'rt');

sLine = fgetl(fid);

headers = regexp(sLine,',','split');
headers = regexprep(headers,'\s','');
EOF = 0;
inc = 1;

% The actual data import.__________________________________________________
frewind(fid)
x  = length(headers);
textformat = [repmat('%s ',1,x)];
% read single line: number of x-values
datacell = textscan(fid,textformat,'Headerlines',1,'Delimiter',',');
fclose(fid);

dateformatlong = 'dd/mm/yyyy HH:MM';

% Data Processing__________________________________________________________
for i = 1:length(headers)
    
    if i == 1
        data.Date(:,1) = datenum(datacell{1},dateformatlong);
    else
        data.(headers{i})(:,1) = str2doubleq(datacell{i});
    end
end

%  while ~EOF
%
%     sLine = fgetl(fid);
%
%     if sLine == -1
%         EOF = 1;
%     else
%         dataline = regexp(sLine,',','split');
%
%         for ii = 1:length(headers);
%
%             if strcmpi(headers{ii},'ISOTime')
%                 data.Date(inc,1) = datenum(dataline{ii},...
%                                         'dd/mm/yyyy HH:MM');
%             else
%                 data.(headers{ii})(inc,1) = str2double(dataline{ii});
%             end
%         end
%         inc = inc + 1;
%     end
% end


