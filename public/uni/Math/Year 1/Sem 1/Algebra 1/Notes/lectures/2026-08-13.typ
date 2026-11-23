// course: Algebra 1, lecture: 5, date: 2026-08-13
#import "@local/greenbook:0.1.0": *

== Lecture 5
#note[Thursday 13 August 2026]


// Imported from ~/Library/Notes/Notes/Math/Algebra 1/Algebra Lect 5.md
==== Definitions in $bb(R)^n$
#definition[
We define $ bb(R)^n = {vec(a_1, dots.v, a_n)\| #h(0em) a_i in bb(R)} $

]
we call elements of $bb(R)^n$ vectors (for now).

#remark[
Given vectors $v_1 \, dots.h \, v_k$ in $bb(R)^n$, and scalars $ a_1 \, dots.h \, a_k $, the vector
$ a_1 v_1 + dots.h.c + a_k v_k $
is called a #emph[linear combination] of $v_1 \, dots.h \, v_k$ (with weights $a_1 \, dots.h \, a_k$).

]
We now introduce a formal notion of the “span” of vectors:

#definition[
If $S$ is a subset of $bb(R)^n$, then the #emph[span] of $S$ is the set of all linear combinations of vectors in $S$,
$ upright("span") \( S \) = {sum_(i = 1)^k a_i v_i divides a_i in bb(R) \, v_i in bb(R) \, k in bb(N)} $

]
#definition[
A #emph[subspace] of $bb(R)^n$ is a #emph[non-empty] set $W subset bb(R)^n$ that is closed under vector addition and mulriplication by any scalar, i.e:
$ upright("For all ") w_1 \, w_2 in W upright(" and all ") a in bb(R) \, w_1 + w_2 in W upright(" and ") a w_1 in W $

]
How do subspaces arise? There are two primary ways.

One, as in last class we discussed subspaces as solutions to $ A upright(bold(x)) = upright(bold(0)) $where one can verify that a solution space of this will indeed be a subspace.

Second, the span of any subset $S subset bb(R)^n$, is a subspace of $bb(R)^n$.

#remark[
- ${ 0 }$ and $bb(R)^n$ are subspaces of any $bb(R)^n$.
- Nonzero proper subspaces of $bb(R)$: none
- Nonzero proper subspaces of $bb(R^2)$: lines through origin, i.e $ bb(R) v = { a v divides a in bb(R) } $
- Nonzero proper subspaces of $bb(R^3)$: lines, ${ a v divides a in bb(R) }$ and planes, ${ a v + b w divides a \, b in bb(R) }$ where $v$ and $w$ are non-proportional.

]
