local application = require('hs.application')
local geometry = require('hs.geometry')
local hotkey = require('hs.hotkey')
local spaces = require('hs.spaces')
local window = require('hs.window')

local function toggle(appName)
    return function()
        local app = application.get(appName)
        if app == nil then
            app = application.open("WezTerm")
        end
        if app:isFrontmost() then
            app:hide()
        else
            local desktopSize = window.desktop():size()
            app:mainWindow():setSize(geometry.size(desktopSize.w * 18 / 20, desktopSize.h * 18 / 20))
            app:mainWindow():centerOnScreen()
            app:mainWindow():setSize(geometry.size(desktopSize.w * 18 / 20, desktopSize.h * 18 / 20))
            app:mainWindow():centerOnScreen()
            app:mainWindow():setSize(geometry.size(desktopSize.w * 18 / 20, desktopSize.h * 18 / 20))
            app:mainWindow():centerOnScreen()
            local sp = spaces.activeSpaceOnScreen()
            local win = app:mainWindow()
            spaces.moveWindowToSpace(win:id(), sp)
        end
    end
end


hotkey.bind({ "cmd" }, "space", toggle('WezTerm'))
