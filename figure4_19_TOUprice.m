clear all
close all

price = [65.2*ones(60,1);65.2*ones(60,1);65.2*ones(60,1);65.2*ones(60,1);65.2*ones(60,1); ...
         232.64*ones(60,1);232.64*ones(60,1);232.64*ones(60,1);115.45*ones(60,1); 115.45*ones(60,1);115.45*ones(60,1);...
        65.2*ones(60,1);65.2*ones(60,1);65.2*ones(60,1);65.2*ones(60,1);65.2*ones(60,1); ...
        115.45*ones(60,1); 115.45*ones(60,1);115.45*ones(60,1);...
        65.2*ones(60,1);65.2*ones(60,1);65.2*ones(60,1);65.2*ones(60,1);65.2*ones(60,1)];
deltT = 1;         % Time steps in minute
t = 1:deltT:24*60;   %The time sequence

figure(134)
set(gcf,'DefaultAxesFontSize',16)  %<--------set character size
set(gcf,'DefaultTextFontSize',16)
plot(t/60,price,'k','LineWidth',2)
xlabel('Time of the day (hr)')
ylabel('Price ($/MW)') 



sub_loadTemperaturewinter % Load outdoor temperature profile (a day)
Tout = [];    
day = 1
numberOfDay = 3

for i = 1:24*numberOfDay
    if Tout24(24*day+i) ~= Tout24(24*day+i+1)
        Tstep0 = (Tout24(24*day+i+1)-Tout24(24*day+i))/(60/deltT);
        Tout = [Tout [Tout24(24*day+i):Tstep0:Tout24(24*day+i+1)]];
    else
        Tout = [Tout Tout24(24*day+i)*ones(1,(60/deltT))];
    end
end
Tout = (Tout-32)*5/9;
figure(134)
set(gcf,'DefaultAxesFontSize',16)  %<--------set character size
set(gcf,'DefaultTextFontSize',16)
plot(Tout,'k','LineWidth',2)
xlabel('Time of the day (hr)')
ylabel('Price ($/MW)') 