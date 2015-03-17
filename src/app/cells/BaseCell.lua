--[[
Copyright (c) 2015 calloh.com
@author Tom Lee
@date 2015-03-10
@other 
--]]
--------------------------------
-- @module 地鼠的显示对象

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

local BaseCell = class("BaseCell", function ( ... )
	return display.newSprite()
end)

function BaseCell:ctor( dtype, onCompleted )
	self.dtype = dtype
	self.onCompleted = onCompleted

	self.name = "BaseCell"
	self.img = nil
	self.imgPrefix = "mouse00"
	self.imgFormat = "%d"
	self.imgType = ".png"
	self.animationTime = 0.2

	self.imgLength = 2
	self.imgIndex = 1

	self.timer = 1

	self:opacity(0)
end

function BaseCell:playAnimation()
	local data = app:mouseModel():getMap(self.dtype)
	self.imgLength = data.imgLenNum
	self.imgIndex = data.imgBeginNum
	self.timer = data.timerNum
	--mouse101.png  mouse0011.png
	local frames = display.newFrames(self.imgPrefix..tostring(self.dtype)..self.imgFormat..self.imgType, self.imgIndex, 1)--self.imgLength)
	local animation = display.newAnimation(frames, self.animationTime) 
	self.action = self:playAnimationForever(animation)
	
	local n = math.random(1, self.timer)
	self:fadeTo(0.2, 255)
	local function onListener()
		if type(self.onCompleted) == "function" then
			self.onCompleted()
		end
	end
	scheduler.performWithDelayGlobal(onListener, n)
end

function BaseCell:playHitAnimation()
	transition.stopTarget(self)
	local spawn = cc.Spawn:create({  
	    cc.FadeTo:create(checknumber(0.2), 0),  
	    cc.ScaleTo:create(checknumber(0.2), 1.4, 1.4)
	    })  
	local sequence = transition.sequence({
		spawn,
		cc.RemoveSelf:create() 
		})
	self:runAction(sequence)
end


function BaseCell:stopAnimation()
	transition.stopTarget(self)
	local sequence = transition.sequence({
		cc.FadeTo:create(checknumber(0.2), 0),
		cc.RemoveSelf:create() 
		})
	self:runAction(sequence)
end

return BaseCell