--[[
Copyright (c) 2015 calloh.com
@author Tom Lee
@date 2015-03-10
--]]
--------------------------------
-- @module 游戏说明界面

local ReadMeView = class("ReadMeView", function()
    return display.newNode()
end)

function ReadMeView:ctor(model, delegate)
    dump(device)
    local text_ = "两只老虎，两只老虎\n两只老虎，两只老虎\n两只老虎，两只老虎\n两只老虎，两只老虎\n两只老虎，两只老虎\n"
    local label = display.newTTFLabel({
        text = text_,
        font = "Arial",
        size = 16,
        color = cc.c3b(50, 50, 50), 
        align = cc.TEXT_ALIGNMENT_LEFT,
        valign = cc.VERTICAL_TEXT_ALIGNMENT_TOP,
    })

    app:loadingInstance():show()
    local box = app:createComponent("DialogBox", {
        node = label, 
        dtype = 1, 
        onHandler = handler(self, self.onFeedback_), 
        onCompleteHandler = handler(app:loadingInstance(), app:loadingInstance().hide),
    }):addTo(self)
end

function ReadMeView:onFeedback_(dtype)
    app:popupInstance():close()
end

function ReadMeView:onEnter()
end

function ReadMeView:onExit()
    
end

return ReadMeView