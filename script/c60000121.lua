--Meyneth's Benediction
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c,nil,s.filter)
	--no damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e2:SetCondition(s.damcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--destroy sub
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	e3:SetValue(s.desval)
	c:RegisterEffect(e3)
end
function s.filter(c)
	return c:IsLevelBelow(4) and c:IsRace(RACE_MACHINE)
end
function s.damcon(e)
	return e:GetHandler():GetEquipTarget():GetControler()==e:GetHandlerPlayer()
end
function s.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tg=c:GetEquipTarget()
	if chk==0 then return tg 
		and (tg:IsReason(REASON_BATTLE) or (tg:IsReason(REASON_EFFECT) and ep~=tp))
		and Duel.IsCanRemoveCounter(tp,1,0,COUNTER_SPELL,1,REASON_EFFECT) end
	return true
end
function s.desval(e,re,r,rp)
	return (r&REASON_BATTLE)~=0 or rp~=e:GetHandlerPlayer()
end