
local StateView = class("StateView", function ( ... )
	return display.newNode()
end)

function StateView:ctor( model, delegate, properties)
	local cls = model.class
	cc.EventProxy.new(model, self)
        :addEventListener(cls.UPDATE_TIMER_EVENT, handler(self, self.updateTimer_))
        :addEventListener(cls.UPDATE_SCORE_EVENT, handler(self, self.updateScore_))
        :addEventListener(cls.UPDATE_DATA_EVENT, handler(self, self.updateData_))

	self.layoutWidth = properties.width
	self.layoutHeight = properties.height
	self.layoutX = properties.x
	self.layoutY = properties.y

	self.model = model
	self.delegate = delegate
end


function StateView:layout_()
	if self.progressBar then
		self.timerTxt:setString(self:formatStringNumber_(self.model:getTimer()))
		self.scoreTxt:setString("x00000")
		self.scoreAddTxt:setString("")
		self.scoreAddTxt:stop()
		self.progressBar:setScaleX(1)
		return
	end
	local width, height = self.layoutWidth - 200, self.layoutHeight
	self.bg = display.newScale9Sprite("#"..app:images():list().chip.queue.white_sawtooth, 0, 0, cc.size(width, height))
		:align(display.CENTER, self.layoutX - 40, self.layoutY)
		:addTo(self)

	local tx, ty = self.bg:getPosition()
	self.progressBar = display.newScale9Sprite("#"..app:images():list().chip.queue.black_brick, 0, 0, cc.size(width - 8, height - 6))
		:align(display.CENTER_LEFT, 4, height * 0.5 -1)
		:addTo(self.bg)

	self.timerTxt = self:newText(self:formatStringNumber_(self.model:getTimer()), display.CENTER_LEFT, self.layoutX - self.layoutWidth * 0.5, self.layoutY + 4, 36)
	self.scoreTxt = self:newText("x00000", display.CENTER_RIGHT, self.layoutX + self.layoutWidth * 0.5, self.layoutY + 4)
	self.scoreAddTxt = self:newText("", display.CENTER, self.layoutX - 36, self.layoutY + 4, 60, cc.c3b(255, 0, 0))
end

function StateView:newText( textContent, align, x, y, size, color)
	-- body
	return display.newTTFLabel({
		    text = textContent,
		    font = "Arial",
		    size = size or 40,
		    color = color or cc.c3b(0, 0, 0),
		})
		:align(align, x, y)
        :addTo(self)
end

function StateView:formatStringNumber_(num, max)
	local str = string.format("%d", num)
	local max = max or "000"
	local xstr = string.len(str)
	local xmax = string.len(max)
	if xmax - xstr > 0 then
		str = string.sub(max, 1, xmax - xstr) .. str
	end
	return str
end

function StateView:updateTimer_(event)
	local data = event.data
	local timer = data.timer
	local sumTimer = data.sumTimer
	self.progressBar:setScaleX(timer / sumTimer)
	self.timerTxt:setString(self:formatStringNumber_(timer))

	if timer == 15 then
		app:audio():countdown()
	elseif timer == 1 then
		app:audio():over()
	end
end

function StateView:updateScore_(event)
	local data = event.data
	local increment = data.increment
	local sum = data.sum

	self.scoreTxt:setString("x"..self:formatStringNumber_(sum, "00000"))
	local incrementStr = ""
	if increment >= 0 then
		incrementStr = string.format("+%d", increment)
		app:audio():hitRight()
	else
		incrementStr = string.format("%d", increment)
		app:audio():hitError()
	end
	self.scoreAddTxt:setString(incrementStr)

	local sequence = transition.sequence({
    	cc.ScaleTo:create(0.2, 2),
    	cc.ScaleTo:create(0.2, 0),
	})
	self.scoreAddTxt:runAction(sequence)
end

function StateView:updateData_(event )
	self:layout_()
end

return StateView