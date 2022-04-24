function [ A ] = rotacion_z( theta, l )
%Esta función devuelve la matriz A del sistema de ecuaciones

    A = [cos(theta)   -sin(theta) 0   l*cos(theta);
         sin(theta)   cos(theta)  0   l*sin(theta);
         0                0       1        0      ;
         0                0       0        1     ];      
end

