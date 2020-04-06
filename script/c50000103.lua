-- Fleuve d'Étoiles

function c50000103.initial_effect(c)
	c:SetUniqueOnField(1,0,50000103)
	aux.AddEquipProcedure(c,0,c50000103.filter,c50000103.eqlimit)
	--Atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c50000103.value)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(50000103,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c50000103.descon)
	e3:SetTarget(c50000103.destg)
	e3:SetOperation(c50000103.desop)
	c:RegisterEffect(e3)
end

function c50000103.value(e,c)
	return e:GetHandler():GetEquipTarget():GetLevel()*100
end
function c50000103.eqlimit(e,c)
	return c:GetControler()==e:GetHandler():GetControler()
		and (c:IsSetCard(0x703) and c:IsType(TYPE_RITUAL))
end
function c50000103.filter(c)
	return c:IsSetCard(0x703) and c:IsType(TYPE_RITUAL)
end

function c50000103.descon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	local dt=nil
	if ec==Duel.GetAttacker() then dt=Duel.GetAttackTarget()
	elseif ec==Duel.GetAttackTarget() then dt=Duel.GetAttacker() end
	e:SetLabelObject(dt)
	if dt==nil then return false end
	return dt:IsRelateToBattle()
end
function c50000103.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetLabelObject(),1,0,0)
end
function c50000103.desop(e,tp,eg,ep,ev,re,r,rp)
	local dt=e:GetLabelObject()
	if dt:IsRelateToBattle() then
		Duel.Destroy(dt,REASON_EFFECT)
	end
end