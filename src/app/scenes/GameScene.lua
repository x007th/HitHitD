--[[
Copyright (c) 2015 calloh.com
@author Tom Lee
@date 2015-03-10
--]]
--------------------------------
-- @module 游戏场景管理


local GameScene = class("GameScene", function ( ... )
	return display.newScene("GameScene")
end)

function GameScene:ctor( ... )
	app:images():loadSceneImage(self.name)
	self.model = app:getModelClass("GameModel").new()

	local cls = self.model.class
	cc.EventProxy.new(self.model, self)
        :addEventListener(cls.TIMER_OVER_EVENT, handler(self, self.timerOver_))
	
	self.gameController = app:getControllerClass("GameController").new(self.model):addTo(self)
	
end

function GameScene:timerOver_()
	app:getControllerClass("OverController").new(self.model):showPopup()
end

function GameScene:toExit()
	handler(app, app.gotoHomeScene)()
end

function GameScene:onEnter()
	self:ready()

	app:keyEvent(self)
end

function GameScene:ready()
	self.gameController:ready()
end

function GameScene:onExit()
	app:images():unloadSceneImage(self.name)
	app:audio():gameMusic(false)
end

return GameScene