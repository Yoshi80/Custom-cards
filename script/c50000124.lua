-- Hyper Beam

function c50000124.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,50000124)
	e1:SetCondition(c50000124.condition)
	e1:SetCost(c50000124.damcost)
	e1:SetTarget(c50000124.target)
	e1:SetOperation(c50000124.activate)
	c:RegisterEffect(e1)
	if not c50000124.global_check then
		c50000124.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(c50000124.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end

function c50000124.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc:IsType(TYPE_SYNCHRO) and tc:IsRace(RACE_DRAGON) then
		Duel.RegisterFlagEffect(tc:GetControler(),50000124,RESET_PHASE+PHASE_END,0,1)
	end
end

function c50000124.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,50000124)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetTarget(c50000124.atktarget)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c50000124.atktarget(e,c)
	return c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_DRAGON)
end
function c50000124.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_DRAGON)
end
function c50000124.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c50000124.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c50000124.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c50000124.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50000124.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(c50000124.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c50000124.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c50000124.filter,tp,0,LOCATION_ONFIELD,e:GetHandler())
	Duel.Destroy(sg,REASON_EFFECT)
end
