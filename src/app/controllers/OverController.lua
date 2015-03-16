local OverController = class("OverController", function ( ... )
	return display.newNode()
end)

function OverController:ctor(model)
	self.model = model
	self.view = app:createView("OverView", model, self):addTo(self)
end

function OverController:delegate_onNext()
	app:audio():hitButton()
	self:hidePopup()
	app:userModel():setNextLevelIndex()
	display.getRunningScene():ready()
end

function OverController:delegate_onBack()
	app:audio():hitButton()
	self:hidePopup()
	display.getRunningScene():toExit()
end

function OverController:delegate_onRepeat()
	app:audio():hitButton()
	self:hidePopup()
	display.getRunningScene():ready()
end

function OverController:showPopup()
	app:popupInstance():open(self)
end

function OverController:hidePopup()
	app:popupInstance():close()
end

return OverController