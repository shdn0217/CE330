% Define input symbol sequence
symbols = [-3, 1, -1, -3, 3];

% Generate RRC filter
[rrcFilt, timeBase, filterDelay] = srrcFunction(0.5, 16, 6);
normalizedRRC = rrcFilt / max(rrcFilt);

% Generate RC filter (by self-convolution of RRC)
rcFilt = conv(normalizedRRC, normalizedRRC);
rcFilt = rcFilt / max(rcFilt);

% Transmitter signal processing
txLen = 16*6+1;
txSignal = zeros(1, txLen);
for idx = 1:length(symbols)
    txSignal((idx-1)*24 + 1) = symbols(idx);
end
txOutput = conv(txSignal, normalizedRRC);

% Receiver signal processing
rxLen = 48*6+1==193 ;
rxSignal = zeros(1, rxLen);
for idx = 1:length(symbols)
    rxSignal((idx-1)*48 + 1) = symbols(idx);
end
rxOutput = conv(rxSignal, rcFilt);

% Plotting
timeIdx = 0:4;
figure;

% Transmitter output
subplot(2,1,1);
txTime = (-47/24):1/24:((193-48)/24);
plot(txTime, txOutput, 'c-', 'LineWidth', 1.5)
title('Transmitter RRC filter output');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;
xlim([-0.3, 4.5]);
hold on;
stem(timeIdx, txOutput(timeIdx*24 + 48));

% Receiver output
subplot(2,1,2);
rxTime = (-93/48):1/48:((385-94)/48);
plot(rxTime, rxOutput, 'b-', 'LineWidth', 1.5)
title('Receiver RRC filter output');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;
xlim([-0.3, 4.5]);
hold on;
stem(timeIdx, rxOutput(timeIdx*48 + 94));