% Parameters
symbols = [-3, 1, -1, -3, 3];
sps = 16;  % samples per symbol
span = 6;  % filter span

% Generate filters
[rrc, ~, ~] = sqrt_rc_filter(0.5, sps, span);
rrc = rrc / max(abs(rrc));
rc = conv(rrc, rrc);
rc = rc / max(abs(rc));

% Transmitter
tx = zeros(1, sps*span + 1);
for i = 1:length(symbols)
    tx((i-1)*24 + 1) = symbols(i);
end
tx_out = conv(tx, rrc);

% Receiver
rx = zeros(1, 48*span + 1);
for i = 1:length(symbols)
    rx((i-1)*48 + 1) = symbols(i);
end
rx_out = conv(rx, rc);

% Plot
t = 0:4;
figure;
subplot(2,1,1);
plot((-47/24):1/24:((193-48)/24), tx_out, 'c-', 'LineWidth', 1.5)
hold on; stem(t, tx_out(t*24 + 48));
title('Transmitter Output'); grid on;
xlim([-0.3, 4.5]);

subplot(2,1,2);
plot((-93/48):1/48:((385-94)/48), rx_out, 'b-', 'LineWidth', 1.5)
hold on; stem(t, rx_out(t*48 + 94));
title('Receiver Output'); grid on;
xlim([-0.3, 4.5]);

function [p,t,d] = sqrt_rc_filter(beta, L, N)
    t = (-N/2):1/L:(N/2);
    num = sin(pi*t*(1-beta)) + 4*beta*t.*cos(pi*t*(1+beta));
    den = pi*t.*(1-(4*beta*t).^2);
    p = num./den;
    p(isnan(p)) = 1;
    p(t==1/(4*beta)) = beta*((1+2/pi)*sin(pi/(4*beta))+(1-2/pi)*cos(pi/(4*beta)));
    p(t==-1/(4*beta)) = p(t==1/(4*beta));
    d = (length(p)-1)/2;
end