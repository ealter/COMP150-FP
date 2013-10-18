% Programming Practice with Monads
% COMP 150FP
% Fall 2013

You're not really fluent with monads until you can write your own.
This week I'm asking you to write two for practice, then combine them
with the `IO` monad.

1. Implement a monad of computations that require a source of
randomness in order to produce a value.  Here are some constraints,
recommendations, and hints:

    - To represent a source of randomness, try using the class `RandomGen`
      defined in the Haskell module `System.Random`.^[If you haven't
      discovered Hoogle yet, now is the time]  If you have trouble with
      the type class, you can try a simpler problem: use the `StdGen`
      type.

    - Your randomness monad must be capable of dealing with infinite
      random computations.  For example, I should be able to use
      `zipWith (+)` to combine two infinite streams from the same source
      of randomness.  You will need to be aware of the `split`
      function, whose type is

            split :: RandomGen g => g -> (g, g)

    - Equip your monad with a sufficiently expressive set of functions
      so that it is reasonably pleasant to program.   You will be
      programming with it next week.

    - Make sure it is possible to "escape" the monad: you must be able
      to supply a source of randomness and get back a result.

    - Remember always that the types tell the story.

    The interwebs are full of randomness monads.  But I want you to
discover traps, pitfalls, and (most important) design choices for
yourself.   So until we have a chance to have Show and Tell in class
in two weeks, please refrain from informing yourself.

2. Familiarize yourself with `dot`, the graph-drawing tool from
`graphviz.org`.  Your second practice task is to create a monad whose
computations produce dot graphs as a side effect.  In particular, you
will want to define monadic functions to create nodes and edges.
To keep things simple, give each node and edge an optional label of
type `Maybe String`.   Find some interesting trees or graphs to
visualize.  

    - It must be possible to take any monadic computation and extract
      either the result value or a string that can be input to `dot`
      to produce a graph.

3. Develop a program that uses three monads.  I recommend picking one
of the following three choices and implementing it yourself:

    - A red/black tree

    - A leftist heap

    - *Both* a simple binary-search tree and a simple functional heap

    Your program should use the randomness monad, the graph-writing monad,
and the IO monad to get a `dot` graph that will give you a
visualization of a data structure created by inserting a random stream
of integers.

    If you're not sure which data structure to pick, I recommend the
    leftist heap.  It is a cool data structure; the performance on heapsort
    is amazing; and in two weeks when we look at QuickCheck, it might
    provide the most fun.




