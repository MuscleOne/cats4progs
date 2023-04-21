## Learning programming

functions 
```haskell
(div x y) * y + (mod x y) == x
```
Let syntax
```haskell
let x = sin (pi / 4)
let llama = cos (pi / 4)
x^2 + llama^2
```

```haskell
let x' = 2 * x
```
multi-line modes in ghci
```haskell
:{
let abs x | x >= 0 = x
          | otherwise = -x
:}
```
Modules 

something like `module Test where`, If you want to compile and execute a Haskell file, it must contain the definition of `main`.

Input/Output
```haskell
main = do
    putStrLn "This is a prime number"
    print (2^31 - 1)
```
Comments
like `id :: a -> a --identity funciton`

language pragmas 






