
* Preethi_Ravula, file created on 12/6/2018

Set i       / 1*3 /
    j       / 1*3 /
    k1    "cases1" /1*15 /
    k2    "cases2" /16*19/ ;

File output /prob1d.txt/;
put output ;
put 'Expected return     ' , 'Variance     ', 'x1          ', 'x2          ', 'x3      ' /

Parameter
   r(i) "expected return for stock i"
                      / 1 10,  2 20, 3 30/
Scalar   rm    / 0 /  ;

Table  V(i,j)   "co-variance of returns for stock i and stock j"

          1      2      3
 1       4.2   -1.9     2.0
 2      -1.9    6.7    -5.0
 3       2.0   -5.0     7.0
;

Variables
         x   "% of total budget spent on stock i"
         z ;

Positive Variable x;
Equations
  variance       define objective function
  sum_p          sum of all fractions of x(i) constraint
  return         minimum return constraint;

variance .. z =e= Sum((i,j),V(i,j)*x(i)*x(j));
sum_p ..    Sum(i,x(i)) =e= 1;
return ..   Sum(i,r(i)*x(i)) =g= rm;

Model prob2 /all/ ;
loop ( k1 ,
         Solve prob2 using qcp minimizing z ;
         put rm z.l x.l('1') x.l('2') x.l('3') /;
         rm = rm +2 ;
   );

Parameter
   last(k2) "min return for last 4 cases"
                      / 16 29, 17 29.5, 18 29.7, 19 29.9 / ;

loop ( k2,
         rm = last(k2) ;
         Solve prob2 using qcp minimizing z ;
         put rm z.l x.l('1') x.l('2') x.l('3') /;
   );
