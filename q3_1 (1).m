clear; clc; close all;

% Basic parameters
N = 1e6;               % Number of transmitted bits
maxIter = 20;          % Iteration count for each SNR
EbNo = 1;              % Energy per bit
SNRdB = 0:1:10;        % SNR range (in dB)
SNR = 10.^(SNRdB/10);  % Linear SNR

% SNR loop
for snrIdx = 1:length(SNR)
    avgError = 0;
    
    % Average over multiple iterations
    for iter = 1:maxIter
        errorCount = 0;

        % Generate random data
        dataI = randn(1, N) >= 0;
        dataQ = randn(1, N) >= 0;
        modI = 2*dataI - 1;
        modQ = 2*dataQ - 1;

        % Add Gaussian noise
        noiseAmp = sqrt(1/(SNR(snrIdx)*2));
        noiseI = noiseAmp * randn(1, N);
        noiseQ = noiseAmp * randn(1, N);
        rxI = modI + noiseI;
        rxQ = modQ + noiseQ;

        % Bit error counting
        for k = 1:N
            if ((rxI(k) > 0 && dataI(k) == 0) || (rxI(k) < 0 && dataI(k) == 1) || ...
                (rxQ(k) > 0 && dataQ(k) == 0) || (rxQ(k) < 0 && dataQ(k) == 1))
                errorCount = errorCount + 1;
            end
        end

        errorRate = errorCount / N;
        avgError = avgError + errorRate;        
    end
    
    BER_sim(snrIdx) = avgError / maxIter;  % Simulated BER
end

% Theoretical BER calculation
BER_theory = berawgn(SNR, 'psk', 4, 'nondiff');
% Plot results
figure;
semilogy(SNRdB, BER_theory, 'b-s', 'LineWidth', 2, 'MarkerSize', 6, 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b'); 
hold on;
semilogy(SNRdB, BER_sim, 'r-*', 'LineWidth', 2, 'MarkerSize', 6, 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r');

% Title and axis labels
title('QPSK BER Performance in AWGN Channel', 'FontSize', 16, 'FontWeight', 'bold');
xlabel('Eb/No [dB]', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Bit Error Rate (BER)', 'FontSize', 14, 'FontWeight', 'bold');

% Customize axes properties
set(gca, 'FontSize', 12, 'LineWidth', 1.5); % Change font size and axes line width
grid off; % Turn off the grid
ax = gca; % Get current axes
ax.XGrid = 'off'; % Disable X Grid
ax.YGrid = 'off'; % Disable Y Grid

% Set axis limits
xlim([min(SNRdB), max(SNRdB)]); % Limit x-axis from 0 to 10
ylim([1e-5 1]); % Limit y-axis for better display of values

% Customize legend
legend('Theoretical BER', 'Simulated BER', 'Location', 'SouthEast', 'FontSize', 12);

% Set background color to white
set(gcf, 'Color', 'w'); % Set figure background color to white