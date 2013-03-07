{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}

import XMonad
import qualified XMonad.StackSet as W
import XMonad.Actions.RandomBackground
import XMonad.Layout.Spiral
import XMonad.Layout.ThreeColumns
import XMonad.Layout.MultiToggle
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.FadeInactive
import XMonad.Util.EZConfig(additionalKeysP)
import System.IO

data MIRROR = MIRROR deriving (Read, Show, Eq, Typeable)
instance Transformer MIRROR Window where
    transform _ x k = k (Mirror x) (\(Mirror x') -> x')

main = xmonad =<< xmobar (defaultConfig
    { borderWidth        = 0
    , terminal           = "urxvt"
    , manageHook = myManageHooks
    , layoutHook = layout
    , logHook = myFadeHook
    , modMask = mod4Mask
    } `additionalKeysP`
    [ ("M-S-z", spawn "xscreensaver-command -lock")
    , ("C-<Print>", spawn "sleep 0.2; scrot -s")
    , ("<Print>", spawn "scrot")
    , ("M-x", sendMessage $ Toggle MIRROR)
    , ("M-S-<Return>", randomBg $ RGB 0x00 0x3f)
    ])

layout = mkToggle (single MIRROR) (spiral ratio ||| threeCol ||| tall ||| Full)
  where
    threeCol = ThreeColMid nmaster delta ratio
    tall   = Tall nmaster delta ratio
    -- The default number of windows in the master pane
    nmaster = 1
    -- Percent of screen to increment by when resizing panes
    delta   = 3/100
    -- Default proportion of screen occupied by master pane
    ratio   = 2/3

myFadeHook = fadeInactiveLogHook 0.7

myManageHooks = composeAll
  [ isFullscreen --> (doF W.focusDown <+> doFullFloat) ]
