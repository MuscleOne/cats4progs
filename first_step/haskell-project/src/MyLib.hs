module MyLib (someFunc) where

import System.Directory

someFunc :: IO ()
someFunc = do 
    contents <- listDirectory "Src" 
    putStrLn (show contents)
