--Yoyo Dino Gathering

function c50000200.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,50000200)
	e1:SetTarget(c50000200.target)
	e1:SetOperation(c50000200.activate)
	c:RegisterEffect(e1)
end

function c50000200.filter1(c,tp)
	return c:IsLevelAbove(1) and c:IsType(TYPE_NORMAL)
		and Duel.IsExistingTarget(c50000200.filter2,tp,LOCATION_MZONE,0,1,c)
end
function c50000200.filter2(c)
	return c:IsLevelAbove(1)
end
function c50000200.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c50000200.filter1,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g1=Duel.SelectTarget(tp,c50000200.filter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c50000200.filter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst(),g1:GetFirst():GetRace())
end
function c50000200.mfilter(c)
	return c:IsFaceup() and not c:IsType(TYPE_TOKEN)
end
function c50000200.xyzfilter(c,mg)
	return c:IsSetCard(0x70a) and c:IsXyzSummonable(mg)
end
function c50000200.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	if tc1:IsRelateToEffect(e) and tc1:IsFaceup() and tc2:IsRelateToEffect(e) and tc2:IsFaceup() then
		local lv=tc1:GetLevel()+tc2:GetLevel()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL_FINAL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc1:RegisterEffect(e1)
		local e2=e1:Clone()
		tc2:RegisterEffect(e2)
		Duel.BreakEffect()
		local mg=Duel.GetMatchingGroup(c50000200.mfilter,tp,LOCATION_MZONE,0,nil)
		local xyzg=Duel.GetMatchingGroup(c50000200.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
		if xyzg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(50000200,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
			Duel.XyzSummon(tp,xyz,mg,1,99)
		end
	end
end