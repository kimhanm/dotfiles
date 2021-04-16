-- Imports

import System.Exit -- exitWith
import System.IO

import XMonad

import XMonad.Actions.MouseResize

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks (avoidStruts)

import XMonad.Layout
-- import XMonad.Layout.Fullscreen (fullscreenFull)
import XMonad.Layout.Grid (Grid(..))
import XMonad.Layout.ResizableTile
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
  spawnOnce "/usr/bin/xmobar /home/hk/kimhanm/dotfiles/xmonad/xmobarrc"
  --spawnOnce "$HOME/.config/polybar/launch.sh &"

layoutHook' = avoidStruts $ mouseResize $ 
                    Tall 1 delta prop
                -- ||| spirals (6/7)
                -- ||| tabbed
                -- ||| Grid
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

--layoutHook' = avoidStruts $ mouseResize $ layoutHook defaultConfig

-- Programs
terminal' :: String
terminal' = "alacritty"
browser' :: String
browser' = "vivaldi-stable"
launcher :: String
launcher = "rofi -show run"

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



ezKeys :: [(String, X ())]
ezKeys =
  -- Spawning and killing
  [ ("M-<Return>" , spawn terminal')
  , ("M-S-q"      , kill)
  , ("M-w"        , spawn browser')
  , ("M-d"        , spawn launcher)

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
  , ("M-m"      , windows W.focusMaster)
  , ("M-S-m"    , windows W.swapMaster)
  -- Layouts
  , ("M-<Space>", sendMessage NextLayout)
  -- Floating Windows
  , ("M-t"      , withFocused $ windows . W.sink) -- push to tile
  -- Rquires ResizeableTall layout from
  -- , ("M-S-j"    , sendMessage MirrorShrink)
  -- , ("M-S-k"    , sendMessage MirrorExpand)
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
  -- xmproc <- spawnPipe "/usr/bin/xmobar /home/hk/kimhanm/dotfiles/xmonad/xmobarrc"
  -- Background

  xmonad $ def { 
      terminal    = terminal'
    , modMask     = modMask'
    , borderWidth = borderWidth'
    , workspaces  = workspaceIDs
    , startupHook = startupHook'
    , focusedBorderColor  = focusedBorderColor'
    , normalBorderColor   = normalBorderColor'
    , layoutHook   = layoutHook'
    -- , logHook = dynamicLogWithPP $ xmobarPP
                  -- { ppOutput  = hPutStrLn xmproc
                  -- , ppCurrent = xmobarColor "blue" "" . wrap "[" "]"
                  -- , ppTitle   = xmobarColor "green" "" . shorten 50
                  -- }
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
