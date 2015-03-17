--[[
Copyright (c) 2015 calloh.com
@author Tom Lee
@date 2015-03-10
--]]
--------------------------------
-- @module 关卡选择界面

local BarrierView = class("BarrierView", function ()
	return display.newNode()
end)

function BarrierView:ctor(model, delegate)
	self.model = model
	self.delegate = delegate
	local width, height = 600, 400
	
	local bg = display.newScale9Sprite("#"..app:images():list().chip.queue.white_sawtooth, 0, 0, cc.size(width, height))
		:pos(0, 0)
		:addTo(self)
	local barrierImg = {
		normal = "#"..app:images():list().chip.queue.hollow_painting_circle,
		pressed = "#"..app:images():list().chip.queue.hollow_painting_circle,
		disabled = "#"..app:images():list().chip.queue.hollow_painting_circle,
	}
	local len = app:levelModel():getLen() - 1
	local n = app:userModel():getLastLevelIndex() - 1
	local team = 5
	local nw,nh = 60, 60
	local gap = 50
	local x, y = 0, 0
	local tx, ty = gap, height - gap
	local line = 0
	local column = 0
	for i=0,len do
		line = math.floor(i / team)
		if math.fmod(i , team) == 0 then
			column = 0
		end
		x = tx + column * (nw + gap) + nw*0.5
		y = ty - line * (nh + gap) - nw*0.5
		column = column + 1
	    local button = self:newButton_(i+1, barrierImg, handler(self, self.onHit_))
	    	:align(display.CENTER, x, y)
	    	:addTo(bg)
	    button.index_ = i+1
	    if i > n then
	    	button:opacity(100)
	    	button:setButtonEnabled(false)
	    end
	end

	local backImg = {
		normal = "#"..app:images():list().chip.queue.backtrack,
		pressed = "#"..app:images():list().chip.queue.backtrack,
		disabled = "#"..app:images():list().chip.queue.backtrack,
	}
	self:newButton_("", backImg, handler(self, self.onBack_))
	    	:align(display.CENTER, width*0.5, 0)
	    	:addTo(bg)
end

function BarrierView:onBack_( event )
	app:audio():hitButton()
	app:popupInstance():close()
end

function BarrierView:onHit_( event )
	app:audio():hitButton()
	self.delegate:delegate_onSelectBarrier(event.target.index_)
end

function BarrierView:newButton_(label, img, handler)
	return cc.ui.UIPushButton.new(img, {scale9 = true})
        :setButtonLabel(cc.ui.UILabel.new({text = label,color = cc.c3b(0, 0, 0)}))
        :onButtonPressed(function(event)
            event.target:setScale(0.9)
        end)
        :onButtonRelease(function(event)
            event.target:setScale(1.0)
        end)
        :onButtonClicked(function(event)
        	if type(handler) == "function" then
        		handler(event)
        	end
            
        end)
end

return BarrierView