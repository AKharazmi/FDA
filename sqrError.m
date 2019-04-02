function err = sqrError(coeffs, x1, y1, x2, y2)
% Interpolation of 'y2' with scaled 'x2' into the domain 'x1'
%y2sampledInx1 = interp1(coeffs(1)*x2,y2,x1,'spline');%'spline','pchip'
% Spline interpolation using not-a-knot end conditions. The interpolated value at a query point is based on a cubic interpolation of the values at neighboring grid points in each respective dimension.
% Squred error calculation
% err = sum((coeffs(2)*y2sampledInx1-y1).^2);
err = sum((coeffs(2)*y2-y1).^2);