--[[
Copyright (c) 2015 calloh.com
@author Tom Lee
@date 2015-03-10
--]]
--------------------------------
-- @module 网络数据请求

--local Network = import(".Network")

local HTTPRequest = class("HTTPRequest")

function HTTPRequest:ctor()
	
end

function HTTPRequest:load(properties)
	local url = properties.url
	local key = properties.key
	local value = properties.value
	local onError = properties.onError
	local onSucceed = properties.onSucceed

	function onRequestFinished(event)
		local data = {
			code = nil,
			info = nil
		}
        local ok = (event.name == "completed")
        local request = event.request

        if not ok then
            -- 请求失败，显示错误代码和错误消息
            data.code = request:getErrorCode()
            data.info = request:getErrorMessage()
            onError(data)
            return
        end

        local code = request:getResponseStatusCode()
        if code ~= 200 then
            -- 请求结束，但没有返回 200 响应代码
            data.code = code
            onError(data)
            return
        end

        -- 请求成功，显示服务端返回的内容
        --print(response)
        data.code = code
        data.info = request:getResponseString()
        onSucceed(data)
    end

    -- 创建一个请求，并以 POST 方式发送数据到服务端
    local request = network.createHTTPRequest(onRequestFinished, url, "POST")
    if type(key) == "string" and value then
    	request:addPOSTValue(key, value)
    end
    
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end

return HTTPRequest