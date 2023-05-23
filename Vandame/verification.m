load('total.mat');
total = (total)/max(total);
%[total,indice] = sort(total);

[total,indice] = sort(total);
ADI = importdata('D:\stage\verification\V1\ADI.txt');
ADI = ADI.data;
ADI = sum(ADI,1).';
ADI = (ADI);
ADI = ADI/max(ADI);
ADI = ADI(indice);
%ADI = ADI(indice);

res = [total ADI];

subplot(2,1,1)
bar(res)
hold on
xlabel('microphone folder')
ylabel('index')
legend('ACI','ADI')

subplot(2,1,2)
plot(total,ADI,'*')
ylabel('ADI')
xlabel('ACI')


