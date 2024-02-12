-- Make Param files from the given directory

import System.Directory
import System.FilePath((</>),takeFileName,takeDirectory,takeBaseName)
import Control.Monad
import Data.List(transpose,intercalate)
import Data.List.Split(splitOn)
import Text.Groom(groom)
import Data.Char(isSpace)

main = do
   cur <- getCurrentDirectory
   let dirPath =  cur </> "given" 

   dir <- getDirectoryContents dirPath 
   filterM filterer $ map (dirPath </>) dir
   >>= mapM_ process
  

filterer f | takeFileName f == ".DS_Store" = return False
filterer f = doesFileExist f


process :: FilePath -> IO ()
process fp = do
   file <- readFile fp 
   putStrLn fp
   {-putStrLn file-}

   let res = mkparam (lines file) 
   {-putStrLn (groom res)-}
   

   let base = (takeDirectory . takeDirectory ) $ fp
   let newFp = base </> (takeBaseName . takeFileName ) fp ++ ".param" 
   writeFile newFp res
   return ()


mkparam :: [String] -> String
mkparam (info:rest) = 
    let pairs   = map (words . trim) rest
        demandS = map handlePair (transpose pairs)

    in  handleData ( intercalate ",\n" demandS : (words . trim ) info ) 


handleData [dem,n,m,b,r,a] = 
      "language Essence 1.3" ++ "\n"
   ++ "letting nnodes be "   ++ n ++ "\n"
   ++ "letting nrings be "   ++ m ++ "\n"
   ++ "letting capacity be " ++ r ++ "\n"
   ++ "letting demand be {" ++ dem ++ "}\n"

handlePair [n,m,_] = 
    "{" ++ n ++ ", " ++ m ++ "}"

handlePair [""] = ""
handlePair a = error . groom $ a

trim xs = dropSpaceTail "" $ dropWhile isSpace xs

dropSpaceTail maybeStuff "" = ""
dropSpaceTail maybeStuff (x:xs)
        | isSpace x = dropSpaceTail (x:maybeStuff) xs
        | null maybeStuff = x : dropSpaceTail "" xs
        | otherwise       = reverse maybeStuff ++ x : dropSpaceTail "" xs
