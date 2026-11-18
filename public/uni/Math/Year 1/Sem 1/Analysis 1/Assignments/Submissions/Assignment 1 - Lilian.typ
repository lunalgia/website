#import "@preview/nova-pset:0.1.0": *
#import "@preview/adaptive-dots:0.1.0": adaptive-dots, ldots, cdots
#import "@local/typst-math:0.1.0": setup, scr
#show: setup
#show: adaptive-dots
#let class = "Analysis 1"
#let assignment = "Assignment 1"
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

#q(title: "Problem 1")[Suppose $⟨ a_(n) : n ≥ 1 ⟩$ is a monotonically increasing bounded sequence of real numbers. Show that $∃ a ∈ RR$ such that $lim_(n → ∞) a_(n) = a$ (also written as $a_(n) --> a$). Hint: Let $B$ denote the set $⟨ a_(n) : n ≥ 1 ⟩$ and take $a = "l.u.b. B."$]

#b() 

#Q()

#pagebreak()

#q(title: "Problem 2")[Let $⟨ a_(n) : n ≥ 1 ⟩ , ⟨ b_(n) : n ≥ 1 ⟩$ be convergent sequences. Let $c_(n) = a_(n) + b_(n) , d_(n) = a_(n) b_(n) , ∀ n ≥ 1$. Then show that $⟨ c_(n) : n ≥ 1 ⟩ , ⟨ d_(n) : n ≥ 1 ⟩$ are also convergence.]

#b() 

#Q()

#pagebreak()

#q(title: "Problem 3")[Let $⟨ a_(n) : n ≥ 1 ⟩ , ⟨ b_(n) : n ≥ 1 ⟩$ be convergent sequences. Suppose $lim_(n → ∞) a_(n) = a$ and $lim_(n → ∞) b_(n) = a$. Suppose $⟨ c_(n) : n ≥ 1 ⟩$ is such that $a_(n) ≤ c_(n) ≤ b_(n) , ∀ n ≥ 1$. Show that $lim_(n → ∞) c_(n) = a$.]

#b() 

#Q()

#pagebreak()

#q(title: "Problem 4")[Let $⟨ a_(n) : n ≥ 1 ⟩ , ⟨ b_(n) : n ≥ 1 ⟩$ be convergent sequences with $lim_(n → ∞) a_(n) = a , lim_(n → ∞) b_(n) = b$, with $b ≠ 0$. For $n ≥ 1$, let $u_(n) = 0$ if $b_(n) = 0$ and $u_(n) =^(a n)$ $b_(n)$ if $b_(n) ≠ 0$. Show that $⟨ u_(n) : n ≥ 1 ⟩$ is convergent. The sequence $⟨ u_(n) : n ≥ 1 ⟩$ as defined above is also expressed as $u_(n) =^(a n)$ $b_(n)$ $1_(⟨ b n ≠ 0 ⟩)$.]

#b() 

#Q()

#pagebreak()

#q(title: "Problem 5")[Let $⟨ a_(n) : n ≥ 1 ⟩$ be a convergent sequence. Show that it is a Cauchy sequence.]

#b() 

#Q()

#pagebreak()

#q(title: "Problem 6")[Let $⟨ a_(n) : n ≥ 1 ⟩$ be a Cauchy sequence. Show that \[a\] $⟨ a_(n) : n ≥ 1 ⟩$ is bounded. \[b\] For $n ≥ 1$ let $E_(n)$ be the set defined by $E_(n) = \{ a_(k) : k ≥ n \}$ and let $t_(n) = "l.u.b. E"_(n)$. Show that $⟨ t_(n) : n ≥ 1 ⟩$ is a bounded monotonically decreasing sequence. \[c\] Show that $⟨ t_(n) : n ≥ 1 ⟩$ is a convergent sequence. \[d\] Let $a = lim_(n → ∞) t_(n)$. Show that $⟨ a_(n) : n ≥ 1 ⟩$ converges to $a$.]

#b() 

#Q()

#pagebreak()

#q(title: "Problem 7")[Let $⟨ a_(n) : n ≥ 1 ⟩$ be a bounded sequence. For $n ≥ 1$ let $E_(n)$ be the set defined by $E_(n) = \{ a_(k) : k ≥ n \}$ and let $t_(n) = "l.u.b. E"_(n) , s_(n) = "g.l.b. E"_(n)$. Show that \[a\] For all $n ≥ 1 , s_(n) ≤ s_(n + 1) ≤ t_(n + 1) ≤ t_(n)$ \[b\] $lim_(n → ∞) s_(n) = s , lim_(n → ∞) t_(n) = t$ exist and $s ≤ t$. \[c\] $⟨ a_(n) : n ≥ 1 ⟩$ is Cauchy if and only if $s = t$. \[c\] $⟨ a_(n) : n ≥ 1 ⟩$ converges to $a$ if and only if $s = t = a$. The quantities $s , t$ defined in \[b\] above are respectively called lim inf of $⟨ a_(n) : n ≥ 1 ⟩$ and lim sup of $⟨ a_(n) : n ≥ 1 ⟩$, and expressed as $s = liminf_(n → ∞) a_(n) , t = limsup_(n → ∞) a_(n)$.]

#b() 

#Q()
