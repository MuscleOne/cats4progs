## Learn cats 4 prgs with Haskell
首先，安装haskell在远端平台上。

如何安装haskell？从官网开始

link: https://www.haskell.org/get-started/

GHCup: universal installer

link: https://www.haskell.org/ghcup/install/

```
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
```

first step: https://www.haskell.org/ghcup/steps/

遇到报错，跑了`sudo apt install ghc`

code: 
```Haskell
:{
 map f list =
     case list of
         [] -> []
         x : xs -> f x : map f xs
:}
```
Using external packages in ghci

By default, GHCi can only load and use packages that are included with the GHC installation.

Creating a proper package with modules

A four letures courses: https://github.com/haskell-beginners-2022/course-plan






