--[[
Copyright (c) 2015 calloh.com
@author Tom Lee
@date 2015-03-10
--]]
--------------------------------
-- @module 游戏展示区舞台界面

local PerformerView = class("PerformerView", function ( ... )
	return display.newNode()
end)

function PerformerView:ctor(model, delegate, properties)
	local cls = model.class
	cc.EventProxy.new(model, self)
        :addEventListener(cls.UPDATE_DATA_EVENT, handler(self, self.updateData_))

	self.layoutWidth = properties.width
	self.layoutHeight = properties.height
	self.layoutX = properties.x
	self.layoutY = properties.y

	self.model = model
	self.delegate = delegate
	self.queue = {}
end

function PerformerView:layout_()
	local len = table.getn(self.queue)
	if len > 0 then
		for i=1,len do
			self.queue[i]:refresh()
		end
		return
	end
	local width, height = self.layoutWidth, self.layoutHeight
	self.bg = display.newScale9Sprite("#"..app:images():list().chip.queue.white_sawtooth, 0, 0, cc.size(width, height))
		:align(display.CENTER, self.layoutX, self.layoutY)
		:addTo(self)

	local tx, ty = self.bg:getPosition()

	local n = self.model:getDisplayObjectsNum() - 1
	local team = 10
	local nw,nh = 60, 60
	local gap = 18
	local x, y = 0, 0
	local tx, ty = gap, height - gap
	local line = 0
	local column = 0
	for i=0,n do
		line = math.floor(i / team)
		if math.fmod(i , team) == 0 then
			column = 0
		end
		x = tx + column * (nw + gap) + nw
		y = ty - line * (nh + gap) 
		column = column + 1
	    local mouse = app:createCell("Mouse", self.model, self.delegate)
	    	:align(display.CENTER, x, y)
	    	:addTo(self.bg)
	    mouse:setIndex(i+1)
	    mouse:setLocation(column, line)
	    table.insert(self.queue, mouse)
	end
end

function PerformerView:updateData_(event)
	self:layout_()
end

return PerformerView