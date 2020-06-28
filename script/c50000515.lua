--Sky Dragon Grandeeney
local s,id=GetID()
function s.initial_effect(c)
	--revive 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.cost)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
end
function s.filter(c,e,tp,attributes)
	return c:IsRace(RACE_DRAGON) and c:IsLevel(10) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)
		and not s.has_value(attributes,c:GetAttribute())
end
function s.filter2(c)
	return c:IsFaceup()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g2=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_MZONE,0,nil)
	local tc2=g2:GetFirst()
	local attributes={} 
	while tc2 do
		if not s.has_value(attributes,tc2:GetAttribute()) then
			table.insert(attributes,tc2:GetAttribute())
		end
		tc2=g2:GetNext()
	end
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and s.filter(chkc,e,tp,attributes) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp,attributes) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp,attributes)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT+REASON_DISCARD)==1 and tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
function s.has_value(tab,val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local at=Duel.GetAttackTarget()
	local c=e:GetHandler()
	if chk==0 then return at and at:IsControler(tp) and at:IsRace(RACE_DRAGON) and c:IsCanChangePosition() end
	Duel.ChangePosition(c,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttackTarget()
	Duel.NegateAttack()
	Duel.Recover(tp,tc:GetAttack()/2,REASON_EFFECT)
end