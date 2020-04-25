--Mastery of the Monado Arts
local s,id=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--pos
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(s.condition)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()==tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function s.filter1(c)
	return c:IsSetCard(0x712) and c:IsType(TYPE_SPELL) and c:IsAbleToDeck()
end
function s.filter2(c)
	return c:IsSetCard(0x712) and c:IsType(TYPE_SPELL) and not c:IsCode(50000425) and c:IsAbleToRemove()
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local b1=Duel.IsExistingTarget(s.filter1,tp,LOCATION_HAND,0,1,nil)
	local b2=Duel.IsExistingTarget(s.filter2,tp,LOCATION_GRAVE,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(id,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(id,1))+1
	end
	e:SetLabel(op)
	if op==0 then
		Duel.SetTargetPlayer(tp)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
	else
		Duel.SetTargetPlayer(tp)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if e:GetLabel()==0 then
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(p,s.filter1,p,LOCATION_HAND,0,1,63,nil)
		if #g>0 then
			Duel.ConfirmCards(1-p,g)
			local ct=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
			Duel.ShuffleDeck(p)
			Duel.BreakEffect()
			Duel.Draw(p,ct,REASON_EFFECT)
		end
	else
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(p,s.filter2,p,LOCATION_GRAVE,0,1,63,nil)
		if #g>0 then
			local ct=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			Duel.BreakEffect()
			Duel.Draw(p,ct,REASON_EFFECT)
		end
	end
end