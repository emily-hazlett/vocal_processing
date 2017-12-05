clear all

folderName = 'D:\Bat Vocalization Recordings\Good Calls\A0523_F_Mesh2_';
prefix = 'A0523_F_Mesh2_';
fileType = '.wav';

cd(folderName)
files = dir(['*',fileType]);

% Loop through each
for id = 1:length(files)
    % Get the file name (minus the extension)
    [~, f] = fileparts(files(id).name);

    renamer = [prefix,f,fileType];
    movefile(files(id).name, renamer);
end