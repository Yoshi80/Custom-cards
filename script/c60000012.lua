-- Restrained Blade Herald
local s,id=GetID()
function s.initial_effect(c)
	c:EnableUnsummonable()
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.tgcon)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.tktg)
	e2:SetOperation(s.tkop)
	c:RegisterEffect(e2)
end
function s.tgcon(e)
	return e:GetHandler():IsLinked()
end
function s.rfilter(c,tp,tc)
	return c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_LINK) and c:GetLinkedGroup():IsContains(tc)
end
function s.tktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.rfilter(chkc,tp,e:GetHandler()) end
	if chk==0 then return Duel.IsExistingTarget(s.rfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp,e:GetHandler()) end
	local rg=Duel.SelectTarget(tp,s.rfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp,e:GetHandler())
	local ct=rg:GetFirst():GetLink()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
end
function s.tkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local ct=tc:GetLink()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
		if #g>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end