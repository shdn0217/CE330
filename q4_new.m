% Init
s = [-3,1,-1,-3,3]/3;  % 归一化输入符号
n = 32;                 % 增加采样率
w = 6;

% Filters 
[h,~] = rrc(0.5,n,w);
h = h/max(abs(h));
g = conv(h,h);
g = g/max(abs(g));

% Tx/Rx
x = zeros(1,n*w+1);
y = zeros(1,n*w+1);  % 统一采样率
for i = 1:length(s)
   x((i-1)*n+1) = s(i);
   y((i-1)*n+1) = s(i); 
end

tx = conv(x,h);
rx = conv(y,g);

% Plot
figure;t = 0:4;
subplot(211);
plot(linspace(-2,6,length(tx)),tx,'c','LineWidth',2); % 调整时间轴
hold on;stem(t,tx(t*n+n),'k');
grid on;title('TX');xlim([-1,5]);

subplot(212);
plot(linspace(-2,6,length(rx)),rx,'b','LineWidth',2);
hold on;stem(t,rx(t*n+n),'k');
grid on;title('RX');xlim([-1,5]);

function [p,t] = rrc(b,L,N)
   t = (-N/2:1/L:N/2);
   n = sin(pi*t*(1-b)) + 4*b*t.*cos(pi*t*(1+b));
   d = pi*t.*(1-(4*b*t).^2);
   p = n./d;
   p(isnan(p)) = 1;
   v = b*((1+2/pi)*sin(pi/(4*b))+(1-2/pi)*cos(pi/(4*b)));
   p(abs(t*4*b)==1) = v;
end