// course: Algebra 1, lecture: 2, date: 2026-08-06
#import "@local/greenbook:0.1.0": *

== Lecture 2
#note[Thursday 6 August 2026]


// Imported from ~/Library/Notes/Notes/Math/Algebra 1/Algebra Lect 2.md
He wrote down the overview of the course, I am too lazy to write it down, probably will be uploaded soon.

- Matrix units: $ bb(E)_(i j) = {1 &  & upright(" at slot ") \( i \, j \)\
  0 &  & upright(" otherwise") $
- Decomposition into units: $ A = A_(i j) bb(E)_(i j) $
- To understand matrix multiplication, we really need to just understand matrix multiplication of matrix units. Distributivity and such help with this.
  $ bb(E)_(i j) bb(E)_(k l) = delta_(j k) bb(E)_(i l) $

#remark[
What we are working with are matrix entries of a specific size, in particular, the size of $A$. So when expanding out the matrix multiplication, one has to be somewhat careful. The subscripts don't refer to the #emph[size] of the matrices, just where the non-zero entries are located. Somewhat less carefully, one may omit the size and remember just this formula and that you can multiply these unit matrices when evaluating $A B$ once we check that in fact we have something of the form $A_(p times q) B_(q times r)$.

]
==== Understanding solutions of linear equations
#definition[
A #emph[Linear Equation] in $n$ variables, $x_1 \, dots.h \, x_n$ is an equation of the form
$ a_1 x_1 + dots.h.c + a_n x_n = b $
where $a_i \, b in bb(R)$.

]
One can naively understand the dimension of the solution space as the “degrees of freedom” one has when writing the general solution. For example,
$ 2 x_1 - 3 x_2 + 0 x_3 + x_4 = 5 $
really gives you solutions of the form,
$ vec(x_1, x_2, x_3, - 2 x_1 + 3 x_2 + 5) $
therefore, $x_1 \, x_2 \, x_3$ are “free variables”, so our solution space is $3$ dimensional.

==== Systems of Linear Equations
The system of linear equations:

$  & a_11 x_1 + dots.h.c + a_(1 c) x_c & = b_1\
 & a_21 x_1 + dots.h.c + a_(2 c) x_c & = b_2\
 & dots.v\
 & a_(r 1) x_1 + dots.h.c + a_(r c) x_c & = b_r $
is equivalent to

$ mat(delim: "(", a_11, dots.h.c, a_(1 c); dots.v, dots.h.c, dots.v; a_(1 r), dots.h.c, a_(r c)) vec(x_1, dots.v, x_c) = vec(b_1, dots.v, b_r) $
