-- Hakaishin - Heles
local s,id=GetID()
function s.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	--atk up (p zone)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCost(s.atkcost1)
	e1:SetTarget(s.atktg1)
	e1:SetOperation(s.atkop1)
	c:RegisterEffect(e1)
	--cannot be battle target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(s.tg)
	c:RegisterEffect(e2)
end
function s.atkfilter1(c,tp)
	return c:IsSetCard(0x702) and c:IsLevelAbove(7) and Duel.IsExistingTarget(s.atkfilter2,tp,LOCATION_MZONE,0,1,c)
end
function s.atkfilter2(c)
	return c:IsSetCard(0x702) and c:IsLevelBelow(7) and c:IsFaceup()
end
function s.atkcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,s.atkfilter1,1,false,nil,nil,tp) end
	local g=Duel.SelectReleaseGroupCost(tp,s.atkfilter1,1,1,false,nil,nil,tp)
	e:SetLabel(g:GetFirst():GetBaseAttack())
	Duel.Release(g,REASON_COST)
end
function s.atktg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.atkfilter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.atkfilter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.atkfilter2,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.atkop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function s.tg(e,c)
	return c~=e:GetHandler() and c:IsFaceup() and c:IsSetCard(0x702) and c:IsLevelBelow(7)
end