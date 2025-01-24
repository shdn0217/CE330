s=[-3,1,-1,-3,3];n=16;w=6;
[h,~]=rrc(0.5,n,w);
h=h/max(abs(h));
g=conv(h,h)/max(conv(h,h));
x=zeros(1,n*w+1);y=zeros(1,48*w+1);
for i=1:length(s)
    x((i-1)*24+1)=s(i);
    y((i-1)*48+1)=s(i);
end
tx=conv(x,h);rx=conv(y,g);
figure;t=0:4;
subplot(211);
plot(linspace(-47/24,145/24,length(tx)),tx,'c','LineWidth',1.5);
hold on;stem(t,tx(t*24+48));
xlim([-0.3,4.5]);grid on;title('TX');
subplot(212);
plot(linspace(-93/48,291/48,length(rx)),rx,'b','LineWidth',1.5);
hold on;stem(t,rx(t*48+94));
xlim([-0.3,4.5]);grid on;title('RX');