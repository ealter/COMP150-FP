import Albums
import Data.List
import Data.Function

main = do
  mapM_ (print . (map albumName)) fitNormanAlbums
  putStrLn ("The number of dvds is " ++ (show $ length fitNormanAlbums))
  putStrLn ("The smallest dvd is " ++ (show $ dvdSize $ minimumBy (compare `on` dvdSize) fitNormanAlbums))

dvdMaxSize = 4700000000

type Dvd = [Album]

albumSize :: Album -> Integer
albumSize = snd

albumName :: Album -> String
albumName = fst

dvdSize :: Dvd -> Integer
dvdSize dvd = sum $ map albumSize dvd

isDvdEmpty :: Dvd -> Bool
isDvdEmpty = null

albumCanFitDvd :: Album -> Dvd -> Bool
albumCanFitDvd album dvd = albumSize album + dvdSize dvd < dvdMaxSize

addAlbumToDvd :: Album -> Dvd -> Dvd
addAlbumToDvd = (:)

addAlbum :: Album -> [Dvd] -> [Dvd]
addAlbum album dvds =
  let (tooFull, rest) = break (albumCanFitDvd album) dvds
  in tooFull ++ [addAlbumToDvd album (head rest)] ++ tail rest

blankDvds :: [Dvd]
blankDvds = repeat []

fitAlbums :: [Dvd] -> [Album] -> [Dvd]
fitAlbums = foldr addAlbum

fitNormanAlbums :: [Dvd]
fitNormanAlbums = takeWhile (not . isDvdEmpty) (fitAlbums blankDvds (sortAlbums norman'sAlbums))

sortAlbums :: [Album] -> [Album]
sortAlbums = sortBy (compare `on` albumSize)

