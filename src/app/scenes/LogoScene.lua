--[[
Copyright (c) 2015 calloh.com
@author Tom Lee
@date 2015-03-10
--]]
--------------------------------
-- @module 启动时显示LOGO场景管理

local LogoScene = class("LogoScene", function()
    return display.newScene("LogoScene")
end)

function LogoScene:ctor()
	self.name = "LogoScene"
    app:images():loadSceneImage(self.name)
    display.newColorLayer(cc.c4b(250, 249, 222, 255)):addTo(self)
end

function LogoScene:toExit()
	handler(app, app.gotoHomeScene)()
end

function LogoScene:onEnter()
	display.newScale9Sprite("#"..app:images():list().logo.queue.calloh, 0, 0)
		:pos(display.cx, display.cy)
		:opacity(0)
		:addTo(self)
		:fadeIn(1)
	self:performWithDelay(handler(self, self.toExit), 3)
    app:audio():loadSound()
end

function LogoScene:onExit()

end

return LogoScene
