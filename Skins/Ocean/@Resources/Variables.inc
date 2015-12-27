[Variables]

Bands=21
; Number of peaks - Activate Ocean\GenerateBands.ini skin after changing this value

Color=192,128,255

Width=600
Height=200

LineWidth=4

AverageSize=0
; Average sound levels over time to provide continuity

LoudnessEqualization=1
; Increases visibility for quiet audio sources when applicable

FFTSize=10240
FFTOverlap="(#FFTSize#-256)"
FFTAttack=0
FFTDecay=300
FreqMin=20
FreqMax=20000
Sensitivity=17
; http://docs.rainmeter.net/manual-beta/plugins/audiolevel

MusicPlayer=None
; Music player process name

FirstBandIndex=1

; Environment variables for settings window
SkinGroup=Ocean
Config=Ocean
ConfigPath=#ROOTCONFIGPATH##Config#.ini
WriteVariable=Color
LineOnly=0
Angle=0
Invert=0
Channel=Avg
Port=Output
ID=
