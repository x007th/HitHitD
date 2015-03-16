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
