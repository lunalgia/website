#import "@preview/nova-pset:0.1.0": *
#import "@preview/adaptive-dots:0.1.0": adaptive-dots, ldots, cdots
#import "@local/typst-math:0.1.0": setup, scr
#show: setup
#show: adaptive-dots
#let class = "Analysis 1"
#let assignment = "Group Project"
#let author = "Lilian"
// To use a logo, add an image to this folder and replace none:
// #let logo = image("your-logo.png", height: 25pt)
#let logo = none
#let instructor = ""
#let semester = "Fall 2026"
#let due-time = ""
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

#q(title: "Problem (a)")[Show that the power series defining $A ( x )$ and $B ( x )$ converge for all $x ∈ RR$.]

#b() 

#Q()

#pagebreak()

#q(title: "Problem (b)")[Show that $A ( 0 ) = 0$ and $B ( 0 ) = 1$.]

#b() 

#Q()

#pagebreak()

#q(title: "Problem (c)")[Show that the derivative $A^(') ( x )$ of $A ( x )$ equales $B ( x )$, likewise $B^(') ( x )$ equals $- A ( x )$.]

#b() 

#Q()

#pagebreak()

#q(title: "Problem (d)")[Show that $∃ θ > 0$ such that $A ( θ ) = 0$ and $A ( x ) > 0$ for $x ∈ ( 0 , θ )$.]

#b() 

#Q()

#pagebreak()

#q(title: "Problem (e)")[Let $g ( x ) = ( A ( x ) )^(2) + ( B ( x ) )^(2)$. Show that $g ( 0 ) = 1$ and $g^(') ( x ) = 0$ for all $x$. (f ) Show that $g ( x ) = 1$ for all $x$. (g) Show that $| A ( x ) | ≤ 1 , | B ( x ) | ≤ 1$ for all $x$. (h) Show that $∃ τ ∈ ( 0 , θ )$ such that $A ( τ ) = 1$ and $B ( τ ) = 0$. (i) Show that for $x , y ∈ RR , A ( x + y ) = A ( x ) B ( y ) + B ( x ) A ( y )$ and $B ( x + y ) = B ( x ) B ( y ) - A ( x ) A ( y )$. (j) Show that for $x ∈ RR , A ( x + τ ) = B ( x )$ and $B ( x + τ ) = - A ( x )$. (k) Show that $θ = 2 τ$. (l) Show that $A , B$ are periodic functions with period $2 θ$. (m) Show that if $f : RR |-> RR$ is any function that is twice differentiable and satisfies the equation $f^(' ') ( x ) = - f ( x )$, then $∃ a , b ∈ RR$ such that $f ( x ) = a A ( x ) + b B ( x )$ for all $x$. As several (if not all) of you could have guessed, $A ( x )$ is sin($x$) and $B ( x )$ is cos($x$) and $θ = π$. So try to write various properties of sin($x$) and cos($x$) that you know and see which of these you can prove that $A$ and $B$ satisfy using only the definitions and properties given about and convergence of sequences, power series, continuity, differentiability, ...]

#b() 

#Q()
