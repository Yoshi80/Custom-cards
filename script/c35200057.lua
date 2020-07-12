--Supremecode Talker
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,nil,2,6,s.lcheck)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(s.matcheck)
	c:RegisterEffect(e1)
end
function s.lcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsSetCard,1,nil,0x101,lc,sumtype,tp)
end
function s.matfilter(c)
	return c:IsSetCard(0x101) and c:IsLink(3)
end
function s.filter(c,att)
	return c:IsAttribute(att)
end
function s.matcheck(e,c)
	local g=c:GetMaterial():Filter(s.matfilter,nil)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(g:GetCount()*2300)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE-RESET_TOFIELD)
	c:RegisterEffect(e1)
	if g:IsExists(s.filter,1,nil,ATTRIBUTE_EARTH) then
		--indes
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetTarget(s.indtg)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE-RESET_TOFIELD)
		c:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		c:RegisterEffect(e3)
	end
	if g:IsExists(s.filter,1,nil,ATTRIBUTE_WATER) then
		local e4=Effect.CreateEffect(c)
		e4:SetDescription(aux.Stringid(id,0))
		e4:SetCategory(CATEGORY_DRAW)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e4:SetCode(EVENT_ATTACK_ANNOUNCE)
		e4:SetRange(LOCATION_MZONE)
		e4:SetCountLimit(1)
		e4:SetCondition(s.atkcon)
		e4:SetTarget(s.atktg)
		e4:SetOperation(s.atkop)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE-RESET_TOFIELD)
		c:RegisterEffect(e4)
	end
	if g:IsExists(s.filter,1,nil,ATTRIBUTE_FIRE) then
		--damage
		local e5=Effect.CreateEffect(c)
		e5:SetDescription(aux.Stringid(id,0))
		e5:SetCategory(CATEGORY_DAMAGE)
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e5:SetCode(EVENT_BATTLE_DESTROYING)
		e5:SetRange(LOCATION_MZONE)
		e5:SetCountLimit(1)
		e5:SetCondition(s.damcon)
		e5:SetTarget(s.damtg)
		e5:SetOperation(s.damop)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE-RESET_TOFIELD)
		c:RegisterEffect(e5)
	end
	if g:IsExists(s.filter,1,nil,ATTRIBUTE_WIND) then
		--negate
		local e6=Effect.CreateEffect(c)
		e6:SetDescription(aux.Stringid(id,1))
		e6:SetCategory(CATEGORY_NEGATE)
		e6:SetType(EFFECT_TYPE_QUICK_O)
		e6:SetCode(EVENT_CHAINING)
		e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
		e6:SetRange(LOCATION_MZONE)
		e6:SetCountLimit(1)
		e6:SetCondition(s.negcon)
		e6:SetTarget(s.negtg)
		e6:SetOperation(s.negop)
		e6:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE-RESET_TOFIELD)
		c:RegisterEffect(e6)
	end
	if g:IsExists(s.filter,1,nil,ATTRIBUTE_LIGHT) then
		local e7=Effect.CreateEffect(c)
		e7:SetCategory(CATEGORY_REMOVE)
		e7:SetType(EFFECT_TYPE_IGNITION)
		e7:SetRange(LOCATION_MZONE)
		e7:SetCountLimit(1)
		e7:SetTarget(s.target)
		e7:SetOperation(s.operation)
		e7:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE-RESET_TOFIELD)
		c:RegisterEffect(e7)
	end
	if g:IsExists(s.filter,1,nil,ATTRIBUTE_DARK) then
		--indes
		local e8=Effect.CreateEffect(c)
		e8:SetType(EFFECT_TYPE_FIELD)
		e8:SetCode(EFFECT_UNRELEASABLE_SUM)
		e8:SetRange(LOCATION_MZONE)
		e8:SetTargetRange(LOCATION_MZONE,0)
		e8:SetTarget(s.indtg)
		e8:SetValue(1)
		e8:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE-RESET_TOFIELD)
		c:RegisterEffect(e8)
		local e9=e8:Clone()
		e9:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		c:RegisterEffect(e9)
		--remove
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD)
		e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
		e0:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		e0:SetRange(LOCATION_MZONE)
		e0:SetTargetRange(0,0xff)
		e0:SetValue(LOCATION_REMOVED)
		e0:SetTarget(s.rmtg)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE-RESET_TOFIELD)
		c:RegisterEffect(e0)
	end
end
function s.indtg(e,c)
	return c:IsRace(RACE_CYBERSE) and c:IsType(TYPE_LINK)
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:IsControler(tp) and at:IsRace(RACE_CYBERSE) and at:IsType(TYPE_LINK)
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=eg:GetFirst()
	return rc:IsRelateToBattle() and rc:IsStatus(STATUS_OPPO_BATTLE)
		and rc:IsFaceup() and rc:IsRace(RACE_CYBERSE) and rc:IsType(TYPE_LINK) and rc:IsControler(tp)
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(2300)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,2300)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function s.negfilter(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_CYBERSE) and c:IsType(TYPE_LINK) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(s.negfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetHandler():GetLinkedGroupCount()+1
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(s.rmfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_ONFIELD)
	Duel.SetChainLimit(s.chlimit)
end
function s.chlimit(e,ep,tp)
	return tp==ep
end
function s.rmfilter(c)
	return c:IsAbleToRemove() and aux.SpElimFilter(c,false,true)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetHandler():GetLinkedGroupCount()+1
	if ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.rmfilter,tp,0,LOCATION_ONFIELD,1,ct,nil)
	if #g>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function s.rmtg(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer() and Duel.IsPlayerCanRemove(e:GetHandlerPlayer(),c)
end