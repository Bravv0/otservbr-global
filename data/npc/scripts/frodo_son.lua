local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)
    npcHandler:onCreatureAppear(cid)
end
function onCreatureDisappear(cid)
    npcHandler:onCreatureDisappear(cid)
end
function onCreatureSay(cid, type, msg)
    npcHandler:onCreatureSay(cid, type, msg)
end
function onThink()
    npcHandler:onThink()
end

local voices = { {text = 'Come into my tavern and share some stories!'} }
npcHandler:addModule(VoiceModule:new(voices))

-- Basic
keywordHandler:addKeyword({'hut'}, StdModule.say, {npcHandler = npcHandler, text = "I hope you like it. Would you like some {food}?"})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "I am the son of Frodo. I am also {selling} food like him. "})
keywordHandler:addAliasKeyword({'saloon'})
keywordHandler:addKeyword({'food'}, StdModule.say, {npcHandler = npcHandler, text = "I can offer you ham, or meat. If you'd like to see my offers, ask me for a trade."})
keywordHandler:addKeyword({'father'}, StdModule.say, {npcHandler = npcHandler, text = "Oh yes, Frodo is my father. Can you please say that I {need} him?"})
keywordHandler:addKeyword({'king'}, StdModule.say, {npcHandler = npcHandler, text = "Oh, our beloved king! Thanks to him, alcohol is so cheap."})
keywordHandler:addKeyword({'need'}, StdModule.say, {npcHandler = npcHandler, text = "Tell him he needs to fuck up. That prick abandoned me."})
keywordHandler:addAliasKeyword({'tibianus'})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = "Just call me Lil Frodo."})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, text = "It is exactly |TIME|."})
keywordHandler:addKeyword({'bravera'}, StdModule.say, {npcHandler = npcHandler, text = "Come on! You know that our world is called Bravera."})

npcHandler:setMessage(MESSAGE_GREET, "Hey, come closer. You heard about my {father}, Frodo?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Please come back from time to time.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Please come back from time to time.")

npcHandler:addModule(FocusModule:new())
