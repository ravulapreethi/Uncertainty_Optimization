* Preethi_Ravula, file created on 12/6/2018
$onText
Chance constrained problem with random coefficent matrix A, solved for
different values of F_inv
$offText

Sets
         m      / 1*5 /
         n      / 1*5 /
         i      / 1*3 /
         j      / 1*5 /
         k    "Cases with different values of F_inv" /1*4/ ;

* output the optimal values to the file specified
File output /prob7.txt/;
put output ;
put 'Case: F_inv(1)       ' , 'x1*         ' , 'x2*         ' ,'x3*         ' ,'x4*         ', 'x5*      ', 'Objective function value' /

Parameters
   C(m)    / 1 100,  2 200, 3 300, 4 400, 5 500/
   b(i)    / 1 1,  2 2, 3 3/
   F_inv(i)  / 1 -0.2, 2 -0.4, 3 -0.6 /
   F_case(k)  'First column of F_inv(1-ai) values'  / 1 -0.2, 2 -0.7, 3 -1.2, 4 1.0 /
;

* Since in each of the cases, only first value is different,
* the first values are asigned to a seperate parameter F_case(k)
* Variance-covariance matrices for each i are stored seperately to V1, V, V3

Table  V1(m,n)   "1st variance co-variance matrix"

          1  2  3  4  5
 1        1  0  0  0  0
 2        0  2  0  0  0
 3        0  0  3  0  0
 4        0  0  0  4  0
 5        0  0  0  0  5
;

Table V2(m,n)   "2nd variance co-variance matrix"

          1  2  3  4  5
 1        2  1  1  1  1
 2        1  2  1  1  1
 3        1  1  2  1  1
 4        1  1  1  2  1
 5        1  1  1  1  2

;

Table V3(m,n)   "3rd variance co-variance matrix"

          1  2  3  4  5
 1        3  1  1  1  1
 2        1  3  1  1  1
 3        1  1  3  1  1
 4        1  1  1  3  1
 5        1  1  1  1  3

;

Table A(i,j)

          1    2   3   4   5
 1        1    2   3   4   5
 2        6    7   8   9  10
 3        11  12  13  14  15
;

* Assign co-variance matrices to a single 3D matrix V

Parameter V(m,n,i) Co-variance matrix ;
V(m,n,'1') = V1(m,n)   ;
V(m,n,'2') = V2(m,n)   ;
V(m,n,'3') = V3(m,n)   ;

Variables
         x
         z  'objective function' ;

Positive Variable x;
Equations
  cost       define objective function
  Constraints(i) ;

cost .. z =e= sum(m, C(m)*x(m));
Constraints(i) .. Sum((j),a(i,j)*x(j)) + F_inv(i)*sqrt(sum((m,n),V(m,n,i)*x(m)*x(n))) =g= b(i);

* Constraints(i) contains constraints for i =1, 2, 3, total 3 constraints

Model prob7 /all/ ;

* The loop runs for the four cases by replacing the first value of F_inv each time

loop ( k ,
         F_inv('1') = F_case(k);
         Solve prob7 minimizing z using nlp ;
         put F_inv('1') x.l('1') x.l('2') x.l('3') x.l('4') x.l('5') z.l/;
   );

display x.l, z.l
