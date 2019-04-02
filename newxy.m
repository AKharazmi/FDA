function [scale1,scale2,scale3,data_avephotolysis,data_forsclaing,newydata1,newydata2] = newxy (minmax_value,x1,y1,yrefspec)
min_value = str2double(minmax_value{1,1});
max_value = str2double(minmax_value{2,1});

data_avephotolysis = [x1,y1];
data_forsclaing = [x1,yrefspec];

data1size = size(data_avephotolysis);
data2size = size(data_forsclaing);
zero1 = zeros(1,data1size(1,2));
zero2 = zeros(1,data2size(1,2));

m = data1size(1,1);
n = data2size(1,1);

for k = 1:m
    if data_avephotolysis (k,1) > max_value
        data_avephotolysis(k,:) = zero1;
    elseif data_avephotolysis (k,1) < min_value
        data_avephotolysis(k,:) = zero1;
    end
end
data_avephotolysis( ~any(data_avephotolysis,2), : ) = [];

for k = 1:n
    if data_forsclaing (k,1) > max_value
        data_forsclaing(k,:) = zero2;
    elseif data_forsclaing (k,1) < min_value
        data_forsclaing(k,:) = zero2;
        
    end
end
data_forsclaing( ~any(data_forsclaing,2), : ) = [];
%%
%finding scale1 by deviding the area under the curve for sample over
%the area under the curve for ref spec after baseline correcting both
data1size = size(data_avephotolysis);

xdata1 = [data_avephotolysis(1,1),data_avephotolysis(data1size(1,1),1)]';
ydata1 = [data_avephotolysis(1,2),data_avephotolysis(data1size(1,1),2)]';
pdata1 = polyfit(xdata1,ydata1,1);
ppdata1 = polyval(pdata1,data_avephotolysis(:,1));
newydata1 = data_avephotolysis(:,2)-ppdata1;

data2size = size(data_forsclaing);
xdata2 = [data_forsclaing(1,1),data_forsclaing(data2size(1,1),1)]';
ydata2 = [data_forsclaing(1,2),data_forsclaing(data2size(1,1),2)]';
pdata2 = polyfit(xdata2,ydata2,1);
ppdata2 = polyval(pdata2,data_forsclaing(:,1));
newydata2 = data_forsclaing(:,2)-ppdata2;

intfn1 = trapz (newydata1);
intfn2 = trapz (newydata2);
scale1 = intfn1 /intfn2;
%finding scale1 by deviding the area under the curve for sample over
%the area under the curve for ref spec after baseline correcting both
%%
%finding scale2 by solver fitting data points after baseline correcting both
coeffs = fmincon(@(c) sqrError(c,data_avephotolysis(:,1), newydata1, data_forsclaing(:,1), newydata2),[1;1]);


%                 A = coeffs(1);
scale2 = coeffs(2);
%finding scale2 by solver fitting data points after baseline correcting both
%%
%finding scale3 by solver fitting data points without baseline
coeffs = fmincon(@(c) sqrError(c,data_avephotolysis(:,1), data_avephotolysis(:,2), data_forsclaing(:,1), data_forsclaing(:,2)),[1;1]);
scale3 = coeffs(2);
% coeffs = lsqlin(data_forsclaing(:,2),data_avephotolysis(:,2));%,[],[],[],[],0,1);
% scale3 = coeffs;
