-- OceanBars v1.3
-- LICENSE: Creative Commons Attribution-Non-Commercial-Share Alike 3.0

local Measure,MeasureBuffer,cos,PI={},{},math.cos,math.pi
function Initialize()
	BarWidth,BarGap=SKIN:ParseFormula(SKIN:ReplaceVariables("#BarWidth#")),SKIN:ParseFormula(SKIN:ReplaceVariables("#BarGap#"))
	HalfWidth=math.ceil(BarWidth*0.5)
	Mu=1/BarWidth
	
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
	for j=1,HalfWidth*2 do
		LocalMu=LocalMu+Mu*0.5
		SKIN:Bang("!CommandMeasure","ScriptCallback","x="..CubicInterpolate(y0,y1,y2,y3,LocalMu))
		SKIN:Bang("[!UpdateMeasure ScriptCallback][!UpdateMeter MeterHistogram][!UpdateMeter MeterLine]")
	end
	
	for i=2,Limit-3 do
		SKIN:Bang("!CommandMeasure","ScriptCallback","x="..MeasureBuffer[i])
		SKIN:Bang("[!UpdateMeasure ScriptCallback][!UpdateMeter MeterHistogram][!UpdateMeter MeterLine]")
		
		local y0,y1,y2,y3,LocalMu=MeasureBuffer[i-1],MeasureBuffer[i],MeasureBuffer[i+1],MeasureBuffer[i+2],0
		for j=1,HalfWidth do
			LocalMu=LocalMu+Mu
			SKIN:Bang("!CommandMeasure","ScriptCallback","x="..CubicInterpolate(y0,y1,y2,y3,LocalMu))
			SKIN:Bang("[!UpdateMeasure ScriptCallback][!UpdateMeter MeterHistogram][!UpdateMeter MeterLine]")
		end
		SKIN:Bang("[!CommandMeasure ScriptCallback x=0][!UpdateMeasure ScriptCallback]")
		for j=1,BarGap do
			SKIN:Bang("[!UpdateMeter MeterHistogram][!UpdateMeter MeterLine]")
		end
		for j=1,HalfWidth do
			LocalMu=LocalMu+Mu
			SKIN:Bang("!CommandMeasure","ScriptCallback","x="..CubicInterpolate(y0,y1,y2,y3,LocalMu))
			SKIN:Bang("[!UpdateMeasure ScriptCallback][!UpdateMeter MeterHistogram][!UpdateMeter MeterLine]")
		end
	end
	
	y0,y1,y2,y3,LocalMu=MeasureBuffer[Limit-4],MeasureBuffer[Limit-2],MeasureBuffer[Limit-1],MeasureBuffer[Limit-1],0
	for j=1,HalfWidth*2 do
		LocalMu=LocalMu+Mu*0.5
		SKIN:Bang("!CommandMeasure","ScriptCallback","x="..CubicInterpolate(y0,y1,y2,y3,LocalMu))
		SKIN:Bang("[!UpdateMeasure ScriptCallback][!UpdateMeter MeterHistogram][!UpdateMeter MeterLine]")
	end
end