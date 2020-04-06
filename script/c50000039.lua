-- Harmony Element of Loyalty

function c50000039.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c50000039.target)
	e1:SetOperation(c50000039.activate)
	c:RegisterEffect(e1)
	--cannot direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50000039,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_ATTACK)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c50000039.grcondition)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(c50000039.groperation)
	c:RegisterEffect(e2)
end

function c50000039.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
			and (Duel.IsPlayerCanSpecialSummonMonster(tp,50000040,0,0x5011,0,0,1,RACE_THUNDER,ATTRIBUTE_WIND)) 
	end
	local lv=1
	if Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)>=5 then
		lv=Duel.AnnounceLevel(tp,1,8,nil)
	end
	Duel.SetTargetParam(lv)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end

function c50000039.mfilter(c)
	return c:IsType(TYPE_TUNER)
end

function c50000039.cfilter(c,syn)
	return syn:IsSynchroSummonable(c)
end

function c50000039.spfilter(c,mg)
	return mg:IsExists(c50000039.cfilter,1,nil,c)
end

function c50000039.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lv=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,50000040,0,0x4011,0,0,lv,RACE_THUNDER,ATTRIBUTE_WIND) then return end
	local token=Duel.CreateToken(tp,50000040)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c50000039.splimit)
	token:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_LEVEL)
	e2:SetValue(lv)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	token:RegisterEffect(e2)
	local mg=Duel.GetMatchingGroup(c50000039.mfilter,tp,LOCATION_MZONE,0,nil)
	if Duel.IsExistingMatchingCard(c50000039.spfilter,tp,LOCATION_EXTRA,0,1,nil,mg) and Duel.SelectYesNo(tp,aux.Stringid(50000039,0)) then
		local g=Duel.GetMatchingGroup(c50000039.spfilter,tp,LOCATION_EXTRA,0,nil,mg)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
			local tg=mg:FilterSelect(tp,c50000039.cfilter,1,1,nil,sg:GetFirst())
			Duel.SynchroSummon(tp,sg:GetFirst(),tg:GetFirst())
		end
	end
end

function c50000039.splimit(e,c)
	return not c:IsSetCard(0x701)
end

function c50000039.grcondition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetTurnPlayer()~=tp and (Duel.IsAbleToEnterBP() or (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE))
end
function c50000039.groperation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end