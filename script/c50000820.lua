--Smash Taunt
local s,id=GetID()
function s.initial_effect(c)
	--Change position and negate effects
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function s.disfilter(c)
	return c:IsFaceup() and c:IsAttackPos()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil) 
		and Duel.IsExistingTarget(s.disfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g1=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	Duel.SelectTarget(tp,s.disfilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc1=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc2=g:GetFirst()
	if tc2==tc1 then tc2=g:GetNext() end
	if tc1:IsRelateToEffect(e) and tc2:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-800)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc2:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ONLY_ATTACK_MONSTER)
		e2:SetTargetRange(0,LOCATION_MZONE)
		e2:SetValue(s.atklimit)
		e2:SetLabel(tc1:GetRealFieldID())
		e2:SetReset(RESET_PHASE+PHASE_END)
		tc2:RegisterEffect(e2,true)
		--must attack
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetTargetRange(0,LOCATION_MZONE)
		e3:SetCode(EFFECT_MUST_ATTACK)
		e3:SetReset(RESET_PHASE+PHASE_END)
		tc2:RegisterEffect(e3,true)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc2:RegisterEffect(e4,true)
	end
end
function s.atklimit(e,c)
	return c:GetRealFieldID()==e:GetLabel()
end