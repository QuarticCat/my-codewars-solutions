module HowManyNumbers (findAll) where

findAll :: Int -> Int -> (Int, Maybe Int, Maybe Int)
findAll s n
  | s < n || s > n * 9 = (0, Nothing, Nothing)
  | otherwise = (length nums, Just (toInt . head $ nums), Just (toInt . last $ nums))
  where
    toInt = foldr1 (\x y -> x + y * 10)
    nums = filter ((==s) . sum) (gen n)
    gen 1 = [[a] | a <- [1..9]]
    gen n = [a:b | b@(x:_) <- gen (n - 1), a <- [x..9]]
