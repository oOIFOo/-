fileNameF = 'outputF.csv';  %frequence
fileNameR = 'outputR.csv';  %respond
fileNameREnv = 'outputREnv.csv';%response environment
fileNamePCA = 'outputPCA.csv';  %PCA data
fileNameEnvPCA = 'outputEnvPCA.csv';  %environment PCA data
fileNameThreshold = 'outputThreshold.csv';
Freq = csvread(fileNameF);
Resp = csvread(fileNameR);
RespEnv = csvread(fileNameREnv);%response environment(change the name of the first data)
global PS;
Environment = [];
Time = [];
Env_Left = [];
Resp_Left = [];
Threshold = [];
RT_Env = [];
delT = 0.2;
tmpT = 0;

[RowFE, ColTE] = size(RespEnv);
%============Remove channel 1=========================
for i = 1:(ColTE/2)
    Env_Left = [Env_Left, RespEnv(:,(i*2-1))];
end

[Row, Col] = size(Resp);
for i = 1:(Col/2)
    Resp_Left = [Resp_Left, Resp(:,(i*2-1))];
end
%=====================================================
%85998~90001
Environment = zeros(RowFE,1);
for i = 1:(ColTE/8)
    Environment = Environment + Env_Left(:,i);
end
for i = (ColTE/8):(ColTE/2)
    RT_Env =Env_Left(:,i);
end
Environment = Environment / (ColTE/2);
Resp_Left = Resp_Left - Environment;
Env_Left = Env_Left - Environment;
RT_Env = RT_Env - Environment;

Resp_var = var(Resp_Left);
Env_var = var(Env_Left);
RT_Env_var = var(RT_Env);

Resp_avgvar =  sum(Resp_var)/(Col/2);
Env_avgvar =  sum(Env_var)/(ColTE*3/8);
RT_Env_avgvar =  sum(RT_Env_var)/(ColTE*3/8);

Threshold = RT_Env_avgvar/Env_avgvar ; 
display(Threshold);

%E = mean(Resp_Left) + var(Resp_Left);
%EEnv = mean(Env_Left) + var(Env_Left);

%Threshold = [Threshold, var(Resp_Left)./var(Env_Left)];

% Env_Left = abs(Env_Left);
% Resp_Left = abs(Resp_Left);
% Env_Left(Env_Left < EEnv) = 0;
% Resp_Left(Resp_Left < E) = 0;
pca_Resp = pca(Resp_Left);
pca_Env = pca(Env_Left);
[R, C] = size(pca_Resp);
% 
% csvwrite(fileNameEnvPCA, pca_Env);
% csvwrite(fileNamePCA, pca_Resp);
%==============find peak===============================
% V = [];
% for i = 1:C/2
%     [PPKS,PLOCS] = findpeaks(pca_Resp(:,i*2));
%     V = [V, length(PPKS)];
% end
% csvwrite(fileNamePCA, V);
%======================================================
[RowF, ColT] = size(Resp_Left);
Resp_Left = transpose(Resp_Left);
% colormap(hot);
% colorbar;
% axis([0 5 21000 23000]);
% for i = 1:ColT
%    hold on;
%    Time = repmat(tmpT, [1, size(Freq)]);
%    
%    surface([Time; Time], [transpose(Freq); transpose(Freq)], [Resp_Left(i,:); Resp_Left(i,:)], 'EdgeColor', 'flat', 'FaceColor', 'none', 'linewidth', 5);
%    tmpT = tmpT + delT;
% end
% ========================Draw Response 2D==================================
figure('Name', 'Response 2D','NumberTitle','off');
for j = 1:ColT
    hold on;
    axis([21000 23000 -1 1]);
    plot([0,0],'Tag',sprintf('line%02d',j),'linewidth',2);
    xlabel('Frequency (Hz)');
    ylabel('Response (dB)');
end

for j = 1:ColT
    line = findobj('Tag', sprintf('line%02d', j));
    set(line, 'xData', Freq);%last part setting time
    set(line, 'yData', Resp_Left(j,:)); % only show the 1st ch
end
%==========================================================================

% %========================Draw environment 2D===============================
% figure('Name', 'Environment 2D','NumberTitle','off');
% for j = 1:ColT
%     hold on;
%     axis([21000 23000 0 1]);
%     plot([0,0],'Tag',sprintf('envline%02d',j),'linewidth',2);
%     xlabel('Frequency (Hz)');
%     ylabel('Response (dB)');
% end
% 
% for j = 1:ColT
%     line = findobj('Tag', sprintf('envline%02d', j));
%     set(line, 'xData', Freq);%last part setting time
%     set(line, 'yData', Env_Left(:,j)); % only show the 1st ch
% end
% %==========================================================================

% %========================Draw environment 3D===============================
% figure('Name', 'Environment 3D','NumberTitle','off');
% tmpT = 0;
% colormap(hot);
% colorbar;
% axis([0 5 21000 23000]);
% Env_Left = transpose(Env_Left);
% for i = 1:ColT
%    hold on;
%    Time = repmat(tmpT, [1, size(Freq)]);
%    
%    surface([Time; Time], [transpose(Freq); transpose(Freq)], [Env_Left(i,:); Env_Left(i,:)], 'EdgeColor', 'flat', 'FaceColor', 'none', 'linewidth', 5);
%    tmpT = tmpT + delT;
% end
% %==========================================================================