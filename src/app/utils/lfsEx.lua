--[[
Copyright (c) 2015 calloh.com
@author Tom Lee
@date 2015-03-10
--]]
--------------------------------
-- @module 对本地文件和文件夹的管理

require "lfs"

function subRight(str)
	if string.sub(str, -1) == "/" then
	    str = string.sub(str, 1, -2)
	end
	return str
end

function subLeft(str)
	if string.sub(str, 1) == "/" then
	    str = string.sub(str, 2, -1)
	end
	return str
end

function subDouble(str)
	local path,len = string.gsub(str, "//", "/")
	return path
end

	-- a/b/c/ , /Users/xx/xx/xxx   
function _checkDirectory(directory, path)
    directory = subRight(directory)
	local queue = string.split(directory, "/")
    for i=1,table.getn(queue) do
        path = path.."/"..queue[i]
        path = subDouble(path)
        if not io.exists(path) then
            lfs.mkdir(path)
        end
    end
end

--文件名， 文件相对地址， 文件可写入的目录地址（目的）， 文件在res中的全路径（源）
function _read(filename, filepath, writablePath, resFileFullPath)
	_checkDirectory(filepath, writablePath)
	local dataString = nil
	local path = writablePath..filepath..filename
	path = subDouble(path)
	if not io.exists(path) then
		if not io.exists(resFileFullPath) then
			device.showAlert("Read Error", filename.." : is Error !!\n"..resFileFullPath, {"YES"})
		else
			dataString = io.readfile(resFileFullPath)
			io.writefile(path, dataString)
		end
	else
		dataString = io.readfile(path)
	end

	while true do
		local x = string.sub(dataString, string.len(dataString))
		if x ~= "\n" and x ~= " " then
			break
		end
		dataString = string.sub(dataString, 1, -2)
	end
	return dataString
end

function _write(filename, filepath, writablePath, dataString)
	_checkDirectory(filepath, writablePath)
	local path = writablePath..filepath..filename
	path = subDouble(path)
	if not io.exists(path) then
		device.showAlert("Write Error", filename.." : is Error !!", {"YES"})
		return false
	else
		io.writefile(path, dataString)
	end
	return true
end

local lfsEx = {
	checkDirectory = _checkDirectory,
	read = _read,
	write = _write
}
return lfsEx