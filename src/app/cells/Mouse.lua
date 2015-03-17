--[[
Copyright (c) 2015 calloh.com
@author Tom Lee
@date 2015-03-10
@other 
--]]
--------------------------------
-- @module 地鼠显示对象的控制器

local Cell = import("..cells.BaseCell")

local Mouse = class("Mouse", function ( ... )
	return display.newSprite()
end)

function Mouse:ctor(model, delegate)
	self:setNodeEventEnabled(true)
	self:size(60, 60)

	self.bg = cc.LayerColor:create((cc.c4b(math.random(10, 100), math.random(10, 100), math.random(10, 100), 100))):addTo(self)
	self.bg:align(display.BOTTOM_LEFT,-30,-30)
	self.bg:setTouchEnabled(false)
    self.bg:setTouchSwallowEnabled(false)
    self.bg:setContentSize(cc.size(60, 60))

	self.model = model
	self.delegate = delegate

	self.myname = "Mouse"
	self.index = 0
	self.location = cc.p(0, 0)
	self.isRunning_ = false
	self.cell = nil
	self.dtype = 0

	local cls = model.class
	cc.EventProxy.new(model, self)
        :addEventListener(cls.TIMER_OVER_EVENT, handler(self, self.timerOver_))
        :addEventListener(cls.UPDATE_INDEX_EVENT, handler(self, self.updateIndex_))
    
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.onHit_))
end

function Mouse:onEnter()
	
end

function Mouse:onExit()
	self.cell = nil
	self.dtype = 0
	self:setTouchEnabled(false)
	self:removeAllNodeEventListeners()
end

function Mouse:toString()
	return string.string.format("It's name: %s, index: %d, location.x: %d, location.y: %d", self.myname, self.index, self.location.x, self.location.y )
end

function Mouse:refresh()
	self:stop()
end

function Mouse:isRunning()
	return self.isRunning_
end

function Mouse:play()
	self:setTouchEnabled(true)
	self.isRunning_ = true
	self.dtype = self.model:getNowType()
	self.cell = Cell.new(self.dtype, handler(self, self.onAnimationCompleted_)):addTo(self)
	self.cell:playAnimation() 
end

function Mouse:stop(ishit)
	self:setTouchEnabled(false)
	self.isRunning_ = false
	self.dtype = 0
	if self.cell then
		if ishit then
			self.cell:playHitAnimation()
		else
			self.cell:stopAnimation()
		end
		self.cell = nil
	end
end

function Mouse:setIndex( index )
	self.index = index
end

function Mouse:setLocation(x, y)
	self.location = cc.p(x, y)
end

function Mouse:getLocation()
	return self.location
end

function Mouse:timerOver_()
	self:stop()
end

function Mouse:updateIndex_(event)
	if self.isRunning_ then
		return
	end
	local data = event.data
	if self.index == data.index then
		self:play()
	end
end

function Mouse:onHit_(event)
	self.model:eliminate(self.dtype, self.index, self.location)
	
	self.bg:setOpacity(255)
	self:performWithDelay(handler(self, function ( ... )
		self.bg:setOpacity(100)
	end), 0.1)
	self:stop(true)
end

function Mouse:onAnimationCompleted_()
	self:stop(false)
end

return Mouse