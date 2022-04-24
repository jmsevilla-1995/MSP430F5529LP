%% Limpiar datos
close all
clear all
addpath(genpath('libreria'))
%% Constantes
l1=0;
l2=0.105;
l3=0.095;
l4=0.15;
d1=0;
tiempoSimulacion=10;
T=1;
%% Posiciones objetivo
X0 = 0.2;
Y0 = 0.05;
Z0 = 0.1;
Theta = -pi/4;
%% Calculo angulos objetivo
Theta_1_obj = atan(Y0/X0);
lx=l4*cos(Theta);
lz=l4*sin(Theta);
X1=sqrt((X0^2) + (Y0^2))-lx;
Z1=Z0-lz-(d1+l1);
h=sqrt((X1^2) + (Z1^2));
Theta_2_obj=atan(Z1/X1)+acos(((l2^2)-(l3^2)+(h^2))/(2*l2*h));
Theta_3_obj=acos(((l2^2)+(l3^2)-(h^2))/(2*l2*l3))-pi;
Theta_4_obj=Theta-Theta_2_obj-Theta_3_obj;
%% Calculo valores finales
A1=rotacion_z(Theta_1_obj, l1);
A2=rotacion_y(Theta_2_obj, l2);
A3=rotacion_y(Theta_3_obj, l3);
A4=rotacion_y(Theta_4_obj, l4);
At_1=A1;
At_2=A1*A2;
At_3=A1*A2*A3;
At_4=A1*A2*A3*A4;
%% Graficas
Xpos=zeros(1,4);
Ypos=zeros(1,4);
Zpos=zeros(1,4);
Xpos(1)=At_1(1,4);
Ypos(1)=At_1(2,4);
Zpos(1)=At_1(3,4);
Xpos(2)=At_2(1,4);
Ypos(2)=At_2(2,4);
Zpos(2)=At_2(3,4);
Xpos(3)=At_3(1,4);
Ypos(3)=At_3(2,4);
Zpos(3)=At_3(3,4);
Xpos(4)=At_4(1,4);
Ypos(4)=At_4(2,4);
Zpos(4)=At_4(3,4);
i=1;
figure(i)
hold on
title('Posicion')
plot3(Xpos, Ypos, Zpos)
zlabel('Eje Z')
xlabel('Eje X')
ylabel('Eje Y')
grid on
hold off










% for k=1:tiempoSimulacion/T
%     tiempo(k)=k*T;
%     A0=creador_matriz_xy(Theta_1, l1);
%     A1=creador_matriz_xz(Theta_2, l2);
%     A2=creador_matriz_xz(Theta_3, l3);
%     A3=creador_matriz_xz(Theta_4, l4);
%     At=A1*A2*A3;
% end
%% Simulacion
% h_3 = animatedline('Marker','o');
% h_2 = animatedline('Marker','x');
% h_1 = animatedline('Marker','*');
% for k = 1:length(z3)
%     addpoints(h_3,x3(k),z3(k))
%     addpoints(h_2,x2(k),z2(k))
%     addpoints(h_1,x1(k),z1(k))
%     drawnow limitrate
%     pause(1)
% end