-- Fairy Spirit - Scorpio

function c50000101.initial_effect(c)
	c:EnableReviveLimit()
	--attack all
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_ALL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c50000101.destg)
	e2:SetValue(c50000101.value)
	e2:SetOperation(c50000101.desop)
	c:RegisterEffect(e2)
end

function c50000101.dfilter(c)
	return not c:IsReason(REASON_REPLACE) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsType(TYPE_RITUAL)
end
function c50000101.repfilter(c)
	return ((c:IsAttribute(ATTRIBUTE_LIGHT) and c:GetAttack()==1850) or (c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER))) and c:IsAbleToRemove() and aux.SpElimFilter(c,true)
end
function c50000101.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local count=eg:FilterCount(c50000101.dfilter,nil)
		e:SetLabel(count)
		return count>0 and Duel.IsExistingMatchingCard(c50000101.repfilter,tp,LOCATION_GRAVE,0,count,nil)
	end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c50000101.value(e,c)
	return c:IsFaceup() and c:GetLocation()==LOCATION_MZONE and c:IsType(TYPE_RITUAL)
end
function c50000101.desop(e,tp,eg,ep,ev,re,r,rp)
	local count=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
	local g=Duel.SelectMatchingCard(tp,c50000101.repfilter,tp,LOCATION_GRAVE,0,count,count,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end