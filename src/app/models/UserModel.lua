local UserModel = class("UserModel", cc.mvc.ModelBase)

UserModel.DATA_FILE_PATH ="res/data/" 
UserModel.DATA_FILE_NAME ="USER_DATA" 

function UserModel:ctor( properties )
    UserModel.super.ctor(self, properties)
    self.levelLen = 10
    self.lastLevelIndex = 0
    self:refresh()
    self.selectiveLevelIndex = 0
end

function UserModel:refresh()
	local dataString = app:lfs().read(UserModel.DATA_FILE_NAME, UserModel.DATA_FILE_PATH, app:writablePath(), app:getResPath(UserModel.DATA_FILE_NAME))
    local data = self:decode(dataString)
    self.username = tostring(table.remove(data,1))
    self.volume = checknumber(table.remove(data,1))
    self.levelQueue = {}
    for i=1,self.levelLen do
    	table.insert(self.levelQueue, checknumber(table.remove(data,1)))
    end
    self:updateLastLevelIndex()
end

--序列化
function UserModel:decode(dataString)
	return string.split(dataString, " ")
end
--反序列化
function UserModel:encode()
	local dataString = ""
	dataString = dataString..tostring(self.username).." "
	dataString = dataString..tostring(self.volume).." "
	for i=1,self.levelLen do
    	dataString = dataString..tostring(self.levelQueue[i]).." "
    end
	string.rtrim(dataString)
	return dataString
end

function UserModel:writeUsername()
	self:write_()
end

function UserModel:writeVolume()
	self:write_()
end

function UserModel:writeLevelIndex(levelIndex, score)
	self.levelQueue[levelIndex] = score
	--if levelIndex > self.lastLevelIndex then
		self:updateLastLevelIndex()
	--end
	self:write_()
end

function UserModel:write_()
	app:lfs().write(
		UserModel.DATA_FILE_NAME, 
		UserModel.DATA_FILE_PATH, 
		app:writablePath(), 
		self:encode()
	)
end

function UserModel:getUsername()
	return self.username
end

function UserModel:setUsername( username )
	self.username = username
end

function UserModel:getVolume()
	return self.volume
end

function UserModel:setVolume(value)
	self.volume = value
end


function UserModel:getSelectiveLevelIndex()
	return self.selectiveLevelIndex
end

function UserModel:setSelectiveLevelIndex(levelIndex)
	if levelIndex > self.levelLen then
		return
	end
	self.selectiveLevelIndex = levelIndex
end

function UserModel:setNextLevelIndex()
	self:setSelectiveLevelIndex(self.selectiveLevelIndex + 1)
end

function UserModel:updateLastLevelIndex()
	for i=1,self.levelLen do
		if self.levelQueue[i] == 0 then
			self.lastLevelIndex = i 
			break
		end
	end
end

function UserModel:getLastLevelIndex()
	return self.lastLevelIndex
end

function UserModel:updateLevel( levelIndex, score )
	self.levelQueue[levelIndex] = math.max(checknumber(self.levelQueue[levelIndex]), score)
end

function UserModel:getScore(levelIndex)
	local x = 0
	if not levelIndex then
		--	
	end
	x = checknumber(self.levelQueue[levelIndex])
	return x
end

return UserModel