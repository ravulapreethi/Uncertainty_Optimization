* Preethi_Ravula, file created on 12/6/2018
$onText
Section 1:
In this section, the program is a deterministic LP where uncertainities in yield are not considered.
The optimal objective function values (Z1, Z2, Z3) are computed for yield values
set according to three scenarios and for case 4, expected value of the yields from three scenarios
is used to compute first stage variables.
These first stage variables i.e., x(crop) are given as input in the
stochastic version of the program (section 2) to determine optimal objective function value Z4
Optimal Objective function value Z5 is computed with yield also as a variable in section 3 of the program
 a.) EVPI = (0.35*Z1+0.5*Z2+0.15*Z3) - Z5 ;
 b.) VSS  = Z5 - Z4 ;
$offText

Set
   crop             / wheat, corn, sugarbeets /
   i                / wheat, corn, sugarbeets1, sugarbeets2 /
   cases      'Three scenarios & case with expected yield values' / 1*4 / ;

File output /prob10.txt/;
put output ;
put '        x1*         ' , 'x2*         ' ,'x3*   ' , 'Objective function value' /

Parameter

   yield(crop)          'tons/acre'               /  wheat         2.5
                                                     corn          3
                                                     sugarbeets   20   /
   plantingcost(crop)   '$/acre'                  /  wheat       150
                                                     corn        230
                                                     sugarbeets  260   /
   sellingprice(i)      '$/ton'                   /  wheat       170
                                                     corn        150
                                                     sugarbeets1  36
                                                     sugarbeets2  10   /
   purchaseprice(crop)  '$/ton'                   /  wheat       238
                                                     corn        210
                                                     sugarbeets  0    /
   minreq(crop)         'ton'                     /  wheat       200
                                                     corn        240
                                                     sugarbeets  0     /;

* To calculate Objective function values seperately for three scenarios
* for case 4 : Expected values of crops
* Yield(wheat) = 0.35*3+0.5*2.5+0.15*2 = 2.6;
* Yield(corn) = 0.35*3.6+0.5*3+0.15*2.4= 3.12;
* Yield(sugarbeets) = 0.35*24+0.5*20+0.15*16= 20.8;

Table yield_case(crop, cases)   'yield of cros for different cases'

              1      2      3      4
 wheat        3      2.5    2      2.6
 corn         3.6    3      2.4    3.12
 sugarbeets   24     20     16     20.8

;

Scalar
   landTotal           'available land'   /  500 /
   maxbeets            'quota on production of sugarbeets'    / 6000 /
   EVPI                'Expected value of perfect information' ;

Variable
   x(crop)      'acres of land devoted to the crops'
   w(i)         'Tons of crops sold'
   y(crop)      'Tons of crops purchased'
   Z            'Profit';

Positive Variable x, w, y;

Equation
   profiteqn         'objective function'
   landallocation    'Total Land Available'
   req(crop)         'feed requirements'
   beetsquota        'Sugarbeets production';

profiteqn..    Z =e= - sum(crop,  plantingcost(crop)*x(crop))
                       -    sum(crop, purchaseprice(crop)*y(crop))
                       +    sum(i, sellingprice(i)*w(i));

landallocation..      sum(crop, x(crop)) =l= landTotal;

req(crop)..   yield(crop)*x(crop) + y(crop) - sum(sameas(i,crop),w(i)) =g= minreq(crop);

beetsquota..        w('sugarbeets1') + w('sugarbeets2') =l= yield('sugarbeets')*x('sugarbeets');

w.up('sugarbeets1') = maxbeets;

Model Prob10_S2 / all /;

loop ( cases ,
         yield(crop) = yield_case(crop, cases);
         solve Prob10_S2 using lp maximizing Z;
         put  x.l('wheat') x.l('corn') x.l('sugarbeets') z.l/;
   );

Display w.l, y.l, Z.l, x.l ;

$onText
Section 2:

In this program, uncertainities in the yield are considered.
The first stage variables i.e., x4(crop) calculated from expected or average values
of yield are given as input and objective function value Z4 is calculated

$offText

Set
   s 'scenarios'    / high, medium, low /;

Parameters
   yield2(crop)       'tons/acre'               /  wheat         2.5
                                                   corn          3.0
                                                   sugarbeets   20   /

   p(s)           'scenario probability'        /  high        0.35
                                                   medium      0.5
                                                   low         0.15  /

   x4(crop)       'First stage variable_input'   /  wheat        182.692
                                                    corn          76.923
                                                    sugarbeets   240.385   /

   yldscenario(crop,s)  'yield for scenario s';

*  Given that yield changes +/- 20%

   yldscenario(crop,'low')      = 0.8*yield2(crop);
   yldscenario(crop,'medium')   =     yield2(crop);
   yldscenario(crop,'high')     = 1.2*yield2(crop);


Variables
*   x4(crop)      'acres of land devoted to the crops'
   Z4            'Total Profit'
   ws(i, s)     'Tons of crops sold under scenario s'
   ys(crop, s)  'Tons of crops purchased under scenario s' ;

Positive Variable ws, ys;

Equation
   profiteqn4           'objective function'
   req4(crop,s)         'Feed Requirements'
   beetsquota1(s)
   beetsquota2(s);

profiteqn4..    Z4 =e= - sum(crop, plantingcost(crop)*x4(crop))
                           + sum(s, P(s)*(- sum(crop, purchaseprice(crop)*ys(crop,s))
                                          + sum(i, sellingprice(i)*ws(i,s))));

req4(crop,s)..    yldscenario(crop,s)*x4(crop) + ys(crop,s) -  sum(sameas(i,crop),ws(i,s))
                        =g= minreq(crop);

beetsquota1(s)..    ws('sugarbeets1',s) + ws('sugarbeets2',s) =l= yldscenario('sugarbeets',s)*x4('sugarbeets');

beetsquota2(s)..    ws('sugarbeets1',s)  =l=  maxbeets ;

Model Prob10_S4 / profiteqn4, req4, beetsquota1, beetsquota2 /;

Solve Prob10_S4 using lp maximizing Z4;

put  x4('wheat') x4('corn') x4('sugarbeets') Z4.l/;

Display Z4.l, ws.l, ys.l ;

$onText
Section 3:

In this program, uncertainities in the yield are considered and
the first stage variables i.e., x(crop) are considered as unknown.
The optimal objective function value Z5 is calculated
$offText

Variables
   x5(crop)      'acres of land devoted to the crops'
   Z5            'Total Profit'


Positive Variable x5;

Equation
   profiteqn5           'objective function'
   landAllocation5       'Total Land Available'
   req5(crop,s)         'Feed Requirements'
   beetsquota15(s);

profiteqn5..   Z5  =e= - sum(crop, plantingcost(crop)*x5(crop))
                           + sum(s, P(s)*(- sum(crop, purchaseprice(crop)*ys(crop,s))
                                          + sum(i, sellingprice(i)*ws(i,s))));

landAllocation5..      sum(crop, x5(crop)) =l= landTotal;

req5(crop,s)..    yldscenario(crop,s)*x5(crop) + ys(crop,s) -  sum(sameas(i,crop),ws(i,s))
                        =g= minreq(crop);

beetsquota15(s)..    ws('sugarbeets1',s) + ws('sugarbeets2',s) =l= yldscenario('sugarbeets',s)*x5('sugarbeets');


Model Prob10_S5 / profiteqn5, landAllocation5, req5, beetsquota15, beetsquota2 /;

Solve Prob10_S5 using lp maximizing Z5;

put  x5.l('wheat') x5.l('corn') x5.l('sugarbeets') Z5.l/;

Display x5.l, Z5.l, ws.l, ys.l ;




