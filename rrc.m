function [p,t]=rrc(b,L,N)
t=(-N/2:1/L:N/2);
n=sin(pi*t*(1-b))+4*b*t.*cos(pi*t*(1+b));
d=pi*t.*(1-(4*b*t).^2);
p=n./d;
p(isnan(p))=1;
v=b*((1+2/pi)*sin(pi/(4*b))+(1-2/pi)*cos(pi/(4*b)));
p(abs(t*4*b)==1)=v;
end