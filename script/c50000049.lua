-- Combustion of Laughter

function c50000049.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,50000049)
	e1:SetCost(c50000049.cost)
	e1:SetOperation(c50000049.activate)
	c:RegisterEffect(e1)
end

function c50000049.filter(c)
	return c:IsSetCard(0x701) and c:IsDiscardable()
end
function c50000049.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50000049.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c50000049.filter,1,1,REASON_COST+REASON_DISCARD)
end

function c50000049.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(1-tp,2)
	if g:GetCount()<2 then return end
	Duel.SendtoHand(g,tp,REASON_EFFECT)
end