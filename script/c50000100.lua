-- Control over the Celestial Keys

function c50000100.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,50000100+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c50000100.target)
	e1:SetOperation(c50000100.activate)
	c:RegisterEffect(e1)
end

function c50000100.tfilter(c,lvl,e,tp)
	return c:IsType(TYPE_RITUAL) and c:GetLevel()==lvl and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c50000100.filter(c,e,tp)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_RITUAL)
		and Duel.IsExistingMatchingCard(c50000100.tfilter,tp,LOCATION_HAND,0,1,nil,c:GetLevel(),e,tp)
end
function c50000100.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c50000100.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c50000100.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c50000100.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c50000100.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c50000100.tfilter,tp,LOCATION_HAND,0,1,1,nil,tc:GetLevel(),e,tp)
	if sg:GetCount()>0 then
		Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
	end
end