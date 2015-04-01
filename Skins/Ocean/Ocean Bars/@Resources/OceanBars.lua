-- OceanBars v1.1
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
local function CosineInterpolate(y1,y2,mu)
	local mu2=(1-cos(mu*PI))/2 return (y1*(1-mu2)+y2*mu2) end

function Update()
	for i=Index,Limit do MeasureBuffer[i]=Measure[i]:GetValue() end 
	
	for i=Index,Limit-1 do
		SKIN:Bang("!SetOption","MeasureIter","Formula",MeasureBuffer[i])
		SKIN:Bang("[!UpdateMeasure MeasureIter][!UpdateMeter MeterHistogram][!UpdateMeter MeterLine]")
		
		local y1,y2,LocalMu=MeasureBuffer[i],MeasureBuffer[i+1],0
		for j=0,HalfWidth do
			LocalMu=LocalMu+Mu
			SKIN:Bang("!SetOption","MeasureIter","Formula",CosineInterpolate(y1,y2,LocalMu))
			SKIN:Bang("[!UpdateMeasure MeasureIter][!UpdateMeter MeterHistogram][!UpdateMeter MeterLine]")
		end
		for j=0,BarGap do
			SKIN:Bang("[!SetOption MeasureIter Formula 0][!UpdateMeasure MeasureIter][!UpdateMeter MeterHistogram][!UpdateMeter MeterLine]")
		end
		for j=0,HalfWidth do
			LocalMu=LocalMu+Mu
			SKIN:Bang("!SetOption","MeasureIter","Formula",CosineInterpolate(y1,y2,LocalMu))
			SKIN:Bang("[!UpdateMeasure MeasureIter][!UpdateMeter MeterHistogram][!UpdateMeter MeterLine]")
		end
	end
end