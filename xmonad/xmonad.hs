-- Imports

import System.Exit -- exitWith
import System.IO

import XMonad

import XMonad.Actions.MouseResize
import XMonad.Actions.WorkspaceNames


import XMonad.Hooks.DynamicLog
-- import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.UrgencyHook

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

import Data.Maybe (fromJust)

import qualified Codec.Binary.UTF8.String as UTF8
import qualified DBus as D
import qualified DBus.Client as D
import qualified Data.Map as M
import qualified XMonad.StackSet as W
import qualified XMonad.Layout.IndependentScreens as LIS


-- Hooks
startupHook' :: X ()
startupHook' = do
  --spawnOwnce :: String -> X ()
  spawnOnce "xrdb ~/.Xresources"
  spawnOnce "nitrogen --restore &"
  spawnOnce "picom &"
  spawnOnce "clipmenud &"
  -- spawnOnce "lightlocker &"
  spawnOnce "xmodmap ~/.Xmodmap &"
  spawn     "$HOME/.config/polybar/launch.sh &"

layoutHook' = avoidStruts 
            $ mouseResize 
            $     Tall 1 delta prop
              -- ||| Mirror (Tall 1 delta prop)
              ||| tabbed shrinkText tabConfig
                where
                  delta = (3/100)
                  prop  = (1/2)

-- multi montor setup
-- toggleevga = do
  -- screencount <- LIS.countScreens
  -- if screencount > 1
    -- then spawn "xrandr --output HDMI-1 --off"
    -- else spawn "xrandr --output HDMI-1 --off"


-- Layout Arguments
tabConfig = def { activeColor         = "#46d9ff"
                , inactiveColor       = "#313846"
                , activeBorderColor   = "#313846"
                , inactiveBorderColor = "#282c34"
                }


logHook' :: D.Client -> PP
logHook' dbus = def 
    { ppOutput = dbusOutput dbus 
    , ppCurrent = wrap ("%{B" ++ blue ++ "} ") " %{B-}"
    , ppVisible = wrap ("%{B" ++ gray ++ "}") "%{B-}"
    , ppHidden = wrap " " " "
    , ppWsSep = ""
    , ppSep = " | "
    , ppTitle = shorten 20
    }


-- Emit ad DBus signal on log updates
dbusOutput :: D.Client -> String -> IO ()
dbusOutput dbus str = do
    let signal = (D.signal objectPath interfaceName memberName) {
            D.signalBody = [D.toVariant $ UTF8.decodeString str]
        }
    D.emit dbus signal
  where
    objectPath = D.objectPath_ "/org/xmonad/Log"
    interfaceName = D.interfaceName_ "org.xmonad.Log"
    memberName = D.memberName_ "Update"

----
-- Appearance
----
borderWidth' = 4

-- Nord Color Scheme 
--  Grayscale
fg        = "#ebdbb2"
bg        = "#282828"
bg1       = "#3c3836"
bg2       = "#504945"
bg3       = "#665c54"
bg4       = "#7c6f64"

-- 8 normal colors
black     = "#282C34"
red       = "#BF616A"
green     = "#A3BE8C"
yellow    = "#EBCB8B"
blue      = "#81A1C1"
magenta   = "#BA8EAD"
cyan      = "#88C0D0"
white     = "#E5E9F0"

-- bright
gray          = "#4C566A"
light-red     = "#BF616A"
light-green   = "#A3BE8C"
light-yellow  = "#cc241d"
light-purple  = "#d3869b"


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
browser' = "vivaldi-stable"
altbrowser = "nyxt"
clipboard = "clipmenu"
compositor = "picom"
filemanager = terminal' ++ " -e ranger"
launcher = "dmenu_run"
screentoclip = "escrotum -s -C"
screentopng = "escrotum -s '~/Pictures/escrotum-%Y-%m-%d-%H%M%S.png'"
terminal' = "alacritty"
-- lockscreen  = "light-locker-command -l"



ezKeys :: [(String, X ())]
ezKeys =
  -- Spawning and killing Processes
  [ ("M-S-q"        , kill)
  , ("M-<Return>"   , spawn terminal')
  , ("M-w"          , spawn browser')
  , ("M-S-w"        , spawn altbrowser)
  , ("M-d"          , spawn launcher)
  , ("M-c"          , spawn clipboard)
  , ("M-e"          , spawn filemanager)
  , ("M-S-<Return>" , spawn "emacs")
  , ("M-S-s"        , spawn screentoclip)
  , ("M-M1-S-s"     , spawn screentopng)
  , ("M-M1-c"       , spawn ("killall " ++ compositor))
  , ("M-M1-S-c"     , spawn compositor)
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
  dbus <- D.connectSession
  -- Request access to the DBus name
  D.requestName dbus (D.busName_ "org.xmonad.Log")
      [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]

  -- xmonad . ewmh $ docks def { 
  xmonad $ docks def { 
      terminal    = terminal'
    , modMask     = modMask'
    , borderWidth = borderWidth'
    , workspaces  = workspaceIDs
    , startupHook = startupHook'
    -- Behaviour
    , focusFollowsMouse = False
    -- Appearance
    , focusedBorderColor  = blue
    , normalBorderColor   = black
    , layoutHook  = layoutHook'
    , logHook     = dynamicLogWithPP (logHook' dbus) 
    } `additionalKeysP` ezKeys

{- 
# General
additionalKeysP :: XConfig l [(String, X ())] -> XConfig l

# Actions
sendMessage :: Message a => a -> IO ()
spawn :: MonadIO m => String -> m ()
spawnPipe :: MonadIO m => String -> m Handle

# Layout
avoidStruts :: LayoutClass l a => l a -> ModifiedLayout AvoidStruts l a

-}
