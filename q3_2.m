%3.2
% clear; clc; close all;

% Basic parameters
N = 1e6;            % Number of bits
maxIter = 20;       % Iterations for averaging
EbNo = 1;           % Energy per bit
SNRdB = 0:1:10;     % SNR range (in dB)
SNR = 10.^(SNRdB / 10);  % Linear SNR values

% SNR loop for simulation
for snrIdx = 1:length(SNR)
    avgError = 0;
    
    % Average over multiple iterations
    for iter = 1:maxIter
        errorCount = 0;

        % Generate four independent data streams
        data = randn(4, N) >= 0;  % 4 rows for data1, data2, data3, and data4
        modData = 2 * data - 1;   % Mapping to -1 and +1

        % Add Gaussian noise
        noiseAmp = sqrt(1 / (SNR(snrIdx) * 2));
        noise = noiseAmp * randn(4, N);  % Noise for 4 data streams

        % Received signals
        rx = modData + noise;

        % Error counting
        errorCount = sum(sum((rx > 0) ~= data));  % Count errors for all streams

        errorRate = errorCount / (N * 4);  % Average error rate for 4 data streams
        avgError = avgError + errorRate;        
    end
    BER_sim(snrIdx) = avgError / maxIter;  % Simulated BER for current SNR
end

% Theoretical BER calculation for 16-QAM
BER_theory = berawgn(SNR, 'qam', 16);

% Plot results
figure;
semilogy(SNRdB, BER_theory, 'g--s', 'LineWidth', 2, 'MarkerSize', 6, 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b'); 
hold on;
semilogy(SNRdB, BER_sim, 'r--*', 'LineWidth', 2, 'MarkerSize', 6, 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r');

% Title and axis labels
title('16-QAM BER Performance in AWGN Channel', 'FontSize', 16, 'FontWeight', 'bold');
xlabel('Eb/No [dB]', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Bit Error Rate (BER)', 'FontSize', 14, 'FontWeight', 'bold');

% Customize axes properties
set(gca, 'FontSize', 12, 'LineWidth', 1.5); % Change font size and axes line width
grid off; % Turn off the grid

% Set axis limits
xlim([min(SNRdB), max(SNRdB)]); % Limit x-axis from 0 to 10
ylim([1e-5 1]); % Limit y-axis for better display of values

% Customize legend
legend('Theoretical BER', 'Simulated BER', 'Location', 'SouthEast', 'FontSize', 12);

% Set background color to white
set(gcf, 'Color', 'w'); % Set figure background color to white