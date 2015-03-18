--[[
Copyright (c) 2015 calloh.com
@author Tom Lee
@date 2015-03-10
@other 
--]]
--------------------------------
-- @module 自定义对话框组件

local DialogBox = class("DialogBox", function()
	return display.newNode()
end)
-- {node = label, dtype = 2, onHandler = handler(self, self.onFeedback_)}
function DialogBox:ctor(properties)
	local node = properties.node 
	local dtype = properties.dtype
	local onHandler = properties.onHandler
	local onCompleteHandler = properties.onCompleteHandler
	self:setNodeEventEnabled(true)
	self.name = "DialogBox"
	self.filename = filename
	self.dtype = dtype
	self.onHandler = onHandler
	self.onCompleteHandler = onCompleteHandler
	self.bg = display.newSprite("#"..app:images():list().popup.queue.bg, 0, 0)
	local bgRec = self:getBoundingBox()
	local texttag = "YES"
	if dtype == 1 then
		texttag = "CLOSE"
	end
	self.yesButton = self:newButton_(texttag, handler(self, self.onYes_))
	local bgSize = self.bg:getContentSize()
	local buttonSize = self.yesButton:getContentSize()
	if dtype == 2 then
		self.noButton = self:newButton_("NO", handler(self, self.onNo_))
		self.noButton:pos(bgRec.x - 200, bgRec.y - bgSize.height * 0.5 + 14)
			:addTo(self)
		self.yesButton:pos(bgRec.x + 200, bgRec.y - bgSize.height * 0.5 + 14)
			:addTo(self)
	else
		self.yesButton:pos(bgRec.x, bgRec.y - bgSize.height * 0.5 + 20)
			:addTo(self) 
	end
	self.bg:addTo(self)
	self.node = node
	node:setAnchorPoint(0, 0)
	self.emptyNode = cc.Node:create()
    self.emptyNode:addChild(node)
    local bound = {
    	x = 0,
    	y = 0,
    	width = 500,
    	height = 300
	}
	if type(node.setDimensions) == "function" then
		node:setDimensions(bound.width, bound.height)
	elseif type(node.setContentSize) == "function" then
	end
	self.scrollView = cc.ui.UIScrollView.new({
			viewRect = bound, 
			bgColor = cc.c4b(0xff,0xff,0xff, 100),
			direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
			--scrollbarImgV = "main_11.png",
		})
		:hide()
	    :addScrollNode(self.emptyNode)
	    --:onScroll(handler(self, self.scrollListener))
	    :pos(bgRec.x - bound.width * 0.5, bgRec.y - bound.height * 0.5)
	    :addTo(self)
	    
	self:performWithDelay(handler(self, self.showScrollView_),0)
end

function DialogBox:showScrollView_()
	self.scrollView:resetPosition()
	self.scrollView:scrollAuto()
	self.scrollView:enableScrollBar()
	self.scrollView:show()
	if type(self.onCompleteHandler) == "function" then
		self.onCompleteHandler()
		self.onCompleteHandler = nil
	end
end

function DialogBox:onYes_()
	self.onHandler(1)
end

function DialogBox:onNo_()
	self.onHandler(2)
end

function DialogBox:newButton_(label, handler)
	local img = {
		normal = "#"..app:images():list().popup.queue.up,
		pressed = "#"..app:images():list().popup.queue.down,
		disabled = "#"..app:images():list().popup.queue.down,
	}
	return cc.ui.UIPushButton.new(img, {scale9 = true})
        :setButtonLabel(cc.ui.UILabel.new({text = label,color = cc.c3b(0, 0, 0)}))
        :onButtonPressed(function(event)
            event.target:setScale(0.98)
        end)
        :onButtonRelease(function(event)
            event.target:setScale(1.0)
        end)
        :onButtonClicked(function()
            handler()
            app:audio():hitButton()
        end)
end
return DialogBox