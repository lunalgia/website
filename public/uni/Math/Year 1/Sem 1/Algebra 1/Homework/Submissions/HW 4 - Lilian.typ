#import "@preview/nova-pset:0.1.0": *
#import "@preview/adaptive-dots:0.1.0": adaptive-dots, ldots, cdots
#import "@local/typst-math:0.1.0": setup, scr
#show: setup
#show: adaptive-dots
#let class = "Algebra 1"
#let assignment = "Homework 4"
#let author = "Lilian"
// To use a logo, add an image to this folder and replace none:
// #let logo = image("your-logo.png", height: 25pt)
#let logo = none
#let instructor = "Prof. Upendra"
#let semester = "Fall 2026"
#let due-time = "Monday, 14/09/2026"
#let vb(x) = $upright(bold(#x))$
#show: homework.with(
  class: class,
  assignment: assignment,
  author: author,
  logo: logo,
  instructor: instructor,
  semester: semester,
  due-time: due-time,
  paper-size: "us-letter",
  accent-color: rgb("#1c2b39"),
)

#set enum(numbering: "a)")

== Homework

_Submit: 2 (one of the four proofs, in your own words), 5 (only the computation), 6(c), 7(a), 11(a) and (c). Most are computational: justify all computations. A computer may verify row reduction; setting up and interpreting must be your own._

#q(title: "Problem 2: Towards invariance of dimension")[
  Show that if $S$ is a finite spanning set in a vector space $V$, then for any linearly independent set $I$, the cardinality of $I$ is at most the cardinality of $S$. Give four proofs, the first two by contradiction. (For the HW, submit one.)

  (a) Assume $|I| > |S|$. Express the vectors in $I$ as linear combinations of vectors in $S$. Express these equations using a wide matrix $A$ by defining a new notion of multiplying a matrix of numbers by a row of abstract vectors. Show appropriate associativity for this new operation and use the fact that $A vb(x) = vb(0)$ has a nontrivial solution for a wide matrix $A$.

  (b) Assume $|I| > |S|$ and again express the vectors in $I$ as linear combinations of vectors in $S$. This is a tall system of equations. Imitate row operations on this tall system to get the last equation as $0 =$ some linear combination of vectors in $I$. Why must the RHS of this equation be a nontrivial combination?

  (c) Proof by reduction to $RR^n$. One way is to use the notion of isomorphism, the fact that having a finite basis for $V$ gives an isomorphism of $V$ with $RR^n$.

  (d) Look up the statement of the Steinitz exchange lemma. Try to prove it on your own. Uncover the proof one line at a time and repeat.
]

#b()

I'll do (a). Let $S = {vb(s)_1, ldots, vb(s)_n}$. If $I$ is infinite, we can just take $n + 1$ vectors from it, which are still independent. So suppose $I = {vb(u)_1, ldots, vb(u)_m}$ with $m > n$.

Since $S$ spans $V$, we can write
$ vb(u)_j = sum_(i = 1)^n a_(i j) vb(s)_i $
for each $j$. Let $A = (a_(i j))$, which is $n times m$, so wide. We define a row of vectors times a matrix the same way as for numbers, i.e. $(vb(s)_1, ldots, vb(s)_n) A$ is the row whose $j$th entry is $sum_i a_(i j) vb(s)_i$. Then the above says
$ (vb(u)_1, ldots, vb(u)_m) = (vb(s)_1, ldots, vb(s)_n) A. $
This is associative, in the sense that for $vb(x) in RR^m$,
$
  ((vb(s)_1, ldots, vb(s)_n) A) vb(x)
  &= sum_j x_j sum_i a_(i j) vb(s)_i \
  &= sum_i (sum_j a_(i j) x_j) vb(s)_i
  = (vb(s)_1, ldots, vb(s)_n)(A vb(x))
$
by rearranging the (finite) sum.

Now since $A$ is wide, $A vb(x) = vb(0)$ has a non-trivial solution (a REF of $A$ has at most $n$ pivots, so there is a free variable). For this $vb(x)$,
$
  sum_j x_j vb(u)_j
  &= ((vb(s)_1, ldots, vb(s)_n) A) vb(x) \
  &= (vb(s)_1, ldots, vb(s)_n)(A vb(x)) = vb(0),
$
which is a non-trivial linear combination of the $vb(u)_j$ equal to $vb(0)$. But $I$ is independent, a contradiction. Thus $|I| <= |S|$.

#Q()

#pagebreak()

#q(title: "Problem 5 (computation)")[
  Let $A = mat(1, 2, 3; 0, 1, 4; 5, 6, 0)$. Show that $A$ is invertible, write $A$ as a product of elementary matrices and find the inverse of $A$.
]

#b()

We row reduce $(A | I)$:
$
  mat(1, 2, 3, |, 1, 0, 0; 0, 1, 4, |, 0, 1, 0; 5, 6, 0, |, 0, 0, 1)
  stretch(->)^(R_3 - 5R_1)
  mat(1, 2, 3, |, 1, 0, 0; 0, 1, 4, |, 0, 1, 0; 0, -4, -15, |, -5, 0, 1)
$
$
  stretch(->)^(R_3 + 4R_2)
  mat(1, 2, 3, |, 1, 0, 0; 0, 1, 4, |, 0, 1, 0; 0, 0, 1, |, -5, 4, 1)
  stretch(->)^(R_2 - 4R_3)
  mat(1, 2, 3, |, 1, 0, 0; 0, 1, 0, |, 20, -15, -4; 0, 0, 1, |, -5, 4, 1)
$
$
  stretch(->)^(R_1 - 3R_3)
  mat(1, 2, 0, |, 16, -12, -3; 0, 1, 0, |, 20, -15, -4; 0, 0, 1, |, -5, 4, 1)
  stretch(->)^(R_1 - 2R_2)
  mat(1, 0, 0, |, -24, 18, 5; 0, 1, 0, |, 20, -15, -4; 0, 0, 1, |, -5, 4, 1)
$
Since $"RREF"(A) = I$, $A$ is invertible, and
$ A^(-1) = mat(-24, 18, 5; 20, -15, -4; -5, 4, 1). $
The row operations above are given by the elementary matrices
$
  E_1 = mat(1, 0, 0; 0, 1, 0; -5, 0, 1), quad
  E_2 = mat(1, 0, 0; 0, 1, 0; 0, 4, 1), quad
  E_3 = mat(1, 0, 0; 0, 1, -4; 0, 0, 1),
$
$
  E_4 = mat(1, 0, -3; 0, 1, 0; 0, 0, 1), quad
  E_5 = mat(1, -2, 0; 0, 1, 0; 0, 0, 1),
$
so $E_5 E_4 E_3 E_2 E_1 A = I$, and thus
$ A = E_1^(-1) E_2^(-1) E_3^(-1) E_4^(-1) E_5^(-1), $
where $E_i^(-1)$ is $E_i$ with the sign of the off-diagonal entry flipped, i.e. the elementary matrices for $R_3 + 5R_1$, $R_3 - 4R_2$, $R_2 + 4R_3$, $R_1 + 3R_3$ and $R_1 + 2R_2$.

#Q()

#pagebreak()

#q(title: "Problem 6(c)")[
  Let $A = mat(2, 3, 1; 1, 2, 3)$. Show that $A$ has infinitely many right inverses. Find them all. Now give a matrix $B$ having infinitely many right inverses and find them all.
]

#b()

Note that $A R = I$ for a $3 times 2$ matrix $R$ iff its columns $vb(r)_1, vb(r)_2$ satisfy $A vb(r)_1 = vb(e)_1$ and $A vb(r)_2 = vb(e)_2$. Row reducing both at once,
$
  mat(2, 3, 1, |, 1, 0; 1, 2, 3, |, 0, 1)
  stretch(->)^(R_1 <-> R_2)
  mat(1, 2, 3, |, 0, 1; 2, 3, 1, |, 1, 0)
  stretch(->)^(R_2 - 2R_1)
  mat(1, 2, 3, |, 0, 1; 0, -1, -5, |, 1, -2)
$
$
  stretch(->)^(-R_2)
  mat(1, 2, 3, |, 0, 1; 0, 1, 5, |, -1, 2)
  stretch(->)^(R_1 - 2R_2)
  mat(1, 0, -7, |, 2, -3; 0, 1, 5, |, -1, 2)
$
So $x_3$ is free in both, and the solutions are
$ vb(r)_1 = vec(2 + 7s, -1 - 5s, s), quad vb(r)_2 = vec(-3 + 7t, 2 - 5t, t) $
for $s, t in RR$. Thus the right inverses of $A$ are
$ R = mat(2 + 7s, -3 + 7t; -1 - 5s, 2 - 5t; s, t), quad s, t in RR, $
and there are infinitely many of them.

For $B$, take $B = mat(1, 1)$. Its right inverses are $vec(a, b)$ with $a + b = 1$, i.e. $vec(t, 1 - t)$ for $t in RR$.

#Q()

#pagebreak()

#q(title: "Problem 7(a)")[
  Let $vb(v)_1 = (1, 2, 1)^T$, $vb(v)_2 = (0, 1, 2)^T$, $vb(v)_3 = (2, 0, 1)^T$. Show that $B = {vb(v)_1, vb(v)_2, vb(v)_3}$ is a basis of $RR^3$. What is the change of basis matrix $P$ when the old basis is the standard basis and the new basis is $B$? Find $vb(w)$ such that $[vb(w)]_B = (4, 5, 5)^T$. Find $[vb(v)]_B$ for $vb(v) = (4, 5, 5)^T$.

  (Recall: the $i$-th column of $P$ is the coordinate vector of the $i$-th new basis vector in terms of the old basis, $B' = B P$, and $[vb(v)]_B = P [vb(v)]_(B')$.)
]

#b()

Let $P$ be the matrix with columns $vb(v)_1, vb(v)_2, vb(v)_3$. Row reducing,
$
  P = mat(1, 0, 2; 2, 1, 0; 1, 2, 1)
  stretch(->)^(R_2 - 2R_1, R_3 - R_1)
  mat(1, 0, 2; 0, 1, -4; 0, 2, -1)
  stretch(->)^(R_3 - 2R_2)
  mat(1, 0, 2; 0, 1, -4; 0, 0, 7)
$
which has a pivot in every row and column, so the columns are independent and span $RR^3$, i.e. $B$ is a basis.

$P$ is also the change of basis matrix, since its $i$th column is $vb(v)_i$ written in the standard basis.

Then $vb(w) = P [vb(w)]_B$, so
$ vb(w) = 4 vb(v)_1 + 5 vb(v)_2 + 5 vb(v)_3 = vec(14, 13, 19). $

For $[vb(v)]_B$, we solve $P vb(y) = vb(v)$:
$
  mat(1, 0, 2, |, 4; 2, 1, 0, |, 5; 1, 2, 1, |, 5)
  stretch(->)^(R_2 - 2R_1, R_3 - R_1)
  mat(1, 0, 2, |, 4; 0, 1, -4, |, -3; 0, 2, -1, |, 1)
  stretch(->)^(R_3 - 2R_2)
  mat(1, 0, 2, |, 4; 0, 1, -4, |, -3; 0, 0, 7, |, 7)
$
which gives $y_3 = 1$, $y_2 = 1$ and $y_1 = 2$, so $[vb(v)]_B = (2, 1, 1)^T$.

#Q()

#pagebreak()

#q(title: "Problem 11(a)")[
  Write a formula, with justification, for the linear function $f: RR^2 -> RR^2$ that takes $(1, 2)^T$ to $(3, 4)^T$ and $(2, 5)^T$ to $(10, 13)^T$.
]

#b()

Let $C = mat(1, 2; 2, 5)$. $C$ is invertible, with $C^(-1) = mat(5, -2; -2, 1)$, so $(1, 2)^T$ and $(2, 5)^T$ form a basis, and $f$ is determined by where it sends them. If $f(vb(x)) = M vb(x)$, then
$ M C = mat(3, 10; 4, 13), $
so
$ M = mat(3, 10; 4, 13) mat(5, -2; -2, 1) = mat(-5, 4; -6, 5), $
i.e. $f(x, y) = (-5x + 4y, -6x + 5y)$.

#Q()

#pagebreak()

#q(title: "Problem 11(c)")[
  Write a formula, with justification, for reflection in the line $y = k x$ for a real number $k$. Do this in two ways: first, directly working with the standard basis. Second, start with a more convenient basis and then change it to the standard basis. Maybe it helps to name an angle?
]

#b()

Let $vb(d) = (1, k)^T$, which spans the line, and $vb(m) = (-k, 1)^T$, which is perpendicular to it. The reflection $T$ fixes $vb(d)$ and sends $vb(m)$ to $-vb(m)$.

First, directly. Writing $vb(v)$ as its projection onto the line plus the rest, $T$ flips the rest, so
$ T(vb(v)) = 2 (vb(v) dot vb(d))/(vb(d) dot vb(d)) vb(d) - vb(v) = (2 (vb(v) dot vb(d)))/(1 + k^2) vec(1, k) - vb(v). $
Plugging in $vb(e)_1$ and $vb(e)_2$,
$ T(vb(e)_1) = 1/(1 + k^2) vec(1 - k^2, 2k), quad T(vb(e)_2) = 1/(1 + k^2) vec(2k, k^2 - 1), $
so
$ [T] = 1/(1 + k^2) mat(1 - k^2, 2k; 2k, k^2 - 1). $

Second, in the basis $B' = {vb(d), vb(m)}$, $T$ is just $D = mat(1, 0; 0, -1)$. The change of basis matrix is $P = mat(1, -k; k, 1)$, with $P^(-1) = 1/(1 + k^2) mat(1, k; -k, 1)$, so
$
  [T] = P D P^(-1)
  &= 1/(1 + k^2) mat(1, k; k, -1) mat(1, k; -k, 1) \
  &= 1/(1 + k^2) mat(1 - k^2, 2k; 2k, k^2 - 1).
$

If $theta$ is the angle the line makes with the $x$-axis, then $k = tan theta$, and this is
$ [T] = mat(cos 2theta, sin 2theta; sin 2theta, -cos 2theta). $

#Q()

#pagebreak()

== Rest of Tutorial 4

_Not part of the homework._

#q(title: "Problem 1: Basic language")[
  Recall the definition of an abstract vector space. Many terms seen in $RR^n$ carry over: subspace, linear combination, span, linear (in)dependence, basis, dimension. Prove the basic observations made in class about span, linear dependence/independence and equivalent ways to think of a basis. Let $S$ be a multiset (repetitions allowed) of vectors in $V$.

  (a) If $vb(v) in S$ and $vb(v)$ is a linear combination of the other vectors in $S$, then $"span"(S) = "span"(S - {vb(v)})$. Converse?

  (b) If $S$ is independent and $vb(v) in.not "span"(S)$, then $S union {vb(v)}$ is independent. Converse?

  Let $f$ be a linear map from $V$ to $W$. State if (c) and (d) are true or false. If false, is there a condition on $f$ under which the statement becomes true?

  (c) "If $S$ is linearly independent, then $f(S)$ is linearly independent." Converse?

  (d) "If $S$ spans $V$ then $f(S)$ spans $W$." Converse?

  (e) Show that the following are equivalent for a subset $B$ of $V$: (1) $B$ is a linearly independent spanning set, i.e. a basis; (2) $B$ is a maximal linearly independent set; (3) $B$ is a minimal spanning set; (4) each vector in $V$ is a unique linear combination of elements of $B$.
]

#b() 
#Q()

#pagebreak()

#q(title: "Problem 3: Payoff")[
  Deduce several consequences of problem 2 for a finite dimensional vector space.

  (a) Invariance of dimension. (We proved that any finite basis of $RR^n$ has exactly $n$ elements. What if there is an infinite basis? Can you answer this objection?)

  (b) Growing strategy to get a basis: any linearly independent set can be enlarged to a basis. Note a variation stated in Artin: "If $I$ is linearly independent in $V$ and $S$ spans $V$, then one can add vectors from $S$ to $I$ to build a basis of $V$." Compare the two proofs. Does one give a stronger statement than the other?

  (c) The dimension of a proper subspace $W$ of $V$ is always less than the dimension of $V$.
]

#b() 
#Q()

#pagebreak()

#q(title: "Problem 4: Algebra of linear maps and matrix operations")[
  Imagine you do not know any operations involving matrices, not even matrix-vector multiplication. But you have defined abstract vector spaces and proved the existence of a basis. Fixing a basis gives a dictionary between $V$ of dimension $n$ and $RR^n$ via the coordinate map. Recall also our commutative square where a linear map $f: V -> W$ is "translated into a matrix" using a basis for $V$ and one for $W$.

  (a) Show that function application $f(vb(v))$ translates into matrix-vector multiplication, so you can define matrix-vector multiplication this way.

  (b) Show how composition of two linear maps translates into multiplication of matrices, so you can define matrix multiplication this way. Deduce associativity of matrix multiplication.

  (c) Given vector spaces $V$ and $W$, let $L(V, W)$ be the set of all linear maps from $V$ to $W$. Show how to make $L(V, W)$ a vector space and show that it is isomorphic to the vector space of matrices of a certain size. (Hint: choose bases.) Under your isomorphism, which linear map corresponds to the matrix unit $E_(i j)$?
]

#b() 
#Q()

#pagebreak()

#q(title: "Problem 5 (theory)")[
  Let $A$ be any square matrix. Show that the following are equivalent:

  (a) $A$ is invertible, i.e. there exists $A'$ with $A A' = A' A = I$. (b) $f(vb(x)) = A vb(x)$ is a bijection. (c) $A$ has a left inverse $L$, i.e. $L A = I$. (d) $A$ has a right inverse $R$, i.e. $A R = I$. (e) $"RREF"(A) = I$. (f) $A$ is a product of elementary matrices.
]

#b() 
#Q()

#pagebreak()

#q(title: "Problem 6(a), (b), (d): Faux generality?")[
  Let $A$ be an $r times c$ matrix; $I$ denotes the identity matrix of whatever size makes the equation make sense. The problems may become more transparent if you think in terms of the associated linear map.

  (a) Call $A$ "invertible" if it has a left inverse $L$ and a right inverse $R$. Show that then $L = R$, and this common inverse is unique.

  (b) Suppose $A$ has a two-sided inverse $A'$ ($A A' = I$ and $A' A = I$), necessarily $c times r$. Show that then $r = c$.

  (d) Characterize non-square matrices that have a left inverse. Show that such a matrix must have infinitely many left inverses. Give an explicit numerical example illustrating both statements. Do the same for right inverses. (Also look at Artin's problem M.8 in chapter 1.)
]

#b() 
#Q()

#pagebreak()

#q(title: "Problem 7(b)–(d): Change of coordinates")[
  (b) Consider $p(t) = 1 + 2t + t^2$ on $t in [0, 1]$. Find its coordinate vector $[p]_B$ with respect to the Bernstein basis $B = {b_0, b_1, b_2}$, where $b_0(t) = (1 - t)^2$, $b_1(t) = 2t(1 - t)$, $b_2(t) = t^2$. (Search "Bernstein polynomials" or "Bézier curves".)

  (c) In the general situation (old basis $B$, new basis $B'$, change of basis matrix $P$), justify why $P$ must be invertible.

  (d) Two alternative ways to prove the change of basis formulas without hypervector notation: (i) read off a formula from the equations expressing $B'$ in terms of $B$; (ii) operationalize the commutative square for the identity map from $V$ to $V$.
]

#b() 
#Q()

#pagebreak()

#q(title: "Problem 8: Universal property of a basis")[
  (a) Suppose $B subset V$. Show that if $B$ is a basis of $V$, then for any vector space $W$, any function from the set $B$ to $W$ extends uniquely to a linear map $L: V -> W$. (Show that the forced formula actually defines a linear function.)

  (b) (Optional) Show that the property in (a) characterizes those subsets of $V$ that are bases. Do you find the verbiage in the formulation worthwhile?
]

#b() 
#Q()

#pagebreak()

#q(title: "Problem 9: A \"vector space\" without a basis? (not part of the course)")[
  Suppose only integers $ZZ$ are allowed as scalars in the definition of a vector space.

  (a) Let $V = QQ$ under ordinary operations. See that all axioms hold. Show that $V$ cannot have a basis for a rather easy reason. What fails?

  (b) What happens if $V = RR$? $V = ZZ^2$?
]

#b() 
#Q()

#pagebreak()

#q(title: "Problem 10: Other perspectives on rank-nullity")[
  (a) Our proof of abstract rank-nullity: "extend a basis of the kernel of $f$". Find a proof that directly uses a given basis of the image of $f$.

  (b) We proved rank-nullity earlier for $f(vb(x)) = A vb(x)$ from $RR^c$ to $RR^r$ by counting pivots and free variables in $"REF"(A)$. Prove the general abstract theorem by reducing to that case via the commutative square.

  (c) Using the bases from our proof in class, write a simple matrix for $f$. Recall Tutorial 3 problem 9 (row and column operations, reduced form), row/column operations as matrix multiplication, and the change of basis formula $Q^(-1) A P$. Meld these into a unified understanding.
]

#b() 
#Q()

#pagebreak()

#q(title: "Problem 11(b), (d)")[
  (b) Counterclockwise rotation by angle $theta$.

  (d) Composition of two maps from parts (b) and (c). There are three possibilities to work out. Afterwards, see problem B2 from the 2025 CMI entrance exam and its posted solution. Which solution do you prefer?
]

#b() 
#Q()

#pagebreak()

#q(title: "Problem 12: Determinants")[
  (a) Prove (and fix in your mind) the usual formula for the inverse of a $2 times 2$ matrix $A$ when $det(A)$ is an invertible scalar. (Artin does the $n times n$ version in section 1.6; his cofactor matrix is our $"adj"(A)$. Not in syllabus.)

  (b) Artin section 1.4: do 1, 2, 4 in your head (1(d) should be instantaneous). The matrix in 3 is the Cartan matrix of type A.

  (c) Artin chapter 1, Miscellaneous problem 7.
]

#b() 
#Q()
