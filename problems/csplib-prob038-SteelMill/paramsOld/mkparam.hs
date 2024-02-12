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

   let res = mkparam (lines file)
   {-putStrLn (res)-}


   let base = (takeDirectory . takeDirectory ) $ fp
   let newFp = base </> (takeBaseName . takeFileName ) fp ++ ".param"
   writeFile newFp res
   return ()


{-mkparam :: [String] -> String-}
mkparam (info:n_colours:n_orders:rest) =
    let pairs            = map (words . trim) rest
        [sizes,colours]  = transpose pairs
        (mSize,mColours) = unzip $zipWith3 handleMapping sizes colours [1..]

        fsizes   = toFunc "ordSize" mSize
        fColours = toFunc "ordCol"  mColours

    in  handleData $ getInfo info ++  [n_colours,n_orders,fsizes,fColours ]

getInfo :: String -> [String]
getInfo arr =  [size, ( show . maximum . map textToInt $ nums )]

    where
    (size:nums) =  words . trim $ arr


handleMapping :: String ->  String -> Integer -> (String,String)
handleMapping size colour num =
    ( (show num) ++ " --> " ++ size, (show num) ++ " --> " ++ colour )

toFunc :: String -> [String] -> String
toFunc name mappings = "letting " ++ name ++ " be function( " ++ (intercalate "\n\t," mappings) ++ " )"

handleData [a,b,c,d,g,h] = unlines
    ["language Essence 1.3"
    ,""
    ,"letting nbSizes      be " ++ a ++ " )"
    ,"letting col_per_slab be "        ++ b
    ,"letting n_colours    be "        ++ c
    ,"letting n_orders     be "        ++ d
    ,""
    ,g
    ,""
    ,h
    ]


trim xs = dropSpaceTail "" $ dropWhile isSpace xs

dropSpaceTail maybeStuff "" = ""
dropSpaceTail maybeStuff (x:xs)
        | isSpace x = dropSpaceTail (x:maybeStuff) xs
        | null maybeStuff = x : dropSpaceTail "" xs
        | otherwise       = reverse maybeStuff ++ x : dropSpaceTail "" xs

textToInt :: String -> Int
textToInt t = case reads (t) of
    [(i,_)] -> i
    _       -> error $ "Unable to parse a int from " ++ show t
