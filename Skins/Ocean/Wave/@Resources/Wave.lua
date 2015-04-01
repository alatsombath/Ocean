-- Wave v1.2
-- LICENSE: Creative Commons Attribution-Non-Commercial-Share Alike 3.0

local Measure,MeasureBuffer,cos,PI={},{},math.cos,math.pi
function Initialize()
	local Width=SKIN:ParseFormula(SKIN:ReplaceVariables("#Width#"))
	InterWidth=Width/SKIN:ReplaceVariables("#Bands#")
	Mu=1/InterWidth
	
	Sub,Index,Limit=SELF:GetOption("Sub"),SKIN:ParseFormula(SELF:GetOption("Index")),SKIN:ParseFormula(SELF:GetOption("Limit"))
	local MeasureName,gsub=SKIN:ReplaceVariables("#MeasureName#"),string.gsub
	for i=Index,Limit do Measure[i]=SKIN:GetMeasure((gsub(MeasureName,Sub,i))) end end

-- http://paulbourke.net/miscellaneous/interpolation/
local function CubicInterpolate(y0,y1,y2,y3,mu)
   local mu2,a0=mu*mu,y3-y2-y0+y1
   local a1=y0-y1-a0
   return (a0*mu*mu2+a1*mu2+(y2-y0)*mu+y1) end

function Update()
	for i=Index,Limit do MeasureBuffer[i]=Measure[i]:GetValue() end 
	
	local y0,y1,y2,y3,LocalMu=MeasureBuffer[1],MeasureBuffer[1],MeasureBuffer[2],MeasureBuffer[4],0
	for j=1,InterWidth*2 do
		LocalMu=LocalMu+Mu*0.5
		SKIN:Bang("!SetOption","MeasureIter","Formula",CubicInterpolate(y0,y1,y2,y3,LocalMu))
		SKIN:Bang("[!UpdateMeasure MeasureIter][!UpdateMeter MeterLine]")
	end
	
	for i=2,Limit-3 do
		SKIN:Bang("!SetOption","MeasureIter","Formula",MeasureBuffer[i])
		SKIN:Bang("[!UpdateMeasure MeasureIter][!UpdateMeter MeterLine]")
		
		local y0,y1,y2,y3,LocalMu=MeasureBuffer[i-1],MeasureBuffer[i],MeasureBuffer[i+1],MeasureBuffer[i+2],0
		for j=1,InterWidth do
			LocalMu=LocalMu+Mu
			SKIN:Bang("!SetOption","MeasureIter","Formula",CubicInterpolate(y0,y1,y2,y3,LocalMu))
			SKIN:Bang("[!UpdateMeasure MeasureIter][!UpdateMeter MeterLine]")
		end
	end
	
	y0,y1,y2,y3,LocalMu=MeasureBuffer[Limit-4],MeasureBuffer[Limit-2],MeasureBuffer[Limit-1],MeasureBuffer[Limit-1],0
	for j=1,InterWidth*2 do
		LocalMu=LocalMu+Mu*0.5
		SKIN:Bang("!SetOption","MeasureIter","Formula",CubicInterpolate(y0,y1,y2,y3,LocalMu))
		SKIN:Bang("[!UpdateMeasure MeasureIter][!UpdateMeter MeterLine]")
	end
end