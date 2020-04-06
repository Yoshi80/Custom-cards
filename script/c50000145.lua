-- Winged-Cat Support

function c50000145.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c50000145.target)
	e1:SetOperation(c50000145.activate)
	c:RegisterEffect(e1)
end

function c50000145.cfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsType(TYPE_LINK)
end
function c50000145.filter(c,e,tp)
	return c:IsType(TYPE_XYZ)
end
function c50000145.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c50000145.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c50000145.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(c50000145.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c50000145.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c50000145.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsExistingMatchingCard(c50000145.cfilter,tp,LOCATION_MZONE,0,1,nil) then return end
	local tc1=Duel.GetFirstTarget()
	if not tc1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c50000145.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc2=g:GetFirst()
	if not tc2 then return end
	if tc1:IsRelateToEffect(e) then 
		Duel.Equip(tp,tc1,tc2,true)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c50000145.eqlimit)
		e1:SetLabelObject(tc2)
		tc1:RegisterEffect(e1)
		--atkup
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_DIRECT_ATTACK)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc1:RegisterEffect(e2)
	end
end
function c50000145.eqlimit(e,c)
	return c==e:GetLabelObject()
end