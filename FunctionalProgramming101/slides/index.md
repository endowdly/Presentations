- title: Functional Programming 101
- description: Introduction to Functional Programming and Why You Should Use It
- author: Ryan Dowd
- theme: night
- transition: default

***

## About

This presentation is built with [FsReveal][link-fsreveal].
FsReveal is an F# frontend for [Reveal.js][link-revealjs].

Navigating these waters:

- `Spacebar` or `n` to go forward
- `b` to go backward
- `Esc` to see an overview of all slides

[link-fsreveal]: https://fsprojects.github.io/FsReveal/index.html
[link-revealjs]: https://github.com/hakimel/reveal.js

## What is this?

### ✔️

- An introduction to Functional Programming
- Language agnostic

### ❌

- Coding class
- Elitist fanboy rant

' Other styles and paradigms are not evil; use them when you need them

***

## Overview

- Who am I?
- Who is this talk for?
- What is Functional Programming?
- Core Functional Concepts
  - First-class functions
  - Immutability

***

## Introduction

I am Ryan

![Groot](images/babygroot.gif)

' BS EE USMA 2009
' Started Crane in 2013 with WXQS
' Currently WXQT
' Deployed with MTRC 3 times

***

## Target Audience

- Anyone who codes... anything
- Anyone involved in data science or analysis
- Anyone using or developing machine learning techniques/algorithms

***

## What is Functional Programming?

Functional programming is a declaritive programming paradigm.
It focuses on designing programs as an evaluation of mathmatical functions.
This focus drives the style away from state mutations and mutable data.

---

### Wait... what!?

- Functions are first class values
- Avoiding state mutation

' First-class values can be passed around like variables
' No state mutation means no mutablility!

***

## What is a Coding Paradigm?

Simply, the style of how code is written and structured.
These paradigms broadly define the features of a programming language.

The two most common paradigms are _imperative_ and _declarative_.

---

## Imperative Paradigm

This structure will instruct a program how to change its state.
Procedural programming and object-oriented programming are common imperative styles.
A classic example of an imperative language is C.

The essence of imperative programming is the _execution of statements_.

' What is an imperative language? A short list:
' [C Family][link-cfam] Languages (includes Java, ECMAScript or JavaScript, and PHP),
' Ada,
' Python/Ruby,
' and any assembly language.

[link-cfam]: https://en.wikipedia.org/wiki/List_of_C-family_programming_languages

## Declarative Paradigm

This structure declares the desired result as a series of expressions.
Functional programming is a common declarative style.
A classic example of a declarative language is Lisp.

The essence of declarative programming is the _evaluation of expressions_.

' An even short list of examples:
' SQL,
' Haskell,
' [Lisp Famaily][link-lispfam] Languages (includes Scheme and Clojure),
' ML/SML/OCaml/F#.

[link-lispfam]: https://en.wikipedia.org/wiki/List_of_Lisp-family_programming_languages

---

## _Execution of Statements_ vs. _Evaluation of Expression_!?

This is a little abstract.
Let's clear that up by making some coffee, shall we?

![Coffee](images/coffee.gif)

We'll make some coffee using the two different paradigms.
Our design goal is to make a cup of coffee with two scoops of sugar.

' Most of us drink it, so I thought it'd be a relatable example.

## Object-Oriented Coffee

We start with a single black coffee by executing a statement.
The constructed object can be modified, so we can change it by adding two sugars.
However, without additional guards, we may miss the goal with incorrect statements.

``` csharp
var cuppa = new Coffee(CoffeeType.Black);

// Can execute cuppa.Drink() now
// If executed, the following statement will execute on an empty cup
// Without more complex defensive coding, we could miss the design goal!

cuppa.AddSugar(2);
```

' Have to assume Coffee class exists!

## Functional Coffee

Here, we start with a single black coffee with 2 sugars by evaluating an expression.
We cannot modify or drink the cup before the sugar is added (it does not exist).
When we get the cup, it already contains the sugar!

``` fsharp
let makeCoffee coffeeStyle sugars =    // this is a function describing our goal
    coffee with { Style = coffeeStyle; Sugar = sugars }

let cuppa = makeCoffee Black 2         // The evaluation
```

' Have to assume Coffee type exists!

***

## What does Functional Programming get me?

So what does using functions as first-class values and avoiding state mutation really mean?

1. Cleaner Code

Opinions aside, functional code is much easier to test.

2. Better support for concurrancy




