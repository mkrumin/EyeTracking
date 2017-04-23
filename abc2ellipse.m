function out = abc2ellipse(params)

% this function goes from
% Ax^2+Bxy+Cy^2+Dx+Ey+F=0
% representation of ellipse to
% (x-x0)^2/a^2 +(y-y0)^2/b^2 = 1 with rotation by angle theta
% - also checks if the result is an ellipse and
% - calculates vectors xx and yy for easy plotting

A = params(1);
B = params(2);
C = params(3);
D = params(4);
E = params(5);
if length(params)==6
    F = params(6);
else
    F = -1;
end

out.pars = [A, B, C, D, E, F];
out.eq = sprintf('%d*x^2+%d*x*y+%d*y^2+%d*x+%d*y+%d=0', A, B, C, D, E, F);

Det = B^2-4*A*C;
out.isEllipse = Det<0;

if out.isEllipse
    out.x0 = (2*C*D-B*E)/Det;
    out.y0 = (2*A*E-B*D)/Det;
    out.a = -sqrt(2*(A*E^2+C*D^2-B*D*E+Det*F)*(A+C+sqrt((A-C)^2+B^2)))/Det;
    out.b = -sqrt(2*(A*E^2+C*D^2-B*D*E+Det*F)*(A+C-sqrt((A-C)^2+B^2)))/Det;
    out.area = pi*out.a*out.b;
    if abs(B)<eps
        if A<C
            theta = 0;
        else
            theta = pi/2;
        end
    else
        theta = atan((C-A-sqrt((A-C)^2+B^2))/B);
    end
    out.theta = theta;
    
    rotMatrix = [cos(theta), -sin(theta); sin(theta), cos(theta)];
    t = linspace(0, 2*pi, 33)'; % 33 points, 8 per 90 degrees, should look smooth enough
    % this is an ellipse at the origin, not rotated
    coords = [out.a*cos(t), out.b*sin(t)];
    % shifting and rotating the ellipse
    coords = bsxfun(@plus, [out.x0, out.y0], coords*rotMatrix');
    out.xxEllipse = coords(:, 1);
    out.yyEllipse = coords(:, 2);
    
else
    out.x0 = NaN;
    out.y0 = NaN;
    out.a = NaN;
    out.b = NaN;
    out.area = NaN;
    out.theta = NaN;
    out.xxEllipse = NaN;
    out.yyEllipse = NaN;
end