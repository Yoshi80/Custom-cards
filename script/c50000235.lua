--Separation of Nohr and Hoshido
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(9)
	return true
end
function s.filter1(c)
	return c:IsSetCard(0x70c) and c:IsAbleToHand()
end
function s.filter2(c)
	return c:IsSetCard(0x70b) and c:IsAbleToHand()
end
function s.cfilter1(c)
	return c:IsSetCard(0x70b) and c:IsDiscardable()
end
function s.cfilter2(c)
	return c:IsSetCard(0x70c) and c:IsDiscardable()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local b1=nil
	local b2=nil
	-- label is 9 means checks costs
	-- label is 0 means checks target
	if e:GetLabel()==9 then
		b1=Duel.IsExistingMatchingCard(s.cfilter1,tp,LOCATION_HAND,0,1,nil)
		b2=Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_HAND,0,1,nil)
	else
		b1=Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_DECK,0,1,nil)
		b2=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK,0,1,nil)
	end
	if chk==0 then
		e:SetLabel(0)
		return b1 or b2
	end
	local sel=0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	if b1 and b2 then
		sel=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
	elseif b1 then
		sel=Duel.SelectOption(tp,aux.Stringid(id,0))
	else
		sel=Duel.SelectOption(tp,aux.Stringid(id,1))+1
	end
	if sel==0 then
		if e:GetLabel()==9 then
			Duel.DiscardHand(tp,s.cfilter1,1,1,REASON_COST+REASON_DISCARD,nil)
		end
	else
		if e:GetLabel()==9 then
			Duel.DiscardHand(tp,s.cfilter2,1,1,REASON_COST+REASON_DISCARD,nil)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	e:SetLabel(sel)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=nil
	if e:GetLabel()==0 then
		g=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_DECK,0,1,1,nil)
	else
		g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_DECK,0,1,1,nil)
	end
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end