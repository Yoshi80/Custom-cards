--- Infernal Imp

function c35200002.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c35200002.matfilter,2,2)
	c:EnableReviveLimit()
	--atk/def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c35200002.indtg)
	e1:SetValue(c35200002.damval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(35200002,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,35200002)
	e3:SetCondition(c35200002.condition)
	e3:SetOperation(c35200002.operation)
	c:RegisterEffect(e3)
end

function c35200002.damval(e,re,val,r,rp,rc)
	local atk=e:GetHandler():GetAttack()
	return atk
end

function c35200002.matfilter(c,lc,sumtype,tp)
	return not c:IsType(TYPE_TOKEN,lc,sumtype,tp)
end

function c35200002.indtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end

function c35200002.filter(c,tp)
	return c:IsType(TYPE_NORMAL)
end
function c35200002.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c35200002.filter,1,nil,tp)
end
function c35200002.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
end
function c35200002.tgcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_END
		and e:GetHandler():GetFlagEffect(35200002)==0
end