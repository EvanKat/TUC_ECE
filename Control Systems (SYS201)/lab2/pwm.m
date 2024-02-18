ts = 10^(-6);
f = 50;
Vs = 200;
const = 0.5;
t = 0:ts:0.1;
triangle = (sawtooth(2*pi*f*t, 1/2) + 1) / 2;
pulse(1) = 0;
for k=2:length(t)
    if(triangle(k) > const)
        pulse(k) = 0;
    else 
        pulse(k) = Vs;
    end;
end;

plot(t,pulse);