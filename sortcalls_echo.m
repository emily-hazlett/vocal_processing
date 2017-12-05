% Opens .wav files in Avisoft (if set as default program) and allow the
% user to copy that file into different folders based on visual inspection
% of the characteristics of the call.
%
% Written by Emily Hazlett 01/07/2015


% User defines folder of files to sort and sets variables. Enter 'new' to create new folders within folder of files to sort
prompt = {'Enter location of folder to sort','Enter destination folder of echo calls'};
dlg_title = 'Input';
num_lines = 1;
defAns = {'D:\Bat Vocalizations\bat1_10cm_held_1_1\Second detection\All calls\Not normalized', 'D:\Bat Vocalizations\bat1_10cm_held_1_1\Second detection\Echo analysis'};
answer = inputdlg(prompt, dlg_title, num_lines, defAns);

% Check if manually entered files exist, otherwise warn and try again
% for k = 1:length(answer)
%     if strcmp(answer(k,:),'new') == 0
%         while not(exist(char(answer(1,:)), 'file') == 2 | 7) == 0
%             h = warndlg(['Warning! File in entry ' num2str(k) ' does not exist']);
%             uiwait(h)
%             answer = inputdlg(prompt, dlg_title, num_lines, defAns);
%         end
%     end
% end

newFolder = char(answer(1,:));
oldFolder = cd(newFolder);
fileNames = ls('*.wav');

% Creates any new folders and names variables
n = strcmp(answer(2,:), 'new');
if n == 1
    mkdir('Echo Calls')
    folderLower = [newFolder '\' 'Echo'];
else
    folderLower = char(answer(2,:));
end
clear n prompt dlg_title num_lines defAns answer

% Cycle through files in folder
[m,n] = size(fileNames);
for n = 1:m;
    filename = fileNames(n,:);
    winopen(filename);
   
    running = [];
    failSafe = 0;
    if isempty(running) == 1 && failSafe < 1000
        [status result] = system( 'tasklist /FI "IMAGENAME eq SASLAB32.EXE"');
        running = strfind(lower(result), lower('SASLAB32.EXE'));
        failSafe = failSafe + 1;
    elseif failSafe == 100
        warndlg('Warning! Avisoft is not opening')
        return
    end
    
    prompt = {'Copy to Echo Folder?'};
    dlg_title = 'Sort - Enter Y or N';
    num_lines = 1;
    answer = inputdlg(prompt, dlg_title, num_lines);
    
    if isempty(answer) == 1
        disp(['Exited script on ' filename])
        return
    end
    
    copyEcho = char(answer(1,:));
    clear prompt dlg_title num_lines answer
    
    if copyEcho == 'y'
        copyfile(filename,folderLower);
    end
    
    clear filename
    status = dos('taskkill /F /IM SASLAB32.exe');
end