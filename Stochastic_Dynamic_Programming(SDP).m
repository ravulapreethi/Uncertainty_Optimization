%%Using the stochastic dynamic program, solve this problem to find an optimal budget allocation for each of the four projects in
%each of the two time periods. The goal is to maximize the probability that at least one project succeeds (makes it to TRL 8
%starting from TRL 4). Answer should include the optimal funding strategy (which projects
%get funded in which time periods), the optimal success probability (that at least one project suc-
%ceeds), and supporting calculations.

% Code Author: Preethi Ravula
% Created on 11/15/2018


clear all
close all
clc
% a cost of projects
a=[4.6 7; 3.6 7.5; 2.8 8.6; 5.0 6.5];
% Budjet allocation
B1 = 12; B2 = 20;
% decision variable on whether to fund or not
X = zeros(4,1); 
% probability of success of each project
p = [0.29; 0.195; 0.260; 0.32]; 
V = zeros(4,4); Xn = zeros(4,16); % V - objective function to be maximized
% calculating V for different combinations of funding decisions undert
% the budjet constraint
n = 1; 
for i = 1:4
X = zeros(4,1); X(i) = 1; Xn(:,n) = X';
   for  j = i+1:4
     X(j) = 1;  cost = (X.*a(:,1));
     if cost <=B1 % budjet constraint
         n = n+1; Xn(:,n) = X'; % storing decisions
    V(i,j)= 1-((1-X(i)*p(i))*(1-X(j)*p(j))); % overall probability for two projects funded
     X(j) = 0;
     end
   end bbbnbbbbb b                    
   V(i,i) = 1-(1-X(i)*p(i)); % only one project funded overall probability
    n = n+1;
end
% funding three projects in first stage
for i = 1:4
X = zeros(4,1); X(i) = 1; Xn(:,n+1) = X';
   for  j = i+1:4
     X(j) = 1;  
     for k = j+1:4
         X(k)=1; cost = (X.*a(:,1));
     if cost <=B1 % budjet constraint
         n = n+1; Xn(:,n) = X';
    V2(i)= 1-((1-X(i)*p(i))*(1-X(j)*p(j))+(1-X(j)*p(j))*(1-X(k)*p(k))+(1-X(i)*p(i))*(1-X(k)*p(k)))/3; % two projects funded
          end
     X(k) = 0;
     end
     X(j) = 0;
   end
end
M1 = max(V(:))
M2 = max(V2(:))
optimal_Objective_function = max(M1,M2)
    
    




