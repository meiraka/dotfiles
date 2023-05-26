import qualified Data.Map as M
import System.Exit
import System.IO
import XMonad
import XMonad.Actions.RotSlaves
import XMonad.Hooks.EwmhDesktops (ewmh, ewmhFullscreen)
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Layout.ToggleLayouts
import qualified XMonad.StackSet as W
import XMonad.Util.NamedScratchpad

main = do
  xmonad $
    ewmhFullscreen . ewmh $
      docks
        def
          { manageHook = myManageHook,
            layoutHook = myLayoutHook,
            workspaces = myWorkspaces,
            terminal = myTerminal,
            borderWidth = myBorderWidth,
            normalBorderColor = myNormalBorderColor,
            focusedBorderColor = myFocusedBorderColor,
            focusFollowsMouse = False,
            startupHook = myStartupHook,
            keys = myKeys,
            mouseBindings = myMouseBindings
          }

myNormalBorderColor = "#282828"

myFocusedBorderColor = "#e0e0e0"

myBorderWidth = 3

myStartupHook :: X ()
myStartupHook = do
  spawn "sh ~/.xmonad/autostart.sh"

myTerminal = "wezterm"

myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8"]

myManageHook =
  composeOne
    [ title =? "gmrun" -?> doCenterFloat,
      className =? "Xfce4-notifyd" -?> doIgnore,
      isDialog -?> customFloating $ W.RationalRect (4 / 20) (4 / 20) (12 / 20) (12 / 20)
    ]
    <+> manageDocks
    <+> namedScratchpadManageHook scratchpads
    <+> manageHook def
    <+> (isFullscreen --> doFullFloat)

myLayoutHook = lessBorders OnlyScreenFloat $ toggleLayouts full (sparse ||| avoidStruts fillNoGap)
  where
    full = noBorders Full
    sparse = spacing 48 24 emptyBSP
    fillNoGap = emptyBSP
    spacing m n = spacingRaw False (Border m m m m) True (Border n n n n) True

scratchpads =
  [ NS
      "terminal"
      "wezterm --config enable_tab_bar=true start --class terminalScratchpad"
      (className =? "terminalScratchpad")
      large,
    NS
      "sound"
      "pavucontrol --name soundScratchpad"
      (resource =? "soundScratchpad")
      middle,
    NS
      "wallpaper"
      "nitrogen ~/.local/share/backgrounds"
      (resource =? "nitrogen")
      small,
    NS
      "bluetooth"
      "blueman-manager"
      (className =? "Blueman-manager")
      middle
  ]
  where
    large = customFloating $ W.RationalRect (1 / 20) (1 / 20) (18 / 20) (18 / 20)
    middle = customFloating $ W.RationalRect (3 / 20) (3 / 20) (14 / 20) (14 / 20)
    small = customFloating $ W.RationalRect (5 / 20) (5 / 20) (10 / 20) (10 / 20)

myKeys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
myKeys conf@(XConfig {XMonad.modMask = modMask}) =
  M.fromList $
    -- launching and killing programs
    [ ((keyModMask .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf), -- %! Launch terminal
      ((keyModMask, xK_r), spawn "gmrun"), -- %! Launch gmrun
      ((keyModMask, xK_space), namedScratchpadAction scratchpads "terminal"), -- %! Toggle terminal
      ((keyModMask .|. shiftMask, xK_s), namedScratchpadAction scratchpads "sound"), -- %! Toggle sound control
      ((keyModMask .|. shiftMask, xK_b), namedScratchpadAction scratchpads "bluetooth"), -- %! Toggle bluetooth control
      ((keyModMask .|. shiftMask, xK_w), namedScratchpadAction scratchpads "wallpaper"), -- %! Toggle wallpaper
      ((keyModMask, xK_w), kill), -- %! Close the focused window
      ((keyModMask, xK_f), sendMessage ToggleLayout), -- %! Toggle fullscreen mode
      ((keyModMask, xK_t), sendMessage NextLayout), -- %! Toggle tab view in fullscreen mode
      ((keyModMask, xK_n), refresh), -- %! Resize viewed windows to the correct size
      -- move focus up or down the window stack
      ((keyModMask, xK_Tab), windows W.focusDown), -- %! Move focus to the next window
      ((keyModMask .|. shiftMask, xK_Tab), windows W.focusUp), -- %! Move focus to the previous window
      ((mouseModMask, xK_Tab), rotAllDown), -- %! Swap and move the focused window with the previous window
      ((mouseModMask .|. shiftMask, xK_Tab), rotAllUp), -- %! Swap and move the focused window with the next window
      ((keyModMask, xK_m), windows W.focusMaster), -- %! Move focus to the master window

      -- modifying the window order
      ((keyModMask, xK_Return), windows W.swapMaster), -- %! Swap the focused window and the master window

      -- resizing the master/slave ratio
      ((keyModMask, xK_h), sendMessage Shrink), -- %! Shrink the master area
      ((keyModMask, xK_l), sendMessage Expand), -- %! Expand the master area

      -- floating layer support
      ((keyModMask, xK_i), withFocused $ windows . W.sink), -- %! Push window back into tiling

      -- increase or decrease number of windows in the master area
      ((keyModMask, xK_comma), sendMessage (IncMasterN 1)), -- %! Increment the number of windows in the master area
      ((keyModMask, xK_period), sendMessage (IncMasterN (-1))), -- %! Deincrement the number of windows in the master area
      ((keyModMask, xK_n), spawn "killall xfce4-notifyd || /usr/lib/xfce4/notifyd/xfce4-notifyd & sleep 0.2 && notify-send Notification on"), -- %! toggle notification
      -- quit, or restart
      ((keyModMask .|. shiftMask, xK_q), io exitSuccess), -- %! Quit xmonad
      ((keyModMask .|. shiftMask, xK_r), spawn "if type xmonad; then xmonad --recompile && xmonad --restart; else xmessage xmonad not in \\$PATH: \"$PATH\"; fi") -- %! Restart xmonad
    ]
      ++
      -- mod-[1..9] %! Switch to workspace N
      -- mod-shift-[1..9] %! Move client to workspace N
      [ ((m .|. keyModMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9],
          (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
      ]
  where
    keyModMask = mod4Mask
    mouseModMask = mod1Mask

myMouseBindings (XConfig {XMonad.modMask = keyModMask}) =
  M.fromList
    -- mod-button1 %! Set the window to floating mode and move by dragging
    [ ((mouseModMask, button1), \w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster),
      -- mod-button2 %! Raise the window to the top of the stack
      ((mouseModMask, button2), windows . (W.shiftMaster .) . W.focusWindow),
      -- mod-button3 %! Set the window to floating mode and resize by dragging
      ((mouseModMask, button3), \w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster)
      -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]
  where
    mouseModMask = mod1Mask
