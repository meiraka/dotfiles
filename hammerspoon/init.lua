hs.hotkey.bind({"cmd"}, "space", function()
    local term = hs.application.get("WezTerm")
    if term == nil then
        hs.application.launchOrFocus("/Applications/WezTerm.app")
        local term = hs.application.get("WezTerm")
        term:mainWindow():maximize()
    elseif term:isFrontmost() then
        term:hide()
    else
        hs.application.launchOrFocus("/Applications/WezTerm.app")
        term:mainWindow():maximize()
    end
end)
