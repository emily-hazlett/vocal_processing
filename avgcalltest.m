% Checks if .wav files of calls meet statistics for typical exemplars
%
% Avisoft output columns format
%
% 1) element number 2) duration 3) interval 4) start time 5) end time
% 6) fundamental(start) 7) bandw(start) 8) fundamental (end)
% 9) bandw(end) 10) fundamental(max) 11) bandw(max)
%
% Avisoft output needs to be manipulated in Excel. Seconds need to be
% converted to ms, and empty cells inficated with '-' need to be replaced
% with 0.
%
% Written by Emily Hazlett 01/08/2015
% Last Editted by EHazlett 01/22/2015

% ----------------------------------------------------------------------------------------------------------------
% Conditions that are being tested
% ----------------------------------------------------------------------------------------------------------------
button = questdlg('Which conditions do you want to test?', 'Conditions', 'BBN calls', 'Lower Agg Calls', 'Both', 'Both');
switch button
    case 'BBN calls'
        condition = 1;
    case 'Lower Agg Calls'
        condition = 2;
    case 'Both'
        condition = 3;
end

% ----------------------------------------------------------------------------------------------------------------
% Conditions that are being tested
% ----------------------------------------------------------------------------------------------------------------

% Values for first condition being tested
nameConditionOne = 'BBN calls';
numstatsConditionOne = 4;
headerConditionOne = {'Filenames' 'Syll/ Call' 'Total Dur' 'Syll Dur' 'BW - max' '' 'Syll/ Call' 'Total Dur' 'Syll Dur' 'BW - max'};

% Total Call stats
% Syllables per call
spcConditionOne1 = [2 2];
spcConditionOne2 = [2 5];
spcConditionOne3 = [2 6];
% Total Call Duration
totaldurConditionOne1 = [44.6 100.4];
totaldurConditionOne2 = [30 150];
totaldurConditionOne3 = [25 200];

% Syllable stats
% Syllable duration
sylldurConditionOne1 = [10 25 ];
sylldurConditionOne2 = [7 30];
sylldurConditionOne3= [5 30];
% Bandwidth
bwConditionOne1 = [47300 100000];
bwConditionOne2 = [43920 100000];
bwConditionOne3 = [40550 100000];

% ----------------------------------------------------------------------------------------------------------------

% Values for second condition being tested
nameConditionTwo = 'Lower Agg calls';
numstatsConditionTwo = 4;
headerConditionTwo = {'Filenames' 'Syll/ Call' 'repRate' 'Total Dur' 'Is DFM' '' 'Syll/ Call' 'repRate' 'Total Dur' 'Is DFM'};

% Totall Call stats
% Syllables per call
spcConditionTwo1 = [4 15];
spcConditionTwo2 = [4 20];
spcConditionTwo3 = [4 25];
% Rep Rate
repConditionTwo1 = [54.9 100.1];
repConditionTwo2 = [98 124.4];
repConditionTwo3 = [100.11 97.99];
% Total duration
totaldurConditionTwo1 = [0 120];
totaldurConditionTwo2 = [0 150];
totaldurConditionTwo3 = [0 170];

% Syllable stats
% Syllable is DFM

% ----------------------------------------------------------------------------------------------------------------
% Import ascii file and set locations
% ----------------------------------------------------------------------------------------------------------------
prompt = {'Enter location of ASCII file with Avisoft output', 'Enter location of ASCII file with filename information', ['Enter folder for ' nameConditionOne], ['Enter folder for ' nameConditionTwo], 'Enter location of parent folder for new folders'};
dlg_title = 'Input';
num_lines = 1;
defAns = {'\Numerical Output.txt', '\Name Output.txt', 'new', 'new', cd};
options.Resize='on';
answer = inputdlg(prompt, dlg_title, num_lines, defAns, options);

% Check if manually entered files exist, otherwise warn and try again

while exist(char(answer(1,:)), 'file') ~= 2
    h = warndlg('Warning! First text file does not exist');
    uiwait(h)
    answer = inputdlg(prompt, dlg_title, num_lines, defAns);
end

avisoftAscii = char(answer(1,:));
defAns = {avisoftAscii, 'D:\MATLAB\', 'new', 'new'};

while exist(char(answer(2,:)), 'file') ~= 2
    h = warndlg('Warning! Second text file does not exist');
    uiwait(h)
    answer = inputdlg(prompt, dlg_title, num_lines, defAns, options);
end

filenameAscii = char(answer(2,:));
defAns = {avisoftAscii, filenameAscii, 'new', 'new'};

for k = 3:length(answer)
    if strcmp(answer(k,:),'new') == 0
        if strcmp(answer(k,:),'none') == 0
            while exist(char(answer(k,:)), 'dir') ~= 7
                h = warndlg(['Warning! Folder in entry ' num2str(k) ' does not exist']);
                uiwait(h)
                answer = inputdlg(prompt, dlg_title, num_lines, defAns, options);
            end
        end
    end
end

parentFolder = char(answer(5,:));
callNum = importdata(avisoftAscii);
callName =  importdata(filenameAscii);

% Make or set folders for copied files, don't if marked 'none'
n = strcmp(answer(3,:), 'none');
if n ==1
    location1ConditionOne = 'none';
    location2ConditionOne = 'none';
    location3ConditionOne = 'none';
else
    n = strcmp(answer(3,:), 'new');
    if n == 1
        mkdir([parentFolder '\' nameConditionOne '\' 'First limit'])
        mkdir([parentFolder '\' nameConditionOne '\' 'Second limit'])
        mkdir([parentFolder '\' nameConditionOne '\' 'Third limit'])
        location1ConditionOne = [parentFolder '\' nameConditionOne '\' 'First limit'];
        location2ConditionOne = [parentFolder '\' nameConditionOne '\' 'Second limit'];
        location3ConditionOne = [parentFolder '\' nameConditionOne '\' 'Third limit'];
    else
        location1ConditionOne = [char(answer(3,:)) '\' 'First limit'];
        location2ConditionOne = [char(answer(3,:)) '\' 'Second limit'];
        location3ConditionOne = [char(answer(3,:)) '\' 'Third limit'];
    end
end

n = strcmp(answer(4,:), 'none');
if n ==1
    location1ConditionTwo = 'none';
    location2ConditionTwo = 'none';
    location3ConditionTwo = 'none';
else
    n = strcmp(answer(4,:), 'new');
    if n == 1
        mkdir([parentFolder '\' nameConditionTwo '\' 'First limit'])
        mkdir([parentFolder '\' nameConditionTwo '\' 'Second limit'])
        mkdir([parentFolder '\' nameConditionTwo '\' 'Third limit'])
        location1ConditionTwo = [parentFolder '\' nameConditionTwo '\' 'First limit'];
        location2ConditionTwo = [parentFolder '\' nameConditionTwo '\' 'Second limit'];
        location3ConditionTwo = [parentFolder '\' nameConditionTwo '\' 'Third limit'];
    else
        location1ConditionTwo = [char(answer(3,:)) '\' 'First limit'];
        location2ConditionTwo = [char(answer(3,:)) '\' 'Second limit'];
        location3ConditionTwo = [char(answer(3,:)) '\' 'Third limit'];
    end
end

clear n prompt dlg_title num_lines defAns answer

% ----------------------------------------------------------------------------------------------------------------
% Find index of where calls start and stop
% ----------------------------------------------------------------------------------------------------------------
[m n] = size(callNum);
callsIndex = zeros(m,2);

syllableStart = 1;
syllableEnd = 2;
q = 1;

while syllableEnd <= m
    if any(cell2mat(strfind(lower(callName(syllableEnd,:)),'.wav'))) == 1
        callsIndex(q,1) = syllableStart;
        callsIndex(q,2) = syllableEnd - 1;
        syllableStart = syllableEnd;
        syllableEnd = syllableEnd + 1;
        q = q+1;
    elseif syllableEnd == m
        callsIndex(q,1) = syllableStart;
        callsIndex(q,2) = syllableEnd;
        syllableEnd = syllableEnd + 1;
        q = q+1;
    else
        syllableEnd = syllableEnd + 1;
    end
end

callsIndex = callsIndex(1:q-1,:);
clear syllable* test

% Create output matrices for BNB and lower agg testing
copy1ConditionOne {length(callsIndex),1} = [];
copy2ConditionOne {length(callsIndex),1} = [];
copy3ConditionOne {length(callsIndex),1} = [];

copy1ConditionTwo {length(callsIndex),1} = [];
copy2ConditionTwo {length(callsIndex),1} = [];
copy3ConditionTwo {length(callsIndex),1} = [];

limit1ConditionOne = zeros (m, numstatsConditionOne);
limit2ConditionOne = zeros (m, numstatsConditionOne);
limit3ConditionOne = zeros (m, numstatsConditionOne);

limit1ConditionTwo = zeros (m, numstatsConditionTwo);
limit2ConditionTwo = zeros (m, numstatsConditionTwo);
limit3ConditionTwo = zeros (m, numstatsConditionTwo);

valuesConditionOne = zeros (m, numstatsConditionOne);
valuesConditionTwo = zeros (m, numstatsConditionTwo);

clear m n numstats*

% ----------------------------------------------------------------------------------------------------------------
% Test statistics for condition One
% ----------------------------------------------------------------------------------------------------------------

% Test each call
for q = 1:length(callsIndex)
    % test within 3 deviations from limits for condition one
    first = callsIndex(q,1);
    last = callsIndex(q,2);
    numSyll = last-first + 1;
    valuesConditionOne (first, 1) = numSyll;
    valuesConditionTwo (first, 1) = numSyll;
    
    passConditionOne = [1, 1, 1, 1];
    passConditionTwo = [1, 1, 1, 1];
    
    % ----------------------------------------------------------------------------------------------------------------
    % Condition One
    % ----------------------------------------------------------------------------------------------------------------
    
    % Syllables per call
    if numSyll >= spcConditionOne1(1,1) && numSyll <= spcConditionOne1(1,2)
        limit1ConditionOne (first, 1) = 1;
    else
        passConditionOne (1,1) = 2;
        if numSyll >= spcConditionOne2(1,1) && numSyll <= spcConditionOne2(1,2)
            limit2ConditionOne (first, 1) = 1;
        else
            passConditionOne (1,1) = 3;
            if numSyll >= spcConditionOne3(1,1) && numSyll <= spcConditionOne3(1,2)
            else
                if numSyll >= spcConditionOne3(1,1) && numSyll <= spcConditionOne3(1,2)
                    limit3ConditionOne (first, 1) = 1;
                else
                    passConditionOne (1,1) = 4;
                end
            end
        end
    end
          
    % Total call duration
    test = callNum(last, 5) - callNum (first, 4);
    valuesConditionOne (first, 2) = test;
    if   test >= totaldurConditionOne1(1,1) && test <= totaldurConditionOne1(1,2)
        limit1ConditionOne (first, 3) = 1;
    else
        passConditionOne (1,3) = 2;
        if test >= totaldurConditionOne2(1,1) && test <= totaldurConditionOne2(1,2)
            limit2ConditionOne (first, 3) = 1;
        else
            passConditionOne (1,3) = 3;
            if test >= totaldurConditionOne2(1,1) && test <= totaldurConditionOne2(1,2)
                limit2ConditionOne (first, 3) = 1;
            else
                passConditionOne (1,3) = 4;
            end
        end
    end
    
    % Syllable duration
    for w = first:last
        valuesConditionOne (w, 3) = callNum(w,2);
        if callNum(w,2) >= sylldurConditionOne1(1,1) && callNum(w,2) <= sylldurConditionOne1(1,2)
            limit1ConditionOne (w, 3) = 1;
        else
            passConditionOne (1,3) = 2;
            if callNum(w,2) >= sylldurConditionOne2(1,1) && callNum(w,2) <= sylldurConditionOne2(1,2)
                limit2ConditionOne (w, 3) = 1;
            else
                passConditionOne (1,3) = 3;
                if callNum(w,2) >= sylldurConditionOne3(1,1) && callNum(w,2) <= sylldurConditionOne3(1,2)
                    limit3ConditionOne (w, 3) = 1;
                else
                    passConditionOne (1,3) = 4;
                end
            end
        end
    end
    
    % Bandwidth
    for w = first:last
        valuesConditionOne (w, 4) = callNum(w,11);
        if callNum(w,11) >= bwConditionOne1(1,1) && callNum(w,11) <= bwConditionOne1(1,2)
            limit1ConditionOne (w, 4) = 1;
        else
            passConditionOne (1,4) = 2;
            if callNum(w,11) >= bwConditionOne2(1,1) && callNum(w,11) <= bwConditionOne2(1,2)
                limit2ConditionOne (w, 4) = 1;
            else
                passConditionOne (1,4) = 3;
                if callNum(w,11) >= bwConditionOne3(1,1) && callNum(w,11) <= bwConditionOne3(1,2)
                    limit3ConditionOne (w, 4) = 1;
                else
                    passConditionOne (1,4) = 4;
                end
            end
        end
    end
    
    % Copy file to appropriate folder
    if all(passConditionOne==1)
            copy1ConditionOne{q,1} = callName(first,1);
       elseif all(passConditionOne<3)
            copy2ConditionOne{q,1} = callName(first,1);
        elseif all(passConditionOne<4)
            copy3ConditionOne{q,1} = callName(first,1);
    end
    
    % ----------------------------------------------------------------------------------------------------------------
    % Condition Two
    % ----------------------------------------------------------------------------------------------------------------
    
    % Syllables per call
    if numSyll >= spcConditionTwo1(1,1) && numSyll <= spcConditionTwo1(1,2)
        limit1ConditionTwo (first, 1) = 1;
    else
        passConditionTwo (1,1) = 2;
        if numSyll >= spcConditionTwo2(1,1) && numSyll <= spcConditionTwo2(1,2)
            limit2ConditionTwo (w, 1) = 1;
        else
            passConditionTwo (1,1) = 3;
            if numSyll >= spcConditionTwo3(1,1) && numSyll <= spcConditionTwo3(1,2)
                limit3ConditionTwo (first, 1) = 1;
            else
                passConditionTwo (1,1) = 4;
            end
        end
    end
    
    % Rep Rate
    if numSyll > 1
        % Calculate Rep Rate
        repRate = 0;
        for w = first+1:last
            repRate = repRate + callNum(w,3);
        end
        repRate = repRate/ (last-first);
        repRate = 1000/repRate;
        valuesConditionTwo (first, 2) = repRate;
        
        % test Rep Rate
        if repRate >= repConditionTwo1(1,1) && repRate <= repConditionTwo1(1,2)
            limit1ConditionTwo (first, 2) = 1;
        else
            passConditionTwo (1,2) = 2;
            if repRate >= repConditionTwo1(1,1) && repRate <= repConditionTwo1(1,2)
                limit1ConditionTwo (first, 2) = 1;
            else
                passConditionTwo (1,2) = 3;
                if repRate >= repConditionTwo1(1,1) && repRate <= repConditionTwo1(1,2)
                    limit1ConditionTwo (first, 2) = 1;
                else
                    passConditionTwo (1,2) = 4;
                end
            end
        end
    end
    
    % Total call duration
    test = callNum(last, 5) - callNum (first, 4);
    valuesConditionTwo (first, 3) = test;
    if   test >= totaldurConditionTwo1(1,1) && test <= totaldurConditionTwo1(1,2)
        limit1ConditionTwo (first, 3) = 1;
    else
        passConditionTwo (1,3) = 2;
        if test >= totaldurConditionTwo2(1,1) && test <= totaldurConditionTwo2(1,2)
            limit2ConditionTwo (first, 3) = 1;
        else
            passConditionTwo (1,3) = 3;
            if test >= totaldurConditionTwo2(1,1) && test <= totaldurConditionTwo2(1,2)
                limit2ConditionTwo (first, 3) = 1;
            else
                passConditionTwo (1,3) = 4;
            end
        end
    end
    
    % Syllables are DFM
    for w = first:last
        test = callNum(w,9) - callNum(w,6);
        if  test > 0
            valuesConditionTwo (w, 4) = 1;
            limit1ConditionTwo (w, 4) = 1;
            limit2ConditionTwo (w, 4) = 1;
            limit3ConditionTwo (w, 4) = 1;
        end
    end
    
    % Copy file to appropriate folder
    if all(passConditionTwo==1)
            copy1ConditionTwo{q,1} = callName(first,1);
       elseif all(passConditionTwo<3)
            copy2ConditionTwo{q,1} = callName(first,1);
        elseif all(passConditionTwo<4)
            copy3ConditionTwo{q,1} = callName(first,1);
    end
    
    clear w first last isi avgISI repRate passCondition* numSyll test
end

clear *ConditionOne1 *ConditionOne2 *ConditionOne3 *ConditionTwo1 *ConditionTwo2 *ConditionTwo3 q

% ----------------------------------------------------------------------------------------------------------------
% Copy files that meet Conditions into folders
% ----------------------------------------------------------------------------------------------------------------
if condition ~= 2
    % Copy Condition 1 files within the first limit
    for j = 1:length(copy1ConditionOne);
        if isempty(copy1ConditionOne {j,1}) == 1
            continue
        end
        filename = char(copy1ConditionOne{j,1} (1,:));
        copyfile(filename,location1ConditionOne);
    end
    
    % Copy Condition 1 files within the second limit
    for j = 1:length(copy2ConditionOne);
        if isempty(copy2ConditionOne {j,1}) == 1
            continue
        end
        filename = char(copy2ConditionOne{j,1} (1,:));
        copyfile(filename,location2ConditionOne);
    end
    
    % Copy Condition 1 files within the third limit
    for j = 1:length(copy3ConditionOne);
        if isempty(copy3ConditionOne {j,1}) == 1
            continue
        end
        filename = char(copy3ConditionOne{j,1} (1,:));
        copyfile(filename,location3ConditionOne);
    end
end
% ----------------------------------------------------------------------------------------------------------------
% Copy Condition 2 files within the first limit
if condition ~= 1
    for j = 1:length(copy1ConditionTwo);
        if isempty(copy1ConditionTwo {j,1}) == 1
            continue
        end
        filename = char(copy1ConditionTwo{j,1} (1,:));
        copyfile(filename,location1ConditionTwo);
    end
    
    % Copy Condition 2 files within the second limit
    for j = 1:length(copy2ConditionTwo);
        if isempty(copy2ConditionTwo {j,1}) == 1
            continue
        end
        filename = char(copy2ConditionTwo{j,1} (1,:));
        copyfile(filename,location2ConditionTwo);
    end
    
    % Copy Condition 2 files within the third limit
    for j = 1:length(copy3ConditionTwo);
        if isempty(copy3ConditionTwo {j,1}) == 1
            continue
        end
        filename = char(copy3ConditionTwo{j,1} (1,:));
        copyfile(filename,location3ConditionTwo);
    end
end

clear filename j
% ----------------------------------------------------------------------------------------------------------------
% Export as Excel spreadsheet if wanted
% ----------------------------------------------------------------------------------------------------------------
button = questdlg('Do you want to save as an Excel spreadsheet?', 'Save in Excel', 'Yes', 'No', 'Yes');
switch button
    case 'Yes'
        filename = regexprep(avisoftAscii, '.txt','');
        if condition ~= 2
            xlswrite(filename, headerConditionOne, [nameConditionOne '- limit1'], 'A1');
            xlswrite(filename, callName, [nameConditionOne '- limit1'], 'A2');
            xlswrite(filename, limit1ConditionOne, [nameConditionOne '- limit1'], 'B2');
            xlswrite(filename, valuesConditionOne, [nameConditionOne '- limit1'], 'G2');
            
            xlswrite(filename, headerConditionOne, [nameConditionOne '- limit2'], 'A1');
            xlswrite(filename, callName, [nameConditionOne '- limit2'], 'A2');
            xlswrite(filename, limit2ConditionOne, [nameConditionOne '- limit2'], 'B2');
            xlswrite(filename, valuesConditionOne, [nameConditionOne '- limit2'], 'G2');
            
            xlswrite(filename, headerConditionOne, [nameConditionOne '- limit3'], 'A1');
            xlswrite(filename, callName, [nameConditionOne '- limit3'], 'A2');
            xlswrite(filename, limit3ConditionOne, [nameConditionOne '- limit3'], 'B2');
            xlswrite(filename, valuesConditionOne, [nameConditionOne '- limit3'], 'G2');
        end
        if condition ~= 1
            xlswrite(filename, headerConditionTwo, [nameConditionTwo '- limit1'], 'A1');
            xlswrite(filename, callName, [nameConditionTwo '- limit1'], 'A2');
            xlswrite(filename, limit1ConditionTwo, [nameConditionTwo '- limit1'], 'B2');
            xlswrite(filename, valuesConditionTwo, [nameConditionTwo '- limit1'], 'G2');
            
            xlswrite(filename, headerConditionTwo, [nameConditionTwo '- limit2'], 'A1');
            xlswrite(filename, callName, [nameConditionTwo '- limit2'], 'A2');
            xlswrite(filename, limit2ConditionTwo, [nameConditionTwo '- limit2'], 'B2');
            xlswrite(filename, valuesConditionTwo, [nameConditionTwo '- limit2'], 'G2');
            
            xlswrite(filename, headerConditionTwo, [nameConditionTwo '- limit3'], 'A1');
            xlswrite(filename, callName, [nameConditionTwo '- limit3'], 'A2');
            xlswrite(filename, limit3ConditionTwo, [nameConditionTwo '- limit3'], 'B2');
            xlswrite(filename, valuesConditionTwo, [nameConditionTwo '- limit3'], 'G2');
        end
    case 'No'
        disp('Data not saved in Excel');
end

clear *1Condition* *2Condition* *3Condition*