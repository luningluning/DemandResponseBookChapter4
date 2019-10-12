clear all
close all

price0 = [0:1:10];
price1 = [10:1:50];
price2 = [50:1:60];
setpoint1 = [80:-0.25:70];
setpoint2 = 70*ones(1,11);
setpoint0 = 80*ones(1,11);

price_customer1 = [price0 price1 price2];
setpoint_customer1 = [setpoint0 setpoint1 setpoint2];

figure(1)
set(gcf,'DefaultAxesFontSize',14)  %<--------set character size
set(gcf,'DefaultTextFontSize',14)
plot(price1, setpoint1,'k','LineWidth',2)
hold on
plot(price0, setpoint0,'r','LineWidth',2)
plot(price2, setpoint2,'b','LineWidth',2)
xlabel('Price ($/MW)')
ylabel('Setpoint (^oF)')
ylim([69 81])
grid on

clear price0 price1 price2 setpoint1 setpoint2 setpoint0
price0 = [0:1:20];
price1 = [20:20/7:40];
price2 = [40:1:60];
setpoint1 = [79:-1:72]
setpoint2 = 72*ones(1,21)
setpoint0 = 79*ones(1,21)

figure(1)
set(gcf,'DefaultAxesFontSize',14)  %<--------set character size
set(gcf,'DefaultTextFontSize',14)
plot(price1, setpoint1,'k:','LineWidth',2)
hold on
plot(price0, setpoint0,'r:','LineWidth',2)
plot(price2, setpoint2,'b:','LineWidth',2)
xlabel('Price ($/MW)')
ylabel('Setpoint (^oF)')
ylim([69 81])
grid on

price_customer2 = [price0 price1 price2];
setpoint_customer2 = [setpoint0 setpoint1 setpoint2];

figure(2)
set(gcf,'DefaultAxesFontSize',14)  %<--------set character size
set(gcf,'DefaultTextFontSize',14)
plot(price_customer1, setpoint_customer1,'k','LineWidth',1)
hold on
plot(price_customer2, setpoint_customer2,'r','LineWidth',1)
legend('customer1','customer2')
xlabel('Price ($/MW)')
ylabel('Setpoint (^oF)')
ylim([69 81])
grid on
