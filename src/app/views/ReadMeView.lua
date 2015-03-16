local ReadMeView = class("ReadMeView", function()
	return display.newNode()
end)

function ReadMeView:ctor(model, delegate)
	dump(device)
	local text_ = --io.readfile("gamedata.txt")
	"两只老虎，两只老虎\n两只老虎，两只老虎\n两只老虎，两只老虎\n两只老虎，两只老虎\n两只老虎，两只老虎\n"
	--io.readfile("gamedata.txt")
	--for i=1,3 do
	--	text_ = text_ .. text_
	--end
	local label = display.newTTFLabel({
	    text = text_,
	    font = "Arial",
	    size = 16,
	    color = cc.c3b(50, 50, 50), 
	    align = cc.TEXT_ALIGNMENT_LEFT,
	    valign = cc.VERTICAL_TEXT_ALIGNMENT_TOP,
	})

	app:loadingInstance():show()
	local box = app:createComponent("DialogBox", {
		node = label, 
		dtype = 1, 
		onHandler = handler(self, self.onFeedback_), 
		onCompleteHandler = handler(app:loadingInstance(), app:loadingInstance().hide),
	}):addTo(self)
end

function ReadMeView:onFeedback_(dtype)
	if dtype == 1 then
		--printf("is : %s", "yes")
	elseif dtype == 2 then
		--printf("is : %s", "no")
	end
	app:popupInstance():close()
end

function ReadMeView:onEnter()
end

function ReadMeView:onExit()
	
end

return ReadMeView