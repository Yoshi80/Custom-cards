-- Contract Establishment

function c50000097.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,50000097+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c50000097.cost)
	e1:SetTarget(c50000097.target)
	e1:SetOperation(c50000097.activate)
	c:RegisterEffect(e1)
end

function c50000097.cfilter(c,ft,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:GetAttack()==1850 and c:IsControler(tp)
end
function c50000097.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,c50000097.cfilter,1,false,nil,nil,ft,tp) end
	local rg=Duel.SelectReleaseGroupCost(tp,c50000097.cfilter,1,1,false,nil,nil,ft,tp)
	Duel.Release(rg,REASON_COST)
end
function c50000097.filter(c)
	return c:IsSetCard(0x703) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c50000097.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50000097.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c50000097.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c50000097.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end