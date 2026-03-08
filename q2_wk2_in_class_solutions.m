clear all
close all 
clc

Vmpp = 35.5;
Voc = 44;
Impp = 4.78;
Isc = 5.3;
ki=1.22e-3;
kv=-154e-3;
Tstc=25+273.15;
T=Tstc;
Gstc=1000;
G=300;
np=1;
ns=72;

[Iph,Vt,Rs,Io]=Q1(Impp,Vmpp,Isc,Voc);

points = 100;
V = linspace(0,Voc,points);
I = zeros(1,points);

function [Iph,Vt,Rs,Io]=Q1(Impp,Vmpp,Isc,Voc)
% This function determines the 4 paramters for the
% four parameter model from Impp, Vmpp, Isc, Voc

Iph = Isc; 
Vt = ((2*Vmpp-Voc)*(Isc - Impp))/(Impp + (Isc -Impp)*log((Isc - Impp))/Isc);
Rs = (Vt*log((Isc - Impp)/Isc) + Voc - Vmpp)/Impp;
Io = Isc/(exp(Voc/Vt));

end



%Isc,Voc temperature dependency
Isct=Isc+ki*(T-Tstc);
Voct=Voc+kv*(T-Tstc);
%I0, Vt temperature dependency
Vtt=Vt*(T/Tstc);
Iot=Isct/(exp(Voct/Vtt));

%Isc, Voc irradiance AND temperature dependency
Iscgt=Isct*(G/Gstc);
Vocgt=log(Iscgt/Iot)*Vtt;


points_2 = 100;
V2 = linspace(0,Vocgt,points_2);
Ivgt = zeros(1,points_2);


Ivgt=Iscgt-Iot*exp((V2+Ivgt.*Rs)./Vtt);

Iarray=Ivgt*np;
Vstring=V*ns;



I = Isc - Io*(exp((V + I.*Rs)./Vt)-1);

figure
hold on
box on
grid on
plot(V,I,"Linewidth",1.5,"Color",'r')
xlabel("Voltage (V)" ,"FontSize",20,'FontWeight','bold')
ylabel("Current (A)","FontSize",20,'FontWeight','bold')

plot(V2,Ivgt,"Linewidth",1.5,"Color",'g')


hold off

figure
hold on
box on
grid on
plot(V,V.*I,"Linewidth",1.5,"Color",'r')
xlabel("Voltage (V)","FontSize",20,'FontWeight','bold')
ylabel("Power (W)","FontSize",20,'FontWeight','bold')

plot(V2,V2.*Ivgt,"Linewidth",1.5,"Color",'g')

hold off