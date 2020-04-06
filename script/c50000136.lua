-- Dragon Slayer's Rebirth

function c50000136.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,50000136)
	e1:SetTarget(c50000136.target)
	e1:SetOperation(c50000136.activate)
	c:RegisterEffect(e1)
end

function c50000136.filter(c)
	return c:IsSetCard(0x705) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_LINK) and c:IsAbleToDeck()
end
function c50000136.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE and c50000136.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c50000136.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c50000136.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c50000136.spfilter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
		and Duel.IsExistingMatchingCard(c50000136.spfilter3,tp,LOCATION_GRAVE,0,1,c,e,tp,c:GetRace())
end
function c50000136.spfilter3(c,e,tp,race)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
		and c:GetRace()==race
end
function c50000136.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
		if not Duel.IsPlayerAffectedByEffect(tp,59822133) 
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
			and Duel.IsExistingMatchingCard(c50000136.spfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp)
			and Duel.SelectYesNo(tp,aux.Stringid(50000136,0)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g1=Duel.SelectMatchingCard(tp,c50000136.spfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
				if g1:GetCount()==0 then return end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c50000136.spfilter3),tp,LOCATION_GRAVE,0,1,1,g1:GetFirst(),e,tp,g1:GetFirst():GetRace())
				g1:Merge(g2)
				tc2=g1:GetFirst()
				while tc2 do
					Duel.SpecialSummonStep(tc2,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_DISABLE)
					e1:SetReset(RESET_EVENT+0x1fe0000)
					tc2:RegisterEffect(e1)
					local e2=Effect.CreateEffect(e:GetHandler())
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetCode(EFFECT_DISABLE_EFFECT)
					e2:SetReset(RESET_EVENT+0x1fe0000)
					tc2:RegisterEffect(e2)
					tc2=g1:GetNext()
				end
				Duel.SpecialSummonComplete()
		end
	end
end