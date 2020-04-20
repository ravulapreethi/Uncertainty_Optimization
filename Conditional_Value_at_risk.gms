***************************************************************************
* Code Author: Preethi Ravula, created on 11/15/2018
* Conditional Value at Risk as a risk measure, create CDF, scenario profits, and efficeint frontier
***************************************************************************
SETS
f Contracts /f1 * f3/
T Periods /t1 * t3/
W Scenarios /w1 * w10/;

SCALARS
beta Weighting parameter /1/
alpha Confidence level /0.8/
LambdaC selling price to clients /35/;

PARAMETERS
LambdaF(f) price in future markets
/ f1 34
f2 35
f3 36 /
PC(T) Demand of consumer
/ t1 150
t2 225
t3 175/
Xmax(f) Maximum quantity from future market
/ f1 50
f2 30
f3 25/
pi(W) probability of scenario
*/ w1 0.05, w2 0.05, w3 0.05, w4 0.05, w5 0.05, w6 0.15, w7 0.15
*w8 0.15, w9 0.15, w10 0.15 /;
/ w1 0.01, w2 0.01, w3 0.01, w4 0.01, w5 0.01, w6 0.01, w7 0.01
w8 0.01, w9 0.01, w10 0.01 /;
TABLE lambdaP(W,T) price of energy in pool (dollars per MWh)
     t1   t2    t3
w1  28.5 36.3 31.4
w2  27.3 37.5 29.6
w3  29.4 35.7 31.3
w4  33.9 35.4 35.1
w5  34.5 38.9 37.5
w6  29.2 34.8 31.2
w7  34.1 36.9 35.4
w8  33.4 35.4 34.9
w9  28.4 36.3 32.9
w10 27.6 38.9 32.1 ;
***************************************************************************
* DECLARATION OF VARIABLES
***************************************************************************
POSITIVE VARIABLES
** FIRST-STAGE VARIABLES
x(f) Power purchased in contract
** SECOND-STAGE VARIABLES
y(T,W) Power purchased from pool
s(W) Auxiliary variable used to calculate the CVaR ;

VARIABLES
z Objective function
** VARIABLES ASSOCIATED WITH RISK MODELING
eta Auxiliary variable used to calculate the CVaR;

EQUATIONS
ObjectiveFunction
MaximumFromFuturesMarket
DemandOfCustomer
ConstraintCVar ;

ObjectiveFunction .. z =e= (1-beta)*( lambdaC*(sum(T, PC(T)))
-sum(T, sum(f, lambdaF(f)*x(f) ))
-sum(W, pi(W)*(sum(T, lambdaP(W,T)*y(T,W)) )))
+beta*(eta-(1/(1-alpha))*sum(W, pi(W)*s(W)));
MaximumFromFuturesMarket(f) .. x(f) =l= Xmax(f);
DemandOfCustomer(T,W) .. sum(f, x(f)) + y(T,W) =e= PC(T);
ConstraintCVar(W) .. eta - ( sum(T, lambdaC*PC(T))- sum(T, sum(f,lambdaF(f)*x(f)))
- sum(T, lambdaP(W,T)*y(T,W))) =l= s(W);

***************************************************************************
* MODEL
***************************************************************************
MODEL CVarAtRisk /ALL/;
SOLVE CVarAtRisk USING miqcp MAXIMIZING z;
display x.l, z.l, s.l, eta.l, y.l
