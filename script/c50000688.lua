--Requip Armor
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.cfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_EQUIP) and c:IsType(TYPE_SPELL)
		and Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_HAND,0,1,nil,c:GetCode(),c:GetEquipTarget())
end
function s.cfilter2(c,code,ec)
	return ec and c:IsType(TYPE_EQUIP) and c:IsType(TYPE_SPELL) and not c:IsCode(code) and c:CheckEquipTarget(ec)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_SZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_SZONE,0,1,1,nil,tp)
	local tc=g:GetFirst()
	e:SetLabel(tc:GetCode())
	e:SetLabelObject(tc:GetEquipTarget())
	Duel.SendtoHand(g,nil,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	local ec=e:GetLabelObject()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		local g=Duel.SelectMatchingCard(tp,s.cfilter2,tp,LOCATION_HAND,0,1,1,nil,code,ec)
		Duel.Equip(tp,g:GetFirst(),ec)
	end
end