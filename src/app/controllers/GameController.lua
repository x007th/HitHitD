--[[
Copyright (c) 2015 calloh.com
@author Tom Lee
@date 2015-03-10
@other 
--]]
--------------------------------

-- @module 游戏准备界面

local ReadyView = class("ReadyView", function ( ... )
	return display.newSprite()
end)

function ReadyView:ctor(onCompleteHandler)
	--number_01.png
	self.imgPrefix = "number_"
	self.imgFormat = "%02d"
	self.imgType = ".png"
	self.imgLength = 3
	self.imgIndex = 1
	self.animationTime = 0.2
	local frames = display.newFrames(self.imgPrefix..self.imgFormat..self.imgType, self.imgIndex, self.imgLength, true)
	self.animation = display.newAnimation(frames, 1) 
	self.removeWhenFinished = true
	self.delay = 0.5
	self.onComplete = onCompleteHandler
end

function ReadyView:play()
	self:playAnimationOnce(self.animation, self.removeWhenFinished, self.onComplete, self.delay)
	app:audio():ready123()
	self:performWithDelay(function()
		app:audio():readyGo()
	end , 2)
end



-- @module 游戏逻辑控制器

local GameController = class("HomeMenuController", function()
	return display.newNode()
end)

function GameController:ctor(model)
	self.model = model
	local cls = model.class
	cc.EventProxy.new(model, self)
        :addEventListener(cls.TIMER_OVER_EVENT, handler(self, self.timerOver_))

	self.bg = display.newColorLayer(cc.c4b(0xfa,0xf8,0xef, 255))
		:addTo(self)

	local StateAreaRange = {width = 800, height = 30, x = display.cx, y = display.cy + 560 * 0.5}
	local performerAreaRange = {width = 800, height = 560, x = display.cx, y = display.cy - 20}
	--状态区
	self.StateArea = app:createView("StateView", model, self, StateAreaRange):addTo(self)
	--游戏区
	self.performerArea = app:createView("PerformerView", model, self, performerAreaRange):addTo(self)
	--操作区
	--local operateView = app:createView("OperateView" ,nil ,self):addTo(self)
	self:setTouchEnabled(false)
end

function GameController:ready()
	self.model:setLevelIndex(app:userModel():getSelectiveLevelIndex())

	local readyView = ReadyView.new(handler(self, self.play)):pos(display.cx, display.cy):addTo(self)
	readyView:play()
end

function GameController:play()
	self:setTouchEnabled(true)
	self.model:play()
	app:audio():gameMusic(true)
end

function GameController:timerOver_()
	app:audio():gameMusic(false)
end

function GameController:onStartup()

end

return GameController