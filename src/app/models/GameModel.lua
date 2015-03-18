--[[
Copyright (c) 2015 calloh.com
@author Tom Lee
@date 2015-03-10
--]]
--------------------------------
-- @module 游戏数据对象的管理

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

local GameModel = class("GameModel", cc.mvc.ModelBase)

GameModel.UPDATE_TIMER_EVENT = "UPDATE_TIMER_EVENT"
GameModel.UPDATE_INDEX_EVENT = "UPDATE_INDEX_EVENT"
GameModel.TIMER_OVER_EVENT = "TIMER_OVER_EVENT"
GameModel.UPDATE_SCORE_EVENT = "UPDATE_SCORE_EVENT"
GameModel.ELIMINATE_COMPLETED_EVENT = "ELIMINATE_COMPLETED_EVENT"
GameModel.UPDATE_DATA_EVENT = "UPDATE_DATA_EVENT"

function GameModel:ctor( properties )
    GameModel.super.ctor(self, properties)
    self:refresh()
end

function GameModel:refresh()
	self:stopScheduler()
	self.timer = 0
	self.sumTimer = 0
	self.score = 0
	self.levelIndex = 0
	self.levelIndexData = {}
	self.queue = {}
	self.displayObjectsNum = 70
	self.reviews = 0
	self.isWin_ = nil
end

function GameModel:getDisplayObjectsNum()
	return self.displayObjectsNum
end

function GameModel:setLevelIndex( index )
	self:refresh()
	if index ~= self.levelIndex then
		self.levelIndex = index
		self:updateLevel_()
	end
	self:createQueue()
	self:dispatchEvent({name = GameModel.UPDATE_DATA_EVENT})
end

function GameModel:getLevelIndex()
	return self.levelIndex
end

function GameModel:updateLevel_()
	self.levelIndexData = app:levelModel():getMap(self.levelIndex)
	self.timer = self.levelIndexData.timerNum
	self.sumTimer = self.timer
end

function GameModel:createQueue()
	local typeQueue = clone(self.levelIndexData.typeQueue)
	local arr = {}
	for i=1,table.getn(typeQueue) do
		if typeQueue[i] ~= 0 then
			table.insert(arr, i)
		end
	end
	
	while true do
		if table.getn(arr) == 0 then
			break
		end

		local index = math.random(1, table.getn(arr))
		local typeIndex = arr[index]
		if typeQueue[typeIndex] == 0 then
			table.remove(arr,index)
		else
			typeQueue[typeIndex] = typeQueue[typeIndex] - 1
			local dtype = typeIndex
			table.insert(self.queue, dtype)
		end
	end
end

function GameModel:formatTableNumber(data)
	for i=1, table.getn(data)do
		data[i] = checknumber(data[i])
	end
	return data
end

function GameModel:updateScore(n)
	self.score = math.max((self.score + n), 0)
	self:dispatchEvent({name = GameModel.UPDATE_SCORE_EVENT, data = {increment = n, sum = self.score}})
end

function GameModel:getScore()
	return self.score
end

function GameModel:getNowType()
	local x = table.remove(self.queue)
	if table.getn(self.queue) == 0 then
		self:createQueue()
	end
	return x
end

function GameModel:getTimer()
	return self.timer
end

function GameModel:play()
	self:playScheduler()
end

function GameModel:over()
	self:stopScheduler()
end

function GameModel:isWin()
	return self.isWin_
end

function GameModel:getReviews()
	return self.reviews
end

function GameModel:toTimerOver_()
	local data = app:levelModel():getMap(self.levelIndex)
	local reviews = data.reviewsQueue
	self.isWin_ = self.score >= checknumber(reviews[1])

	local highestScore = app:userModel():getScore(self.levelIndex)
	if self.isWin_ then
		if self.score > highestScore then
			app:userModel():writeLevelIndex(self.levelIndex, self.score)
		end
	end

	self.reviews = 0
	if self.score > 0 then
		for i=1,table.getn(reviews) do
			if self.score >= reviews[i] then
				self.reviews = i
				break
			end
		end
	end
	
	self:dispatchEvent({
		name = GameModel.TIMER_OVER_EVENT, 
		data = {
			isWin = self.isWin_, 
			reviews = self.reviews, 
			score = self.score, 
			highestScore = highestScore, 
			levelIndex = self.levelIndex
	}})
	
end

function GameModel:eliminate(dtype, index, location)
	local data = app:mouseModel():getMap(dtype)
	local x = data.scoreNum

	self:updateScore(x)
	self:dispatchEvent({name = GameModel.ELIMINATE_COMPLETED_EVENT, data = {dtype= dtype, index = index, location = location}})
end


function GameModel:playScheduler()
	self:stopScheduler()
	local rate = 5
	local irate = 1
	local function onInterval( dt )
		if irate == rate then
			irate = 1
			self.timer = self.timer - 1
			self:dispatchEvent({name = GameModel.UPDATE_TIMER_EVENT, data = {timer = self.timer, sumTimer = self.sumTimer}})
		end
		irate = irate + 1

		local x = math.random(-10, self.displayObjectsNum + 10)
		self:dispatchEvent({name = GameModel.UPDATE_INDEX_EVENT, data = {index = x}})

		if self.timer <= 0 then
			self:stopScheduler()
			self:toTimerOver_()
		end
	end
	self.scheduler = scheduler.scheduleGlobal(handler(self, onInterval), 1/rate)
end

function GameModel:stopScheduler()
	if self.scheduler ~= nil then
		scheduler.unscheduleGlobal(self.scheduler)
	end
end

return GameModel