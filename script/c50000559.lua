--Hanten - Yatogami Tenka
local s,id=GetID()
function s.initial_effect(c)
	Xyz.AddProcedure(c,nil,8,2)
	c:EnableReviveLimit()
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.xyzlimit)
	c:RegisterEffect(e1)
	--cannot activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(s.xyzlimit)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(s.immcost)
	e3:SetOperation(s.immop)
	c:RegisterEffect(e3)
	--return
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCondition(s.regcon)
	e4:SetOperation(s.retreg)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCondition(aux.TRUE)
	e5:SetCode(EVENT_FLIP)
	c:RegisterEffect(e5)
end
function s.xyzlimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_GRAVE
end
function s.immcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.dfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPIRIT) and c:IsType(TYPE_XYZ)
end
function s.immop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dg=Duel.GetMatchingGroup(s.dfilter,tp,LOCATION_MZONE,0,nil)
	local tc=dg:GetFirst()
	local atk=Duel.GetMatchingGroupCount(aux.TRUE,0,LOCATION_GRAVE,LOCATION_GRAVE,nil)*100
	for tc in aux.Next(dg) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(s.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		--Increase ATK/DEF
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(atk)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e3)
	end
end
function s.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return (e:GetHandler():GetSummonType()&SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function s.retreg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetDescription(1104)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT|RESETS_STANDARD&~RESET_TEMP_REMOVE|RESET_PHASE|PHASE_END)
	e1:SetCondition(aux.SpiritReturnCondition)
	e1:SetTarget(s.rettg)
	e1:SetOperation(s.retop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	c:RegisterEffect(e2)
end
function s.spfilter(c,e,tp)
	return c:IsType(TYPE_SPIRIT) and c:IsLevel(8) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:IsHasType(EFFECT_TYPE_TRIGGER_F) then
			return true
		else
			return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and Duel.SendtoDeck(c,nil,2,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		local tg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
		if #tg>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=tg:Select(tp,1,1,nil)
			Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end