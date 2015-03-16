local OverView = class("OverView", function ( ... )
	return display.newNode()
end)

function OverView:ctor(model, delegate)
	self.model = model
	self.delegate = delegate

	self.username = app:userModel():getUsername()
	self.levelIndex = app:userModel():getSelectiveLevelIndex()

	self.highestScore = app:userModel():getScore(self.levelIndex)
	self.maxReviews = app:levelModel():getMap(self.levelIndex).reviewsQueue
	self.reviews = model:getReviews()
	self.score = model:getScore()
	self.isWin = model:isWin()
	self:layout_()
end

function OverView:layout_()
	local backButton = self:newButton_("back", handler(self.delegate, self.delegate.delegate_onBack)):addTo(self)
	local nextButton = self:newButton_("next", handler(self.delegate, self.delegate.delegate_onNext)):addTo(self)
	local repeatButton = self:newButton_("repeat", handler(self.delegate, self.delegate.delegate_onRepeat)):addTo(self)
	local bg = display.newSprite("#"..app:images():list().popup.queue.bg):align(display.CENTER, 0, 0):addTo(self)

	local size = bg:getContentSize()

	backButton:align(display.CENTER_LEFT, size.width * 0.5 * -1 +12, size.height * 0.5 * -1 + 6)
	nextButton:align(display.CENTER, 0,  size.height * 0.5 * -1 + 20)
	repeatButton:align(display.CENTER_RIGHT, size.width * 0.5 - 12,  size.height * 0.5 * -1 + 6)

	local resultTxt = self:newText_("WIN! ", display.CENTER, size.width - 200 , size.height - 120, 100):scale(0):addTo(bg)
	--resultTxt:enableOutline(cc.c4b(255, 0, 0, 255), 2)
	if not self.isWin then
		nextButton:hide()
		resultTxt:setString("LOST!")
		app:audio():lost()
	else
		app:audio():win()
	end

	if self.levelIndex + 1 >= app:levelModel():getLen() then
		nextButton:hide()
	end

	local usernameTxt = self:newText_(self.username, display.CENTER_LEFT, 60, size.height - 60, 60):addTo(bg)
	--local levelPrefixTxt = self:newText_("lv.", display.CENTER_RIGHT, 0, size.height - 60, 90):addTo(bg)
	local levelIndexTxt = self:newText_(self.levelIndex, display.CENTER_RIGHT, 60, size.height * 0.5, 200):addTo(bg)

	local theScorePrefixTxt = self:newText_("THEN SCORE:", display.TOP_LEFT, 60, size.height - 140, 24):addTo(bg)
	local theScoreTxt = self:newText_(self.score, display.TOP_LEFT, 230, size.height - 140 + 4, 40):addTo(bg)

	local highestScorePrefixTxt = self:newText_("HIGHEST SCORE:", display.TOP_LEFT, 60, size.height - 220, 24):addTo(bg)
	local highestScoreTxt = self:newText_(self.highestScore, display.TOP_LEFT, 270, size.height - 220 + 4, 40):addTo(bg)

	local reviewsTxt = self:newText_("REVIEWS:", display.TOP_LEFT, 60, size.height - 300, 24):addTo(bg)

	local trophyQueue = {}

	for i=1,table.getn(self.maxReviews) do
		local trophy = display.newSprite("#"..app:images():list().chip.queue.star):align(display.BOTTOM_LEFT, 200 + (i-1) * 70, 56):addTo(bg)
		trophy:opacity(100)
		table.insert(trophyQueue, trophy)
	end

	for j=1,self.reviews do
		trophyQueue[j]:opacity(255)
	end

	function showResultTxt()
		local sequence = transition.sequence({
	    	cc.ScaleTo:create(0.2, 2),
	    	cc.ScaleTo:create(0.2, 0.5),
	    	cc.ScaleTo:create(0.2, 1),
		})
		resultTxt:runAction(sequence)
	end
	self:performWithDelay(handler(self, showResultTxt), 0.5)
end



function OverView:newButton_(label, handler)
	local img = {
		normal = "#"..app:images():list().popup.queue.up,
		pressed = "#"..app:images():list().popup.queue.down,
		disabled = "#"..app:images():list().popup.queue.down,
	}

	return cc.ui.UIPushButton.new(img, {scale9 = true})
        :setButtonLabel(cc.ui.UILabel.new({text = label,color = cc.c3b(0, 0, 0)}))
        :onButtonPressed(function(event)
            event.target:setScale(0.98)
        end)
        :onButtonRelease(function(event)
            event.target:setScale(1.0)
        end)
        :onButtonClicked(function()
            handler()
        end)
end

function OverView:newText_( textContent, align, x, y, size, color)
	-- body
	return display.newTTFLabel({
		    text = textContent,
		    font = "Arial",
		    size = size or 40,
		    color = color or cc.c3b(0, 0, 0),
		})
		:align(align, x, y)
end



return OverView