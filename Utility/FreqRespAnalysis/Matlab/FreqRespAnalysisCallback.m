function [ret] = FreqRespAnalysisCallback( obj, type, data )
    global dataCellBuf; % save this data buffer for the future reference
    global dataCellBufEnd;
    global PS;
    global M;
    ret = [];
    csvFile = 'outputR.csv';
    csvFile2 = 'outputF.csv';
    if type == obj.CALLBACK_TYPE_INIT,
        dataCellBuf = {};
        dataCellBufEnd = 0;
        createUI(obj);
    elseif type == obj.CALLBACK_TYPE_DATA,
        for traceIdx = 1:size(data,2)
            dataCellBuf{ dataCellBufEnd + 1 } = squeeze(data(:,traceIdx,:));
            dataCellBufEnd = dataCellBufEnd + 1;
            dataFreq = abs(fft(dataCellBuf{dataCellBufEnd}));
            dataFreq = dataFreq(1:floor(size(dataFreq, 1) / 2),:);
            resp2 = log10(smooth(dataFreq(:, 1), 30));
            freqs2 = (1:length(resp2)) ./length(resp2) .* (PS.FS/2);
            csvwrite(csvFile2, transpose(freqs2));
            for chIdx = 1:size(data, 3)
                line = findobj('Tag', sprintf('line%02d_%02d', chIdx, dataCellBufEnd));    
                resp = log10(smooth(dataFreq(:, chIdx), 30));
                freqs = (1:length(resp)) ./length(resp) .* (PS.FS/2);
                M = [M, resp];
                set(line, 'xData', freqs);%last part setting time
                set(line, 'yData', resp); % only show the 1st ch
            end
        end
    end
    csvwrite(csvFile, M);
end

function createUI(obj)
%C:\Users\USER\Desktop\LibAcousticSensing-master\Utility\FreqRespAnalysis\Matlab
    PLOT_AXE_IN_WIDTH = 250;
    PLOT_AXE_OUT_WIDTH = 310;
    PLOT_AXE_CNT = 2;
    
    set(0,'DefaultAxesFontSize',14,'DefaultTextFontSize',16);
    obj.userfig = figure('Name','Callback','NumberTitle','off', 'Position',[50,50, PLOT_AXE_OUT_WIDTH * PLOT_AXE_CNT + 150, 350]);
    
    lineCnt = obj.audioSource.repeatCnt;
    for i = 1:PLOT_AXE_CNT,
        obj.axe = axes('Parent',obj.userfig,'Units','pixels','Position', [PLOT_AXE_OUT_WIDTH * (i-1) + 150, 60, PLOT_AXE_IN_WIDTH, 250]);
        hold on;
        for j = 1:lineCnt,
            axis([21000 23000 3 8]);
            plot([0,0],'Tag',sprintf('line%02d_%02d',i,j),'linewidth',2);
            xlabel('Frequency (Hz)');
            ylabel('Response (dB)');
        end
        title(sprintf('ch %d', i));
    end
end
