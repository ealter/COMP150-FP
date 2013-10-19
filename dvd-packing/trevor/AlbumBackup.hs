{-#OPTIONS -Wall -Werror -fno-warn-name-shadowing #-}
module AlbumBackup
where

import Data.Function
import Data.List

dvdCap :: Integer
dvdCap = 4700000000

type Album = (String, Integer) --title, size

albumTitle :: Album -> String
albumTitle album = fst album

albumSize  :: Album -> Integer
albumSize  album = snd album

data DVD = DVD {albums :: [Album], currSize :: Integer }
emptyDvd :: DVD
emptyDvd        = DVD {albums = [], currSize = 0 }

dvdIsEmpty :: DVD -> Bool
dvdIsEmpty  dvd = (currSize dvd) == 0

albumFits :: Album -> DVD -> Bool
albumFits album dvd = (currSize dvd + albumSize album) < dvdCap

dvdWithAlbum :: Album -> DVD -> DVD
dvdWithAlbum a (DVD {albums = as, currSize = dvdSize}) =
    DVD {albums = (a : as), currSize = dvdSize + albumSize a}

addAlbum :: Album -> [DVD] -> [DVD]
addAlbum album (dvd:dvds)
    | (albumFits album dvd) = ((dvdWithAlbum album dvd) : dvds)
    | otherwise             = (dvd : (addAlbum album dvds))
addAlbum _ []           = error "No dvds to add album to"

addAlbums :: [Album] -> [DVD] -> [DVD]
addAlbums albums dvds = foldr addAlbum dvds
                              (sortBy (compare `on` snd) albums)
dvdsUsed :: [DVD] -> Int
dvdsUsed dvds = length (takeWhile (not . dvdIsEmpty) dvds)

showAlbums :: [Album] -> [Char]
showAlbums [] = ""
showAlbums (a:as) = show a ++ "\n" ++ showAlbums as

instance Show DVD where
    show DVD {albums = as, currSize = size} = "\nSize: " ++ show size ++ "\n" ++
                                              "Albums:\n" ++ showAlbums as
backedUp :: [Album] -> [DVD]
backedUp albums = (takeWhile (not . dvdIsEmpty)
                    (addAlbums albums (repeat emptyDvd)))
