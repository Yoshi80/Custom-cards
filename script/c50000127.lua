-- Gyarados

function c50000127.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c50000127.matfilter,1)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50000127,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c50000127.atktg)
	e1:SetOperation(c50000127.atkop)
	c:RegisterEffect(e1)
end

function c50000127.matfilter(c)
	return c:GetLevel()==1 and c:IsRace(RACE_FISH) and c:IsType(TYPE_NORMAL)
end

function c50000127.atkfilter(c,g)
	return c:IsFaceup() and c:GetAttack()>0 and g:IsContains(c)
end
function c50000127.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lg=e:GetHandler():GetLinkedGroup()
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c50000127.atkfilter,tp,LOCATION_MZONE,0,1,nil,lg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g=Duel.SelectTarget(tp,c50000127.atkfilter,tp,LOCATION_MZONE,0,1,1,nil,lg)
	e:SetLabelObject(g:GetFirst())
end
function c50000127.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc1=e:GetLabelObject()
	local c=e:GetHandler()
	if tc1:IsFaceup() and tc1:IsRelateToEffect(e) then
		local atk=tc1:GetAttack()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc1:RegisterEffect(e2)
	end
end