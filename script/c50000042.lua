-- Harmony Element of Kindness

function c50000042.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,500000421)
	e1:SetCondition(c50000042.notcon)
	e1:SetTarget(c50000042.target)
	e1:SetOperation(c50000042.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,500000421)
	e2:SetCondition(c50000042.con)
	e2:SetTarget(c50000042.sptg)
	e2:SetOperation(c50000042.spop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,500000422)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c50000042.tdtg)
	e3:SetOperation(c50000042.tdop)
	c:RegisterEffect(e3)
end

function c50000042.notcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)<5
end

function c50000042.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)>=5
end

function c50000042.filter(c,e,tp)
	local lv=c:GetLevel()
	local mg=Duel.GetMatchingGroup(c50000042.filter2,tp,LOCATION_GRAVE,0,nil,e,tp,lv)
	return lv>0 and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and mg:GetCount()>0
end

function c50000042.filter2(c,e,tp,lvl)
	local lv=c:GetLevel()
	local mg=Duel.GetMatchingGroup(c50000042.filter3,tp,LOCATION_EXTRA,0,nil,e,tp,7)
	return lv>0 and c:GetLevel()==lvl and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and mg:GetCount()>0
end

function c50000042.filter3(c,e,tp,rk)
	return not c:IsFaceup() and c:GetRank()==rk
end

function c50000042.xyzfilter(c)
	return c:IsType(TYPE_XYZ) and not c:IsFaceup()
end

function c50000042.mfilter1(c,mg,exg)
	return mg:IsExists(c50000042.mfilter2,1,c,c,exg,c:GetLevel())
end

function c50000042.mfilter2(c,mc,exg,lvl)
	return c:GetLevel()==lvl and exg:IsExists(c50000042.mxyzfilter,1,c,7)
end

function c50000042.mxyzfilter(c,rk)
	return c:GetRank()==rk
end

function c50000042.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local mg=Duel.GetMatchingGroup(c50000042.filter,tp,LOCATION_GRAVE,0,nil,e,tp)
	local exg=Duel.GetMatchingGroup(c50000042.xyzfilter,tp,LOCATION_EXTRA,0,nil)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and mg:GetCount()>0 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg1=mg:FilterSelect(tp,c50000042.mfilter1,1,1,nil,mg,exg)
	local tc1=sg1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg2=mg:FilterSelect(tp,c50000042.mfilter2,1,1,tc1,tc1,exg,tc1:GetLevel())
	sg1:Merge(sg2)
	Duel.SetTargetCard(sg1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg1,2,0,0)
end

function c50000042.filter4(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c50000042.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c50000042.filter4,nil,e,tp)
	if g:GetCount()<2 then return end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	local newlvl=7
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(newlvl)
	e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
	tc1:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_LEVEL)
	e2:SetValue(newlvl)
	e2:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
	tc2:RegisterEffect(e2)
	Duel.BreakEffect()
	local xyzg=Duel.GetMatchingGroup(c50000042.filter3,tp,LOCATION_EXTRA,0,nil,e,tp,newlvl)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,g)
	end
end

function c50000042.spfilter(c,e,tp)
	return c:IsCode(50000041) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,true)
end

function c50000042.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c50000042.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function c50000042.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c50000042.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		if Duel.SpecialSummon(g,SUMMON_TYPE_XYZ,tp,tp,true,true,POS_FACEUP)~=0 then
			if c:IsRelateToEffect(e) then
				c:CancelToGrave()
				Duel.Overlay(g:GetFirst(),Group.FromCards(c))
			end
		end
	end
end

function c50000042.recfilter(c)
	return c:IsFaceup() and c:GetBaseAttack()>0
end

function c50000042.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c50000042.recfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c50000042.recfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c50000042.recfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetFirst():GetBaseAttack())
end
function c50000042.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:GetAttack()>0 then
		Duel.Recover(tp,tc:GetBaseAttack(),REASON_EFFECT)
	end
end