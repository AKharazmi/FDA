function err2 = sqrError2(coeffs,y1,all)

err2 = sum((y1-((coeffs(1)*all(:,1))+(coeffs(2)*all(:,2))+(coeffs(3)*all(:,3))+...
    (coeffs(4)*all(:,4))+(coeffs(5)*all(:,5))+(coeffs(6)*all(:,6))+(coeffs(7)*all(:,7))+...
    (coeffs(8)*all(:,8))+(coeffs(9)*all(:,9))+(coeffs(10)*all(:,10))+(coeffs(11)*all(:,11))+...
    (coeffs(12)*all(:,12))+(coeffs(13)*all(:,13))+(coeffs(14)*all(:,14))+(coeffs(15)*all(:,15))+...
    (coeffs(16)*all(:,16))+(coeffs(17)*all(:,17))+(coeffs(18)*all(:,18)))).^2);

end