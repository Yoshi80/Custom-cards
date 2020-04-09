--Elegant Lilligant
local s,id=GetID()
function s.initial_effect(c)
	--link summon
	Link.AddProcedure(c,nil,2,4,s.lcheck)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(s.indcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(s.eqtg)
	e3:SetOperation(s.eqop)
	c:RegisterEffect(e3)
end
function s.lcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsCode,1,nil,50000217)
end
function s.indcon(e)
	local c=e:GetHandler()
	local lg=c:GetLinkedGroup()
	local res=false
	local c1=lg:GetFirst()
	local c2=lg:GetNext()
	local c3=lg:GetNext()
	if (c1 and c2) or (c1 and c3) or (c2 and c3) then
		if (c1 and c2) then
			res=c1:GetCode()==c2:GetCode()
		end
		if (c1 and c3 and not res) then
			res=c1:GetCode()==c3:GetCode()
		end
		if (c2 and c3 and not res) then
			res=c2:GetCode()==c3:GetCode()
		end
	end
	return res
end
function s.eqfilter2(c,e,tp,lg)
	return c:IsFaceup() and lg:IsContains(c)
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lg=e:GetHandler():GetLinkedGroup()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.eqfilter2(chkc,e,tp,lg) end
	if chk==0 then return Duel.IsExistingTarget(s.eqfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp,lg) end
	local g=Duel.SelectTarget(tp,s.eqfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp,lg)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) then
		tc:RegisterFlagEffect(0,RESET_EVENT+0xfe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,1))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(id)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
		tc:RegisterEffect(e1)
	end
end