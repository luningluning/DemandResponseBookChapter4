% Code written by Dr. Ning Lu for DR book
% Example 3.3 - produce figure 3.7(c)
% Code written 9/21/2017
% Copyright North Carolina State University

clear all 
close all

% Simulation setup
Outdoor_temp_start = 0
Outdoor_temp_end = 5
color = ['rgbcm'];
Time = 60*3 % in minutes
Timestep = 1 % second
N_timestep = Time*60/Timestep;
Tout = linspace(Outdoor_temp_start,Outdoor_temp_end,N_timestep);
Tset = 20 % degree C
TDB = 1 %degree C
Troom0 = 20;
Prated = 5020 %W
Area = 228  % in m^2
Vair =  228*5 % m^3
DensityAir = 1.225  % kg/m^3
Cp_air = 1005 % J/kg.k
Cv_air = 780  % J/kg.k
C_funiture = 1000 % J/kg.k
V_furniture = 1000 %kg
UA = 111  %W/degree C
UAmass = 3924 %W/degree C
T_on=0;
T_off=0;

R1 = 1/UA
R2 = 1/UAmass
Ca = Vair*DensityAir*Cv_air  
Cm = V_furniture*C_funiture

A = [-(1/(R2*Ca)+1/(R1*Ca))  1/(R2*Ca); 1/(R2*Cm)  -1/(R2*Cm)]
B = [1/(R1*Ca) 1/Ca ;0 0]
C = [1 0; 0 1]
D = [0; 0]

status = zeros(1, Time);
Q =  zeros(1, Time);
x0 = [Troom0;Troom0];

if x0(1) > (Tset + TDB/2)
    status(1) = 0;
elseif x0(1)<(Tset - TDB/2)
    status(1) = 1;
end
if status(1) == 1
    Q0(1) = Prated*Timestep;
else
    Q0(1) = 0;
end
u0 = [Tout(1); Q0]    

for i = 2:1:N_timestep
    DT = A*x0  + B*u0;
    x1 = x0+DT;
    if (x1(1)>(Tset + TDB/2)) &&  (status(i-1) == 1)
        status(i) = 0;
    elseif (x1(1)< (Tset - TDB/2)) &&  status(i-1) == 0
        status(i) = 1;
    else
        status(i) = status(i-1);
    end
    if status(i) == 1
        Q(i) = Prated*Timestep;
        T_on(i,1) = T_on(i-1,1)+1;
        T_off(i,1) = 0;
    else
        Q(i) = 0;
        T_off(i,1) = T_off(i-1,1)+1;
        T_on(i,1) = 0;
    end
    x0 = x1;
    u0 = [Tout(i); Q(i)];
    Troom_record(i-1,1) = x1(1);
    Tmass_record(i-1,1) = x1(2);
end
Time = [0:Timestep:((N_timestep-2)*Timestep)]/60;

figure(1)
set(gcf,'DefaultAxesFontSize',14)  %<--------set character size
set(gcf,'DefaultTextFontSize',14)
plot(Time,Troom_record,color(1),'LineWidth',2)
% plot(Tmass_record,'b')
xlabel('Time (minute)')
ylabel('Temperature (^oC)')
hold on
title('Room Temperature Profiles')
xlim([0 60*60*3]/60)


% calculate the room temperature using a linear model
Ton_0degree = 538; % in second
Toff_0degree = 680; % in second
dT_on = TDB/Ton_0degree; 
dT_off = -TDB/Toff_0degree;
x00 = x0(1);

if x00 > (Tset + TDB/2)
    status(1) = 0;
elseif x00<(Tset - TDB/2)
    status(1) = 1;
end
if status(1) == 1
    Q0(1) = Prated*Timestep;
    DT_linear = TDB/Ton_0degree;
else
    Q0(1) = 0;
    DT_linear = -TDB/Toff_0degree;
end
u0 = [Tout(1); Q0]

for i = 2:1:N_timestep
    x11 = x00+DT_linear;

    DT_actual = A*x0  + B*u0;
    x1 = x0+DT_actual;
    
    if (x11>(Tset + TDB/2)) &&  (status(i-1) == 1)
        status(i) = 0;
    elseif (x11< (Tset - TDB/2)) &&  status(i-1) == 0
        status(i) = 1;
    else
        status(i) = status(i-1);
    end
    if status(i) == 1
        Q(i) = Prated*Timestep;
        DT_linear = TDB/Ton_0degree;
        T_on(i,1) = T_on(i-1,1)+1;
        T_off(i,1) = 0;
    else
        Q(i) = 0;
        DT_linear = -TDB/Toff_0degree;
        T_off(i,1) = T_off(i-1,1)+1;
        T_on(i,1) = 0;
    end
    
    if i == 900 |  i == 1800 |  i == 2700 |  i == 3600 |  i == 4500 |  i == 5400 |  i == 6300 ...
            |  i == 7200 |  i == 8100 |  i == 9000 |  i == 9900 |  i == 10800
        x00=x1(1);
        x0 = x1;      
        figure(2)
        set(gcf,'DefaultAxesFontSize',16)  %<--------set character size
        set(gcf,'DefaultTextFontSize',16)
        plot(i/60,x1(1),'r^')
        hold on
        plot(i/60,x11,'bo')
        
    else
        x00=x11;
        x0 = x1;
    end

    u0 = [Tout(i); Q(i)];
    Troom_record_simple(i-1,1) = x11;
    Troom_record_actual(i-1,1) = x1(1);

end
Time = [0:Timestep:((N_timestep-2)*Timestep)]/60;

figure(1)
set(gcf,'DefaultAxesFontSize',14)  %<--------set character size
set(gcf,'DefaultTextFontSize',14)
plot(Time,Troom_record_simple,'b--','LineWidth',2)
% plot(Tmass_record,'b')
xlabel('Time (minute)')
ylabel('Temperature (^oC)')
legend('SS-RCQ','Linear ETP')
hold on


figure(2)
set(gcf,'DefaultAxesFontSize',16)  %<--------set character size
set(gcf,'DefaultTextFontSize',16)
plot(Time,Troom_record_actual,'r')
hold on
plot(Time,Troom_record_simple,'b')
% plot(Tmass_record,'b')
xlabel('Time (minute)')
ylabel('Temperature (^oC)')
hold on


title('(c) Linearized ETP with 15-miunute Error Correction')
legend('SS-RCQ','Linear ETP')
xlim([0 60*60*3]/60)
ylim([19 22])



    
    

