
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
    --self:runTest()
    --device.showAlert("title", device.writablePath)
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
  --local scene = display.getRunningScene()
  scene:setKeypadEnabled(true)
  scene:addNodeEventListener(cc.KEYPAD_EVENT, function (event)
      --dump(event)
      local str = "event.key is [ " .. event.key .. " ]"
      --device.showAlert("title", str)
      if event.key == "back" then
          --print("back")
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
          --print("menu")
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
-----------------------------------------------------------------------
--test-----------------------------------------------------------------
-----------------------------------------------------------------------
-----------------------------------------------------------------------

function MyApp:testdevice( )
    --dump(device)
    --/Users/tom/Documents/quick-3.3/player3.app/Contents/Resources/
    --print(cc.FileUtils:getInstance():fullPathForFilename("gamedata.txt"))
    local path = "gamedata.txt" -- cc.FileUtils:getInstance():fullPathForFilename("gamedata.txt")
    printf("path: %s", path)
    if io.exists(path) then
        printf("txt: %s", io.readfile(path))
    else
        io.writefile(path, txt)
    end
end

function MyApp:testjson( )
     local jsonVal = json.decode('{"a":1,"b":"ss","c":{"c1":1,"c2":2},"d":[10,11],"1":100}')
        --print("====>")
        --print(jsonVal)
end

function MyApp:runTest( ... )
end

return MyApp
--[[

function MyApp:runTest2( ... )
  -- body
end
   --print(cc.FileUtils:getInstance():fullPathForFilename("gamedata.txt"))
   --printf("gameView_%02d.png", 1, 2)
   --local str = "zxcvb 1 "
   --print(string.sub(str,1, -2))
   --ccs.NodeReader:getInstance():createNode("xxx/xxx.ExportJson");
   print(io.exists("calloh_03.jpg"))
  -- print(cc.FileUtils:getInstance():getWritablePath())
   --dump(cc.FileUtils:getInstance():getSearchResolutionsOrder())
   --dump(cc.FileUtils:getInstance():getSearchPaths())
   local ps = cc.FileUtils:getInstance():getSearchPaths()
   dump(ps)

   for i=1,table.getn(ps) do
       print(io.exists(ps[i].."path.txt"))
   end
   --print(cc.FileUtils:getInstance():fullPathFromRelativePath("path.txt"))

  --print(cc.FileUtils:getInstance():fullPathFromRelativeFile("path.txt"))
  print(device.getOpenUDID())
  dump(device)

  local path = cc.FileUtils:getInstance():fullPathForFilename("LANGUAGE")
  print(path)
  print(io.exists(path))
  
  -- print(lfs.mkdir)


  path = device.writablePath.."res/data2/11.txt"
  ff = "mkdir "..device.writablePath.."res/data2"
  print("mkdir -p "..device.writablePath.."res/data2")
    if device.platform ~= "windows" then
      os.execute(ff)
  end
  io.writefile(path, "dataString")
  --device.showAlert(tostring(io.exists(path)), path)

        path = device.writablePath.."res"
        require "lfs"
        local oldpath = lfs.currentdir()
        print("old path------> "..oldpath)

         if lfs.chdir(path) then
            lfs.chdir(oldpath)
            print("path 1check OK------> "..path)
            --return true
         end

         if lfs.mkdir(path) then
            print("path 2create OK------> "..path)
            --return true
         end

         local queue = string.split("res/data2/", "/")
         dump(queue)
         path = "res/data2/"
         print(string.sub(path,1, -1))

         self:checkDirectory("a/b/c/")
         path = app:writablePath().."a/b/c/"
        -- device.showAlert(tostring(io.exists(path)), path)
end

function MyApp:checkDirectory(userdatapath)
    require "lfs"
    local queue = string.split(userdatapath, "/")
    if string.sub(userdatapath, -1) == "/" then
        table.remove(queue)
    end
    
    local path = app:writablePath()
    if string.sub(path, -1) == "/" then
        path = string.sub(path, 1, -2)
    end
    for i=1,table.getn(queue) do
        path = path.."/"..queue[i]
        if not io.exists(path) then
            lfs.mkdir(path)
        end
    end
end


]]