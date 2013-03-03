import XMonad
import XMonad.Actions.RandomBackground
import XMonad.Layout.Spiral
import XMonad.Layout.ThreeColumns
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.FadeInactive
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

main = xmonad =<< xmobar (defaultConfig
    { borderWidth        = 0
    , terminal           = "urxvt"
    , manageHook = manageHook defaultConfig
    , layoutHook = layout
    , logHook = myFadeHook
    , modMask = mod4Mask
    } `additionalKeys`
    [ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock")
    , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
    , ((0, xK_Print), spawn "scrot")
    , ((mod4Mask .|. shiftMask, xK_x), spawn "killall xcompmgr; sleep 1; xcompmgr -cCfF &")
    , ((mod4Mask .|. shiftMask, xK_Return), randomBg $ RGB 0x00 0x3f)
    ])

layout = spiral ratio ||| threeCol ||| tall ||| Full
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

