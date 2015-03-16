--[[
local Popup = class("Popup")

function Popup:ctor(properties)
    self.queue = {}
    self.zorder = 999
end

local PopupManager = function ( popup_ )
	
	function show( view , closeHandler)
		local queue = popup_.queue
		table.insert(queue, {
			view = view, 
			handler = closeHandler,
		})
		display.getRunningScene():add(view, popup_.zorder)
		popup_.zorder = popup_.zorder + 1
	end 

	function close( )
		local queue = popup_.queue
		local obj = queue[#queue]
		display.getRunningScene():removeChild(obj.view)
		obj.handler()
		queue[#queue] = nil
		table.remove(queue,#queue)
		popup_.zorder = popup_.zorder - 1
	end 

	function closeAll( )	
		local queue = popup_.queue
		while true do
			if #queue == 0 then
					return
			end
			close()
		end
	end 

	return {
		show = show,
		close = close,
		closeAll = closeAll,
	}
end

return PopupManager(Popup.new())
]]

local PopupManager = class("PopupManager")


function PopupManager:ctor(properties)
    self.queue = {}
    self.box = nil
    self.zorder = properties.zorder
end

function PopupManager:getZorder()
	return self.zorder 
end

function PopupManager:open( popupView, closeHandler)

	if not self.box then
	    self.box = display.newColorLayer(cc.c4b(0xfa,0xf8,0xef, 200))
    	display.getRunningScene():add(self.box, self.zorder)
    	function scenelistener(self, event)
                local name = event.name
                if name == "enter" then  
                elseif name == "exit" then
                     self:closeAll()
                elseif name == "enterTransitionFinish" then    
                elseif name == "exitTransitionStart" then    
                elseif name == "cleanup" then
                end
        end
    	display.getRunningScene():addNodeEventListener(cc.NODE_EVENT, handler(self, scenelistener))
    	--添加，node:removeFromParent 之后自动触发 close
	end

	table.insert(self.queue, {
		popupView = popupView, 
		closeHandler = closeHandler,
	})
	self.box:add(popupView)
	popupView:align(display.CENTER, display.cx, display.cy)
end 

function PopupManager:close( )
	if table.getn(self.queue) == 0 then
		return
	end
	local queue = self.queue
	local obj = queue[#queue]
	local popupView = obj.popupView
	if not popupView then
		return
	end
	
	self.box:removeChild(popupView)
	if obj.closeHandler then
		obj.closeHandler()
	end
	queue[#queue] = nil
	table.remove(queue)
	
	return self:checkIsLast()
end 

function PopupManager:closeAll( )	
	for i=1,table.getn(self.queue) do
		self:close()
	end
end 

function PopupManager:checkIsLast()
	if table.getn(self.queue) == 0 then
		self.queue = {}
		display.getRunningScene():removeChild(self.box)
		self.box = nil
		return true
	end
	return false
end
--[[
local instance = nil
PopupManager.getInstance = function( ... )
	if not instance then
		instance = PopupManager.new()
	end
	return instance
end
]]
return PopupManager



