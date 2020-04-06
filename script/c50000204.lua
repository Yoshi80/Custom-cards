--Yoyo Dino Flower Freedom

function c50000204.initial_effect(c)
	-- Ritual Summon
	aux.AddRitualProcEqual(c,aux.FilterBoolFunction(Card.IsSetCard,0x70a),nil,nil,c50000204.extrafil,c50000204.extraop,c50000204.matfil):SetCountLimit(1,500002042+EFFECT_COUNT_CODE_OATH)
	-- to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,500002041)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c50000204.sptg)
	e2:SetOperation(c50000204.spop)
	c:RegisterEffect(e2)
end

function c50000204.matfil(c)
	return c:IsSetCard(0x70a)
end
function c50000204.exfilter0(c)
	return c:IsSetCard(0x70a) and c:GetLevel()>=1 and c:IsReleasableByEffect()
end
function c50000204.extrafil(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetMatchingGroup(c50000204.exfilter0,tp,LOCATION_EXTRA,0,nil)
end
function c50000204.extraop(mg,e,tp,eg,ep,ev,re,r,rp)
	local mat2=mg:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
	mg:Sub(mat2)
	Duel.ReleaseRitualMaterial(mg)
	Duel.SendtoGrave(mat2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL+REASON_RELEASE)
end

function c50000204.spfilter(c,e,tp)
	return c:IsSetCard(0x70a) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c50000204.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c50000204.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c50000204.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c50000204.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c50000204.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ShuffleHand(tp)
	end
end