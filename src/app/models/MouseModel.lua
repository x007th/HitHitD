--[[
Copyright (c) 2015 calloh.com
@author Tom Lee
@date 2015-03-10
--]]
--------------------------------
-- @module 游戏中地鼠类型的数据对象的管理

--种类 对应的分值 显示时间 图片序列起始－长度
function new_map_item(scoreNum, timerNum, imgBeginNum, imgLenNum)
    return {
        scoreNum = scoreNum,
        timerNum = timerNum,
        imgBeginNum = imgBeginNum,
        imgLenNum = imgLenNum,
    }
end


local MouseModel = class("MouseModel", cc.mvc.ModelBase)

MouseModel.DATA_FILE_PATH ="res/data/" 
MouseModel.DATA_FILE_NAME ="MOUSE_MAP" 

function MouseModel:ctor( properties )
    MouseModel.super.ctor(self, properties)
    self:refresh()
end

function MouseModel:refresh()
    local dataString = app:lfs().read(MouseModel.DATA_FILE_NAME, 
        MouseModel.DATA_FILE_PATH, 
        app:writablePath(), 
        app:getResPath(MouseModel.DATA_FILE_NAME)
    )
    local data = self:decode(dataString)
    self.map = {}
    for _x=1,table.getn(data) do
    	local item = new_map_item(
            checknumber(table.remove(data[_x],1)), 
            checknumber(table.remove(data[_x],1)),
            checknumber(table.remove(data[_x],1)),
            checknumber(table.remove(data[_x],1))
        )
    	table.insert(self.map, item)
    end
end

--序列化
function MouseModel:decode(dataString)
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
function MouseModel:encode()
	local dataString = ""
	
	return dataString
end

function MouseModel:getMap(index)
    if index then
        return clone(self.map[index])
    end
    return clone(self.map)
end

function MouseModel:getLen()
    return table.getn(self.map)
end

return MouseModel