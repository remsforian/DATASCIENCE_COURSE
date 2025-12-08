%first we'll generate our random vectors and get their means and standard
%deveations

x1 = 0 + 1*randn(1,10000);
m1 = mean(x1);
s1 = std(x1);
x2 = 0 + 2*randn(1,10000);
m2 = mean(x2);
s2 = std(x2);
x3 = 0 + sqrt(2)*randn(1,10000);
m3 = mean(x3);
s3 = std(x3);
x4 = 2 + sqrt(2)*randn(1,10000);
m4 = mean(x4);
s4 = std(x4);

%the mean and std values are close to the input values, which is expected. 

%next we'll plot the histograms 

figure(1);
hold on;
histogram(x1, 'Normalization', 'pdf');
histogram(x2, 'Normalization', 'pdf');
histogram(x3, 'Normalization', 'pdf');
histogram(x4, 'Normalization', 'pdf');
hold off;
xlabel('Value');
ylabel('Probability Density');
title('Histograms of Random Vectors');
legend('x1', 'x2', 'x3', 'x4');

figure(2);
histogram(x1, "Normalization",'pdf');
xlabel('Value of x1');
ylabel('Probability Density');
title('Histogram of Random Vector x1');

figure(3);
histogram(x2, "Normalization",'pdf');
xlabel('Value of x2');
ylabel('Probability Density');
title('Histogram of Random Vector x2');

figure(4);
histogram(x3, "Normalization",'pdf');
xlabel('Value of x3');
ylabel('Probability Density');
title('Histogram of Random Vector x2');

figure(5);
histogram(x4, "Normalization",'pdf');
xlabel('Value of x4');
ylabel('Probability Density');
title('Histogram of Random Vector x4');

