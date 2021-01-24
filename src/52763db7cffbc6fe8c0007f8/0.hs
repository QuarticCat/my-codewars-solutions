module Codewars.Exercise.Tongues where

import Data.Maybe
import qualified Data.Map.Strict as Map

tongues :: String -> String
tongues = map (\x -> Map.findWithDefault x x table)
  where
    table = Map.fromList (zip "aiyeoubkxznhdcwgpvjqtsrlmfAIYEOUBKXZNHDCWGPVJQTSRLMF" "eouaiypvjqtsrlmfbkxznhdcwgEOUAIYPVJQTSRLMFBKXZNHDCWG")
