--[[
Copyright (c) 2015 calloh.com
@author Tom Lee
@date 2015-03-10
--]]
--------------------------------
-- @module 联系我开发者介绍界面

local ContactMeView = class("ContactMeView", function ( ... )
    return display.newNode()
end)

function ContactMeView:ctor(model, delegate)
    local width = 500
    local height = 300

    -- all node
    local node = display.newNode()
        :size(width, height)

    local logo = display.newSprite("#"..app:images():list().logo.queue.calloh)
        :scale((width/660)*0.5)
        :addTo(node)
    logo:setTouchEnabled(true)
    logo:addNodeEventListener(cc.NODE_TOUCH_EVENT, function()
        device.openURL("http://calloh.com")    
    end)
    logo:setAnchorPoint(0, 0)

    local nametext = "  STUDIO : CALLOH\n\n  NAME : TOM LEE\n\n  SITE : CALLOH.COM"
    local namelabel = self:newLabel(nametext):addTo(node)

    
    local welcometext = "  We only like to do the simple pleasures of the game ! \n  hi, welcome to visit our site. :)"
    local welcomelabel = self:newLabel(welcometext):addTo(node)
    welcomelabel:setAnchorPoint(0, 1)

    local twitterLogo = display.newSprite("#"..app:images():list().share.queue.tw)
        :scale(0.5)
        :addTo(node)
    twitterLogo:setTouchEnabled(true)
    twitterLogo:addNodeEventListener(cc.NODE_TOUCH_EVENT, function()
        device.openURL("https://twitter.com/x007th")    
    end)
    twitterLogo:setAnchorPoint(0, 1)

    local googleLogo = display.newSprite("#"..app:images():list().share.queue.g)
        :scale(0.5)
        :addTo(node)
    googleLogo:setTouchEnabled(true)
    googleLogo:addNodeEventListener(cc.NODE_TOUCH_EVENT, function()
        --device.openURL("http://calloh.com")    
    end)
    googleLogo:setAnchorPoint(0, 1)

    local facebookLogo = display.newSprite("#"..app:images():list().share.queue.fb)
        :scale(0.5)
        :addTo(node)
    facebookLogo:setTouchEnabled(true)
    facebookLogo:addNodeEventListener(cc.NODE_TOUCH_EVENT, function()
        --device.openURL("http://calloh.com")    
    end)
    facebookLogo:setAnchorPoint(0, 1)

    -- set pos
    local logoSzie = logo:getBoundingBox()
    logo:pos(0, height - logoSzie.height - 10)
    local ltX, ltY = logo:getPosition() -- left_top
    namelabel:pos(ltX + logoSzie.width , ltY)
    welcomelabel:pos(ltX, ltY - 20)
    twitterLogo:pos(ltX + logoSzie.width + 10, height - 10)
    googleLogo:pos(ltX + logoSzie.width + 80, height - 10)
    facebookLogo:pos(ltX + logoSzie.width + 150, height - 10)

    -- startup
    app:loadingInstance():show()

    local box = app:createComponent("DialogBox", {
        node = node, 
        dtype = 1, 
        onHandler = handler(self, self.onFeedback_), 
        onCompleteHandler = handler(app:loadingInstance(), app:loadingInstance().hide),
    }):addTo(self)
end

function ContactMeView:onFeedback_(dtype)
    app:popupInstance():close()
end


function ContactMeView:newLabel( text )
    local label = display.newTTFLabel({
        text = text,
        font = "Arial",
        size = 16,
        color = cc.c3b(50, 50, 50), 
        align = cc.TEXT_ALIGNMENT_LEFT,
        valign = cc.VERTICAL_TEXT_ALIGNMENT_TOP,
    })
    label:setAnchorPoint(0, 0)
    return label
end


return ContactMeView