-- Jin the Tornan Blade

function c50000188.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_DARK),2,99,c50000188.lcheck)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c50000188.indtg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--return to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50000188,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c50000188.rmcon)
	e2:SetTarget(c50000188.target)
	e2:SetOperation(c50000188.operation)
	c:RegisterEffect(e2)
end

function c50000188.lcheck(g,lc)
	return g:GetClassCount(Card.GetCode)==g:GetCount()
end

function c50000188.indtg(e,c)
	return c:GetMutualLinkedGroupCount()>0
end

function c50000188.imfilter(c)
	return c:IsFaceup() and c:GetMutualLinkedGroupCount()>0
end
function c50000188.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLinkedGroup():FilterCount(c50000188.imfilter,1,nil)>=2
end
function c50000188.filter(c)
	return c:IsAbleToDeck()
end
function c50000188.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c50000188.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c50000188.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c50000188.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c50000188.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)
		Duel.ShuffleDeck(1-tp)
	end
end