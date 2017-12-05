% Brings in a list of filenames saved as an ascii file in order to copy
% selected files to a new location
%
% Written by Emily Hazlett 01/07/2015
% Last Editted by EHazlett 01/22/2015

% Enter in file to inport and destination folder
prompt = {'Enter filename to inport','Enter destination folder location'};
dlg_title = 'Input';
num_lines = 1;
defAns = {'D:\MATLAB\', 'new'};
options.Resize='on';
answer = inputdlg(prompt, dlg_title, num_lines, defAns, options);

% Check if manually entered text exist, otherwise warn and try again
while exist(char(answer(1,:)), 'file') ~= 2
    h = warndlg('Warning! Text file does not exist');
    uiwait(h)
    answer = inputdlg(prompt, dlg_title, num_lines, defAns, options);
end

defAns = {char(answer(1,:)), 'new'};

if strcmp(answer(2,:),'new') == 0
    while exist(char(answer(2,:)), 'dir') ~= 7
        h = warndlg('Warning! Folder does not exist');
        uiwait(h)
        answer = inputdlg(prompt, dlg_title, num_lines, defAns, options);
    end
end
clear prompt dlg_title num_lines defAns

fileNames = importdata(char (answer(1,:)));
n = strcmp(answer(2,:), 'new');
if n == 1
    mkdir('Files on List')
    locationNew = [cd '\' 'Files on List'];
else
    locationNew = char(answer(2,:));
end

% Copy files on list to destination folder
for n = 1:length(fileNames);
    filename = char(fileNames(n,:));
    copyfile(filename,locationNew);
end

clear n locationNew fileNames filename answer