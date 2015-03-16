
local Loading = class("Loading")

function Loading:ctor(properties)
	--local filename = properties.filename
	--local size = properties.size
	self.zorder = properties.zorder
	self:init_()
end

function Loading:init_()
	self.box = nil
	self.node = nil
	self.count = 0
	self.text = "loanding..."
end

function Loading:show()
	if not self.box then
		self:new_()
	end
	self.box:show()

	if self.count == 0 then
		local t = 0.1
		local n = 999999999
		local action = cc.Repeat:create(cc.RotateBy:create(t, 30), n)
		self.node:runAction(action)
	end
	self.count = self.count + 1
end

function Loading:hide()
	if self.count == 0 then
		return
	end
	self.count = self.count - 1

	if self.count == 0 then
		transition.stopTarget(self.node)
		self.box:hide()
	end
end

function Loading:clear_()
	self.count = 0
	self:hide()
	display.getRunningScene():removeChild(self.box)
	self:init_()
end



function Loading:new_()
    self.box = display.newColorLayer(cc.c4b(0xfa,0xf8,0xef, 200))
	display.getRunningScene():add(self.box, self.zorder)
	function listener(self, event)
            local name = event.name
            if name == "enter" then  
            elseif name == "exit" then
                 self:clear_()
            elseif name == "enterTransitionFinish" then    
            elseif name == "exitTransitionStart" then    
            elseif name == "cleanup" then
            end
    end
	display.getRunningScene():addNodeEventListener(cc.NODE_EVENT, handler(self, listener))
	
	self.node = display.newSprite("#"..app:images():list().chip.queue.hollow_star, display.cx, display.cy)
		:addTo(self.box)


	self.label = display.newTTFLabel({
	    text = self.text,
	    font = "Arial",
	    size = 24,
	    color = cc.c3b(100, 100, 100), -- 使用纯红色
	    align = cc.TEXT_ALIGNMENT_LEFT,
	    valign = cc.VERTICAL_TEXT_ALIGNMENT_TOP,
	})
	self.label:setAnchorPoint(0.5, 1)
	local nodeSize = self.node:getContentSize()
	local nodeX, nodeY = self.node:getPosition()
	local labelSize = self.label:getBoundingBox()

	self.label:pos(nodeX, nodeY - nodeSize.height * 0.5)
	self.label:addTo(self.box)


end

return Loading