% Code written by Dr. Ning Lu for DR book
% Example 3.3 - produce figure 3.7(c)
% Code written 9/21/2017
% Copyright North Carolina State University

clear all 
close all


    
for j = 1:5
    % Simulation setup
    Outdoor_temp_start = 5
    Outdoor_temp_end = 5
    color = ['rgbcm'];
    Time = 60*20 % in minutes
    Timestep = 1 % second
    N_timestep = Time*60/Timestep;
    Tout = linspace(Outdoor_temp_start,Outdoor_temp_end,N_timestep);
    
    Tset = 21 % degree C
    TDB = 2 %degree C
    Troom0 = Tset-TDB+rand(1)*TDB;
    Prated = 6000 %W
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

    R1 = 1/UA+0.1*1/UA*rand(1)
    R2 = 1/UAmass+0.1*1/UAmass*rand(1)
    Ca = Vair*DensityAir*Cv_air + Vair*DensityAir*Cv_air*0.1*rand(1) 
    Cm = V_furniture*C_funiture + V_furniture*C_funiture*0.1*rand(1)

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
    plot(Time,Troom_record,color(j),'LineWidth',1)
    % plot(Tmass_record,'b')
    xlabel('Time (minute)')
    ylabel('Temperature (^oC)')
    hold on
%     title('Room Temperature Profiles')
    ylim([19 23])
    
    
    clear all
end






    
    

