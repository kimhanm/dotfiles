-- Imports

import System.Exit -- exitWith
import System.IO

import XMonad

import XMonad.Actions.MouseResize
import XMonad.Actions.WorkspaceNames


import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks

import XMonad.Layout
-- import XMonad.Layout.Fullscreen (fullscreenFull)
import XMonad.Layout.Grid (Grid(..))
import XMonad.Layout.LayoutModifier
import XMonad.Layout.ResizableTile
import XMonad.Layout.Spacing
-- import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed

import XMonad.Util.EZConfig(additionalKeysP) -- Emacs style keys
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.SpawnOnce

import qualified Data.Map as M
import qualified XMonad.StackSet as W




-- Hooks
startupHook' :: X ()
startupHook' = do
  --spawnOwnce :: String -> X ()
  spawnOnce "nitrogen --restore &"
  spawnOnce "picom &"
  spawnOnce "clipmenud &"
  --spawnOnce "$HOME/.config/polybar/launch.sh &"

layoutHook' = avoidStruts 
            $ mouseResize 
            -- $ mySpacing 8 
            $       Tall 1 delta prop
                ||| Mirror (Tall 1 delta prop)
                ||| tabbed shrinkText tabConfig
                where
                  delta = (3/100)
                  prop  = (1/2)
-- Layout Arguments
tabConfig = def { activeColor         = "#46d9ff"
                , inactiveColor       = "#313846"
                , activeBorderColor   = "#313846"
                , inactiveBorderColor = "#282c34"
                }

--  mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
--  mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True
 
--layoutHook' = avoidStruts $ mouseResize $ layoutHook defaultConfig

-- logHook' pipe = workspaceNamesPP  xmobarPP
logHook' pipe = dynamicLogWithPP $ xmobarPP
                { ppOutput  = hPutStrLn pipe
                , ppTitle   = xmobarColor "green" "" . shorten 50
                , ppCurrent = xmobarColor "blue" "" . wrap "[" "]"
                , ppVisible = xmobarColor "#98be65" "" . shorten 50
                , ppSep =  "<fc=#666666> <fn=1>|</fn> </fc>"
                , ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!"
                }

----
-- Appearance
----
borderWidth' = 4

-- Colors
--color1, color2, color3, color4 :: String
--color1 = "#7F7F7F"
--color2 = "#c792ea"
--color3 = "#900000"
--color4 = "#2E9AFE"
focusedBorderColor', normalBorderColor' :: String
focusedBorderColor' = "#88C0D0"
normalBorderColor'  = "#282C32"



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

-- Programs
terminal' = "alacritty"
browser' = "vivaldi-stable"
launcher = "dmenu_run"
clipboard = "clipmenu"
filemanager = terminal' ++ " -e ranger"
screentoclip = "escrotum -s -C"



ezKeys :: [(String, X ())]
ezKeys =
  -- Spawning and killing Programs
  [ ("M-S-q"      , kill)
  , ("M-<Return>" , spawn terminal')
  , ("M-w"        , spawn browser')
  , ("M-d"        , spawn launcher)
  , ("M-c"        , spawn clipboard)
  , ("M-e"        , spawn filemanager)
  , ("M-S-s"      , spawn screentoclip)

  -- Refresh Restart Quit
  , ("M-p"      , refresh)
  , ("M-S-p"    , restart "xmonad" True)
  , ("M-M1-S-p" , io (exitWith ExitSuccess))
  -- Resize Windows
  , ("M-S-h"    , sendMessage Shrink)
  , ("M-S-l"    , sendMessage Expand)
  -- Window Management
  , ("M-j"      , windows W.focusDown)
  , ("M-k"      , windows W.focusUp)
  , ("M-S-j"    , windows W.swapDown)
  , ("M-S-k"    , windows W.swapUp)
  -- Layout
  , ("M-S-b"        , sendMessage ToggleStruts)
  , ("M-<Space>"    , sendMessage NextLayout)
  , ("M-M1-<Right>" , incWindowSpacing 2)
  , ("M-M1-<Left>"  , decWindowSpacing 2)
  --  Master/Stack
  , ("M-m"      , windows W.focusMaster)
  , ("M-S-m"    , windows W.swapMaster)
  , ("M-C-h"    , sendMessage (IncMasterN 1))
  , ("M-C-l"    , sendMessage (IncMasterN (-1)))
  --  Floating Windows
  , ("M-t"      , withFocused $ windows . W.sink) -- push to tile
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



-- MAIN
main :: IO ()
main = do
  -- spawnPipe :: MonadIO m => String -> m Handle
  -- xmobar
  xmproc <- spawnPipe "xmobar /home/hk/.xmonad/xmobarrc" 

  -- statusBarPipe <- spawnPipe

  xmonad $ docks def { 
      terminal    = terminal'
    , modMask     = modMask'
    , borderWidth = borderWidth'
    , workspaces  = workspaceIDs
    , startupHook = startupHook'
    , focusedBorderColor  = focusedBorderColor'
    , normalBorderColor   = normalBorderColor'
    , layoutHook  = layoutHook'
    , logHook     = logHook' xmproc
    } `additionalKeysP` ezKeys

{- 
# General
additionalKeysP :: XConfig l [(String, X ())] -> XConfig l

# Actions
sendMessage :: Message a => a -> IO ()
spawn :: MonadIO m => String -> m ()

# Layout
avoidStruts :: LayoutClass l a => l a -> ModifiedLayout AvoidStruts l a

-}
