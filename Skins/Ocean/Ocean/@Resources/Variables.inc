[Variables]

; Refresh the skin after updating these settings!


; DISPLAY
; =======

Bands=96
; Number of "peaks"

LineWidth=4
GraphOrientation=Vertical

Color=161,186,220,255

Mirror=0

X=0
Y=0
Width=(#WORKAREAWIDTH#/2)
Height=(#WORKAREAHEIGHT#/4)
; "#WORKAREAWIDTH#" and "#WORKAREAHEIGHT#" are generally your monitor's width and height
; http://docs.rainmeter.net/manual-beta/variables/built-in-variables#WORKAREAXYWH


; AUDIO
; =====

Sensitivity=42
; Increase this if the spectrum is not visible enough

FFTAttack=350
FFTDecay=350
; Decrease for faster response, increase for slower response
; http://docs.rainmeter.net/manual-beta/plugins/audiolevel#FFTAttack

FFTSize=2048
FFTOverlap=(#FFTSize#/2)
FreqMin=40
FreqMax=16000
Port=Output
; Additional audio settings
; http://docs.rainmeter.net/manual-beta/plugins/audiolevel#FFTOptions
