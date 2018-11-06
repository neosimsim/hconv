-- Copyright © 2018, Alexander Ben Nasrallah <me@abn.sh>
-- Use of this source code is governed by a BSD 3-clause
-- style license that can be found in the LICENSE file.
module Main
  ( main
  ) where

import           Data.Semigroup      ((<>))
import           Data.Text           as Text
import           Data.Text.IO        as IO
import           Data.Text.Normalize as Normalize
import           Options.Applicative

data Options = Options
  { normalizationMode :: NormalizationMode
  , showLength        :: Bool
  } deriving (Show)

parseOpts :: Parser Options
parseOpts =
  Options <$>
  option
    modeOption
    (long "mode" <> short 'm' <>
     help "Normalizetion mode for the output [NFC|NFD|NFKC|NFKD]" <>
     showDefault <>
     value NFC <>
     metavar "MODE") <*>
  switch (long "length" <> short 'l' <> help "print length of the text")

parseMode :: String -> Either String NormalizationMode
parseMode s
  | s == "NFC" = Right NFC
  | s == "NFD" = Right NFD
  | s == "NFKC" = Right NFKC
  | s == "NFKD" = Right NFKD
  | otherwise = Left $ "unknown normalization mode " ++ show s

modeOption :: ReadM NormalizationMode
modeOption = eitherReader parseMode

normalizeInput :: Options -> Text -> Text
normalizeInput opt = normalize (normalizationMode opt)

printOutput :: Options -> Text -> IO ()
printOutput Options {showLength = l} t
  | l =  print $ Text.length t
  | otherwise = IO.putStr t

main :: IO ()
main = do
  options <- execParser opts
  inText <- IO.getContents
  printOutput <*> (normalizeInput' inText) $ options
  where
    opts = info (parseOpts <**> helper) (fullDesc <> progDesc "" <> header "")
    normalizeInput' = flip normalizeInput
