-- Imports

import System.Exit -- exitWith

import XMonad

import XMonad.Util.EZConfig(additionalKeysP) -- simplified keys definition

import qualified Data.Map as M
import qualified XMonad.StackSet as W

main :: IO ()
main = do
  xmonad $ def
    { terminal    = terminal'
    , modMask     = modMask'
    , borderWidth = borderWidth'
    , workspaces  = workspaceIDs
    } `additionalKeysP` ezkeys
    -- additionalKeysP :: XConfig l [(String, X ())] -> XConfig l

-- Programs
terminal' :: String
terminal' = "alacritty"
browser' :: String
browser' = "vivaldi-stable"

-- Appearance
borderWidth' = 3

-- Workspaces
workspaceIDs :: [String]
workspaceIDs = map show [1..10]
workspaceKeys :: [String]
workspaceKeys = map show [1..9] ++ ["0"]

-- Key bindings
modMask' :: KeyMask
modMask' = mod4Mask -- Super_L
--amodMask :: KeyMask
--amodMask = mod1Mask -- Alt



ezkeys :: [(String, X ())]
ezkeys =
  -- Spawning and killing
  [ ("M-<Return>" , spawn terminal')
  , ("M-S-q"      , kill)
  , ("M-w"        , spawn browser')

  -- Refresh Restart Quit
  , ("M-p"      , refresh)
  , ("M-S-p"    , restart "xmonad" True)
  , ("M-M1-S-p" , io (exitWith ExitSuccess))
  -- Brightness and Sound (with lux)
  , ("M-M1-<Up>"   , spawn "lux -a 10%")
  , ("M-M1-<Down>" , spawn "lux -s 10%")
  , ("<XF86MonBrightnessUp>"   , spawn "lux -a 10%")
  , ("<XF86MonBrightnessDown>" , spawn "lux -s 10%")
  , ("M-M1-S--" , spawn "amixer -q sset Master 3%+")
  , ("M-M1--"   , spawn "amixer -q sset Master 3%-")
  , ("<XF86AudioRaiseVolume>"  , spawn "amixer -q sset Master 3%+")
  , ("<XF86AudioLowerVolume>"  , spawn "amixer -q sset Master 3%-")
  ]
  ++ -- View Workspace
  [ ("M-" ++ key, windows $ W.greedyView ws)
    | (key,ws) <- zipWith (,) workspaceKeys workspaceIDs
  ]
  ++ -- Move to Workspace
  [ ("M-S-" ++ key, windows $ W.shift ws)
    | (key,ws) <- zipWith (,) workspaceKeys workspaceIDs
  ]


