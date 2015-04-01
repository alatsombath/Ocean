-- OceanBars v1.0
-- LICENSE: Creative Commons Attribution-Non-Commercial-Share Alike 3.0

local Measure,MeasureBuffer,cos,PI={},{},math.cos,math.pi
function Initialize()
	BarWidth,BarGap=SKIN:ParseFormula(SKIN:ReplaceVariables("#BarWidth#")),math.ceil(SKIN:ParseFormula(SKIN:ReplaceVariables("#BarGap#")))
	HalfWidth,Mu=math.ceil(BarWidth*0.5),1/BarWidth
	Sub,Index,Limit=SELF:GetOption("Sub"),SKIN:ParseFormula(SELF:GetOption("Index")),SKIN:ParseFormula(SELF:GetOption("Limit"))
	local MeasureName,gsub=SKIN:ReplaceVariables("#MeasureName#"),string.gsub
	for i=Index,Limit do Measure[i]=SKIN:GetMeasure((gsub(MeasureName,Sub,i))) end end

-- http://paulbourke.net/miscellaneous/interpolation/
local function CosineInterpolate(y1,y2,mu)
	local mu2=(1-cos(mu*PI))/2 return (y1*(1-mu2)+y2*mu2) end

function Update()
	for i=Index,Limit do MeasureBuffer[i]=Measure[i]:GetValue() end 
	for i=Index,Limit-1 do
		SKIN:Bang("!SetOption","MeasureHistogramIter","Formula",Measure[i]:GetValue())
		SKIN:Bang("[!UpdateMeasure MeasureHistogramIter][!UpdateMeter MeterHistogram]")
		
		local y1,y2,LocalMu=MeasureBuffer[i],MeasureBuffer[i+1],0
		for j=1,HalfWidth do
			LocalMu=LocalMu+Mu
			SKIN:Bang("!SetOption","MeasureHistogramIter","Formula",CosineInterpolate(y1,y2,LocalMu))
			SKIN:Bang("[!UpdateMeasure MeasureHistogramIter][!UpdateMeter MeterHistogram]")
		end
		for j=1,BarGap do
			SKIN:Bang("[!SetOption MeasureHistogramIter Formula 0][!UpdateMeasure MeasureHistogramIter][!UpdateMeter MeterHistogram]")
		end
		for j=1,HalfWidth do
			LocalMu=LocalMu+Mu
			SKIN:Bang("!SetOption","MeasureHistogramIter","Formula",CosineInterpolate(y1,y2,LocalMu))
			SKIN:Bang("[!UpdateMeasure MeasureHistogramIter][!UpdateMeter MeterHistogram]")
		end
	end
end