-- Twin Universes Clashes

function c50000089.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,50000089+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c50000089.cost)
	e1:SetTarget(c50000089.target)
	e1:SetOperation(c50000089.activate)
	e1:SetLabel(0)
	c:RegisterEffect(e1)
end

function c50000089.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c50000089.costfilter(c,e,tp)
	return c:GetOriginalLevel()>0 and c:IsSetCard(0x702) and Duel.IsExistingMatchingCard(c50000089.spfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,c,e,tp)
end
function c50000089.spfilter(c,tc,e,tp)
	return c:GetOriginalLeftScale()==tc:GetOriginalLevel() and c:IsSetCard(0x702)
		and (c:IsLocation(LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE) or c:IsFaceup())
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c50000089.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
			and Duel.CheckReleaseGroupCost(tp,c50000089.costfilter,1,false,nil,nil,e,tp)
	end
	e:SetLabel(0)
	local g=Duel.SelectReleaseGroupCost(tp,c50000089.costfilter,1,1,false,nil,nil,e,tp)
	Duel.Release(g,REASON_COST)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA)
end
function c50000089.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c50000089.spfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,tc,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end