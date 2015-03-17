--[[
Copyright (c) 2015 calloh.com
@author Tom Lee
@date 2015-03-10
--]]
--------------------------------
-- @module 主场景管理
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
	self.name = "MainScene"
end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
