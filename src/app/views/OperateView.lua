--[[
Copyright (c) 2015 calloh.com
@author Tom Lee
@date 2015-03-10
--]]
--------------------------------
-- @module 游戏操作界面


local OperateView = class("OperateView", function ( ... )
	return display.newNode()
end)

function OperateView:ctor(model, delegate)

end

return OperateView