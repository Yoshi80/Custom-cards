--- Masaki the Red-Eyes Swordsman

function c35200008.initial_effect(c)
	aux.EnableDualAttribute(c)
	aux.EnablePendulumAttribute(c)
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(35200008,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c35200008.target)
	e1:SetOperation(c35200008.operation)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(35200008,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_CONFIRM)
	e2:SetCondition(aux.IsDualState)
	e2:SetTarget(c35200008.targ)
	e2:SetOperation(c35200008.op)
	c:RegisterEffect(e2)
end

function c35200008.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x3b) and c:GetLevel()>0
end
function c35200008.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c35200008.filter(chkc) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c35200008.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c35200008.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local op=0
	if g:GetFirst():GetLevel()<=2 then op=Duel.SelectOption(tp,aux.Stringid(35200008,1))
	else op=Duel.SelectOption(tp,aux.Stringid(35200008,1),aux.Stringid(35200008,2)) end
	e:SetLabel(op)
end
function c35200008.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		if e:GetLabel()==0 then
			e1:SetValue(1)
		else e1:SetValue(-2) end
		tc:RegisterEffect(e1)
	end
end

function c35200008.targ(e,tp,eg,ep,ev,re,r,rp,chk)
	local t=Duel.GetAttackTarget()
	if chk ==0 then	return Duel.GetAttacker()==e:GetHandler() and t~=nil end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,t,1,0,0)
end
function c35200008.op(e,tp,eg,ep,ev,re,r,rp)
	local t=Duel.GetAttackTarget()
	if t~=nil and t:IsRelateToBattle() then
		Duel.Destroy(t,REASON_EFFECT)
	end
end