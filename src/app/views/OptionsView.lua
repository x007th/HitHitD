--[[
Copyright (c) 2015 calloh.com
@author Tom Lee
@date 2015-03-10
--]]
--------------------------------
-- @module 菜单项界面

local OptionsView = class("OptionsView", function ( ... )
	return display.newNode()
end)

function OptionsView:ctor(model, delegate)
	local width = 500
	local height = 300
	self.model = model
	self.delegate = delegate
	-- all node
	local node = display.newNode()
		:size(width, height)
	local volumeNum = app:userModel():getVolume()
	local images = {on = "#"..app:images():list().chip.queue.volume_on, 
					off = "#"..app:images():list().chip.queue.volume_off}
    local volumeButton = cc.ui.UICheckBoxButton.new(images)
        :setButtonSelected(true)
        :onButtonStateChanged(function(event)
          --  local button = event.target
           -- button:setButtonLabelString(labels[button:isButtonSelected()])
        end)
        :onButtonClicked(function(event)
           local state = event.target:isButtonSelected()
           if state == true then
           		self:updateVolume_(50)
           		self.volumeSlider:setSliderValue(50)
           	else
           		self:updateVolume_(0)
           end
        end)
       	:pos(20, height - 110)
        :addTo(node)
    volumeButton:setAnchorPoint(0, 0)
    self.volumeButton = volumeButton
	local img = {
	    bar = "#"..app:images():list().chip.queue.black_brick,
	    button = "#"..app:images():list().chip.queue.white_stripes,
	}
	local volumeSlider = cc.ui.UISlider.new(display.LEFT_TO_RIGHT, img, {scale9 = true})
        :onSliderValueChanged(function(event)
          self:updateVolume_(event.value)
        end)
        :setSliderSize(420, 40)
      	:pos(62, height - 110)
        :addTo(node)
    volumeSlider:setAnchorPoint(0, 0)
    volumeSlider:setSliderValue(self.model:getVolume() * 100)
    self.volumeSlider = volumeSlider

	local box = app:createComponent("DialogBox", {
		node = node, 
		dtype = 1, 
		onHandler = handler(self, self.onFeedback_), 
		--onCompleteHandler = handler(app:loadingInstance(), app:loadingInstance().hide),
	}):addTo(self)

	if self.model:getVolume()  == 0 then
		self.volumeButton:setButtonSelected(false)
	end
	
end

function OptionsView:onFeedback_(dtype)
	--if dtype == 1 then
	--elseif dtype == 2 then
	--end
	self.delegate:delegate_onSaveVolume()
	app:popupInstance():close()
end

function OptionsView:updateVolume_(value)
	value = checkint(value) * 0.01
	if value == 0 then
		self.volumeButton:setButtonSelected(false)
		self.volumeSlider:setSliderValue(0)
	else
		self.volumeButton:setButtonSelected(true)
	end
	self.delegate:delegate_onChangeVolume(value)
end

return OptionsView