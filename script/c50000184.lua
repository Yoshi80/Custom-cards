-- Minoth the Legendary Blade

function c50000184.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c50000184.matfilter,1,1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50000184,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(2,50000184)
	e1:SetTarget(c50000184.sptg)
	e1:SetOperation(c50000184.spop)
	c:RegisterEffect(e1)
end	

function c50000184.matfilter(c,scard,sumtype,tp)
	return c:IsAttribute(ATTRIBUTE_DARK,scard,sumtype,tp) and not c:IsType(TYPE_LINK)
end

function c50000184.filter(c,e,tp,zone)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,tp,zone)
end
function c50000184.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=Duel.GetLinkedZone(tp)&0x1f
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c50000184.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,zone) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c50000184.spop(e,tp,eg,ep,ev,re,r,rp)
	local zone=Duel.GetLinkedZone(tp)&0x1f
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or zone==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c50000184.filter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp,zone)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE,zone)
	end
end