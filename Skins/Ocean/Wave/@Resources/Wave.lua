-- Wave v1.4
-- LICENSE: Creative Commons Attribution-Non-Commercial-Share Alike 3.0

local Measure,MeasureBuffer={},{}

function Initialize()
	
	-- Check if spectrum is (not) mirrored
	Mirror=tonumber(SKIN:ReplaceVariables("#Mirror#"))
	
	-- Spectrum width
	local Width=SKIN:ParseFormula(SKIN:ReplaceVariables("#Width#"))
	
	-- Band width
	InterWidth=math.ceil(Width/SKIN:ReplaceVariables("#Bands#"))
	
	-- Normalized band width
	Mu=1/InterWidth
	
	-- Iteration control variables
	Sub,Index,Limit=SELF:GetOption("Sub"),SKIN:ParseFormula(SELF:GetOption("Index")),SKIN:ParseFormula(SELF:GetNumberOption("Limit"))
	
	-- Retrieve measures and store in table
	local MeasureName,gsub=SELF:GetOption("MeasureName"),string.gsub
	for i=Index,Limit do
		Measure[i]=SKIN:GetMeasure((gsub(MeasureName,Sub,i)))
	end

end

-- http://paulbourke.net/miscellaneous/interpolation/
local function CubicInterpolate(y0,y1,y2,y3,mu)

   local mu2,a0=mu*mu,y3-y2-y0+y1
   local a1=y0-y1-a0
   return (a0*mu*mu2+a1*mu2+(y2-y0)*mu+y1)
   
end

function Update()

	-- Store measure values in buffer table
	for i=Index,Limit do
		MeasureBuffer[i]=Measure[i]:GetValue()
	end 
	
	-- Check if spectrum is (not) mirrored
	if Mirror==0 then
	
		-- Starting band values for calculation
		local y0,y1,y2,y3,LocalMu=MeasureBuffer[1],MeasureBuffer[1],MeasureBuffer[2],MeasureBuffer[4],0
		
		-- For each pixel in width of the first band (double padded)
		for j=1,InterWidth*2 do
			
			-- Request the interpolated point based on pixel position value
			LocalMu=LocalMu+Mu*0.5
			
			-- Call a Lua script to return its measure value as the interpolated point
			SKIN:Bang("!CommandMeasure","ScriptCallback","x="..CubicInterpolate(y0,y1,y2,y3,LocalMu))
			
			-- Update the measure and meters
			SKIN:Bang("[!UpdateMeasure ScriptCallback][!UpdateMeter MeterLine]")
			
		end
		
		-- For each band (Except the first and last two)
		for i=2,Limit-3 do
		
			-- Update the meter with the actual measure value
			SKIN:Bang("!CommandMeasure","ScriptCallback","x="..MeasureBuffer[i])
			SKIN:Bang("[!UpdateMeasure ScriptCallback][!UpdateMeter MeterLine]")
			
			-- Band values for calculation
			local y0,y1,y2,y3,LocalMu=MeasureBuffer[i-1],MeasureBuffer[i],MeasureBuffer[i+1],MeasureBuffer[i+2],0
			
			-- For each pixel in width of one band
			for j=1,InterWidth do
				
				-- Request the interpolated point based on pixel position value
				LocalMu=LocalMu+Mu
				
				-- Call a Lua script to return its measure value as the interpolated point
				SKIN:Bang("!CommandMeasure","ScriptCallback","x="..CubicInterpolate(y0,y1,y2,y3,LocalMu))
				
				-- Update the measure and meters
				SKIN:Bang("[!UpdateMeasure ScriptCallback][!UpdateMeter MeterLine]")
				
			end
			
		end
		
		-- Concluding band values for calculation
		y0,y1,y2,y3,LocalMu=MeasureBuffer[Limit-4],MeasureBuffer[Limit-2],MeasureBuffer[Limit-1],MeasureBuffer[Limit-1],0
		
		-- For each pixel in width of the last band (double padded)
		for j=1,InterWidth*2 do
			
			-- Request the interpolated point based on pixel position value
			LocalMu=LocalMu+Mu*0.5
			
			-- Call a Lua script to return its measure value as the interpolated point
			SKIN:Bang("!CommandMeasure","ScriptCallback","x="..CubicInterpolate(y0,y1,y2,y3,LocalMu))
			
			-- Update the measure and meters
			SKIN:Bang("[!UpdateMeasure ScriptCallback][!UpdateMeter MeterLine]")
			
		end
	
	else
		
		local y0,y1,y2,y3,LocalMu=MeasureBuffer[1],MeasureBuffer[1],MeasureBuffer[2],MeasureBuffer[4],0
		for j=1,InterWidth*2 do
			LocalMu=LocalMu+Mu*0.5
			SKIN:Bang("!CommandMeasure","ScriptCallback","x="..CubicInterpolate(y0,y1,y2,y3,LocalMu))
			SKIN:Bang("[!UpdateMeasure ScriptCallback][!UpdateMeter MeterLine][!UpdateMeter MeterLineFlip]")
		end
		
		for i=2,Limit-3 do
		
			SKIN:Bang("!CommandMeasure","ScriptCallback","x="..MeasureBuffer[i])
			SKIN:Bang("[!UpdateMeasure ScriptCallback][!UpdateMeter MeterLine][!UpdateMeter MeterLineFlip]")
			
			local y0,y1,y2,y3,LocalMu=MeasureBuffer[i-1],MeasureBuffer[i],MeasureBuffer[i+1],MeasureBuffer[i+2],0
			for j=1,InterWidth do
				LocalMu=LocalMu+Mu
				SKIN:Bang("!CommandMeasure","ScriptCallback","x="..CubicInterpolate(y0,y1,y2,y3,LocalMu))
				SKIN:Bang("[!UpdateMeasure ScriptCallback][!UpdateMeter MeterLine][!UpdateMeter MeterLineFlip]")
			end
			
		end
		
		y0,y1,y2,y3,LocalMu=MeasureBuffer[Limit-4],MeasureBuffer[Limit-2],MeasureBuffer[Limit-1],MeasureBuffer[Limit-1],0
		for j=1,InterWidth*2 do
			LocalMu=LocalMu+Mu*0.5
			SKIN:Bang("!CommandMeasure","ScriptCallback","x="..CubicInterpolate(y0,y1,y2,y3,LocalMu))
			SKIN:Bang("[!UpdateMeasure ScriptCallback][!UpdateMeter MeterLine][!UpdateMeter MeterLineFlip]")
		end
		
	end
	
end