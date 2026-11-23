// course: Algebra 1, lecture: 3, date: 2026-08-11
#import "@local/greenbook:0.1.0": *

== Lecture 3
#note[Tuesday 11 August 2026]


// Imported from ~/Library/Notes/Notes/Math/Algebra 1/Algebra Lect 3.md
Analysis-Algebra Tutorials \@2pm on Mondays and Friday. This week tutorial on sat \@2pm :((((

#example[
Consider the following two equations:
$ 2 x + 4 y + 6 z + 8 w & = 1 quad #h(0em) #h(0em) \( 1 \)\
3 x + dots.h.c + 7 z + w & = 10 quad \( 2 \) $
This is equivalent to the matrix form of the equations:
$ mat(delim: "(", 2, , 4, , 6, , 8; 3, , 0, , 7, , 1) vec(x, y, z, w) = vec(1, 10) $
We can solve this by the usual methods of solving the equations, reducing #emph[independent] variables i.e degress of freedom. Of course a standard way to go about this is to form linear combinations of equations and remove a certain amount of variables this way till we get to a suitable form. For example, here we can substract $3 \/ 2$ times the first equation from the second:
$ - 6 y - 2 z - 11 w = 17 \/ 2 $
Note how this with $\( i \)$ or with $\( i i \)$ is the same system of equations, if we pair this with $\( i \)$, then $\( i i \)$ is recoverable.

]
The insight here is that systematically, if we have $ n$-many equations, replacing the $ i$-th equation with a linear combination of the $n$-equations does not change the system of the equation, and neither does swapping rows.

#definition[
We say two systems of equations are #emph[equivalent] if they've the same set of solutions.

]
To be a little more clear, the following operations retain the equivalence of system of equations:

+ Scale any of the equations by a scalar.
+ Replace eqn. $i$ by $upright(" eqn. ") i + a upright(" eqn ") j$, for any $c in bb(F)$.
+ Swap eqn. $i$ with row $j$.
  Where 1 and 2 maybe condensed to just say replace an equation by a linear combination of all the equations, by first doing 1. and then 2.

#remark[
Hoffman-Kunze defines equivalent systems to be where each equation in one system can be obtained as a linear combination of the equations in the second system. Now, we claim that such two systems must have the solutions. This follow rather straightforwardly, one can show that a solution of one system must be a solution of the other, and then the converse. This works because of linearity, and that equation is a linear combination of the equations of the other system'.

]
#definition[
For the matrix equation $A upright(bold(x)) = upright(bold(b))$. We define the #emph[augmented] matrix $\( A divides b \)$.

]
#example[
For the previous set of equations, the augmented matrix is:
$ mat(delim: "(", 2, 4, 6, 8, 1; 3, 0, 7, 1, 10) $

]
The idea behind this is that the names of the variable is auxiliary, and this allows us to easily represent the operations which preserve the equivalence of the system of the equations.

The associated elementary row operations on the augmented matrix are:

+ Linear combination of the $n$ rows.
+ Swapping the $i$ and $j$ rows.

#example[
$ mat(delim: "(", 2, 4, 6, 8, 1; 3, 0, 7, 1, 10) arrow.r^(R_1 arrow.r R_1 \/ 2) mat(delim: "(", 1, 2, 3, 4, 1 \/ 2; 3, 0, 7, 1, 10)\
arrow.r^(R_2 arrow.r R_2 - 3 R_1) mat(delim: "(", 1, 2, 3, 4, 1 \/ 2; 0, - 6, - 2, - 11, 17 \/ 2)\
arrow.r^(R_2 arrow.r - R_2 \/ 6) mat(delim: "(", 1, 2, 3, 4, 1 \/ 2; 0, 1, 1 \/ 3, 11 \/ 6, - 17 \/ 12)\
arrow.r^(R_1 arrow.r R_1 - 2 R_2) mat(delim: "(", 1, 0, 7 \/ 3, 1 \/ 3, 10 \/ 3; 0, 1, 1 \/ 3, 11 \/ 6, - 17 \/ 12) $

]
#remark[
Note that we can reduce an augmented matrix to something of the form
$ mat(delim: "(", 1, \*, dots.h.c, \*, \*, \*; 0, 1, dots.h.c, \*, \*, \*; dots.v, dots.v, dots.down, dots.v, dots.v, dots.v; 0, 0, dots.h.c, 1, \*, \*; 0, 0, dots.h.c, 0, 1, \*) $
Generally its a bit more complicated, the $1$ in the next row could be somewhere later, and you might've a bunch of entries left over at the last row after the $1$ (i.e you'd have some free variables remaining in the solution set). A row could also be all $0 quote.r.single s$ (except perhaps the constant term (by which I mean the last column, obtained using $upright(bold(b))$)), but in such a case we can either remove this row (if the constant term is $0$, and we have that all choices of variables satisfy the equation) or the system is inconsistent (if the constant term is non-zero). Regardless, you could always swap it to the bottom to still get rightly moving $1$'s.

The point here is that any system of equations can be reduced to such a form. We'll formally prove this later, but think about how you could do this in an algorithmic manner, it truly isn't that hard. But then why do we want to change our matrix to such a thing?

Consider the last row. Remember that this augmented matrix really just represents a system of equations. If we then consider the matrix equation, $A' upright(bold(x)) = upright(bold(b)) quote.r.single$ (where $A quote.r.single$ and $upright(bold(b)) quote.r.single$ are obtained from the equivalent augmented matrix which is reduced to the above form from the original). Look at the last row, after doing the proper matrix-vector multiplication, we see that the last variable is fully determined. Of course, if there were some cells left after the $1$, say the $i_t h$ cell is the $1$ and it goes up till $n$, what would happen is that some variable, $x_i$ would be determined in terms of $x_(i + 1) \, dots.h \, x_n$ (and a constant term). Then, we could substitute $x_i$ to the equation obtained from the second last row, and determine $x_(i - 1)$ in terms of the same variables! Thus this form allows us to easily solve our system of equations and find the solution space.

]
#definition[
The leading non-zero row in any row of the augmented matrix is called a #emph[pivot];.

]
#definition[
A matrix is said to be in a #emph[row-echelon] form if “pivots in sucessive rows move to the right” for all rows except the last. Typically we scale to make the pivots $1$.

]
Look at the previous note for some discussion on this. Algorithmically think about this---if we start with a zero-matrix we are vacuously done, but otherwise consider the #emph[first] non-zero column. Swap the row containing that to the first row. Now operation (2), $i$-th row + $a times j$-th row helps us kill all non-zero entries in that column. Now we essentially induct, the point is that we are done with the first row of the echelon form and can start looking for the second row by considering the #emph[next] non-zero column, in a smaller matrix (the red one)

Let us formally prove this.

#proof[
We induct on the number of the rows. Now for a one-row matrix, if all the columns are zero then the statement vacuously holds. Otherwise, let the pivot be $c eq.not 0$. Scaling by $1 \/ c$ reduces it to the desired form.

Suppose we have shown this for matrices of number of rows $1 \, 2 \, dots.h \, k$. Consider a matrix with $k + 1$ rows. Find the first column with a non-zero element (if this does not exist, the matrix is just the zero-matrix, so our statement is vacuously true). Swap the row containing this to the top. Now, scale it by $1 \/ c$ where $c$ is the value of the pivot. Consider now the rows below the first row. Suppose they've entries $a_i$ is the pivot column. Then, subtract $a_i$ times the first row from the $i$-th row, so that all of the entries in the pivot column are now zero except the first row. Note that, now we can just reduce a matrix of a smaller size (the submatrix formed by rows $2$ through $k + 1$) of $k$ rows to a row-echelon form. Since we do this using elementary row operations, which only involve linear combinations and swapping, the columns containing $0$ can not be changed, as swapping only changes $0$ to another $0$, and a linear combination of $0$ entries is also $0$. Therefore, reducing it to a row-echelon form makes the whole matrix in a row-echelon form now (as the next pivot is at least one column after the first pivot, because all columns in the submatrix have zero entries up until the pivot column, so the first pivot can only occur later (or never)).

]
#remark[
Many of these definitions are valid for matrices in general but we'll primarily use them for augmented matrices. One may consider augmented matrices ad-hoc representations for now, but there is a somewhat nice reason for considering them. These elementary row operations correspond to multiplication by a specific kind of invertible matrix (called an elementary matrix) i.e
$ E A upright(bold(x)) = E upright(bold(b)) arrow.l.r.double A upright(bold(x)) = upright(bold(b)) . $
One ought not to worry too much about it right now, but interestingly applying $E$ to the augmented matrix (as in normal matrix multiplication) is equivalent to left-multiplication here. The proof of both these facts is in Friedberg, Insel, Spence, #emph[Linear Algebra];. Among other things, what is also cool is:$ E \( A divides upright(bold(b)) \) = \( E A divides E upright(bold(b)) \) $
Here is an example, consider the system of equations we considered earlier. Let us show how the row operations correspond to matrix multiplication.

]
#example[Row reduction as left-multiplication by an invertible matrix][
$ mat(delim: "(", 2, 4, 6, 8, 1; 3, 0, 7, 1, 10) arrow.r^(R_1 arrow.r R_1 \/ 2) mat(delim: "(", 1, 2, 3, 4, 1 \/ 2; 3, 0, 7, 1, 10) $

$ arrow.r^(R_2 arrow.r R_2 - 3 R_1) mat(delim: "(", 1, 2, 3, 4, 1 \/ 2; 0, - 6, - 2, - 11, 17 \/ 2) $

$ arrow.r^(R_2 arrow.r - R_2 \/ 6) mat(delim: "(", 1, 2, 3, 4, 1 \/ 2; 0, 1, 1 \/ 3, 11 \/ 6, - 17 \/ 12) $

$ arrow.r^(R_1 arrow.r R_1 - 2 R_2) mat(delim: "(", 1, 0, 7 \/ 3, 1 \/ 3, 10 \/ 3; 0, 1, 1 \/ 3, 11 \/ 6, - 17 \/ 12) $

#figure(
  align(center)[#table(
    columns: 3,
    align: (auto,auto,auto,),
    table.header([Step], [Operation], [$E_i$],),
    table.hline(),
    [1], [$R_1 arrow.r R_1 \/ 2$], [$mat(delim: "(", 1 \/ 2, 0; 0, 1)$],
    [2], [$R_2 arrow.r R_2 - 3 R_1$], [$mat(delim: "(", 1, 0; - 3, 1)$],
    [3], [$R_2 arrow.r - R_2 \/ 6$], [$mat(delim: "(", 1, 0; 0, - 1 \/ 6)$],
    [4], [$R_1 arrow.r R_1 - 2 R_2$], [$mat(delim: "(", 1, - 2; 0, 1)$],
  )]
  , kind: table
  )

$ E = E_4 E_3 E_2 E_1 = mat(delim: "(", 0, 1 \/ 3; 1 \/ 4, - 1 \/ 6) \, #h(2em) det E = - 1 / 12 eq.not 0 $

$ A = mat(delim: "(", 2, 4, 6, 8; 3, 0, 7, 1) \, #h(2em) b = vec(1, 10) $

$ E A = mat(delim: "(", 0, 1 \/ 3; 1 \/ 4, - 1 \/ 6) mat(delim: "(", 2, 4, 6, 8; 3, 0, 7, 1) = mat(delim: "(", 1, 0, 7 \/ 3, 1 \/ 3; 0, 1, 1 \/ 3, 11 \/ 6) $

$ E b = mat(delim: "(", 0, 1 \/ 3; 1 \/ 4, - 1 \/ 6) vec(1, 10) = vec(10 \/ 3, - 17 \/ 12) $

$ E [A divides b] = mat(delim: "(", 0, 1 \/ 3; 1 \/ 4, - 1 \/ 6) mat(delim: "(", 2, 4, 6, 8, 1; 3, 0, 7, 1, 10) = mat(delim: "(", 1, 0, 7 \/ 3, 1 \/ 3, 10 \/ 3; 0, 1, 1 \/ 3, 11 \/ 6, - 17 \/ 12) $

]
#question[
If the system is inconsistent, will the row-echelon form of the augmented matrix have rows of the form:
$ 0 quad 0 quad dots.h.c quad 0 divides c $
where $c eq.not 0$.
---
Yes, otherwise since we can reduce any augmented matrix to a row-echelon form, and this swapping back of variables will lead us to a set of solutions.

]
