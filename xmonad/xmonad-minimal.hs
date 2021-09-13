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
logHook' pipe = dynamicLogWithPP $ xmobarPP
                { ppOutput  = hPutStrLn pipe
                , ppTitle   = xmobarColor "green" "" . shorten 50
                , ppCurrent = xmobarColor "blue" "" . wrap "[" "]"
                , ppVisible = xmobarColor "#98be65" "" . shorten 50
                , ppSep =  "<fc=#666666> <fn=1>|</fn> </fc>"
                , ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!"
                }
-- MAIN
main :: IO ()
main = do
  -- spawnPipe :: MonadIO m => String -> m Handle
  xmproc <- spawnPipe "/usr/bin/xmobar ~/.xmonad/xmobarrc"

  xmonad $ docks def { 
    logHook     = dynamicLogWithPP $ xmobarPP  
                { ppOutput  = hPutStrLn xmproc
                , ppTitle   = xmobarColor "green" "" . shorten 50
                , ppCurrent = xmobarColor "blue" "" . wrap "[" "]"
                , ppVisible = xmobarColor "#98be65" "" . shorten 50
                , ppSep =  "<fc=#666666> <fn=1>|</fn> </fc>"
                , ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!"
                }
    } 
