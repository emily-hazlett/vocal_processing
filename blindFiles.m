% This script takes the contents of a specified folder, and copies them into
% a new folder with a blinded filename.  This is to aid in scoring of files
% without experimenter bias.  A key of original and blinded filenames is
% saved as a read-only ASCII file.
%
% Created 2017-12-05 by EHazlett

%% User edited information

% Name of folder containing files to be renamed
folder = 'C:\Data Processing\Vocalization Files to be Renamed';

% Base of blinded name, should contain information about the experiment
blindedbase = 'TinnitusMicePrePostExposureSummer2017';

% Type of file to be moved
filetype = '.wav';

%% Find files
cd(folder)
Files = dir(['*', filetype]);
Changer.originalName = {Files.name}';
nFiles = length(Changer.originalName);

%% Create blinded names
suffix = 1:nFiles;
suffix = cellstr(num2str(suffix(randperm(nFiles))'));
Changer.blindedName = [repmat([blindedbase, '_'], nFiles, 1), cell2mat(suffix), repmat(filetype, nFiles, 1)];

%% Rename files
newFolder = [folder, '\Renamed Files'];
mkdir(newFolder)

for i = 1:nFiles
    status = copyfile(cell2mat(Changer.originalName(i)), newFolder);
    switch status
        case 0
            disp('file didnt copy properly')
        case 1
            cd(newFolder)
            movefile(cell2mat(Changer.originalName(i)),Changer.blindedName(i,:));
            cd(folder)
    end
end

%% Save key
cd(newFolder)
key = struct2table(Changer);
keyName = ['Blinded_File_Key_for_', blindedbase, '.txt'];
writetable(key, keyName, 'Delimiter', 'tab');
fileattrib(keyName, '-w')
cd(folder)

