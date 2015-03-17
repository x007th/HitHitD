--[[
Copyright (c) 2015 calloh.com
@author Tom Lee
@date 2015-03-10
--]]
--------------------------------
-- @module 游戏关卡的数据对象的管理

-- 时间 每个种类的显示个数 过关评价分值
function new_map_item(timerNum, typeQueue, reviewsQueue)
    return {
        timerNum = timerNum,
        typeQueue = typeQueue,
        reviewsQueue = reviewsQueue,
    }
end

local LevelModel = class("LevelModel", cc.mvc.ModelBase)

LevelModel.DATA_FILE_PATH ="res/data/" 
LevelModel.DATA_FILE_NAME ="LEVEL_MAP" 

function LevelModel:ctor( properties )
    LevelModel.super.ctor(self, properties)
    self:refresh()
end

function LevelModel:refresh()
	local typeLen = app:mouseModel():getLen()
	local reviewsLen = 3
    local dataString = app:lfs().read(
        LevelModel.DATA_FILE_NAME, 
        LevelModel.DATA_FILE_PATH, 
        app:writablePath(), 
        app:getResPath(LevelModel.DATA_FILE_NAME)
    )
    local data = self:decode(dataString)
    self.map = {}
    for _x=1,table.getn(data) do
    	local item = new_map_item(
    		checknumber(table.remove(data[_x],1)),
    		self:getTabel_(data[_x], typeLen),
    		self:getTabel_(data[_x], reviewsLen)
    	)
    	table.insert(self.map, item)
    end
end

function LevelModel:getTabel_(queue, len)
	local data = {}
	for i=1,len do
		table.insert(data, checknumber(table.remove(queue,1)))
	end
	return data
end

--序列化
function LevelModel:decode(dataString)
    local data = string.split(dataString, "\n")
    for i=1,table.getn(data) do
        data[i] = string.split(data[i], " ")
        table.map(data[i], function(v, k)
		    return checknumber(v)
		end)
    end
    return data
end

--反序列化
function LevelModel:encode()
	local dataString = ""
	
	return dataString
end

function LevelModel:getMap(index)
	if not index then
		return clone(self.map)
	end
    return clone(self.map[index])
end

function LevelModel:getLen()
	return table.getn(self.map)
end
return LevelModel