--- Poltergust Booster

function c50000031.initial_effect(c)
	c:SetUniqueOnField(1,0,50000031)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c50000031.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(c50000031.spcon)
	e2:SetTarget(c50000031.sptg)
	e2:SetOperation(c50000031.spop)
	c:RegisterEffect(e2)
end

function c50000031.filter(c)
	return c:IsCode(50000023) and c:IsAbleToHand()
end

function c50000031.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c50000031.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(50000031,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end

function c50000031.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:GetOriginalAttribute()==ATTRIBUTE_WIND and c:GetOriginalRace()==RACE_FIEND and c:GetOriginalLevel()==2
		and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end

function c50000031.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c50000031.cfilter,1,nil,tp) and eg:GetCount()==1
end

function c50000031.spfilter(c,e,tp,code)
	return c:IsRace(RACE_FIEND) and c:IsLevel(2) and c:IsAttribute(ATTRIBUTE_WIND) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c50000031.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		local g=eg:Filter(c50000031.cfilter,nil,tp)
		local tc=g:GetFirst()
		local code=tc:GetCode()
		e:SetLabel(code)
		return Duel.IsExistingMatchingCard(c50000031.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,code)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c50000031.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

function c50000031.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc = Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end