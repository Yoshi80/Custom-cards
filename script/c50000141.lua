-- Eating Fish! Aye Sir!

function c50000141.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c50000141.activate)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50000141,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,50000141)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(c50000141.cost)
	e2:SetTarget(c50000141.target)
	e2:SetOperation(c50000141.operation)
	c:RegisterEffect(e2,false,1)
end

function c50000141.filter(c)
	return c:IsLevelBelow(3) and c:IsRace(RACE_FISH) and c:GetAttack()<=1000 and c:IsAbleToHand()
end
function c50000141.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c50000141.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(50000141,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end

function c50000141.cfilter(c,ft,tp)
	return c:IsLevelBelow(3) and c:IsRace(RACE_FISH) and c:GetAttack()<=1000 and c:IsControler(tp)
end
function c50000141.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>0 and Duel.CheckReleaseGroupCost(tp,c50000141.cfilter,1,false,nil,nil,ft,tp) end
	local rg=Duel.SelectReleaseGroupCost(tp,c50000141.cfilter,1,1,false,nil,nil,ft,tp)
	Duel.Release(rg,REASON_COST)
end
function c50000141.filter2(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c50000141.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50000141.filter2,tp,LOCATION_MZONE,0,1,nil) end
end
function c50000141.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c50000141.filter2,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(c50000141.efilter)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c50000141.efilter(e,te)
	return e:GetOwnerPlayer()~=te:GetOwnerPlayer()
end