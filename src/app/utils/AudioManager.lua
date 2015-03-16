
-- 文件定义  文件管理
--[[
点击菜单音效
点击格子的音效
击中时的音效
加分音效
减分音效
ready go 音效
胜利音效
失败音效

logo界面背景音效
主界面背景音效
游戏时背景音效
]]
local AudioManager = class("AudioManager")

--AudioManager.FILE_PATH  = "res/audio/" 


local sound = {
	LOST       = "5538.mp3" ,
	WIN        = "5553.mp3" ,
	OVER       = "5322.mp3" ,
	COUNT_DOWN = "5541.mp3",	--"5541.mp3" ,
	READY_123   = "2573.mp3" ,
	READY_GO   = "5375.mp3" ,
	HIT_ERROR  = "5520.mp3" ,
	HIT_RIGHT  = "5371.mp3" ,
	HIT_GRID   = "5364.mp3" ,
	HIT_BUTTON = "TapButtonSound.mp3" ,
}

local music = {
	GAME_MUSIC = "5373.mp3" ,
	HOME_MUSIC = "2498.mp3" ,
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

function AudioManager:play()
	-- body
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
	--5322.mp3
	--5391.mp3
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