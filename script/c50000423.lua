--My Butt!
local s,id=GetID()
function s.initial_effect(c)
	--Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DISABLE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_CHAINING)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCost(s.cost)
    e1:SetCondition(s.condition)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
    --immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
	--cannot activate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_ONFIELD)
	e3:SetTargetRange(1,0)
	e3:SetLabel(0)
	e3:SetValue(s.actlimit)
	c:RegisterEffect(e3)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    e:SetLabel(1)
end
function s.filter(c)
    return c:IsOnField() and c:IsType(TYPE_MONSTER)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
     return ep~=tp and re:IsActiveType(TYPE_MONSTER)
end
function s.cfilter(c)
    return c:GetOriginalCode()==50000421 and c:IsFaceup()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingTarget(s.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,true) end
    if e:GetLabel()==1 then
        aux.RemainFieldCost(e,tp,eg,ep,ev,re,r,rp,1)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
    Duel.SelectTarget(tp,s.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,true)
    e:SetLabel(0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local tc=g:GetFirst()
    	if tc:IsRelateToEffect(e) and tc:IsFaceup() and c:IsRelateToEffect(e) then
        	Duel.Equip(tp,c,tc)
            c:CancelToGrave()
            --Equip limit
            local e2=Effect.CreateEffect(c)
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetCode(EFFECT_EQUIP_LIMIT)
            e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e2:SetValue(s.eqlimit)
            e2:SetLabelObject(tc)
            e2:SetReset(RESET_EVENT+RESETS_STANDARD)
            c:RegisterEffect(e2)
        else
            c:CancelToGrave(false)
        end
end
function s.eqlimit(e,c)
    return c==e:GetLabelObject()
end
function s.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL) and te:IsActiveType(TYPE_CONTINUOUS) and te:IsActivated()
end
function s.actlimit(e,te,tp)
	if te:IsHasType(EFFECT_TYPE_ACTIVATE) and te:IsActiveType(TYPE_TRAP) then return true end
	return false
end