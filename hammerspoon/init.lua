local application = require('hs.application')
local geometry = require('hs.geometry')
local hotkey = require('hs.hotkey')
local spaces = require('hs.spaces')
local window = require('hs.window')

local function toggle(appName)
    return function()
        local app = application.get(appName)
        if app == nil then
            app = application.open(appName)
        end
        if app:isFrontmost() then
            app:hide()
        else
            local desktopSize = window.desktop():size()
            local win = app:mainWindow()
            win:setSize(geometry.size(desktopSize.w * 18 / 20, desktopSize.h * 18 / 20))
            win:centerOnScreen()
            win:setSize(geometry.size(desktopSize.w * 18 / 20, desktopSize.h * 18 / 20))
            win:centerOnScreen()
            win:setSize(geometry.size(desktopSize.w * 18 / 20, desktopSize.h * 18 / 20))
            win:centerOnScreen()

            local sp = spaces.activeSpaceOnScreen()
            spaces.moveWindowToSpace(win:id(), sp)
            win:focus()
        end
    end
end


hotkey.bind({ "cmd" }, "space", toggle('WezTerm'))
