%% Limpiar datos
close all
clear all
%% Constantes
R=2.79;
L=0.005;
Ke=0.0731;
Kp=0.0729;
J=1000;
f=0;
Vcc=5;
%% Especificaciones 
tiempoSimulacion=2;
tr=0.5;
SO=0.05;
chi=cos(atan(-pi/log(SO)));
wn=pi/(chi*tr);
wc=sqrt(sqrt(4*(chi^4)+1)-2*chi^2)*wn;
Mf=atan(2*chi*wn/wc);
Mfdeseado=Mf*180/pi;
Mfdes=-180+Mfdeseado;
%% Discretizadores
frecuencia=1000;
T=1/frecuencia;
%% Sensor
G=1;
H=G;
%% Calculo de las matrices
NUM=[Kp];
DEN=[L*J (R*J+L*f) (R*f + Ke*Kp) 0];
[A,B,C,D]=tf2ss(NUM,DEN);
[F,G]=c2d(A,B,T);
%% Calculo de la planta por medio de las matrices
Planta=tf(NUM,DEN);
i=i+1;
figure(i)
rlocus(Planta)
i=i+1;
figure(i)
bode(Planta)
grid
i=i+1;
figure(i)
step(Planta)
Gz=c2d(Planta,T,'zoh');
%% Controlador PID
%Diseño PI
Ti=tr;
numPI=[Ti 1];
denPI=[Ti 0];
PI=tf(numPI,denPI);
%Diseño PID
[MarGanancia,MarFase]=bode(PI*Planta,wc);
if(abs(Mfdes-MarFase) < 65)
    fi=(Mfdes-MarFase)*pi/180;
    alfa=(1-sin(fi))/(1+sin(fi));
    Td=1/(wc*sqrt(alfa));
    numPID=[Td 1];
    denPID=[alfa*Td 1];
    PID=tf(numPID,denPID);
else
    fi=(Mfdes-MarFase)*pi/360;
    alfa=(1-sin(fi))/(1+sin(fi));
    Td=1/(wc*sqrt(alfa));
    numPID=[Td 1];
    denPID=[alfa*Td 1];
    PID=tf(numPID,denPID);
    PID2=PID*PID;
    PID=PID2;
end
[MarGananciaC,MarFaseC]=bode(Planta*PID*PI,wc);
K=1/MarGananciaC;
figure(i)
step(((K*PI*PID)*Planta/(1+K*PI*PID*Planta)))
grid
i=i+1;
figure(i)
bode(K*PI*PID*Planta)
grid
Controlador=K*PI*PID;
Cz = c2d(K*PI*PID,T,'zoh')
numCz=deal(Cz.num{:});
denCz=-deal(Cz.den{:});
i=i+1;
figure(i)
step(Cz*Gz/(1+Cz*Gz)*H*0.001)
if length(numCz)<4
    numCz(4)=0;
    denCz(4)=0;
end
%% Codigo para probar controladores 
Ref=60;
R=Ref*H;
x(:,1)=[0;0;0];
uk_1=0;
uk_2=0;
uk_3=0;
ek_1=0;
ek_2=0;
ek_3=0;
for k=1:tiempoSimulacion/T
    e(k)=(R-C*x(:,k));
    u(k)=denCz(2)*uk_1+denCz(3)*uk_2+denCz(4)*uk_3+numCz(1)*e(k)+numCz(2)*ek_1+numCz(3)*ek_2+numCz(4)*ek_3;
    uk_3=uk_2;
    uk_2=uk_1;
    uk_1=u(k);
    ek_3=ek_2;
    ek_2=ek_1;
    ek_1=e(k);    
    y(k)=C*x(:,k);
    tiempo(k)=k*T;
    x(:,k+1)=F*x(:,k)+G*u(k);
end
error=100*(R-(y(length(y))))/R
i=i+1;
figure(i)
plot(tiempo,y/H)
grid
i=i+1;
figure(i)
plot(tiempo,e)
grid
a_1=denCz(2);
a_2=denCz(3);
a_3=denCz(4);
b_1=numCz(1);
b_2=numCz(2);
b_3=numCz(3);
b_4=numCz(4);
%% Codigo C
FlotadorEEPrealEst_r=fopen('Variables PID.txt','wt');
fprintf(FlotadorEEPrealEst_r, 'float a_1 = %15.15e ; \n\n',a_1);

fprintf(FlotadorEEPrealEst_r, 'float a_2 = %15.15e ; \n\n',a_2);

fprintf(FlotadorEEPrealEst_r, 'float a_3 = %15.15e  ; \n',a_3);
fprintf(FlotadorEEPrealEst_r, 'float b_1 = %15.15e  ; \n',b_1);
fprintf(FlotadorEEPrealEst_r, 'float b_2 = %15.15e  ; \n\n',b_2);

fprintf(FlotadorEEPrealEst_r, 'float b_3 = %15.15e  ; \n',b_3);
fprintf(FlotadorEEPrealEst_r, 'float b_4 = %15.15e  ; \n',b_4);

fclose(FlotadorEEPrealEst_r);