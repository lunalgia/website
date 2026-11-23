#import "@preview/nova-pset:0.1.0": *
#import "@preview/adaptive-dots:0.1.0": adaptive-dots, ldots, cdots
#import "@local/typst-math:0.1.0": setup, scr
#show: setup
#show: adaptive-dots
#let class = "Analysis 1"
#let assignment = "Assignment 2"
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

// From the sheet:
// Analysis 1: Aug-Nov 2026
// Definition: $⟨ b_(k) : k ≥ 1 ⟩$ is said to be a subsequence of $⟨ a_(n) : n ≥ 1 ⟩$ if there exists a strictly increasing
// sequence $1 ≤ n_(1) < n_(2) < . . . < n_(m) < n_(m + 1) < . . . .$. such that $b_(k) = a_(n k) ∀ k ≥ 1$.
// Definition: $θ$ is said to be a limit point of a sequence $⟨ a_(n) : n ≥ 1 ⟩$ if given any $J ≥ 1$ and $ϵ > 0 , ∃ m ≥ J$
// such that
// $( θ - ϵ ) < a_(m) < ( θ + ϵ )$.
// For $c ∈ RR$ and $ϵ > 0$, the interval $( c - ϵ , c + ϵ )$ is called $ϵ$ neighbourhood of $c$. For $c , d ∈ RR , c < d$, the interval
// $( c , d ) ⊆ RR$ is called an Open Interval and the interval $[ c , d ] ⊆ RR$ is called a Closed Interval.
// Exercises set \#2

#q(title: "Problem 1")[Suppose $⟨ a_(n) : n ≥ 1 ⟩$ is a bounded sequence, $limsup_(n) a_(n) = α$. Show that given any $J ≥ 1$ and $ϵ > 0$, $∃ m ≥ J$ such that $( α - ϵ ) < a_(m) < ( α + ϵ )$. The equation above is also written as $a_(m) ∈ ( α - ϵ , α + ϵ )$.]

#b() 

#Q()

#pagebreak()

#q(title: "Problem 2")[Show that there exists a subsequence $⟨ b_(k) : k ≥ 1 ⟩$ of $⟨ a_(n) : n ≥ 1 ⟩$ such that $b_(k) → α$.]

#b() 

#Q()

#pagebreak()

#q(title: "Problem 3")[Show that there exists a subsequence $⟨ c_(k) : k ≥ 1 ⟩$ of $⟨ a_(n) : n ≥ 1 ⟩$ such that $c_(k) → β = liminf_(n) a_(n)$.]

#b() 

#Q()

#pagebreak()

#q(title: "Problem 4")[Let $θ$ be a limit point of a sequence, $limsup_(n) a_(n) = α$. Show that exists a subsequence $⟨ d_(k) : k ≥ 1 ⟩$ of $⟨ a_(n) : n ≥ 1 ⟩$ such that $d_(k) → β = θ$.]

#b() 

#Q()

#pagebreak()

#q(title: "Problem 5")[Give an example of a bounded sequence $⟨ a_(n) : n ≥ 1 ⟩$ that has exactly two (distinct) limit points.]

#b() 

#Q()

#pagebreak()

#q(title: "Problem 6")[Give an example of a bounded sequence $⟨ a_(n) : n ≥ 1 ⟩$ that has infinitely many limit points.]

#b() 

#Q()

#pagebreak()

#q(title: "Problem 7")[Let $⟨ a_(n) : n ≥ 1 ⟩$ be a sequence such that $lim_(n) a_(n) = u$. (i) If $u ∈ ( c , d )$, show that $∃ m ∈ NN$ such that $a_(n) ∈ ( c , d )$ for all $n ≥ m$. (ii) If $∃ m ∈ NN$ such that $a_(n) ∈ [ c , d ]$ for all $n ≥ m$ then $u ∈ [ c , d ]$.]

#b() 

#Q()
