--[[
Copyright (c) 2015 calloh.com
@author Tom Lee
@date 2015-03-10
--]]
--------------------------------
-- @module 首页场景管理

local HomeScene = class("HomeScene", function()
    return display.newScene("HomeScene")
end)

function HomeScene:ctor()
	self.name = "HomeScene"
	app:images():loadSceneImage(self.name)
   	display.newColorLayer(cc.c4b(250, 249, 222, 255)):addTo(self)
   	self.logo = nil
   	self.menuBox = nil
   	self.barrierView = nil
   	self.bg = display.newTilesSprite(app:images():list().home.queue.decorate,cc.rect(0, 0, display.width, 256))
   	self.bg:pos(0, 0)
   	self.bg:opacity(0)
   	self.bg:addTo(self)
end

function HomeScene:onEnter()
    self.logo = display.newSprite("#"..app:images():list().home.queue.name, display.cx, display.cy)
				:addTo(self)
				:moveBy(1, 0, 200)

	self:performWithDelay(handler(self, function()
		local x, y = self.logo:getPosition()
		local size = self.logo:getContentSize()
		self.versionLabel = self:newLabel_("v0.98 beta"):addTo(self):pos(x + size.width*0.5, y+size.height*0.5)
		self.menuBox = display.newSprite("#"..app:images():list().home.queue.bg, display.cx, 0)
		local height = self.menuBox:getContentSize().height
		self.menuBox:pos(display.cx, height * -1)
		self.menuBox:addTo(self)
		self.menuBox:moveTo(1, display.cx, height * 0.5 + 20)
		self:performWithDelay(handler(self, self.showMenu), 1)

		app:audio():homeMusic(true)
	end), 1)
end

function HomeScene:onEnterTransitionFinish()
	app:keyEvent(self)
end

function HomeScene:onExit()
	app:audio():homeMusic(false)
end

function HomeScene:toExit()
	handler(app, app.gotoGameScene)()
end

function HomeScene:showMenu()
	
	local gap = self.menuBox:getContentSize().height * 0.25
	local height = self.menuBox:getContentSize().height 
	local x = self.menuBox:getContentSize().width * 0.5
	local y = height * 0.5 + gap + 14

	self:newButton("STARTUP", handler(self, self.onStartup), x, y)
	self:newButton("OPTIONS", handler(self, self.onOptions), x, y - 90)
	self:newButton("README", handler(self, self.onReadme), x, y - 180)
	self:newButton("CONTACT ME", handler(self, self.onAbout), x, y - 270)

	self.bg:fadeTo(1, 30)
end

function HomeScene:delegate_onSelectBarrier( index )
	app:popupInstance():close()
	app:userModel():setSelectiveLevelIndex(index)
	self:toExit()
end

function HomeScene:onStartup(event)
	app:popupInstance():open(app:createView("BarrierView" ,nil ,self))
end

function HomeScene:onOptions(event)
	app:popupInstance():open(app:createView("OptionsView",app:userModel() ,self))
end

function HomeScene:onReadme(event)
	app:popupInstance():open(app:createView("ReadMeView",nil ,self))
end

function HomeScene:onAbout(event)
	app:popupInstance():open(app:createView("ContactMeView",nil ,self))
end

function HomeScene:newButton(label, handler, x, y)
	local img = {
		normal = "#"..app:images():list().home.queue.up,
		pressed = "#"..app:images():list().home.queue.down,
		disabled = "#"..app:images():list().home.queue.down,
	}

	return cc.ui.UIPushButton.new(img, {scale9 = true})
        :setButtonLabel(cc.ui.UILabel.new({text = label,color = cc.c3b(0, 0, 0)}))
        :onButtonPressed(function(event)
            event.target:setScale(0.9)
        end)
        :onButtonRelease(function(event)
            event.target:setScale(1.0)
        end)
        :onButtonClicked(function()
            handler()
            app:audio():hitButton()
        end)
        :addTo(self.menuBox)
        :pos(x, y)
end

function HomeScene:newLabel_( text )
	local label = display.newTTFLabel({
	    text = text,
	    font = "Arial",
	    size = 16,
	    color = cc.c3b(50, 50, 50), 
	    align = cc.TEXT_ALIGNMENT_LEFT,
	    valign = cc.VERTICAL_TEXT_ALIGNMENT_TOP,
	})
	label:setAnchorPoint(1, 0)
	return label
end

function HomeScene:delegate_onChangeVolume(value)
	app:audio():updateVolume(value)
	app:userModel():setVolume(value)
end

function HomeScene:delegate_onSaveVolume(value)
	app:userModel():writeVolume()
end

return HomeScene