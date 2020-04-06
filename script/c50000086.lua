-- Whis' Guidance

function c50000086.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,50000086+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c50000086.cost)
	e1:SetTarget(c50000086.target)
	e1:SetOperation(c50000086.activate)
	c:RegisterEffect(e1)
end

function c50000086.costfilter(c)
	return c:IsSetCard(0x702) and c:IsLevelAbove(7) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c50000086.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50000086.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c50000086.costfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c50000086.filter(c)
	return c:IsLevelBelow(7) and c:IsSetCard(0x702) and c:IsAbleToHand()
end
function c50000086.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50000086.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c50000086.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c50000086.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end