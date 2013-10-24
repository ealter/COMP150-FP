#Programming practice
COMP 150 - Advanced Functional Programming  
September 13, 2013

Here are some typeclass problems.  Please
bring your solutions next week for Show and Tell.

##Constructor classes  
Here are some type definitions:

    type Pair a = (a, a)
    type List a = [a]
    data Maybe a = Nothing | Just a
    data Tree a = Nil | Node { left :: Tree a, value :: a, right :: Tree a }

Each of these things could be fairly described as a "container of
`a`'s."

  - Devise a syntactic proof system for showing that a constructor $C$
    has the property that $C$ `a` is a container of `a`'s.

  - Think of at least two operations you ought to be able to perform
    on container classes.

  - Define the judgment form and the operations using a Haskell
    typeclass definition.

  - For each rule in your proof system, write the corresponding
    Haskell instance declaration.


##Enriched Boolean operations
I wish to define a new set of operations on Booleans and related
functions.  I will do so by informal English and by example:

  - Function `opposite` returns the opposite of its argument.
    The opposite of `True` is `False`; the opposite of `even` is
    `odd`, and the opposite of `(<)` is `(>=)`.

  - Function `either` disjoins its two arguments.
    Disjunction on Booleans is the usual $\lor$ operation.
    The disjunction of `even` and `odd` is the constant true function
    `const True`.
    The disjunction of `(<)` and `(>)` is the `(/=)` function.
    The disjunction of `(<)` and `(==)` is the `(<=)` function.

  - Function `both` conjoins its two arguments.
    Conjunction on Booleans is the usual $\land$ operation.
    The conjunction of `even` and `odd` is the constant false function
    `const False`.
    The conjunction of `(<)` and `(>)` is the function that takes two
    arguments and returns `False`.
    The conjunction of `(<=)` and `(>=)` is the function `(==)`.

The problem has two parts:

 1. Define a Haskell type class with methods `opposite`, `either`, and
 `both`.

 2. Write instance declarations sufficient to handle the examples
 above, plus *every other example of a function that returns a
 Boolean*, no matter how many arguments the function expects.

*Hint:* Write a syntactic proof system that shows for any type *tau*
precisely when *tau* describes a function that returns a Boolean.

 
