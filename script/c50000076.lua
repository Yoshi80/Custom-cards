-- Bender's Drift

function c50000076.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCost(c50000076.cost)
	e1:SetCondition(c50000076.condition)
	e1:SetTarget(c50000076.target)
	e1:SetOperation(c50000076.activate)
	c:RegisterEffect(e1)
end
c50000076.listed_names={50000066}

function c50000076.cfilter1(c,tp)
	return c:IsCode(50000066) and c:GetPreviousControler()==tp and c:IsAbleToRemoveAsCost() and c:IsLocation(LOCATION_GRAVE)
end
function c50000076.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c50000076.cfilter1,1,nil,tp)
end
function c50000076.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c50000076.cfilter1,1,nil,tp) end
	local g=eg:Filter(c50000076.cfilter1,nil,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c50000076.sumfilter(c)
	return c:IsCode(50000066)
end
function c50000076.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c50000076.sumfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c50000076.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c50000076.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SUMMON_PROC)
		e1:SetCondition(c50000076.ntcon)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		if tc:IsSummonableCard() then
			Duel.Summon(tp,tc,true,nil)
		end
	end
end

function c50000076.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end