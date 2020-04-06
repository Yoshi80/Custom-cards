-- Omni-Hero : Wildmutt

function c50000151.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_BEAST),4,2)
	c:EnableReviveLimit()
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c50000151.aclimit)
	e1:SetCondition(c50000151.actcon)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetDescription(aux.Stringid(50000151,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,50000151)
	e2:SetCost(c50000151.descost)
	e2:SetTarget(c50000151.destg)
	e2:SetOperation(c50000151.desop)
	c:RegisterEffect(e2)
end

function c50000151.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c50000151.actcon(e)
	local a=Duel.GetAttacker()
	return a and a:IsControler(e:GetHandlerPlayer()) and a:IsRace(RACE_BEAST)
end

function c50000151.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c50000151.desfilter(c)
	return c:IsFacedown()
end
function c50000151.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE+LOCATION_FZONE) and chkc:IsControler(1-tp) and c50000151.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c50000151.desfilter,tp,0,LOCATION_SZONE+LOCATION_FZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c50000151.desfilter,tp,0,LOCATION_SZONE+LOCATION_FZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetChainLimit(c50000151.limit(g:GetFirst()))
end
function c50000151.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFacedown() then
		Duel.Destroy(tc,REASON_EFFECT)
		if (tc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
			and tc:IsSSetable() and Duel.SelectYesNo(tp,aux.Stringid(50000151,0)) then
			Duel.BreakEffect()
			Duel.SSet(tp,tc)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
function c50000151.limit(c)
	return	function (e,lp,tp)
				return e:GetHandler()~=c
			end
end