-- Hakaishin - Arack

function c50000080.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c50000080.thcon)
	e1:SetTarget(c50000080.thtg)
	e1:SetOperation(c50000080.thop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c50000080.indtg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(c50000080.aclimit)
	e3:SetCondition(c50000080.actcon)
	c:RegisterEffect(e3)
end

function c50000080.filter(c,tp)
	return c:IsSetCard(0x702) and c:IsLevelBelow(7) and c:IsControler(tp) and c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c50000080.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c50000080.filter,1,nil,tp)
end
function c50000080.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c50000080.desfilter(c,tc)
	return c:IsFaceup() and c:IsSetCard(0x702) and c~=tc
end
function c50000080.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,c50000080.desfilter,tp,LOCATION_MZONE,0,1,1,nil,e:GetHandler())
		Duel.SendtoHand(dg,nil,REASON_EFFECT)
	end
end

function c50000080.indtg(e,c)
	return c:IsSetCard(0x702) and c:IsLevelAbove(7)
end

function c50000080.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and not re:GetHandler():IsImmuneToEffect(e)
end
function c50000080.actcon(e)
	local tp=e:GetHandlerPlayer()
	local a=Duel.GetAttacker()
	if not a then return false end
	local d=a:GetBattleTarget()
	if a:IsControler(1-e:GetHandler():GetControler()) then a,d=d,a end
	return a and a:IsSetCard(0x702) and a:IsLevelBelow(7) and a:IsControler(tp)
end