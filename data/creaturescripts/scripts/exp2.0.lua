local combats = {                        
[PSYCHICDAMAGE] = {cor = COLOR_PSYCHIC},
[GRASSDAMAGE] = {cor = COLOR_GRASS},
[POISONEDDAMAGE] = {cor = COLOR_GRASS},
[FIREDAMAGE] = {cor = COLOR_FIRE2},                         
[BURNEDDAMAGE] = {cor = COLOR_BURN},
[WATERDAMAGE] = {cor = COLOR_WATER},
[ICEDAMAGE] = {cor = COLOR_ICE},
[NORMALDAMAGE] = {cor = COLOR_NORMAL},
[FLYDAMAGE] = {cor = COLOR_FLYING},           
[GHOSTDAMAGE] = {cor = COLOR_GHOST},
[GROUNDDAMAGE] = {cor = COLOR_GROUND},
[ELECTRICDAMAGE] = {cor = COLOR_ELECTRIC},
[ROCKDAMAGE] = {cor = COLOR_ROCK},
[BUGDAMAGE] = {cor = COLOR_BUG},
[FIGHTDAMAGE] = {cor = COLOR_FIGHTING},
[DRAGONDAMAGE] = {cor = COLOR_DRAGON},
[POISONDAMAGE] = {cor = COLOR_POISON},
[DARKDAMAGE] = {cor = COLOR_DARK},               
[STEELDAMAGE] = {cor = COLOR_STEEL},
[MIRACLEDAMAGE] = {cor = COLOR_PSYCHIC},  
[DARK_EYEDAMAGE] = {cor = COLOR_GHOST},
[SEED_BOMBDAMAGE] = {cor = COLOR_GRASS},
[SACREDDAMAGE] = {cor = COLOR_FIRE2}, 
[MUDBOMBDAMAGE] = {cor = COLOR_GROUND}, --alterado v1.9
}

local function sendPlayerDmgMsg(cid, text)
	if not isCreature(cid) then return true end
	doPlayerSendTextMessage(cid, MESSAGE_STATUS_DEFAULT, text)
end

local races = {
[4] = {cor = COLOR_FIRE2},
[6] = {cor = COLOR_WATER},
[7] = {cor = COLOR_NORMAL},
[8] = {cor = COLOR_FIRE2},
[9] = {cor = COLOR_FIGHTING},
[10] = {cor = COLOR_FLYING},
[11] = {cor = COLOR_GRASS},
[12] = {cor = COLOR_POISON},
[13] = {cor = COLOR_ELECTRIC},
[14] = {cor = COLOR_GROUND},
[15] = {cor = COLOR_PSYCHIC},
[16] = {cor = COLOR_ROCK},
[17] = {cor = COLOR_ICE},
[18] = {cor = COLOR_BUG},
[19] = {cor = COLOR_DRAGON},
[20] = {cor = COLOR_GHOST},
[21] = {cor = COLOR_STEEL},
[22] = {cor = COLOR_DARK},
[1] = {cor = 180},
[2] = {cor = 180},
[3] = {cor = 180},
[5] = {cor = 180},
}

local damages = {GROUNDDAMAGE, ELECTRICDAMAGE, ROCKDAMAGE, FLYDAMAGE, BUGDAMAGE, FIGHTINGDAMAGE, DRAGONDAMAGE, POISONDAMAGE, DARKDAMAGE, STEELDAMAGE}
local fixdmgs = {PSYCHICDAMAGE, COMBAT_PHYSICALDAMAGE, GRASSDAMAGE, FIREDAMAGE, WATERDAMAGE, ICEDAMAGE, NORMALDAMAGE, GHOSTDAMAGE}
local ignored = {POISONEDDAMAGE, BURNEDDAMAGE}                
local cannotkill = {BURNEDDAMAGE, POISONEDDAMAGE}

function onStatsChange(cid, attacker, type, combat, value)

if combat == FLYSYSTEMDAMAGE then return false end
if isPlayer(cid) and getCreatureOutfit(cid).lookType == 814 then return false end -- TV

if not isCreature(attacker) then  
	if not isInArray(fixdamages, combat) and combats[combat] then
		doSendAnimatedText(getThingPos(cid), value, combats[combat].cor)
	end
return true
end

local damageCombat = combat
--------------------------------------------------
if type == STATSCHANGE_HEALTHGAIN then
	if cid == attacker then
	return true
	end
	if isSummon(cid) and isSummon(attacker) and canAttackOther(cid, attacker) == "Cant" then
	return false
	end
return true
end
--------------------------------------------------
if isMonster(cid) then
local valor = value
   if not pokes[getCreatureName(cid)] and damageCombat == COMBAT_PHYSICALDAMAGE then
      valor = getOffense(attacker) * playerDamageReduction
      doCreatureAddHealth(cid, -math.abs(valor), 3, races[7].cor)                       
      return false
   elseif not pokes[getCreatureName(cid)] and damageCombat ~= COMBAT_PHYSICALDAMAGE then
      doCreatureAddHealth(cid, -math.abs(valor), 3, combats[damageCombat].cor)
      return false
   end
end
--------------------------------------------------
if isPlayer(attacker) then

	local valor = value
	if valor > getCreatureHealth(cid) then
		valor = getCreatureHealth(cid)
	end

	if combat == COMBAT_PHYSICALDAMAGE then
	return false
	end

	if combat == PHYSICALDAMAGE then
	doSendMagicEffect(getThingPos(cid), 3)
	doSendAnimatedText(getThingPos(cid), valor, races[getMonsterInfo(getCreatureName(cid)).race].cor)
	end

	if combats[damageCombat] and not isInArray(fixdmgs, damageCombat) then
	doSendAnimatedText(getThingPos(cid), valor, combats[damageCombat].cor)
	end

	if #getCreatureSummons(attacker) >= 1 and not isInArray({POISONEDDAMAGE, BURNEDDAMAGE}, combat) then
		doPlayerSendTextMessage(attacker, MESSAGE_STATUS_DEFAULT, "Your "..getPokeName(getCreatureSummons(attacker)[1]).." dealt "..valor.." damage to "..getSomeoneDescription(cid)..".")
	end

return true
end
--------------------------------------------------
if isPlayer(cid) and #getCreatureSummons(cid) >= 1 and type == STATSCHANGE_HEALTHLOSS then
return false                                                                           
end
--------------------------------------------------
if isPlayer(cid) and #getCreatureSummons(cid) <= 0 and type == STATSCHANGE_HEALTHLOSS then

if isSummon(attacker) or isPlayer(attacker) then
   if canAttackOther(cid, attacker) == "Cant" then return false end
end

	local valor = 0
		if combat == COMBAT_PHYSICALDAMAGE then
			valor = getOffense(attacker)
		else
			valor = getSpecialAttack(attacker)
		end

	valor = valor * playerDamageReduction
	valor = valor * math.random(83, 117) / 100

	if valor >= getCreatureHealth(cid) then
		valor = getCreatureHealth(cid)
	end

	valor = math.floor(valor)

    if valor >= getCreatureHealth(cid) then
       if getPlayerStorageValue(cid, 6598754) >= 1 or getPlayerStorageValue(cid, 6598755) >= 1 then
          setPlayerStorageValue(cid, 6598754, -1)
          setPlayerStorageValue(cid, 6598755, -1)
          doRemoveCondition(cid, CONDITION_OUTFIT)             
          doTeleportThing(cid, posBackPVP, false)
          doCreatureAddHealth(cid, getCreatureMaxHealth(cid))
          return false --alterado v1.8
       end
       
       if getPlayerStorageValue(cid, 17001) >= 1 or getPlayerStorageValue(cid, 17000) >= 1 or getPlayerStorageValue(cid, 63215) >= 1 then
          doRemoveCondition(cid, CONDITION_OUTFIT)
          setPlayerStorageValue(cid, 17000, 0)
          setPlayerStorageValue(cid, 17001, 0)
          setPlayerStorageValue(cid, 63215, -1) 
          doChangeSpeed(cid, PlayerSpeed)
          local item = getPlayerSlotItem(cid, 8)
          local btype = getPokeballType(item.itemid)
          if #getCreatureSummons(cid) <= 0 then
	  	     if isInArray(pokeballs[btype].all, item.itemid) then
	   		    doTransformItem(item.uid, pokeballs[btype].off)
	   		    doItemSetAttribute(item.uid, "hp", 0)
             end
          end
       end

       if getPlayerStorageValue(cid, 22545) == 1 then
          if getGlobalStorageValue(22550) == 1 then
             doPlayerSendTextMessage(cid, 20, "You are the last survivor of the golden arena! Take your reward!")
             doPlayerAddItem(cid, 2152, getPlayerStorageValue(cid, 22551)*2)  
             setPlayerStorageValue(cid, 22545, -1)
             doTeleportThing(cid, getClosestFreeTile(cid, getClosestFreeTile(cid, posBackGolden)), false)  
             doCreatureAddHealth(cid, getCreatureMaxHealth(cid)-getCreatureHealth(cid))
             setPlayerRecordWaves(cid)     
             endGoldenArena()
             return false --alterado v1.8           
          else
             setGlobalStorageValue(22550, getGlobalStorageValue(22550)-1)
             setPlayerStorageValue(cid, 22545, -1)
             doTeleportThing(cid, getClosestFreeTile(cid, posBackGolden), false)    
             doCreatureAddHealth(cid, getCreatureMaxHealth(cid)-getCreatureHealth(cid))
             setPlayerRecordWaves(cid)     
             return true
          end 
       end

       if getPlayerStorageValue(cid, 98796) >= 1 then
          setPlayerStorageValue(cid, 98796, -1) 
          setPlayerStorageValue(cid, 98797, -1)                      --alterado v1.8
          doTeleportThing(cid, SafariOut, false)
          doSendMagicEffect(getThingPos(cid), 21)
          doPlayerSendTextMessage(cid, 27, "You die in the saffari... Best luck in the next time!")
          return false --alterado v1.8
       end

       local corpse = doCreateItem(3058, 1, getThingPos(cid))
       doDecayItem(corpse)
       doItemSetAttribute(corpse, "pName", getCreatureName(cid))          --alterado v1.7 coloca corpse quando o player morre!
       doItemSetAttribute(corpse, "attacker", getCreatureName(attacker))
       doItemSetAttribute(corpse, "article", getPlayerSex(cid) == 0 and "She" or "He")
       
       if getPlayerStorageValue(cid, Agatha.stoIni) >= 1 and getPlayerStorageValue(cid, Agatha.stoIni) <= 10 then
          setPlayerStorageValue(cid, Agatha.stoIni, -1)
          setPlayerStorageValue(cid, Agatha.stoRec, -1)
          setPlayerStorageValue(cid, Agatha.stoPer, -1)
          setPlayerStorageValue(cid, Agatha.stoEni, -1)        --alterado v1.9  agatha quest
          setPlayerStorageValue(cid, Agatha.stoRes, -1)
       end 
    end
	doCreatureAddHealth(cid, -valor, 3, 180)
	if not isPlayer(cid) then
	   addEvent(sendPlayerDmgMsg, 5, cid, "You lost "..valor.." hitpoints due to an attack from "..getSomeoneDescription(attacker)..".")
	end
return false
end
--------------------------------------------------
if isMonster(attacker) and getPlayerStorageValue(attacker, 201) ~= -1 then
	if isPlayer(cid) then
	return false
	end
	if getPlayerStorageValue(getCreatureMaster(cid), ginasios[getPlayerStorageValue(attacker, 201)].storage) ~= 1 then
	return false
	end
end
--------------------------------------------------
if isMonster(cid) and getPlayerStorageValue(cid, 201) ~= -1 then
	if getPlayerStorageValue(getCreatureMaster(attacker), ginasios[getPlayerStorageValue(cid, 201)].storage) ~= 1 then
	return false
	end
end
--------------------------------------------------
if ehMonstro(cid) and ehMonstro(attacker) and not isSummon(cid) and not isSummon(attacker) then 
return false                                          --alterado v1.9 /\
end
--------------------------------------------------
--------------------REFLECT-----------------------
if getPlayerStorageValue(cid, 21099) >= 1 and combat ~= COMBAT_PHYSICALDAMAGE then
   if not isInArray({"Team Claw", "Team Slice"}, getPlayerStorageValue(attacker, 21102)) then
      doSendMagicEffect(getThingPosWithDebug(cid), 135)
      doSendAnimatedText(getThingPosWithDebug(cid), "REFLECT", COLOR_GRASS)
      addEvent(docastspell, 100, cid, getPlayerStorageValue(attacker, 21102))
      if getCreatureName(cid) == "Wobbuffet" then
         doRemoveCondition(cid, CONDITION_OUTFIT)    
      end
      setPlayerStorageValue(cid, 21099, -1)                    
      setPlayerStorageValue(cid, 21100, 1)
      setPlayerStorageValue(cid, 21101, attacker)
      setPlayerStorageValue(cid, 21103, getTableMove(attacker, getPlayerStorageValue(attacker, 21102)).f)
      setPlayerStorageValue(cid, 21104, getCreatureOutfit(attacker).lookType)
      return false
   end
end
-------------------------------------------------

local multiplier = 1

   if isCreature(cid) then
      poketype1 = pokes[getCreatureName(cid)].type        
      poketype2 = pokes[getCreatureName(cid)].type2
   end
   if not poketype1 or not poketype2 then return false end  
   
	if getCreatureCondition(cid, CONDITION_INVISIBLE) then
	return false
	end
if damageCombat ~= COMBAT_PHYSICALDAMAGE and not isInArray(ignored, damageCombat) then
	if isInArray(effectiveness[damageCombat].super, poketype1) then
		multiplier = multiplier + 0.5
	end
	if isInArray(effectiveness[damageCombat].super, poketype2) then
		multiplier = multiplier + 0.5
	end
	if isInArray(effectiveness[damageCombat].weak, poketype1) then    
		multiplier = multiplier - 0.25
	end
	if isInArray(effectiveness[damageCombat].weak, poketype2) then
		multiplier = multiplier - 0.25
	end
	if isInArray(effectiveness[damageCombat].non, poketype1) or isInArray(effectiveness[damageCombat].non, poketype2) then
      if isInArray(specialabilities["foresight"], getCreatureName(attacker)) then   
         multiplier = 0.5                 
      end                         --alterado v1.6
    end
elseif combat == COMBAT_PHYSICALDAMAGE then
	if isGhostPokemon(cid) then               
       if not isInArray(specialabilities["foresight"], getCreatureName(attacker)) then  --passiva Foresight!!
          doSendMagicEffect(getThingPos(cid), 3)     
	      return false
       end
    end
		local cd = getPlayerStorageValue(attacker, conds["Miss"])
        local cd2 = getPlayerStorageValue(attacker, conds["Confusion"]) 
        local cd3 = getPlayerStorageValue(attacker, conds["Stun"]) 
        if cd >= 0 or cd2 >= 0 or cd3 >= 0 then
           if math.random(1, 100) > 50 then  
		      doSendMagicEffect(getThingPos(cid), 211)
		      doSendAnimatedText(getThingPos(attacker), "MISS", 215)         
		      return false
           end
        end
end
--------------------------------------------------
local valor = value

	if multiplier == 1.5 and poketype2 == "no type" then
        multiplier = 2                                         
    elseif multiplier == 1.5 and poketype2 ~= "no type" then	
    	multiplier = 1.75       
	elseif multiplier == 1.25 then    
		multiplier = 1    
	end

--------------------------------------------------
    if isSummon(cid) and isSummon(attacker) then
        if getCreatureMaster(cid) == getCreatureMaster(attacker) then
           return false
        end
		if canAttackOther(cid, attacker) == "Cant" then
           return false
        end
	end

	valor = valor * multiplier

	if isSummon(attacker) then
		valor = valor * getHappinessRate(attacker)
	else
		valor = valor * summonReduction
	end
                                                              
	valor = math.floor(valor)                                 
	
	if combat == COMBAT_PHYSICALDAMAGE then
       
       local value = getOffense(attacker) > 1000 and 3 or 2
       block = 1 - (getDefense(cid) / (getOffense(attacker) + getDefense(cid))) --alterado v1.9 testem essa nova formula plzzz '--'
	   valor = (getOffense(attacker)/value) * block
	   
	   if valor <= 0 then
	      valor = math.random(5, 10) --alterado v1.9
       end
	   
       if isInArray(specialabilities["counter"], getCreatureName(cid)) then
	      if math.random(1, 100) <= 10 then
	         doCreatureAddHealth(attacker, -valor, 3, 180)    
	         valor = 0
	         doSendAnimatedText(getThingPosWithDebug(cid), "COUNTER", 215)
          end
       end      
    else
       valor = valor / getDefense(cid)
    end
    
    -------------------------Edited CLAN SYSTEM-----------------------------------
    if isSummon(attacker) and getPlayerStorageValue(getCreatureMaster(attacker), 86228) >= 1 then
       valor = valor*getClanPorcent(getCreatureMaster(attacker), combat, "atk")                           
    elseif isSummon(cid) and getPlayerStorageValue(getCreatureMaster(cid), 86228) >= 1 then
       valor = valor - (valor*getClanPorcent(getCreatureMaster(cid), combat, "def", pokes[getCreatureName(cid)].type, pokes[getCreatureName(cid)].type2))
    end
    -----------------------------------------------------------------------
    ---------------------- FEAR / ROAR ------------------------------------
    if getPlayerStorageValue(attacker, conds["Fear"]) >= 1 then         
    return true
    end
--------------------------------------------------------------------------
if damageCombat ~= COMBAT_PHYSICALDAMAGE and not isInArray(ignored, damageCombat) then
   if isInArray(effectiveness[damageCombat].non, poketype1) or isInArray(effectiveness[damageCombat].non, poketype2) then
      if not isInArray(specialabilities["foresight"], getCreatureName(attacker)) then     
         valor = valor * 0                      
      end
   end
end

if damageCombat == GROUNDDAMAGE then
   if isInArray(specialabilities["levitate"], getCreatureName(cid)) then
      valor = 0                      
   end
end
-----------------------------------------------------------------------------
local p = getThingPos(cid)                     
if p.x == 1 and p.y == 1 and p.z == 10 then
return false                                    
end

if getPlayerStorageValue(cid, 9658783) == 1 then
return false     --imune
end
-----------------------------------------------------------------------------

--------------- FIGHT MODE -----------------------
if useOTClient then
if isSummon(cid) then                                  
   local master = getCreatureMaster(cid)
   if getPlayerStorageValue(master, 248759) == 1 then
      valor = valor * 1.1
   elseif getPlayerStorageValue(master, 248759) == 3 then
      valor = valor * 0.9
   end
end
if isSummon(attacker) then
   local master = getCreatureMaster(attacker)
   if getPlayerStorageValue(master, 248759) == 1 then
      valor = valor * 1.1
   elseif getPlayerStorageValue(master, 248759) == 3 then
      valor = valor * 0.9
   end
end 
end   
-----------------------------------------------------------------------------
	if valor >= getCreatureHealth(cid) then
		if isInArray(cannotKill, combat) and isPlayer(cid) then
			valor = getCreatureHealth(cid) - 1
		else
			valor = getCreatureHealth(cid)
		end
	end
	valor = math.floor(valor)            
	
------------------ SKILLs Q CURAM O ATTACKER ---------------------------------
local function doHeal(cid, amount)
if (getCreatureHealth(cid) + amount) >= getCreatureMaxHealth(cid) then
   amount = math.abs(getCreatureHealth(cid)-getCreatureMaxHealth(cid))
end
if getCreatureHealth(cid) ~= getCreatureMaxHealth(cid) then           
   doCreatureAddHealth(cid, amount)
   doSendAnimatedText(getThingPosWithDebug(cid), "+"..amount.."", 65) 
end
end
          
if damageCombat == PSYCHICDAMAGE or damageCombat == MIRACLEDAMAGE then
   if getPlayerStorageValue(attacker, 95487) >= 1 then
      doHeal(attacker, valor)
      setPlayerStorageValue(attacker, 95487, -1)                  
   end
elseif damageCombat == SEED_BOMBDAMAGE then
   doHeal(attacker, valor)
end
--------------------------------------------
----------SACRED FIRE-----------------------
if combat == SACREDDAMAGE and not ehNPC(cid) then    
   local ret = {}
   ret.id = cid
   ret.cd = 9
   ret.check = getPlayerStorageValue(cid, conds["Silence"])
   ret.eff = 39
   ret.cond = "Silence"

   doCondition2(ret)
elseif combat == MUDBOMBDAMAGE and not ehNPC(cid) then
   local ret = {}                                        
   ret.id = cid
   ret.cd = 9
   ret.eff = 34
   ret.check = getPlayerStorageValue(cid, conds["Miss"])
   ret.spell = "Mud Bomb"       --alterado v1.9
   ret.cond = "Miss"
   
   doCondition2(ret)
end
---------------------------------------------
--------------Passiva Lifesteal Clobat------------
if combat == COMBAT_PHYSICALDAMAGE then
   if getCreatureName(attacker) == "Crobat" then                    
      doCreatureAddHealth(attacker, math.floor(valor))
      doSendAnimatedText(getThingPos(attacker), "+ "..math.floor(valor), 30)
   end
end
--------------------------------------------
    valor = math.abs(valor)    --alterado v1.9
    if isSummon(attacker) then
		if combat == COMBAT_PHYSICALDAMAGE then
			doTargetCombatHealth(getCreatureMaster(attacker), cid, PHYSICALDAMAGE, -valor, -valor, 255)
			addEvent(doDoubleHit, 1000, attacker, cid, valor, races)      
		else
			doTargetCombatHealth(getCreatureMaster(attacker), cid, damageCombat, -valor, -valor, 255)
		end
	else
		if combat ~= COMBAT_PHYSICALDAMAGE then
			doCreatureAddHealth(cid, -valor, 3, combats[damageCombat].cor)  
		else
            doCreatureAddHealth(cid, -valor, 3, races[getMonsterInfo(getCreatureName(cid)).race].cor)
            addEvent(doDoubleHit, 1000, attacker, cid, valor, races)   
        end

		if isSummon(cid) and valor ~= 0 then
			addEvent(sendPlayerDmgMsg, 5, getCreatureMaster(cid), "Your "..getCreatureName(cid).." lost "..valor.." hitpoints due to an attack from "..getSomeoneDescription(attacker)..".")
		end

	end
	
	if damageCombat == FIREDAMAGE and not isBurning(cid) then
	   local ret = {}
	   ret.id = cid
	   ret.cd = math.random(5, 12)
	   ret.check = getPlayerStorageValue(cid, conds["Burn"])
	   ret.damage = isSummon(attacker) and getMasterLevel(attacker)+getPokemonBoost(attacker) or getPokemonLevel(attacker)
	   ret.cond = "Burn"
	   
	   doCondition2(ret)
    elseif damageCombat == POISONDAMAGE and not isPoisoned(cid) then
       local ret = {}
	   ret.id = cid
	   ret.cd = math.random(6, 15)
	   ret.check = getPlayerStorageValue(cid, conds["Poison"])
	   local lvl = isSummon(attacker) and getMasterLevel(attacker) or getPokemonLevel(attacker)
       ret.damage = math.floor((getPokemonLevel(attacker)+lvl)/2)
	   ret.cond = "Poison"
	   
	   doCondition2(ret)
    end
--[[---------------CD BAR-----------------------
if isSummon(cid) then
   doCreatureExecuteTalkAction(getCreatureMaster(cid), "/pokeread")
end  ]]
------------------------------------POTIONS-------------------------------------------
if isSummon(cid) and type == STATSCHANGE_HEALTHLOSS then
   if getPlayerStorageValue(cid, 173) >= 1 then
      if damageCombat ~= BURNEDDAMAGE and damageCombat ~= POISONEDDAMAGE then
         setPlayerStorageValue(cid, 173, -1)  
         doSendAnimatedText(getThingPos(cid), "Lost Heal", 144)
      end
   end
end
----------------------------------------PASSIVAS-------------------------------------  
-------------------------------------------Counter Helix------------------------------------
if passivesChances["Helix"][getCreatureName(cid)] and math.random(1, 100) <= passivesChances["Helix"][getCreatureName(cid)] then
   docastspell(cid, "Counter Helix")
end
-------------------------------------------Lava Counter/Electricity----------------------------
if passivesChances["Fire_Thunder"][getCreatureName(cid)] and math.random(1, 100) <= passivesChances["Fire_Thunder"][getCreatureName(cid)] then
   docastspell(cid, "Lava-Electricity")
end
---------------------------------------Stunning Confusion-----------------------------------------
if passivesChances["Stunning"][getCreatureName(cid)] and math.random(1, 100) <= passivesChances["Stunning"][getCreatureName(cid)] then  
   docastspell(cid, "Stunning Confusion")
end
-----------------------------------------Groundshock-----------------------------------
if passivesChances["Groundshock"][getCreatureName(cid)] and math.random(1, 100) <= passivesChances["Groundshock"][getCreatureName(cid)] then
   docastspell(cid, "Groundshock")
end
--------------------------------------Electric Charge---------------------------------------------
if passivesChances["Electric Charge"][getCreatureName(cid)] and math.random(1, 100) <= passivesChances["Electric Charge"][getCreatureName(cid)] then
   docastspell(cid, "Electric Charge", 0, 0)
end
-------------------------------------Melody------------------------------------
if passivesChances["Melody"][getCreatureName(cid)] and math.random(1, 100) <= passivesChances["Melody"][getCreatureName(cid)] then 
   docastspell(cid, "Melody")
end
------------------------------------- Dragon Fury / Fury ---------------------------------------
if passivesChances["Dragon Fury"][getCreatureName(cid)] and math.random(1, 100) <= passivesChances["Dragon Fury"][getCreatureName(cid)] then
   docastspell(cid, "Dragon Fury", 0, 0)
end
------------------------------------- Mega Drain ---------------------------------------
if passivesChances["Mega Drain"][getCreatureName(cid)] and math.random(1, 100) <= passivesChances["Mega Drain"][getCreatureName(cid)] then
   docastspell(cid, "Mega Drain")
end
------------------------------------- Spores Reaction ---------------------------------------
if passivesChances["Spores Reaction"][getCreatureName(cid)] and math.random(1, 100) <= passivesChances["Spores Reaction"][getCreatureName(cid)] then
   docastspell(cid, "Spores Reaction")
end
------------------------------------ Amnesia ----------------------------------------   
if passivesChances["Amnesia"][getCreatureName(cid)] and math.random(1, 100) <= passivesChances["Amnesia"][getCreatureName(cid)] then 
   docastspell(cid, "Amnesia", 0, 0)
end
----------------------------------- Zen Mind -----------------------------------------
if passivesChances["Zen Mind"][getCreatureName(cid)] and isWithCondition(cid) and math.random(1, 100) <= passivesChances["Zen Mind"][getCreatureName(cid)] then
   docastspell(cid, "Zen Mind", 0, 0)
end
---------------------------------- Mirror Coat ---------------------------------------
if passivesChances["Mirror Coat"][getCreatureName(cid)] and math.random(1, 100) <= passivesChances["Mirror Coat"][getCreatureName(cid)] then   
   docastspell(cid, "Mirror Coat", 0, 0)
end
--------------------------------- Illusion -----------------------------------------
return false
end