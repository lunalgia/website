// course: Algebra 1, lecture: 6, date: 2026-08-18
#import "@local/greenbook:0.1.0": *

== Lecture 6
#note[Tuesday 18 August 2026]


// Imported from ~/Library/Notes/Notes/Math/Algebra 1/Algebra Lect 6.md
You can write down $A upright(bold(x))$ in terms of its #emph[column vectors];:
$ mat(delim: "(", a_11, a_12, dots.h.c, a_(1 n); #none, , dots.v, ; a_(m 1), a_(m 2), dots.h.c, a_(m n)) upright(bold(x)) = x_1 vec(a_11, dots.v, a_(m 1)) + dots.h.c + x_n vec(a_(1 n), dots.v, a_(m n)) $
this allows us to think of linear maps in terms of the matrix operation, $A upright(bold(x))$.

#definition[
For $f \( upright(bold(x)) \) = A upright(bold(x))$, $ f : bb(R)^c arrow.r bb(R)^r $ we define the following:
$ upright("Nil") \( A \) = upright("ker") \( f \) = { upright(bold(x)) divides A upright(bold(x)) = 0 } $
and
$ upright("Col") \( A \) = upright("im") \( f \) = { A upright(bold(x)) divides upright(bold(x)) in bb(R)^r } $

]
the reason for calling the latter $upright("Col") \( A \)$ is because of our prior discussion, for any vector $upright(bold(x))$, $A upright(bold(x))$ is just a member of the space spanned by the column vectors of the #emph[column vectors] of $A$. Note that both of these are subspaces (for the latter, note that this is true because $f$ is #emph[linear];, so that the $3 f \( upright(bold(v)) \) = f \( 3 upright(bold(v)) \) in upright("im") \( f \)$, and same for addition.).
