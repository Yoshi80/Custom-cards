--Daphne's Trick
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--cannot be tribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UNRELEASABLE_SUM)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e3)
	--quick
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	e4:SetCountLimit(1)
	e4:SetCondition(s.qcon)
	e4:SetTarget(s.qtg)
	e4:SetOperation(s.qop)
	c:RegisterEffect(e4)
end
function s.filter(c,e,sp)
	return c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE,1-tp)>0 
		and Duel.IsExistingMatchingCard(s.filter,1-tp,LOCATION_GRAVE,0,1,nil,e,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,1-tp,LOCATION_GRAVE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE,1-tp)<=0 then return end
	local g1=Duel.SelectMatchingCard(1-tp,aux.NecroValleyFilter(s.filter),1-tp,LOCATION_GRAVE,0,1,1,nil,e,1-tp)
	if #g1>0 then
		Duel.SpecialSummon(g1,0,1-tp,1-tp,false,false,POS_FACEUP)
	end
end
function s.qcon(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	return d:IsFaceup() and d:IsControler(tp)
end
function s.qtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttackTarget()
	if chk==0 then return tg:IsOnField() and tg:IsPosition(POS_FACEUP_ATTACK) end
end
function s.qop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tg=Duel.GetAttackTarget()
	Duel.ChangePosition(tg,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE)
end