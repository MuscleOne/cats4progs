# programming: the art of composition
composition in haskell is denoted by "." between the functions. 
```haskell
words "Hello world"
length ["I","like","cats"]

let countwords = length . words
countwords "Yay for composition!"
```

## Categories and Haskell

the lambda calculus *lambda terms*

identity function
```haskell
\x -> x --The Greek letter lambda is replaced, in ASCII, with a backslash \ presumably because it looks like the back part of a lambd

id = \x -> x
```

```haskell
square = \x -> x^2
implies = \x -> \y -> not y || x 

square 7
square 109517

squre x

implies True False
```

Pattern matching
```haskell
id x = x
square x = x^2
implies y x = not y || x
```
But keep in mind that this is just “syntactic sugar”: the compiler converts the pattern matched syntax down to the more basic lambda syntax.

## Types

Not every lambda term can be translated to Haskell, like $\lambda x.xx$
The following code doesn’t compile:
```haskell
ouroboros = \x -> x x
```
simply-typed lambda calculus

If a term `x` has type `A`, we write 
```haskell
x :: A
```
In fact, in GHCi, you can ask what a term’s type is, using the command `:t` or `:type`.
For example:
```haskell
:t "Hi"
--"hi" :: [Char]

:t True
:t "cat"
:t 42
-- 42 :: Num a => a

:t \x -> x 
-- \x -> x :: p -> p

:t \x -> \y -> not y || x 
-- \x -> \y -> not y || x :: Bool -> Bool -> Bool
```
Types are what they sound like: they describe the type of data a term is meant to represent. 
Experienced Haskell programmers often start by defining types first and then specifying the implementations, in what is called type-driven development.

We defined the identity function `id` without giving a type signature. In fact our definition works for any arbitrary type. 
We call such a funciton a *polymorphic* function. 

It’s possible, although not necessary, to use the universal quantifier `forall` in the definition of *polymorphic functions*:
```haskell
id :: forall a. a -> a 
```
Type vs Sets: Types are very similar to sets, and it frequently will be useful to think of the type declaration `x :: A` as analogous to the theoretic statement $x \in A$. 

There are some key differences though, which the category theoretic perspective helps us keep straight. The main difference is that, in the world of sets, sets have elements. 
So given a set A, it’s a fair question to ask what its elements are, or whether a particular x is an element of A. Types and terms are the other way around: terms have types. Thus, conversely, `x :: A` i`s a judgment, an assertion -- it *defines* x as being of the type A, and it doesn’t require a proof.

## Haskell Functions

we have types `A` and `B`, there is a `A -> B` whose terms are (Haskell) functions accepting an `A` and producting a `B`. We call the type `A -> B` the *type of functions from `A` to `B`*.

Example
```haskell
:t not
-- not :: Bool -> Bool
```

consider *type signature*
```haskell
square :: Integer -> Integer
square x = x^2 --A type signature must then be accompanied by an implementation
```
Haskell functions vs mathematical functions

just as types are not the same sets, functions in Haskell are not the same as mathematical functions between sets. 

suppose that the terms of the domain and codomain types form sets, 
and then to write down the set of input–output pairs for the Haskell function

For example, the Haskell type `Bool` can be represented by the set `{True, False}`, which is isomorphic to $\mathbb B$, and the denotation of the Haskell function not is then the usual ‘not’ mathematical function.

example: consider a mathematical function $g: \mathbb Z \rightarrow \mathbb Z, g(x) = x + 1$ 
```haskell
g' :: Integer -> Integer
g' x = x + 1

g'' :: Int -> Int
g'' x = x + 1

g' (2^63 - 2)
g'' (2^63 - 2)
g'' (2^63 - 1)
-- -9223372036854775808
```

## Composing functions

a function `f :: a -> b` and a function `g :: b -> c` is written 
```haskell
g . f :: a -> c
```
This is pronounced '`g` after `f`'. 

To use an *infix* operator as an *outfix* we write `4 + 5` as `(+) 4 5`

Composition is itself a Haskell function, and what is its type signature? 
One way to think about it is that takes a pair of functions, and returns a new funcion. This is *currying*.  

It’s a trick that allows us to consider a function of two arguments as a function of the first argument that returns a function of the second argument. 
```haskell
(.) :: (b -> c) -> ((a -> b) -> (a -> c))
```
The function type symbol `->` by default associates to the right, this is equal to the type 
```haskell
(.) :: (b -> c) -> (a -> b) -> a -> c
```
Note that the rest of the parentheses are essential. 

Consider the implementation, given two functions `g :: b -> c` and `f :: a -> b`, we produce a third function defined as a lambda. 
The only thing we can do with the functions is to apply them to the arguments, and that is waht we do: 
```haskell
(.) = \g -> \f -> \x -> g (f x)
```
Using pattern matching we can also write this as 
```haskell
(.) g f = \x -> g (f x)
```
In this case, composition means $\circ : \lambda x. g(f(x))$ with $f: a \rightarrow b$ and $g: b \rightarrow c$. 

Composition is just a function with a funny name, (.). You can form a function name using symbols, rather than more traditional strings of letters and digits, by putting parentheses around them. 
```haskell
g . f = \x -> g (f x)
```
or, using the syntactic sugar for function definition simply as 
```haskell
(g . f) x = g (f x)
```

Composition, just like identity before, is a fully polymorphic function, as withnessed by lowercase type argument.  
```haskell
(.) :: forall a b c. (b -> c) -> (a -> b) -> a -> c
(g . f) x = g (f x)
```

Example
```haskell
words "Hello world!" 

concat ["Hello", "world!"]

(concat . words) "Hello world!" 

(.) concat words "Hello world!"
-- "Helloworld!"

--ghci> :t (.)
--(.) :: (b -> c) -> (a -> b) -> a -> c
```
It result in an error, because function application binds stronger than the composition operator, This would be equivalent to:
```haskell
length . words "Hello world!"
length . (words "Hello world!")
```
This is because the composition operator expects a function as a second argument, and what we are passing it is a list of strings.


and only this make sense 
```haskell
(length . words) "Hello world!"
```

Execite

Consider a mathematical function $f: \mathbb Z \rightarrow \mathbb Z$ that sends an integer to its square $f(x):= x^2$ and the function $g: \mathbb Z \rightarrow \mathbb Z$ sends an integer to its successor, $g(x):=x+1$. 

```haskell
-- Write analogous functions to f and g. 
f :: Int -> Int
f = \x -> x^2

g :: Int -> Int
g = \x -> x + 1

-- let h = f after g, what is h(2)
f . g = \x -> f (g x)
h = \x -> f (g x)

-- let j = f after g after f and what is j(2)
j = \x -> f (g (f x))
-- :t j
-- j :: Int -> Int
```

## Thinking categorically about Haskell
A category, recall, has objects, morphisms, identities, and composition, In more detail, the morphisms go between objects, every object has an identity morphism, and if we have two morphisms, one of whose domain is the other’s codomain, we can compose them. 

Haskell has types, functions, identities, and composition, the functions go between types, every type has an identity function, and if the codomain of a function is the domain type of another, then we can compose them. 

This leads to an analogy: Haskell is like a category. 

Haskell is a programming language, a tool for expressiong computaions, and even if haskell is not a mathmatical object, it is tempting to try to make this analogy precise. 

People often speak of a fictious category **Hask**, while our category doesn't obey the unit law, as `id . f` and `f` have different code. Still, perhaps a useful comparison is the Haskell type `Int`. 







