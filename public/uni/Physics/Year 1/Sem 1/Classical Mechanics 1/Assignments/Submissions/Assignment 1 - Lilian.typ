#import "@preview/nova-pset:0.1.0": *
#import "@preview/adaptive-dots:0.1.0": adaptive-dots, ldots, cdots
#import "@local/typst-math:0.1.0": setup, scr
#show: setup
#show: adaptive-dots
#let class = "Classical Mechanics 1"
#let assignment = "Assignment 1"
#let author = "Lilian"
// To use a logo, add an image to this folder and replace none:
// #let logo = image("your-logo.png", height: 25pt)
#let logo = none
#let instructor = ""
#let semester = "Fall 2026"
#let due-time = "Wednesday, 19/08/2026"
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

// The problems could not be read from the PDF; copy them in as #q(title: "Problem 1")[...].

#q(title: "Problem 1")[]

#b() 

#Q()
