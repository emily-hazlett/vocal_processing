% Opens .wav files in Avisoft (if set as default program) and allow the
% user to copy that file into different folders based on visual inspection
% of the characteristics of the call.
%
% Written by Emily Hazlett 01/07/2015
% Last edited EHazlett 01/22/2015

%-----------------------------------------------------------------------------------------------------
% Find folder to sort and either resume or start from beginning
%-----------------------------------------------------------------------------------------------------

% Ask if continuing to sort a folder
button = questdlg('Do you want to resume sorting a folder?', 'Session', 'New Session', 'Resume Folder', 'New Session');
switch button
    case 'New Session'
        session = 1;
    case 'Resume Folder';
        session = 0;
end
%-----------------------------------------------------------------------------------------------------
if session == 1 % If starting new session
    % User defines folder of files to sort and sets variables. Enter 'new' to create new folders within folder of files to sort
    prompt = {'Enter location of folder to sort','Enter destination folder of lower aggression calls', 'Enter destination folder of high aggression calls', 'Enter destination folder of excellent calls', 'Enter destination folder for junk calls'};
    dlg_title = 'Input';
    num_lines = 1;
    defAns = {'', 'new', 'new', 'new', 'new'};
    options.Resize='on';
    answer = inputdlg(prompt, dlg_title, num_lines, defAns, options);
    
    % Check if folders exist
    for k = 1:length(answer)
        if strcmp(answer(k,:),'new') == 0
            while exist(char(answer(k,:)), 'dir') ~= 7
                h = warndlg(['Warning! Folder in entry ' num2str(k) ' does not exist']);
                uiwait(h)
                answer = inputdlg(prompt, dlg_title, num_lines, defAns, options);
            end
        end
    end
    
    newFolder = char(answer(1,:));
    oldFolder = cd(newFolder);
    fileNames = ls('*.wav');
    
    % Creates any new folders and names variables
    n = strcmp(answer(2,:), 'new');
    if n == 1
        mkdir('Lower_Aggression')
        folderLower = [newFolder '\' 'Lower_Aggression'];
    else
        folderLower = char(answer(2,:));
    end
    
    n = strcmp(answer(3,:), 'new');
    if n == 1
        mkdir('High_Aggression')
        folderHigh = [newFolder '\' 'High_Aggression'];
    else
        folderHigh = char(answer(3,:));
    end
    
    n = strcmp(answer(4,:), 'new');
    if n == 1
        mkdir('Excellent')
        folderExcellent = [newFolder '\' 'Excellent'];
    else
        folderExcellent = char(answer(4,:));
    end
    
    n = strcmp(answer(5,:), 'new');
    if n == 1
        mkdir('Junk')
        folderJunk = [newFolder '\' 'Junk'];
    else
        folderJunk = char(answer(5,:));
    end
    
    clear n prompt dlg_title num_lines defAns answer
    
    % Cycle through files in folder starting from first file
    [m n] = size(fileNames);
    begin = 1;
    
    %-----------------------------------------------------------------------------------------------------
elseif session == 0 % If resuming old session
    % User defines folder that was being sorted
    prompt = {'Enter location of folder to sort'};
    dlg_title = 'Input';
    num_lines = 1;
    defAns = {'D:\MATLAB\'};
    answer = inputdlg(prompt, dlg_title, num_lines, defAns, options);
    
    % Check to see if that fodler exists and
    count = 0;
    while exist(char(answer(1,:)), 'dir') ~= 7
        h = warndlg('Warning! Folder does not exist');
        uiwait(h)
        answer = inputdlg(prompt, dlg_title, num_lines, defAns, options);
        count = count + 1;
        if count == 10
            return
        end
    end
    newFolder = char(answer(1,:));
    oldFolder = cd(newFolder);
    fileNames = ls('*.wav');
    
    % Check if destination folders are standard name or allow user to change
    folderLower = [newFolder '\' 'Lower_Aggression'];
    folderHigh = [newFolder '\' 'High_Aggression'];
    folderExcellent = [newFolder '\' 'Excellent'];
    folderJunk = [newFolder '\' 'Junk'];
    
    prompt = {'Enter location of folder to sort','Enter destination folder of lower aggression calls', 'Enter destination folder of high aggression calls', 'Enter destination folder of excellent calls', 'Enter destination folder for junk calls'};
    dlg_title = 'Input';
    num_lines = 1;
    defAns = {newFolder, folderLower, folderHigh, folderExcellent, folderJunk};
    answer = inputdlg(prompt, dlg_title, num_lines, defAns, options);
    
    % Check if folders exist
    for k = 1:length(answer)
        while exist(char(answer(k,:)), 'dir') ~= 7
            h = warndlg(['Warning! Folder in entry ' num2str(k) ' does not exist']);
            uiwait(h)
            answer = inputdlg(prompt, dlg_title, num_lines, defAns, options);
        end
    end
    
    % Find index of last file sorted
    prompt = {'Enter filename'};
    dlg_title = 'File that was exited on during last session (not yet sorted)';
    num_lines = 1;
    defAns = {'.wav'};
    answer = inputdlg(prompt, dlg_title, num_lines, defAns, options);
    
    [m n] = size(fileNames);
    count = 1;
    index = [];
    while isempty(index) == 1;
        index = strfind(lower(fileNames(count,:)), lower(char(answer(1,:))));
        count = count + 1;
        if count == m
            disp('Entered filename is not in selected folder')
            return
        end
    end
    begin = count -1;
else
    return
end

%-----------------------------------------------------------------------------------------------------
% Cycle through files in folder
%-----------------------------------------------------------------------------------------------------
% Set standard paramaters for input dialoug box
prompt = {'Copy to Lower Aggression folder?','Copy to High Aggression folder?', 'Copy to Excellent folder?' 'Copy to Junk folder?'};
dlg_title = 'Sort - Enter Y or N';
num_lines = 1;
defAns = {'n', 'n', 'n' 'n'};
accept = {'yes', '1', 'copy'};
for n = begin:m;  
    % Open file in Avisoft
    filename = fileNames(n,:);
    winopen(filename);
    pause(0.3);
    
    % Ask which folders to copy to
    answer = inputdlg(prompt, dlg_title, num_lines, defAns, options);
    
    % Catch in case dialouge box is accendentially closed or dongle missing
    while isempty(answer) == 1
        button = questdlg('Did you mean to stop sorting files?', 'Warning!', 'Yes', 'No', 'Missing dongle', 'No');
        switch button
            case 'Yes'
                disp(['Exited script on ' filename])
                return
            case'No'
                answer = inputdlg(prompt, dlg_title, num_lines, defAns, options);
            case 'Missing dongle'
                winopen(filename);
                answer = inputdlg(prompt, dlg_title, num_lines, defAns, options);
        end
    end
    
    % Copy to selected folders
    copyLower = lower(char(answer(1,:)));
    copyHigh = lower(char(answer(2,:)));
    copyExcellent = lower(char(answer(3,:)));
    copyJunk = lower(char(answer(4,:)));
    
    if any(cell2mat(strfind(accept, copyLower))) == 1
        copyfile(filename,folderLower);
    end
    
    if any(cell2mat(strfind(accept, copyHigh))) == 1
        copyfile(filename,folderHigh);
    end
    
    if any(cell2mat(strfind(accept, copyExcellent))) == 1
        copyfile(filename,folderExcellent);
    end
    
    if any(cell2mat(strfind(accept, copyJunk))) == 1
        copyfile(filename,folderJunk);
    end
    
    clear filename answer
    status = dos('taskkill /F /IM SASLAB32.exe');
end