import           System.Exit
import           System.IO
import           Text.Printf
import           XMonad
import           XMonad.Actions.CycleWindows
import           XMonad.Actions.GridSelect
import           XMonad.Actions.RotSlaves
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.EwmhDesktops   (ewmh, fullscreenEventHook)
import           XMonad.Hooks.FadeInactive
import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.ManageHelpers  (doFullFloat, isFullscreen)
import           XMonad.Hooks.UrgencyHook
import           XMonad.Layout.BinarySpacePartition
import           XMonad.Layout.OneBig
import           XMonad.Layout.Named
import           XMonad.Layout.NoBorders
import           XMonad.Layout.Spacing
import           XMonad.Layout.ToggleLayouts
import           XMonad.Util.EZConfig
import           XMonad.Util.NamedScratchpad
import           XMonad.Util.Run             (spawnPipe)

import qualified Data.List
import qualified Data.Map                    as M
import qualified XMonad.StackSet             as W

main = do
  xmproc <- spawnPipe "xmobar"
  xmonad $ ewmh $ docks def
    { handleEventHook = fullscreenEventHook
    , manageHook = myManageHook
    , logHook = myLogHook xmproc
    , layoutHook = myLayoutHook
    , workspaces = myWorkspaces
    , terminal = myTerminal
    , borderWidth = myBorderWidth
    , normalBorderColor = myNormalBorderColor
    , focusedBorderColor = myFocusedBorderColor
    , focusFollowsMouse = False
    , startupHook = myStartupHook
    , keys = myKeys
    , mouseBindings = myMouseBindings
    }

myLogHook statusbar = dynamicLogWithPP $ xmobarPP
  { ppOutput = hPutStrLn statusbar
  , ppCurrent = xmobarColor "#ffffff" "" .wrap " " ""
  , ppHidden = xmobarColor "#aaaaaa" "" .wrap " " "" .noScratchPad
  , ppHiddenNoWindows = xmobarColor "#aaaaaa" "" .wrap " " "" .noScratchPad
  , ppTitle = xmobarColor "#ffffff" "" . shorten 80
  , ppSep = "  "
  , ppLayout = xmobarColor "#ffffff" ""
  }
  where
    noScratchPad ws = if ws == "NSP" then "" else ws

myNormalBorderColor = "#eeeeee"
myFocusedBorderColor = "#a01d2f"

myStartupHook :: X ()
myStartupHook = do
    spawn "sh ~/.xmonad/autostart.sh"

myBorderWidth = 0
myTerminal = "sakura"
myWorkspaces = ["♥", "♡", "♦", "♢", "♠", "♤", "♣", "♧"]
myManageHook =
  composeAll
    [ className =? "Xfce4-notifyd" --> doIgnore
    , className =? "Gimp" --> doFloat
    , className =? "Gimp-2.6" --> doFloat
    , title =? "Cities: Skylines" --> doFloat
    ] <+>
  manageDocks <+>
  namedScratchpadManageHook scratchpads <+>
  manageHook defaultConfig <+>
  (isFullscreen --> doFullFloat)

myLayoutHook = toggleLayouts full (avoidStruts $ (fill ||| youtube))
  where
    fill = named "fill" (spacing 12 $ emptyBSP)
    youtube = named "youtube" (spacing 12 $ Tall 1 (3/100) (5/6))
    full = named "FullScreen" (noBorders Full)

scratchpads =
  [ NS "terminal"
      "LD_LIBRARY_PATH=~/lib:$LD_LIBRARY_PATH sakura --name terminalScratchpad"
      (resource =? "terminalScratchpad") large
  , NS "sound"
      "pavucontrol --name soundScratchpad"
      (resource =? "soundScratchpad") middle
  ]
  where
    large = customFloating $ W.RationalRect (1/20) (1/20) (18/20) (18/20)
    middle = customFloating $ W.RationalRect (3/20) (3/20) (14/20) (14/20)
    little = customFloating $ W.RationalRect (5/20) (5/20) (10/20) (10/20)

myKeys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
  -- launching and killing programs
  [ ((keyModMask .|. shiftMask,   xK_Return), spawn $ XMonad.terminal conf) -- %! Launch terminal
  , ((keyModMask,                 xK_r     ), spawn "gmrun") -- %! Launch gmrun
  , ((keyModMask,                 xK_space ), namedScratchpadAction scratchpads "terminal") -- %! Toggle terminal
  , ((keyModMask .|. shiftMask,   xK_s     ), namedScratchpadAction scratchpads "sound") -- %! Toggle sound control
  , ((keyModMask,                 xK_w     ), kill) -- %! Close the focused window
  , ((keyModMask,                 xK_f     ), sendMessage ToggleLayout) -- %! Toggle fullscreen mode
  , ((keyModMask,                 xK_t     ), sendMessage NextLayout) -- %! Toggle tab view in fullscreen mode
  , ((keyModMask,                 xK_n     ), refresh) -- %! Resize viewed windows to the correct size
  , ((keyModMask,                 xK_g     ), goToSelected defaultGSConfig)

  -- move focus up or down the window stack
  , ((keyModMask,                 xK_Tab   ), windows W.focusDown) -- %! Move focus to the next window
  , ((keyModMask .|. shiftMask,   xK_Tab   ), windows W.focusUp  ) -- %! Move focus to the previous window
  , ((mouseModMask,               xK_Tab   ), rotAllDown) -- %! Swap and move the focused window with the previous window
  , ((mouseModMask .|. shiftMask, xK_Tab   ), rotAllUp) -- %! Swap and move the focused window with the next window
  , ((keyModMask,                 xK_m     ), windows W.focusMaster  ) -- %! Move focus to the master window

  -- modifying the window order
  , ((keyModMask,                 xK_Return), windows W.swapMaster) -- %! Swap the focused window and the master window

  -- resizing the master/slave ratio
  , ((keyModMask,                 xK_h     ), sendMessage Shrink) -- %! Shrink the master area
  , ((keyModMask,                 xK_l     ), sendMessage Expand) -- %! Expand the master area

  -- floating layer support
  , ((keyModMask,                 xK_i     ), withFocused $ windows . W.sink) -- %! Push window back into tiling

  -- increase or decrease number of windows in the master area
  , ((keyModMask,                 xK_comma ), sendMessage (IncMasterN 1)) -- %! Increment the number of windows in the master area
  , ((keyModMask,                 xK_period), sendMessage (IncMasterN (-1))) -- %! Deincrement the number of windows in the master area

  -- quit, or restart
  , ((keyModMask .|. shiftMask,   xK_q     ), io (exitWith ExitSuccess)) -- %! Quit xmonad
  , ((keyModMask .|. shiftMask,   xK_r     ), spawn "if type xmonad; then xmonad --recompile && xmonad --restart; else xmessage xmonad not in \\$PATH: \"$PATH\"; fi") -- %! Restart xmonad

  ]
  ++
  -- mod-[1..9] %! Switch to workspace N
  -- mod-shift-[1..9] %! Move client to workspace N
  [((m .|. keyModMask, k), windows $ f i)
      | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
      , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

  where
    keyModMask = mod4Mask
    mouseModMask = mod1Mask

myMouseBindings (XConfig {XMonad.modMask = keyModMask}) = M.fromList
  -- mod-button1 %! Set the window to floating mode and move by dragging
  [ ((mouseModMask, button1), \w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster)
  -- mod-button2 %! Raise the window to the top of the stack
  , ((mouseModMask, button2), windows . (W.shiftMaster .) . W.focusWindow)
  -- mod-button3 %! Set the window to floating mode and resize by dragging
  , ((mouseModMask, button3), \w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster)
  -- you may also bind events to the mouse scroll wheel (button4 and button5)
  ]
  where
    mouseModMask = mod1Mask
