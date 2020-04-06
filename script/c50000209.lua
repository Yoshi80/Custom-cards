--Blazing Darmanitan

function c50000209.initial_effect(c)
	--summon with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50000209,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c50000209.ntcon)
	c:RegisterEffect(e1)
	--synchro summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50000209,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c50000209.sccon)
	e2:SetTarget(c50000209.sctg)
	e2:SetOperation(c50000209.scop)
	c:RegisterEffect(e2)
end

function c50000209.ntfilter(c)
	return c:IsFaceup() and c:IsCode(50000208)
end
function c50000209.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c50000209.ntfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end

function c50000209.filter(c)
	return c:IsCode(50000209) and c:IsFaceup()
end
function c50000209.sccon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.IsExistingMatchingCard(c50000209.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
		and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function c50000209.mfilter(c)
	return c:IsCode(50000209)
end
function c50000209.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local mg=Duel.GetMatchingGroup(c50000209.mfilter,tp,LOCATION_MZONE,0,nil)
		return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,mg:GetFirst()) 
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c50000209.cfilter(c,syn)
	return syn:IsSynchroSummonable(c)
end
function c50000209.spfilter(c,mg)
	return mg:IsExists(c50000209.cfilter,1,nil,c)
end
function c50000209.scop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(c50000209.mfilter,tp,LOCATION_MZONE,0,nil)
	local g=Duel.GetMatchingGroup(c50000209.spfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tg=mg:FilterSelect(tp,c50000209.cfilter,1,1,nil,sg:GetFirst())
		Duel.SynchroSummon(tp,sg:GetFirst(),tg:GetFirst())
	end
end