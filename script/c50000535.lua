--Zora Savior Link
local s,id=GetID()
function s.initial_effect(c)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(s.adcost)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+1000)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
function s.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and Duel.IsAbleToEnterBP()
end
function s.filter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER) and not c:IsHasEffect(EFFECT_DIRECT_ATTACK)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
		and (re:GetHandler():IsRace(RACE_FISH) or re:GetHandler():IsRace(RACE_SEASERPENT) or re:GetHandler():IsRace(RACE_AQUA))
end
function s.spfilter(c,e)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsCanBeEffectTarget(e)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e)
	if chkc then return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and s.spfilter(c,e) end
	if chk==0 then return #g>=3 end
	if #g>=6 then
		op=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(id,0))
	end
	local tgc=3+op*3
	e:SetLabel(tgc)
	local tg=aux.SelectUnselectGroup(g,e,tp,tgc,tgc,nil,1,tp,HINTMSG_TODECK)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,#tg,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp,c)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tgc=e:GetLabel()
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=tgc then return end
	Duel.SendtoDeck(tg,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
	Duel.SortDeckbottom(tp,tp,tgc)
	Duel.Draw(tp,tgc/3,REASON_EFFECT)
end
