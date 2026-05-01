%   https://warwick.ac.uk/fac/cross_fac/complexity/newsandevents/events/archive/2012/summerschool2012/programme/watkins-1.pdf
%   https://www.statisticshowto.com/heavy-tailed-distribution/

K=1;
SIGMA=1;
THETA=SIGMA/K;
heavynoise= gprnd(K,SIGMA,THETA,1000,1);


figure(1); clf
plot(heavynoise)
title('white Pareto noise')
xlabel('time')
ylabel('amplitude')


figure(2);clf
heavywalk=cumsum(heavynoise);
plot(heavywalk)
title('Heavy-tailed walk')
xlabel('time')
ylabel('amplitude')

figure(3);clf
hist(heavynoise,200)
xlabel('amplitude')
ylabel('counts')
