function keyNum()
    local preMinSimilarity = Settings:get("MinSimilarity")
    Settings:set("MinSimilarity", 0.7)
    local anchor = lowestLeftest:wait("slash.png")
    local numRegion = Region(anchor:getX() - 55, anchor:getY(), 55, anchor:getH())
    numRegion:highlight(2)
    local num = numberOCRNoFindException(numRegion, "vFlash")
    Settings:set("MinSimilarity", preMinSimilarity)
    return(num)
end

function clickButton(target, num)
--    toast("clickButton")
    if (exists(target,4)) then
--        toast("button found")
        local allButton = findAll(target)
        local sortFunc = function(a, b) return (a:getX() < b:getX()) end
        table.sort(allButton, sortFunc)
        allButton[num]:highlight(2)
        allButton[num]:setTargetOffset(70,0)
        click(allButton[num])
--    else
--        toast("sellButton not found")
    end

end

function refill()
--    flashRequireRegion:click("smallFlash.png")
    clickButton(Pattern("sellButton.png"):similar(0.9), 1)
    waitClick("rechargeFlash.png", 3)
    wait(2)
    clickButton(Pattern("sellButton.png"):similar(0.9), 1)
    upperRight:exists(Pattern("cancel.png"):similar(0.6), 5)
    wait(1)
    keyevent(4) -- back
    keyevent(4)
    wait(1)
--    clickButton(Pattern("sellButton.png"):similar(0.9), 1)
--    waitClick("")
--    upperRight:waitClick(Pattern("cancel.png", 2):similar(0.75))
--    wait(1)

end

function detectLanguage(target, list)
    local langList = ""
    for i, l in ipairs(list) do
        if (exists(target..l..".png", 0)) then return l end
        langList = langList .. l .."\n"
    end
    return (getLanguage())
end

-- ========== Settings ================
Settings:setCompareDimension(true, 1280)
Settings:setScriptDimension(true, 1280)
Settings:set("MinSimilarity", 0.8)
localPath = scriptPath()
dofile(localPath.."lib/commonLib.lua")
setImmersiveMode(false)
dimension = autoResize(Pattern("bigFlash.png"):similar(0.9), 1280, false)
if (dimension < 0) then
    simpleDialog("Error", "cannot find correct compare dimension")
    return
end
toast (""..dimension)
-- ==========  main program ===========
upperRight = Region(640, 0, 640, 350)
right = Region(640, 0, 640, 800)
left = Region(0, 0, 640, 800)
upper = Region(0, 0, 1280, 380)
low = Region(0, 360, 1280, 440)
lowestLeftest = Region(0, 540, 320, 260)
buttonRegion = Region(350, 500, 480, 200)

skip = Location(640, 200)

sortFunc = function(a, b) return (a:getX() < b:getX()) end

dialogInit()
--addCheckBox("halfRes", "Half resolution for reducing memory usage", false)
--newRow()
--addTextView("If AnkuLua killed/stopped abnormally, try enabling this.\n")
--newRow()
--addCheckBox("nextArea", "Goto next area", false)
--newRow()
addCheckBox("sellRune", "Sell the rune after battle", false)
newRow()
addCheckBox("refillEnergy", "Refill energy with crystal", false)
newRow()
addRadioGroup("lpIndex", 999)
addRadioButton("Continuous Run (999)", 999)
addRadioButton("Level 1 Star Fodder(4)", 4)
addRadioButton("Level 2 Star Fodder(10)", 10)
addRadioButton("Level 3 Star Fodder(22)", 22)
addRadioButton("Level 4 Star Fodder(48)", 48)
newRow()
--dimString = "dim the screen when running script"
--fiveMinString = "This function is only available for 5 minutes in trial version"
--addCheckBox("dim", dimString, true)
--newRow()
--addTextView(fiveMinString)
dialogShow("Settings")
--language = getLanguage()

dim = true
halfRes = false
nextArea = false
--round = 0

-- Dim the Screen brightness if Checkbox is Selected
if (dim) then
    setBrightness(1)
end

if (nextArea) then
    print("goto next area")
else
    print("same area")
end

if (halfRes) then
    dimension = math.floor(dimension/2)
    Settings:setCompareDimension(true, dimension)
    setImagePath(localPath.."imageHalf")
end

print ("compareDimenstion = "..dimension)

-- Determine device language and ensures correct image file is used.
language = detectLanguage("cancelWord.", {"en", "zh", "ko"})
--acquirePng = "acquire."..language..".png"
--confirmPng = "confirm."..language..".png"
getPng = "get."..language..".png"
sellPng = "sell."..language..".png"
yesWordPng = "yes."..language..".png"

clickList = {Pattern("defeatedDiamond.png"):similar(0.9), 				-- 1
			"worldMap.png", 											-- 2
			"bigFlash.png", 											-- 3
			"box.png", 													-- 4
			Pattern("cancel2.png"):targetOffset(-3,-40), 				-- 5
			Pattern("cancelLong.png"):targetOffset(122,10),				-- 6
			"cancel.png", 												-- 7
			Pattern("victoryDiamond.png"):similar(0.8),	--Pattern("victoryDiamond.png"):targetOffset(-85,-185),  		-- 8
			"victoryFlash.png", 										-- 9
			"levelupFlash.png", 										-- 10
			"play.png", 												-- 11
			"reward.png"}												-- 12
--    "award.png",	--confirmPng,

if (nextArea) then
    table.insert(clickList, "ilin.png")
    table.insert(clickList, "libia.png")
    table.insert(clickList, "dulander.png")
	flashRequireRegion = right 
else 
	flashRequireRegion = left 
end

bigCancel = find("bigCancel.png")
skip = Location(bigCancel:getX()- bigCancel:getW(), bigCancel:getY() + bigCancel:getH())
click("bigFlash.png")
existsClick("play.png", 10)

while (true) do
    local choice, listMatch = waitMulti(clickList, 20*60, skip)
    if (choice == -1) then
        simpleDialog("Warning", "Unknown happened\nReport to ankulua@gmail.com")
        return
    end

    listMatch:highlight(2)
--    if (choice == 5 or choice == 6 or choice == 7) then
----        toast("cancel found")
--        if (sellRune) then
--            if (exists("sellButton.png",0)) then
--                local allButton = findAll("sellButton.png")
--                allButton[1]:highlight(2)
--                click(allButton[1])
--            else
--                toast("sellButton not found")
--            end
--        else
--            click(listMatch)
--        end
--    else

    if (choice == 1) then
        getLastMatch():highlight(2)
        if (exists(Pattern("defeatedDiamond.png"):similar(0.9), 0.9)) then
            simpleDialog("Warning", "Lose")
            return
        end
    end

    if ( (sellRune and (choice == 5 or choice == 6 or choice == 7)) or (clickList[choice] == "box.png")) then
        if (clickList[choice] == "box.png") then
            click(listMatch)
            wait(2.5)
--            exists("sellButton.png", 2)
        end
        if (sellRune) then
            if (exists(Pattern(sellPng):similar(0.5))) then
                getLastMatch():highlight(2)
--                click(getLastMatch())
                existsClick(Pattern(sellPng):similar(0.5), 0)
            else
                click(listMatch)
            end
            existsClick(yesWordPng)
            local sellResponse, match = waitMulti({yesWordPng, "worldMap.png"}, 3)
            if (sellResponse == 1) then
                click(match)
                print("need confirming selling rune")
            end
        else
            click(listMatch)
        end
    elseif (choice > 2) then click(listMatch) end


    if (clickList[choice] == "ilin.png" or clickList[choice] == "libia.png" or clickList[choice] == "dulander.png") then
        while (existsClick(clickList[choice], 0)) do
            wait(1)
        end
    end

    if (choice == 2 and exists("worldMap.png", 0)) then -- next round
        if (nextArea and flashRequireRegion:exists("require0.png",0)) then
            simpleDialog("Warning", "Reach end of curent area.")
            return
        end

        local requiredFlash = existsMultiMax(flashRequireRegion,
            {"require3.png", "require4.png", "require5.png", "require6.png", "require7.png", "require8.png"})
        
		if (requiredFlash == -1) then 
			requiredFlash = 9 
		else 
			requiredFlash = requiredFlash + 2 
		end
        toast("required Flash = "..requiredFlash)
        
		while (true) do -- check flash
            if (not flashRequireRegion:existsClick("smallFlash.png")) then
				round = round + 1
				toast("LOOP END")
				toast(round)
                waitClick("smallFlash.png")
			end
            wait(1)
            choice, listMatch = waitMulti({"bigFlash.png", "sellButton.png"}, 3)
            if (choice == 1) then 
				break 
			end
            if (choice == 2) then
                if (exists("worldMap.png", 0) and refillEnergy) then
                    round = round - 1
					toast("LOOP END")
					toast(round)
					refill()
                    break
                end
                keyevent(4)
                toast("Not enough flash, wait 5 minutes")
                wait(5*60)
            end
            if (choice == -1) then 
				keyevent(4) 
			end
        end
    end

end
--round = round + 1
--toast("LOOP END")
--toast(round)
--if (round >= lpIndex) then
--	simpleDialog("Loop Complete")
--end