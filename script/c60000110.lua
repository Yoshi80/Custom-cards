--Under Our Spell
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_names={50000439}
function s.cfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x1713)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetTurnPlayer()~=tp or Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_MZONE,0,1,nil))
end
function s.filter(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function s.spfilter(c)
	return c:IsCode(50000439) and c:IsFaceup()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if Duel.GetTurnPlayer()==tp then
			Duel.GetControl(tc,tp,PHASE_END,3)
		else
			Duel.GetControl(tc,tp,PHASE_END,2)
		end
		if Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_ONFIELD,0,1,nil) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_ADD_SETCODE)
			e1:SetValue(0x713)
			if Duel.GetTurnPlayer()==tp then
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,3)
			else
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
			end
			tc:RegisterEffect(e1)
		end
	end
end
