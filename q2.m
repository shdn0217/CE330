clear; clc; close all;

% Simulation parameters
N = 1e6;               % Number of symbols
SNRdB = 0:10;          % SNR range (in dB)
M_QPSK = 4;            % QPSK modulation order
M_16QAM = 16;          % 16-QAM modulation order
grayMapQPSK = [0 1 3 2];    % QPSK Gray mapping
grayMap16QAM = [0 1 3 2 4 5 7 6 12 13 15 14 8 9 11 10];  % 16-QAM Gray mapping

% QPSK signal generation and modulation
qpskData = randi([0,3], 1, N);
qpskMapped = grayMapQPSK(qpskData + 1);
qpskSignal = qammod(qpskMapped, M_QPSK);
qpskPower = mean(abs(qpskSignal).^2);  % Signal power

% 16-QAM signal generation and modulation
qamData = randi([0,15], 1, N);
qamMapped = grayMap16QAM(qamData + 1);
qamSignal = qammod(qamMapped, M_16QAM);
qamPower = mean(abs(qamSignal).^2);  % Signal power

% Precompute SNR (symbol energy to noise ratio)
EsNo_QPSK = SNRdB + 10*log10(2); 
EsNo_16QAM = SNRdB + 10*log10(4); 

% Simulate BER for QPSK and 16-QAM
berQPSK = calcBER(qpskSignal, qpskPower, EsNo_QPSK, qpskData, grayMapQPSK, M_QPSK);
ber16QAM = calcBER(qamSignal, qamPower, EsNo_16QAM, qamData, grayMap16QAM, M_16QAM);

figure;
semilogy(SNRdB, berQPSK, 'o-', 'LineWidth', 2, 'MarkerSize', 6, 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b'); 
hold on;
semilogy(SNRdB, ber16QAM, '*-', 'LineWidth', 2, 'MarkerSize', 6, 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r');

% Title and axis labels
title('QPSK vs 16QAM BER Performance', 'FontSize', 16, 'FontWeight', 'bold');
xlabel('Eb/No [dB]', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Bit Error Rate (BER)', 'FontSize', 14, 'FontWeight', 'bold');

% Customize axes properties
set(gca, 'FontSize', 12, 'LineWidth', 1.5); % Change font size and axes line width
grid on; % Turn on the grid
ax = gca; % Get current axes
ax.XGrid = 'on';
ax.YGrid = 'on';

% Set x and y axis limits
xlim([0 10]); % Limit x-axis from 0 to 10
ylim([1e-5 1]); % Limit y-axis to display better values

% Set axis to logarithmic scale for y-axis
set(gca, 'YScale', 'log');

% Customize legend
legend('QPSK Simulation BER', '16QAM Simulation BER', 'Location', 'SouthEast', 'FontSize', 12);

% Add a background color to the figure
set(gcf, 'Color', 'w'); % Set figure background color to white

%%
function ber = calcBER(modSignal, signalPower, EsNo, data, grayMap, M)
    % Preallocate BER array
    ber = zeros(1, length(EsNo));
    
    % Loop through each SNR value
    for i = 1:length(EsNo)
        % Compute noise variance for current SNR
        noiseStdDev = sqrt(signalPower / (2 * 10^(EsNo(i) / 10)));
        
        % Add noise to the signal
        noise = noiseStdDev * (randn(1, length(modSignal)) + 1i * randn(1, length(modSignal)));
        receivedSignal = modSignal + noise;
        
        % Demodulate the received signal
        demodulated = qamdemod(receivedSignal, M);
        
        % Decode the received symbols using Gray mapping
        decodedData = grayMap(demodulated + 1);
        
        % Calculate BER using bit error rate function
        [~, ber(i)] = biterr(data, decodedData, log2(M));
    end
end