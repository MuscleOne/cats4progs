# Universal constructions and the algebra of types

## Constructing datatypes
Types play a fundamental role in thinking programming from a categorical point of view. 

Haskell starts with a collection of base types, but programming is about using some simple building blocks to construct rich and expressive behavior and often these types are not enough. 

Introduce ways of making new types from old, including introducting operations on types such as taking the product, the sum, or the exponential, such operations define an "algebra" of types.  

we have three ways of constructing new types from old, which may seem quite different. But in fact, they all have something very deep in common, namely they are all characterized by *universal properties*. 

Example, the unit type `()`
```haskell
:t ()
() :: ()
```
## Universal constructions
four universal constructions:

### Terminal Objects

### Initial Objects

### Products

### Coproducts

### Type constructors
syntex: 
```haskell
data TypeContructor = DataConstructors

-- like
data Bool = True | False
```
Type variables may also be used; these must begin with a lower case letter. For example, in the following type definition, `a` is a type variable.
```haskell
data WithString a = MakeWithString a String
```
`Bool` and `WithString` are called *type constructors* since they construct news types. The type variable `a` means that a type must be given to the `WithString` constructor in order to construct a type. 
For example, given the type `Int` we get a type `WithString Int` which is a type whose term are integers with string. 

Type constructors define new types. To produce terms (or *data*) of these types, we must use their *data constructors*. 
The type `Bool` has two data constructors, `True` and `False`, thus these are the two terms of type `Bool`. A term of type `WithString a` must be constructed using the constructor `MakeWithString` together with a term of type `a` and a `string`. Thus this data constructor is a function 
```haskell
MakeWithString :: a -> String -> WithString a
-- :t MakeWithString
```
Normally, function names start with a lowercase letter, but data constructors are an exception: they are functions whose names start with an uppercase letter. 
Since each type has its own data constructors, the compiler can use these data constructors (like `MakeWithString`) as keywords that indicate the type of the term to follow: “whenever I see `MakeWithString x y`, I check what type `x` has, say `Int`, check that `y` is a `String`, and then and I’ll know that `MakeWithString x y` has type `WithString Int`." 

Here’s how the constructor may be used to construct a value of the type `WithString Int`: 
```haskell
charles :: WithString Int
charles = MakeWithString 135 "bananas"
```
The first line declares the type fo the name `charles` as the type by applying the type constructor `WithString` to `Int`. The second line declares `charles` to have a specific value, obtained by passing `135 "bananas"` to the data constructor `MakeWithSring`. 

Once a value of the type `WithString a` (i.e, `WithString Int`) is constructed, it is immutable, which is part of what makes haskell a purely functional language. Because of immutability every value "remembers" the way it was created: what data constructor was used and what values were passed to it. This is why a value of type `WithString a` can always be deconstructed. This deconstruction is called *pattern matching* and here is how it is done. 
```haskell
extractString :: WithString a -> String
extractString (MakeWithString x y) = y
```
The pattern that is matched here is `MakeWithString x y` which names the data constructor `MakeWithString` and the values passed to it `x` and `y`. When applied to the above example, 
```haskell
extractString charles
```

### Unit and void (Initial and Terminal Objects)

**The unit type** thinking haskell as a category, certain types will have certain "universal properties", playing an important role in structuring our programs. 

A singleton type is a type with a uniquee, unparametrized data constructor.
```haskell
data Terminal = UniqueValue
```
Just any set with one element is a terminal object in the category **Set**, terminal object in Haskell: for every other type, there is only one way to define a (total) function to `Terminal`. 

*unit type* which is already defined in any implementation of haskell
```haskell
data () = ()
```
This definition contains a pun, of a sort common in Haskell type definitions. 
The symbol `()` (empty tuple) is being used in two, distinct ways: first as a type constructor (ie. as the name of a type), and second as a data constructor (ie. as the name of a term of that type).
In fact, the `()` is the only term of the type `()`, so this abuse of notation si not so bad, assuming you can tell terms from types (the haskell compiler can). 

Note also that the name `()` is special syntax: ordinary, user-defined types cannot contain parentheses. 

We will see that the unit type is very useful when defining functions with *side-effects*, a way to escape the purely functional aspects of haskell. 
```haskell
-- for all type a, define a function
bang :: a -> ()
```

**The void type** The idea of an initial object inspires the empty Haskell type.  
```haskell
data Void 
```
Note that it has no data constructors, because it’s empty! We can’t construct a term of type `Void`.

Since `Void` has no data constructor, there is no way to create a term of type `Void`—the logical statement it represents is false.

Now in logic, the Latin phrase *ex falso quodlibet* (“from falsehood, anything follows”) refers to the principle that if you can prove a contradiction, or *false*, anything follows.
An initial object thus behaves a bit like a false statement, in the sense that any other object receives a morphism from it: given a proof of `Void`, you can prove anything. For fun, we’ll refer the unique morphism from Void to any type `a` as `exFalso`. 
```haskell
exFalso :: Void -> a
exFalso x = undefined
```
The funny thing here is that whenever the program tries to evaluate `undefined`, it will terminate immediately with an error message. We are safe, though, because there is no way `exFalso` will be executed. For that, one would have to provide it with an argument: a term of type `Void`, and no such term exists!

The library `Data.Void` calls this function `absurd :: Void -> a`. 

Function equality, consider
```haskell 
vTo42 :: Void -> Int
vTo42 x = 42
```
Function equality is tricky. What we use here is called *extensional* equality: two functions are equal if, for every argument, they produce the same result. Or, conversely, to prove that two functions are different, you have to provide a value for the argument on which these two functions are differ. Obviously, if the argument type is `Void` and you cannot do that. 

### Tuple types (Products)
The next universal construction we introduced was the product.

Given two types `a` and `b`, we want to construct `a` type that behaves like their product in our idealized Haskell category
```haskell
data Pair a b = MkPair a b
```

The type constructor says that we have a new type, `Pair a b`, while the value constructor says that to construct a value of type `Paire a b`, we specify a value of type `a` and one of type `b`. 

For example, let us take `a=Int` and `b=Bool`. 
```haskell
p :: Pair Int Bool
p = MkPair 5 True
```

a product consists of three things: in addition to the product object, we have two projection maps. 
```haskell
proj1 :: Pair a b -> a 
proj2 (MkPair a b) = a

proj2 :: Pair a b -> b
proj2 (MkPair a b) = b
```
Note that we’ve used pattern matching to define these functions.
Also note the punning between the type and term levels:
we see the variable `a` in the type `Pair a b` as well as the expression `MkPair a b`. In fact, these are two different as, but closely related: we use this notation because the expression `a` is `a` term of type `a`.

*Exercise.* Write a program that defines the value $x$ = (`"well done!"`, `True`) of type `Pair String Bool`, and then projects out the first component of the pair
```haskell
data Pair a b = MkPair a b 
proj1 :: Pair a b -> a
proj1 (MkPair a b) = a

x = MkPair "Well done!" True
proj1 x
-- or `proj1 (MkPair "Well done!" True)`
-- output: "Well done!"

-- :t x
-- output: `x :: Pair String Bool`
```

*Build-in pair type* 
```haskell
data (a,b) = (a,b) -- doesn't actually compile, but it's the idea
```
The type constructor (a,b) should be thought of as analogous to `Pair a b`, the data constructor (a,b) is analogous to `MkPair a b`. 
The built-in pair type comes with projection maps
```haskell
fst :: (a, b) -> a
fst (x, y) = x

snd :: (a, b) -> b
snd (x, y) = y
```

*Note* `(data, type, newtype)`
```haskell
type AnimalName = String
```
then `"elephant" :: String` and `"elephant" :: AnimalName` both typecheck, and any function that accepts a `String` will accept an `AnimalName`. 

The keyword `newtype` allows the creation of a type isomorphic to an existing type: one must specify a single data constructor. we might define
```haskell
newtype AnimalName = MakeAnimalName String
```
This is similar in use to `data` with a single data constructor but ensures that the runtime representation of an `AnimalName` is identical to that of a `String`, and hence has consequences for the efficiency of code. 

*Example.* Consider standard 52 card deck and each card has a rank and a suit, which is pair type. 
```haskell
type Card = (Rank, Suit)
newtype Rank = R Int

rank :: Rank -> Int
rank (R n) = n
```
Where `Suit` is defined as `data Suit = Club | Diamond | Heart | Spade`

**Using the universal property of products** 
The universal property of the product says that, given a type `c`, a pair of functions `c -> a` and `c -> b` is the same as a single function `c -> (a,b)`. In other words, the types `(c -> a, c-> b)` and `(c -> (a, b))` is isomorphic. 

The isomorphism is very useful to programmers: it says we may construct a function into a pair just as by solving the simpler problems of constructing a function into a factors! 
It is helpful to explicitly have available the isomorphism between the two type. In one direction, we have the function `tuple`. 
```haskell
tuple :: (c -> a, c -> b) -> (c -> (a, b))
tuple (f, g) = \c -> (f c, g c)
```
Or using pattern matching: 
```haskell
tuple :: (c -> a, c -> b) -> (c -> (a, b))
tuple (f, g) c = (f c, g c)
-- tuple (f, g) c = Pair (f c) (g c)
-- In this chapter f and g have been defined
```
In the other direction, we can define the function `untuple`. 
```haskell
untuple :: (c -> (a, b)) -> (c -> a, c -> b)
untuple h = (\c -> fst (h c), \c -> snd (h c))
-- untuple h c = (fst (h c), snd (h c)) -- have error, no way
```
We can show that `tuple` and `untuple`are inverses, and hence the types
`(c -> a, c -> b)` and `c -> (a,b)` are *isomorphic*.

**How to run the code???**

*Note* the standard library `Control.Arrow` already includes the function `tuple`, defined as an infix operator `&&&`. With type signature
```haskell
(&&&) :: (c -> a) -> (a -> b) -> (c -> (a, b))
```
Note that this type signature is different from the one we used for `tuple`; we say this is the *curried* version of the function. 

*Record syntax* Suger to Product, consider `proj1` and `proj2`, record syntax for product types lets you assign names to their components, these name are sometimes called *accessors* or *selectors*. 

Instead of defining the `Pair` datatype and then defining funcitons `proj1` and `proj2` as above, we can use the more concise syntax:
```haskell
data Pair a b = MkPair {proj1 :: a, proj2 :: b}
```
More typically, since the accessors are though of as names for fields as well as functions for accessing them, one chooses names accordingly:
```haskell
data Pair a b = MkPair {fst :: a, snd :: b}
```
Record syntex also allows to "modify" individual fields, this means creating a new version of a data structure with particular fields given new values. For instance, to increment the first component of a pair, we could define a function
```haskell
incrFst :: Pair Int String -> Pair Int String
incrFst p = p {fst = fst p + 1}
```
Here we are defining `incrFst p` which has the same components as `p` except for the `fst` field, which is set to `fst p + 1` (the value of `fst p` plus one). 

*Example.* The game state is a record with three fields
```haskell
data Game = Game { founds  :: Foundations
                 , cells   :: Cells
                 , tableau :: Tableau}
```
The feilds can be accessed through their selectors, as in
```haskell
game :: Game --suppose game is already given
cs = cells game -- then we can get its cells in this way
```
We can also implement three *setter*, which use the record update syntax
```haskell
putFounds game fs = game { founds = fs}
putCells game cs = game { cells = cs}
putTableau game ts = game { tableau = ts}
```
As usal for product types, you can construct a record either using the record syntax with named fieds, or by providing values for all fields in correct order. 
```haskell
newGame :: [Card] -> Game -- we will implement this in an appendix
newGame deck = Game newFoundations
               newCells
               (newTableau deck) --newtableau takes an argument
```

### Sum types (Coproducts)
To model finite coproducts in Haskell, there are sum types. 

Haskell for implementing coproducts makes use of the vertical line `|`,which in computer science is traditionally associated with `OR`.
```haskell
data Coproduct a b = Incl1 a | Incl2 b
```
Types constructed using `|` are known as *sum types*. A more traditional name for `Coproduct` in haskell is simply `Either`: 
```haskell
data Either a b = Left a | Right b
```
Here `Left` and `Right` correspond to the two injections *i_1* and *i_2*. 
```haskell
-- command `:t`
Left :: a -> Either a b 
Right :: b -> Either a b 
```
An instance of `Either a b` may be created using either data constructor.For example:
```haskell
x :: Either Int Bool 
x = Left 42
y :: Either Int Bool
y = Right True
```
Thus, in analogy with the coproduct in **Set**, the terms of type `Either Int Bool` are just the terms of type `Int` together with the terms of type `Bool`.

We define functions out of a sum type by pattern matching. Here are two possible syntaxes:
```haskell
h :: Either a b -> c
h eab = case eab of
        Left a -> foo a
        Right b -> bar b
```
or 
```haskell
h :: Either a b -> c
h (Left a) = foo a
h (Right b) = bar b
```
So, what are the types of the functions `foo` and `bar` above? 
It should be `foo :: a -> c`, **Right?**

**So what? I have not mede sense yet!**

*Exercise.* **Maybe**
Note that a constructor in a sum type need not have any type variable, for example, the `Maybe` type constructor defined in the `Prelude` has the following definition:
```haskell
data Maybe a = Nothing | Just a
```
here `Nothing` is a constructor for a singleton type, with the unique term `Nothing`. Thinking of this as a terminal object 1, the type `Maybe` a models the coproduct $1+a$. 

This data constructors have the type signatures
```haskell
-- run `:t` and get the type signaturesa
Nothing :: Maybe a
Just :: a -> Maybe a
```
Thinking of `Nothing` as a map from a singleton type for example `()` to `Maybe a`, these data construtor correspond to the two inclusions into the coproduct $1+a$. 

In effect, `Maybe a` adds a single, new term, `Nothing` to the type `a`.  
This is useful for type safe definitions of operations that are not totally defined. For example, the integer division function `div` does not always return an integer: it returns an exception if we try to divide by zero. However, we can make this function total by sending division by zero to `Nothing`:
```haskell
safeDev :: Int -> Int -> Maybe Int
safeDev m n = 
    if n == 0
    then Nothing
    else Just (div m n)
```
Note that the return type is now `Maybe Int` instead of `Int`. 

*Example*. As promised previously, we can now implement the type `Suit` fro our running cards example. This is simply a sum type with four data constructors:
```haskell
data Suit = Club | Diamond | Heart | Spade
```

**Using the universal property of the coproduct** 
In analogy with the funciton `tuple` for products, there is an convenient function in haskell that encapsulates the universal property of the coproduct. 
```haskell
either :: (a -> c) -> (b -> c) -> (Either a b -> c)
either f g = 
    \e -> case e of 
          Left a -> f a
          Right b -> g b
```
The `either` function has an inverse
```haskell
unEither :: (Either a b -> c) -> (a -> c, b -> c)
unEither h = (h . Left, h . Right)
```
The above style is called *point free* becouse it doesn't use variable; it is equivalent to the following 
```haskell
unEither h = (\a -> h (Left a), \b -> h (Rigth b))
```
## Exponentials and function types

























