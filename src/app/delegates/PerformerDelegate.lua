--[[
Copyright (c) 2015 calloh.com
@author Tom Lee
@date 2015-03-10
@other 考虑代码紧凑性，不创建委派类做继承了，改为委派方法用delegate开头
--]]
--------------------------------
-- @module 委派对象

local PerformerDelegate = class("PerformerDelegate", function()
	return display.newNode()
end)

function PerformerDelegate:ctor()
	-- body
end

function PerformerDelegate:onNodeHit()
	-- body
end

return PerformerDelegate