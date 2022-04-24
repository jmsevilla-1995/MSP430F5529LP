function [A] = rotacion_y(theta, l)
%Esta funci�n devuelve la matriz A del sistema de ecuaciones

    A = [cos(theta)   0   -sin(theta) l*cos(theta);
         0            1         0      0      ;
         sin(theta)   0    cos(theta) l*sin(theta);
         0            0         0      1      ];      
end