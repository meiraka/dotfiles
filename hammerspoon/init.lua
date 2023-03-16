spaces = require('hs.spaces')
hs.hotkey.bind({"cmd"}, "space", function()
    local term = hs.application.get("WezTerm")
    if term == nil then
        hs.application.launchOrFocus("/Applications/WezTerm.app")
        local term = hs.application.get("WezTerm")
        term:mainWindow():setFullScreen(true)
    elseif term:isFrontmost() then
        term:hide()
    else
        -- move window to current space
        local sp = spaces.activeSpaceOnScreen()
        local win = term:mainWindow()
        spaces.moveWindowToSpace(win:id(), sp)
        term:mainWindow():setFullScreen(true)
        hs.application.launchOrFocus("/Applications/WezTerm.app")
    end
end)
