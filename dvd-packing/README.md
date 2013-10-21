#Programming practice
COMP 150 - Advanced Functional Programming  
September 6, 2013

Here are some warmup problems to get you started with Haskell:

1. At
[`http://www.cs.tufts.edu/comp/150FP/Albums.hs`](http://www.cs.tufts.edu/comp/150FP/Albums.hs)
you will find a list of record albums that have been digitized from
vinyl.
You have an infinite supply of DVDs, each of which holds 4,700,000,000 bytes.
Your mission is to back up these albums using the minimum possible number of
DVDs.
Assume that the size of a backup is the sum of the sizes of the albums
being backed up.

  Here's how you identify a good solution:
    - A solution that uses fewer DVDs is better than a solution that
      uses more DVDs.
    - If two solutions use the same number of DVDs, the better
      solution is the one that has the *most* room on the *least full* DVD.

  This problem provides a good opportunity to use lazy evaluation
 with infinite data structures.

1. John Hughes does a number of numerical examples with different
convergence functions.  Since John's paper was written, the IEEE
floating-point standard has become widely deployed.  GHC provides
access to IEEE floating-point functions using the nonstandard module
[`GHC.Float`](http://hackage.haskell.org/packages/archive/base/3.0.3.0/doc/html/GHC-Float.html).
Using this module, write a convergence function that will give you
results that are accurate to within a stated number of bits of
precision.  If asked for more precision than the machine can provide,
your function should call `error`.

    Using this module, replicate some of the results in John's paper.
    For example, you might see if you can compute pi or e to the
    same accuracy provided by the standard libraries, or close to that
    accuracy. 
