local starterpokes = {
["Weedle"] = {x = 53, y = 70, z = 7},
["Rattata"] = {x = 51, y = 70, z = 7},
["Caterpie"] = {x = 49, y = 70, z = 7},
["Bellsprout"] = {x = 43, y = 70, z = 7},   
["Oddish"] = {x = 45, y = 70, z = 7},
["Sunkern"] = {x = 47, y = 70, z = 7},
["Pidgey"] = {x = 55, y = 70, z = 7},
}

local btype = "normal"

function onUse(cid, item, frompos, item2, topos)

	if getPlayerLevel(cid) > 5 then   
	return true
	end

	local pokemon = ""

	for a, b in pairs (starterpokes) do
		if isPosEqualPos(topos, b) then
			pokemon = a
		end
	end
    if pokemon == "" then return true end
	
    if getPlayerStorageValue(cid, 9658754) ~= 1 then              
       sendMsgToPlayer(cid, 27, "Talk to the Prof. Robert to choose your beginner city first!")
       return true
    end                                            --alterado v1.9 \/

	doPlayerSendTextMessage(cid, 27, "You got your first pokemon! You also received some pokeballs to help you in your way.")
	doPlayerSendTextMessage(cid, 27, "Don't forget to use your pokedex on every undiscovered pokemon!")

    addPokeToPlayer(cid, pokemon, 0, nil, btype, true)
    doPlayerAddItem(cid, 2394, 10)

	doSendMagicEffect(getThingPos(cid), 29)
	doTeleportThing(cid, getTownTemplePosition(getPlayerTown(cid)))
	doSendMagicEffect(getThingPos(cid), 27)
	doSendMagicEffect(getThingPos(cid), 29)
	

return TRUE
end