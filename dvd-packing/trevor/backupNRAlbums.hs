{-#OPTIONS -Wall -Werror -fno-warn-name-shadowing #-}
import Albums as A
import AlbumBackup

main :: IO ()
main = let backedUpNRAlbums = backedUp A.norman'sAlbums
        in do putStrLn (show backedUpNRAlbums)
              putStrLn ((show (dvdsUsed backedUpNRAlbums)) ++ " DVD's used.\n")
