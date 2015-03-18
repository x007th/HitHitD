--[[
Copyright (c) 2015 calloh.com
@author Tom Lee
@date 2015-03-10
--]]
--------------------------------
-- @module 游戏中图片资源及管理

local ImagesManager = class("classname")
local path = "res/images/"
--基本图片细节
local list = {
	mouse = {
		image = "mouse_0.png",
		plist = "mouse_0.plist",
		queue = nil
	},
	logo = {
		image = "calloh_0.png",
		plist = "calloh_0.plist",
		queue = {
			calloh = "calloh_03.png",
		},
	},
	popup = {
		image = "popup_0.png",
		plist = "popup_0.plist",
		queue = {
			bg = "popup_01.png",
			up = "popup_02.png",
			down = "popup_04.png",
		},
	},
	chip = {
		image = "chip_0.png",
		plist = "chip_0.plist",
		queue = {
			black_brick 	= "chip_01.png",
			white_stripes 	= "chip_02.png",
			volume_on 		= "chip_03.png",
			volume_off 		= "chip_04.png",
			hollow_sawtooth = "chip_05.png",
			hollow_painting_circle = "chip_06.png",
			white_sawtooth 	= "chip_07.png",
			backtrack 		= "chip_08.png",
			star 			= "chip_09.png",
			hollow_star 	= "chip_10.png",
			switch_on 		= "chip_11.png",
			switch_off 		= "chip_12.png",
		},
	},
	share = {
		image = "share_0.png",
		plist = "share_0.plist",
		queue = {
			fb 	= "share_02.png",
			tw 	= "share_04.png",
			g 	= "share_06.png",
		},
	},
	home = {
		image = "home_0.png",
		plist = "home_0.plist",
		queue = {
			name 	= "home_01.png",
			up 		= "home_03.png",
			down 	= "home_05.png",
			bg 		= "home_07.png",
			decorate = "home_10.png",
		},
	},
	number = {
		image = "number_0.png",
		plist = "number_0.plist",
		queue = {
			one 	= "number_01.png",
			two 	= "number_02.png",
			three 	= "number_03.png",
		},
	},
}
--配置各个场景的需要加载资源
local scene = {
	logo = {list.logo, list.popup, list.chip ,list.share, list.home, list.number},
	home = {},
	game = {list.mouse},
}

function ImagesManager:ctor( ... )
	self.list_ = list
	self.scene_ = scene
end

function ImagesManager:list()
	--return clone(self.list_)
	return self.list_
end

function ImagesManager:loadSceneImage(sceneName)
	local loadData = nil
	if sceneName == "LogoScene" then
		loadData = self.scene_.logo
	elseif sceneName == "HomeScene" then
		loadData = self.scene_.home
	elseif sceneName == "GameScene" then
		loadData = self.scene_.game
	end
	if loadData then
		for i,v in ipairs(loadData) do
			display.addSpriteFrames(v.plist, v.image)
		end
	end
	
end

function ImagesManager:unloadSceneImage(sceneName)
	local unloadData = nil
	if sceneName == "LogoScene" then
	elseif sceneName == "HomeScene" then
	elseif sceneName == "GameScene" then
		unloadData = self.scene_.game
	end

	if unloadData then
		for i,v in ipairs(unloadData) do
			display.removeSpriteFramesWithFile(v.plist, v.image)
		end
	end
	
end

return ImagesManager