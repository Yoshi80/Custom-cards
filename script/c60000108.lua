--Shake Your Tail
local s,id=GetID()
function s.initial_effect(c)
	--Reflect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.listed_names={50000439}
function s.spfilter(c)
	return c:IsCode(50000439) and c:IsFaceup()
end
function s.spfilter2(c)
	return c:IsSetCard(0x713) and c:IsFaceup()
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_DAMAGE)
	e:SetLabel(cv)
	return Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_MZONE,0,1,nil)
		and ep==1-tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and aux.damcon1(e,tp,eg,ep,ev,re,r,rp)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local dam=Duel.Damage(1-tp,e:GetLabel(),REASON_EFFECT)
	if dam>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_ONFIELD,0,1,nil) then
		Duel.Recover(tp,dam,REASON_EFFECT)
	end
end