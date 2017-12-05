% Takes .txt file of amplitude envelopes outputted from Avisoft and tests
% in the envelope is likely to contain a predictable echo
%
% Average amplitude envelope lined up on start of envelope, not first
% crossing
%
% Does not require envelopes to return to the noise floor
%
% Written by Emily Hazlett 01/16/2015

% Opens input dialoge to enter .txt file location
prompt = {'Enter location of ASCII file with Avisoft output'};
dlg_title = 'Input';
num_lines = 1;
defAns = {'D:\MATLAB\'};
answer = inputdlg(prompt, dlg_title, num_lines, defAns);

% Imports data and creates 0 arrays to fill
ampEnvFull = importdata(char(answer(1,:)));
[reps longest] = size(ampEnvFull);

floorStartFull (1,reps) = 0;
floorStartBinFull (1,reps) = 0;
cross1aFull (1,reps) = 0;
cross1aBinFull (1,reps) = 0;
max1Full (1,reps) = 0;
max1BinFull (1,reps) = 0;
cross1bFull (1,reps) = 0;
cross1bBinFull (1,reps) = 0;
min1Full (1,reps) = 0;
min1BinFull (1,reps) = 0;
cross2aFull (1,reps) = 0;
cross2aBinFull (1,reps) = 0;
max2Full (1,reps) = 0;
max2BinFull (1,reps) = 0;
cross2bFull (1,reps) = 0;
cross2bBinFull (1,reps) = 0;
floorEndFull (1,reps) = 0;
floorEndBinFull (1,reps) = 0;

ampEnvNormFull (1:reps, 1:longest) = NaN;
floorStartNormFull (1,reps) = 0;
cross1aNormFull (1,reps) = 0;
max1NormFull (1,reps) = 0;
cross1bNormFull (1,reps) = 0;
min1NormFull (1,reps) = 0;
cross2aNormFull (1,reps) = 0;
max2NormFull (1,reps) = 0;
cross2bNormFull (1,reps) = 0;
floorEndNormFull (1,reps) = 0;

% Calculates points of interest in each envelope and adds value to matrix
for q =1:reps
    
    % Select out individual amplitude envelope and remove NaN elements
    ampEnv = ampEnvFull(q, :);
    col = find (isfinite(ampEnv));
    ampEnv = ampEnv(col(1,1):col(1,end));
    
    maximum = max(ampEnv);
    ampEnvNorm = -(ampEnv-maximum)/(ampEnv(1,1)-maximum);
    
    floorStart = ampEnv(1,1);
    floorStartBin = 1;
    floorStartNorm = ampEnv (1,1);
    
    floorEnd = ampEnv(1, end);
    floorEndBin = length(ampEnv);
    floorEndNorm = ampEnvNorm(1,floorEndBin);
    
    % Find minimum distance between peaks that gives only 2 maxima
    test = 0;
    mpd = 1;
    while test ~= 2
        [PKS LOCS] = findpeaks(ampEnv,'MINPEAKDISTANCE', mpd);
        test = length(PKS);
        mpd = mpd+1;
    end
    
    % Find local maxima
    max1 = PKS(1,1);
    max1Bin = LOCS(1,1);
    max1Norm = ampEnvNorm(1, max1Bin);
    
    max2 = PKS(1,2);
    max2Bin = LOCS(1,2);
    max2Norm = ampEnvNorm(1, max2Bin);
    
    % Find minimum distance between peaks that gives only 1 minimum
    test = 0;
    mpd = 1;
    while test ~= 1
        [PKS LOCS] = findpeaks(-ampEnv(max1Bin:max2Bin),'MINPEAKDISTANCE', mpd);
        test = length(PKS);
        mpd = mpd+1;
    end
    
    % Find local minimum
    min1 = -PKS(1,1);
    min1Bin = LOCS(1,1) + max1Bin;
    min1Norm = ampEnvNorm(1, min1Bin);
    
    % threshold = -63;
    threshold = min1 + 5;
    
    % Find when crosses a threshold 5dB above min1
    bin = find (ampEnv (1,floorStartBin:max1Bin) <= threshold);
    cross1aBin = bin(1,end);
    cross1a = ampEnv(1, cross1aBin);
    cross1aNorm = ampEnvNorm(1, cross1aBin);
    
    bin = find (ampEnv (1,max1Bin:min1Bin) >= threshold);
    cross1bBin = bin(1,end) + max1Bin;
    cross1b = ampEnv(1, cross1bBin);
    cross1bNorm = ampEnvNorm(1, cross1bBin);
    
    bin = find (ampEnv (1,min1Bin:max2Bin) <= threshold);
    cross2aBin = bin(1,end) + min1Bin;
    cross2a = ampEnv(1, cross2aBin);
    cross2aNorm = ampEnvNorm(1, cross2aBin);
    
    bin = find (ampEnv (1,max2Bin:floorEndBin) >= threshold);
    cross2bBin = bin(1,end) + max2Bin;
    cross2b = ampEnv(1, cross2bBin);
    cross2bNorm = ampEnvNorm(1, cross2bBin);
    
    floorStartFull (1,q) = floorStart;
    floorStartBinFull (1,q) = floorStartBin;
    cross1aFull (1,q) = cross1a;
    cross1aBinFull (1,q) = cross1aBin;
    max1Full (1,q) = max1;
    max1BinFull (1,q) = max1Bin;
    cross1bFull (1,q) = cross1b;
    cross1bBinFull (1,q) = cross1bBin;
    min1Full (1,q) = min1;
    min1BinFull (1,q) = min1Bin;
    cross2aFull (1,q) = cross2a;
    cross2aBinFull (1,q) = cross2aBin;
    max2Full (1,q) = max2;
    max2BinFull (1,q) = max2Bin;
    cross2bFull (1,q) = cross2b;
    cross2bBinFull (1,q) = cross2bBin;
    floorEndFull (1,q) = floorEnd;
    floorEndBinFull (1,q) = floorEndBin;
    
    ampEnvNormFull (q, 1:length(ampEnvNorm)) = ampEnvNorm;
    floorStartNormFull (1,q) = floorStartNorm;
    cross1aNormFull (1,q) = cross1aNorm;
    max1NormFull (1,q) = max1Norm;
    cross1bNormFull (1,q) = cross1bNorm;
    min1NormFull (1,q) = min1Norm;
    cross2aNormFull (1,q) = cross2aNorm;
    max2NormFull (1,q) = max2Norm;
    cross2bNormFull (1,q) = cross2bNorm;
    floorEndNormFull (1,q) = floorEndNorm;
end

% Calculates mean amp envelope and SD
ampEnvMean = nanmean(ampEnvFull);
[muhat sigmahat mu95ci sigma95ci] = normfit(ampEnvFull); %#ok<NASGU,ASGLU>
ampEnvPlus95CI = mu95ci(2,:);
ampEnvMinus95CI = mu95ci(1,:);

ampEnvNormMean = nanmean(ampEnvNormFull);
[muhat sigmahat mu95ci sigma95ci] = normfit(ampEnvNormFull);
ampEnvNormPlus95CI = mu95ci(2,:);
ampEnvNormMinus95CI = mu95ci(1,:);

% Plot mean ampitude envelope with 95% CI
h = figure('Name', 'Mean Amplitude Envelope');
plot (ampEnvMean, '-k')
hold;
title('Mean Amplitude Envelope')
xlabel('ms')
ylabel('dB')
plot(ampEnvPlus95CI, '--k')
plot(ampEnvMinus95CI, '--k')
hold;

i = figure('Name', 'Mean Normalized Amplitude Envelope');
plot (ampEnvNormMean, '-k')
hold;
title('Mean Normalized Amplitude Envelope')
xlabel('ms')
ylabel('dB')
% plot(ampEnvPlus95CI, '--k')
% plot(ampEnvMinus95CI, '--k')
hold;

% Plot max of echo against first crossing of pulse
g = figure('Name', 'Timing of Pulse Max v Timing of Echo Max');
scatter(max2BinFull, max1BinFull)
hold;
scatter(max2BinFull, cross2bBinFull, 'filled')
title('Timing of Max Echo v max Pulse (circle) OR Start Echo (filled)')
xlabel('Echo Max (bin)')
hold;

j = figure('Name', 'Timing of Pulse Max v Timing of Echo Max');
subplot(1,2,1)
scatter(max2BinFull-cross2aBinFull, max1BinFull-cross1aBinFull)
hold;
title('Max- Threshold Crossing- Echo v Pulse')
xlabel('Echo (bin)')
ylabel('Pulse (bin)')
subplot(1,2,2)
scatter(max2BinFull, floorEndBinFull, 'filled')
title('Echo Max v total duration')
xlabel('Echo Max (bin)')
ylabel('Last crossing of Echo (bin)')
hold;

k = figure ('Name', 'Echo timing against duration');
scatter(max2BinFull-max1BinFull, floorEndBinFull)
hold;
scatter(max2BinFull-max1BinFull, cross2bBinFull, 'filled')
title('Max Echo- Max Pulse v total duration (circle) or threshold duration (filled)')
xlabel('Max difference (bin')
ylabel('Duration (bin)')
hold;

% % Plot max of echo against first crossing of pulse
% g = figure('Name', 'Timing of Pulse Max v Timing of Echo Max');
% subplot(1,2,1)
% scatter(max2BinFull, max1BinFull)
% hold;
% title('Timing of Max Echo v max Pulse')
% xlabel('Echo Max (bin)')
% ylabel('Pulse Max (bin)')
% subplot(1,2,2)
% scatter(max2BinFull, cross2bBinFull, 'filled')
% title('Timing of Max Echo v Start Echo')
% xlabel('Echo Max (bin)')
% ylabel('First crossing of Echo (bin)')
% hold;
%
% j = figure('Name', 'Timing of Pulse Max v Timing of Echo Max');
% subplot(1,2,1)
% scatter(max2BinFull-cross2aBinFull, max1BinFull-cross1aBinFull)
% hold;
% title('Max- Threshold Crossing- Echo v Pulse')
% xlabel('Echo (bin)')
% ylabel('Pulse (bin)')
% subplot(1,2,2)
% scatter(max2BinFull, floorEndBinFull, 'filled')
% title('Echo Max v total duration')
% xlabel('Echo Max (bin)')
% ylabel('Last crossing of Echo (bin)')
% hold;