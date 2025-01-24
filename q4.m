%Q4
clear; clc; close all;

% Basic parameters
N = 1e6;               % Number of transmitted bits
maxIter = 20;          % Number of iterations for averaging
EbNo = 1;              % Energy per bit
SNRdB = 0:1:20;        % SNR range (in dB)
SNR = 10.^(SNRdB / 10); % Linear SNR values
modOrder = 4;          % QPSK modulation order
symbolBits = log2(modOrder);  % Number of bits per symbol
SNR_symbol_dB = SNRdB + 10*log10(symbolBits); % Adjusted SNR for symbols

% SNR loop for simulation
for snrIdx = 1:length(SNR)
    avgError = 0;

    % Average over multiple iterations
    for iter = 1:maxIter
        % Generate random data (bits)
        txBits = randn(1, N) >= 0;
        
        % QPSK modulation
        symbols = zeros(1, N/2);
        symbolIdx = 1;
        for i = 1:2:N
            symbols(symbolIdx) = txBits(i)*2 + txBits(i+1)*1;  % Mapping bits to symbols
            symbolIdx = symbolIdx + 1;
        end

        % Modulate and add phase offset
        txSignal = pskmod(symbols, modOrder);  % QPSK modulation
        rxSignal = awgn(txSignal, SNR_symbol_dB(snrIdx), 'measured');  % Add noise
        demodSymbols = pskdemod(rxSignal, modOrder, pi/16);  % Demodulate with phase offset

        % Demodulate back to bit stream
        rxBits = zeros(1, N);
        for i = 1:length(demodSymbols)
            rxBits(2*i-1) = fix(demodSymbols(i)/2);
            rxBits(2*i) = mod(demodSymbols(i), 2);
        end

        % Calculate bit errors
        errors = sum(rxBits ~= txBits);
        errorRate = errors / N;
        avgError = avgError + errorRate;
    end
    BER_sim(snrIdx) = avgError / maxIter;  % Simulated BER for current SNR
end

% Theoretical BER calculation (with phase offset)
BER_theory = berawgn(SNR, 'psk', modOrder, 'nondiff');  % Theory for PSK with phase offset

% Plot results
figure;
semilogy(SNRdB, BER_theory, ['b:' ...
    's'], 'LineWidth', 2, 'MarkerSize', 6, 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b'); 
hold on;
semilogy(SNRdB, BER_sim, 'r-*', 'LineWidth', 2, 'MarkerSize', 6, 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r');

% Title and axis labels
title('QPSK Performance with Carrier Phase Offset', 'FontSize', 16, 'FontWeight', 'bold');
xlabel('Eb/No [dB]', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Bit Error Rate (BER)', 'FontSize', 14, 'FontWeight', 'bold');

% Customize axes properties
set(gca, 'FontSize', 12, 'LineWidth', 1.5); % Adjust font size and line width
grid off; % Turn off the gridlines

% Set axis limits
xlim([min(SNRdB), max(SNRdB)]); % Limit x-axis from 0 to 20
ylim([1e-5 1]); % Limit y-axis for better display of values

% Customize legend
legend('Theoretical BER', 'Simulated BER', 'Location', 'SouthEast', 'FontSize', 12);

% Set background color to white
set(gcf, 'Color', 'w'); % Set figure background color to white