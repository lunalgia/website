// course: Algebra 1, lecture: 4, date: 2026-08-12
#import "@local/greenbook:0.1.0": *

== Lecture 4
#note[Wednesday 12 August 2026]


// Imported from ~/Library/Notes/Notes/Math/Algebra 1/Algebra Lect 4.md
Recap from last lecture. One may think of augmented matrices as #emph[representations];, or really, as the system of equations themselves, and then the way of writing it down as the $r times \( c + 1 \)$ table of numbers as a #emph[representation];. One understands this as:

\$\$
\\begin{align\*}
\\text{System of Linear equations }  {\\Huge\\leftrightsquigarrow} &\\text{ Augmented Matrix} \\\\
A\\mathbf{x} = \\mathbf{b} \\quad \\quad\\quad & \\quad \\quad(A\\mid \\mathbf{x}) \\\\
\\textsf{\\small Easy Operations on Equations} \\Big\\updownarrow \\quad \\quad \\quad \\quad & \\quad \\quad \\quad \\; \\Big\\updownarrow \\textsf{\\small Elementary Row Operations}\\\\
\\text{ Equivalent System of Equations} &\\quad \\quad \\quad \\text{ REF Form} 
\\end{align\*}
\$\$
Formally define a REF:

#definition[
A $r times c$ matrix $A$ is in REF if the following is true for all $2 lt.eq i lt.eq r$. #emph[If] (row $i$ has a pivot), #emph[then] (so must row $i - 1$ and left most non-zero entry in row $i - 1$ must be in an earlier column than “that” in row $i$).

]
We have the following theorem:

#theorem[
The equation $A upright(bold(x)) = upright(bold(b))$ is inconsistent is equivalent to the fact that the REF of $\( A divides upright(bold(b)) \)$ has a pivot in the last column

]
#emph[Proof];. $arrow.l.double.long$ is easy by converting the augmented matrix back to a system of equations. For $arrow.r.double.long$, note the following. The contrapositive of the statement is that if no pivot is there in the last column of $\( A divides upright(bold(b)) \)$, then the system is consistent. Sort of informally one notes that, if there is no pivot in the last column, then each variable is expressible in terms of subsequent variables (by converting the augmented matrix to the system of equations.)

Formally, let us work from the last row. Suppose the augmented matrix represents a set of $r$ linear equations in $c$ variables. Then, the matrix will be $r times c + 1$. Since the last column has zero pivots, let the pivot for the last row occur in the $i$-th column (if no pivot exists, then we skip the row and go the row above it. If no row has a pivot, then clearly the system if not inconsistent since we have all of $bb(R)^c$ as solutions.) Then by assigning arbitrary values to the variables $x_(i + 1) \, dots.h \, x_c$, we get a value for $x_i$. (Note that if $i = c$, we get a value of $x_c$ in terms of $b_r$.) Then, look at the row above, the pivot must occur at $j < i$ column. Therefore, we can write down $x_j$ in terms of $x_(j + 1) \, dots.h \, x_i \, dots.h \, x_c$. Now, since we know $x_i \, dots.h \, x_c$, and assigning arbitrary values to the rest of the “free variables”, we get a value of $x_j$. Inductively, going to the $1$-st row, we have a solution $\( x_1 \, dots.h \, x_c \)$, that satisfies the equations, so that the system must be consistent. $square.stroked.tiny$

#line(length: 100%, stroke: 0.4pt + luma(180))
The statement he writes it down to write down a proof is that:

#theorem[
Given REF of an augmented matrix of $A upright(bold(x)) = upright(bold(b))$ without pivot in the last column, one obtains a #emph[unique] solution to $A upright(bold(x)) = upright(bold(b))$ by assinging arbitrary values to variables corresponding to non-pivot columns.

]
A note is that by assigning arbitrary values he probably means ranging over all values of the free variables to get a #emph[unique] solution set. For me, finding one solution is enough, but one can of course generalise.

#corollary[
If $A upright(bold(x)) = upright(bold(b))$ is consistent, then it has a #emph[unique] solution is equivalent to there is no free variable in REF $\( A upright(bold(x)) divides upright(bold(b)) \)$, or every column except the last has a pivot in the REF of $\( A divides upright(bold(b)) \)$.

]
We briefly discussed RREF, #emph[Reduced Row Echelon Form];. In RREF, we also kill the columns above the pivot. Thus, we don't have to worry about back-substitution, in fact this clearly shows what the free variables are.

#line(length: 100%, stroke: 0.4pt + luma(180))
Some discussion about solutions. Suppose my solution space was something like:
$ x_1 & = \( - 7 \/ 3 \) x_3 + \( - 1 \/ 3 \) x_4 + 20 \/ 6\
x_2 & = \( - 1 \/ 3 \) x_3 + \( - 11 \/ 6 \) x_4 + \( - 17 \/ 6 \)\
 $
and $x_3 \, x_4$ are arbitrary, then, we could write this in vector form as:
\$\$
\= x\_3
- x\_4
  -

\$\$
so that one may understand this as a plane passing through the origin, shifted by the constant. In general one may understand the solution set in terms of the constraints as a some sort of hyperlane shifted by a constant term. If it was a solution to $A upright(bold(x)) = 0$, then it would be a hyperplan passing through the origin.
