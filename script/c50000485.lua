--Advent of Planet X
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.cfilter(c)
	return c:IsCode(27204311) and not c:IsPublic()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then
		return #g>0 and Duel.GetMZoneCount(tp,g,tp)>0 and Duel.GetMZoneCount(1-tp,g,tp)>0
			and Duel.IsPlayerCanSpecialSummonCount(tp,1)
			and Duel.IsPlayerCanSpecialSummonMonster(tp,27204312,0,TYPES_TOKEN,g:GetSum(Card.GetBaseAttack),g:GetSum(Card.GetBaseDefense),11,RACE_ROCK,ATTRIBUTE_LIGHT,POS_FACEUP,1-tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function s.operationvalueatk(c)
	return math.max(c:GetBaseAttack(),0)
end
function s.operationvaluedef(c)
	return math.max(c:GetBaseDefense(),0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.FilterFaceupFunction(Card.IsReleasable),tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if Duel.Release(g,REASON_EFFECT)==0 then return end
	local og=Duel.GetOperatedGroup()
	if Duel.GetMZoneCount(1-tp,nil,tp)>0 then
		local atk=og:GetSum(s.operationvalueatk)
		local def=og:GetSum(s.operationvaluedef)
		if not Duel.IsPlayerCanSpecialSummonMonster(tp,27204312,0,TYPES_TOKEN,atk,def,11,RACE_ROCK,ATTRIBUTE_LIGHT,POS_FACEUP,1-tp) then return end
		Duel.BreakEffect()
		local token=Duel.CreateToken(tp,27204312)
		Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_DEFENSE)
		e2:SetValue(def)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e2)
		Duel.SpecialSummonComplete()
	end
end