--[[
Copyright (c) 2015 calloh.com
@author Tom Lee
@date 2015-03-10
--]]
--------------------------------
-- @module 游戏中音乐资源及管理

local AudioManager = class("AudioManager")
--AudioManager.FILE_PATH  = "res/audio/" 
local sound = {
	LOST       = "5538.mp3" ,	--失败时
	WIN        = "5553.mp3" ,	--成功时
	OVER       = "5322.mp3" ,	--游戏结束时
	COUNT_DOWN = "5541.mp3",	--游戏即将结束时的倒计时提醒
	READY_123   = "2573.mp3" ,	--开始倒计时321
	READY_GO   = "5375.mp3" ,	--开始游戏时
	HIT_ERROR  = "5520.mp3" ,	--点击对象错误时
	HIT_RIGHT  = "5371.mp3" ,	--点击对象正确时
	HIT_GRID   = "5364.mp3" ,	--点击格子
	HIT_BUTTON = "TapButtonSound.mp3" , --点击按钮对象时
}

local music = {
	GAME_MUSIC = "5373.mp3" ,	--进入游戏开始时循环背景音乐
	HOME_MUSIC = "2498.mp3" ,	--进入首页时循环背景音乐
}

function AudioManager:ctor( ... )
	self.volume = 0
end

function AudioManager:updateVolume(volume)
	self.volume = volume
	audio.setSoundsVolume(volume)
	audio.setMusicVolume(volume)
end

function AudioManager:stop()
	audio.stopMusic()
	audio.stopAllSounds()
end

function AudioManager:loadSound()
	 for k, v in pairs(sound) do
         audio.preloadSound(v)
     end
end

function AudioManager:homeMusic(isplay)
	if isplay then
		local filename = app:getResPath(music.HOME_MUSIC)
		audio.playMusic(filename)
	else
		audio.stopMusic()
	end
end

function AudioManager:gameMusic(isplay)
	if isplay then
		local filename = app:getResPath(music.GAME_MUSIC)
		audio.playMusic(filename)
	else
		audio.stopMusic()
	end
end

function AudioManager:hitButton()
	local filename = app:getResPath(sound.HIT_BUTTON)
	audio.playSound(filename)
end

function AudioManager:hitGrid()
	local filename = app:getResPath(sound.HIT_GRID)
	audio.playSound(filename)
end

function AudioManager:hitRight()
	local filename = app:getResPath(sound.HIT_RIGHT )
	audio.playSound(filename)
end
function AudioManager:hitError()
	local filename = app:getResPath(sound.HIT_ERROR )
	audio.playSound(filename)
	
end
function AudioManager:readyGo()
	local filename = app:getResPath(sound.READY_GO )
	audio.playSound(filename)
	
end
function AudioManager:ready123()
	local filename = app:getResPath(sound.READY_123 )
	audio.playSound(filename)
	
end

function AudioManager:countdown()
	local filename = app:getResPath(sound.COUNT_DOWN )
	audio.playSound(filename)
end

function AudioManager:over()
	local filename = app:getResPath(sound.OVER )
	audio.playSound(filename)
end

function AudioManager:win()
	local filename = app:getResPath(sound.WIN )
	audio.playSound(filename)
end
function AudioManager:lost()
	local filename = app:getResPath(sound.LOST )
	audio.playSound(filename)
	
end

return AudioManager