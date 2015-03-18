
--[[
Copyright (c) 2015 calloh.com
@author Tom Lee
Creation 2015-03-10
--]]
--------------------------------
-- @module 启动入口

require("config")
require("cocos.init")
require("framework.init")

local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
    math.randomseed(os.time())

    cc.FileUtils:getInstance():addSearchPath("res/")
    cc.FileUtils:getInstance():addSearchPath("res/data/")
    cc.FileUtils:getInstance():addSearchPath("res/audio/")
    cc.FileUtils:getInstance():addSearchPath("res/images/")
    
    self.images_ = self:createUtil("ImagesManager")
    self.audio_ = self:createUtil("AudioManager")
    self.popup_ = self:createUtil("PopupManager", {zorder = 999})
    self.loading_ = self:createComponent("Loading", {zorder = 1000})
    self.http_ = self:createUtil("HTTPRequest")
    self.lfs_ = require(self.packageRoot .. ".utils.lfsEx")

    self.mouseModel_ = self:getModelClass("MouseModel").new()
    self.levelModel_ = self:getModelClass("LevelModel").new()
    self.userModel_ = self:getModelClass("UserModel").new()
end

function MyApp:run()
    self:enterScene("LogoScene")
end

function MyApp:gotoHomeScene()
    display.getRunningScene():removeAllNodeEventListeners()
    self:enterScene("HomeScene",nil,"fade", 0.5, display.COLOR_WHITE)
end

function MyApp:gotoGameScene()
  display.getRunningScene():removeAllNodeEventListeners()
  self:enterScene("GameScene",nil,"fade", 0.5, display.COLOR_WHITE)
end

function MyApp:keyEvent(scene)
    scene:setKeypadEnabled(true)
    scene:addNodeEventListener(cc.KEYPAD_EVENT, function (event)
      if event.key == "back" then
          local function onButtonClicked(event)
              if event.buttonIndex == 1 then
                  cc.Director:getInstance():endToLua()
                  if device.platform == "windows" or device.platform == "mac" then
                      os.exit()
                  end
              end
          end
        device.showAlert("Confirm Exit", "Are you sure exit game ?", {"YES", "NO"}, onButtonClicked)
      elseif event.key == "menu" then
      end
    end)
end

function MyApp:getControllerClass(name)
    local packageName = self.packageRoot .. ".controllers." .. name
    local clazz = require(packageName)
    return clazz
end

function MyApp:getModelClass(name)
    local packageName = self.packageRoot .. ".models." .. name
    local clazz = require(packageName)
    return clazz
end

function MyApp:createComponent(name, properties)
    local packageName = self.packageRoot .. ".components." .. name
    local clazz = require(packageName)
    return clazz.new(properties)
end

function MyApp:createUtil(name, properties)
    local packageName = self.packageRoot .. ".utils." .. name
    local clazz = require(packageName)
    return clazz.new(properties)
end

function MyApp:createCell(name, ...)
    local packageName = self.packageRoot .. ".cells." .. name
    local clazz = require(packageName)
    return clazz.new(...)
end

function MyApp:additionEventProtocol(eventDispatcher)
    cc(eventDispatcher):addComponent("components.behavior.EventProtocol"):exportMethods()
end

function MyApp:EventProxy(eventDispatcher, view)
    return cc.EventProxy.new(eventDispatcher, view)
end

function MyApp:popupInstance()
    return self.popup_
end

function MyApp:loadingInstance()
    return self.loading_
end

function MyApp:httpInstance()
    return self.http_
end


function MyApp:levelModel()
    return self.levelModel_
end

function MyApp:mouseModel()
    return self.mouseModel_
end

function MyApp:userModel()
    return self.userModel_
end

function MyApp:lfs()
    return self.lfs_
end

function MyApp:writablePath()
    return device.writablePath
end

function MyApp:getResPath(dataname)
    return cc.FileUtils:getInstance():fullPathForFilename(dataname)
end

function MyApp:audio()
    return self.audio_
end

function MyApp:images()
    return self.images_
end

return MyApp
