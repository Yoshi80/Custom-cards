-- Yoyo Dino Snowfall

function c50000194.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,50000194)
	e1:SetTarget(c50000194.target)
	e1:SetOperation(c50000194.activate)
	c:RegisterEffect(e1)
end

function c50000194.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL) and not c:IsType(TYPE_TUNER)
end
function c50000194.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c50000194.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c50000194.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c50000194.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c50000194.scfilter(c)
	return c:IsSetCard(0x70a) and c:IsSynchroSummonable(nil)
end
function c50000194.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c50000194.filter(tc) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e1)
		local g=Duel.GetMatchingGroup(c50000194.scfilter,tp,LOCATION_EXTRA,0,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(50000194,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SynchroSummon(tp,sg:GetFirst(),nil)
		end
	end
end