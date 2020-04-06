-- Splatfest

function c50000178.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x708))
	e2:SetValue(c50000178.val)
	c:RegisterEffect(e2)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,50000178)
	e3:SetTarget(c50000178.target)
	e3:SetOperation(c50000178.activate)
	c:RegisterEffect(e3)
end

function c50000178.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL) and c:IsType(TYPE_EQUIP) and c:IsSetCard(0x709)
end
function c50000178.val(e,c)
	return Duel.GetMatchingGroupCount(c50000178.atkfilter,c:GetControler(),LOCATION_SZONE,0,nil)*200
end

function c50000178.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL) and c:IsType(TYPE_EQUIP) and c:IsSetCard(0x709) and c:IsAbleToHand()
end
function c50000178.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c50000178.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c50000178.filter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c50000178.filter,tp,LOCATION_SZONE,0,1,1,nil)
	e:SetLabelObject(g:GetFirst():GetEquipTarget())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c50000178.spfilter(c,code,e,tp)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_EQUIP) and c:IsSetCard(0x709) and not c:IsCode(code)
end
function c50000178.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local ec=e:GetLabelObject()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
		Duel.ShuffleHand(tc:GetControler())
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
			local g=Duel.SelectMatchingCard(tp,c50000178.spfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode(),e,tp)
			Duel.Equip(tp,g:GetFirst(),ec)
		end
	end
end