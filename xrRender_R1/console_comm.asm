con_comm:
; установка дефолтных значений
;	r__bloodmarks = R2FLAG_USE_NVSTENCIL = по дефолту уже true
	or      ps_r2_ls_flags, 40000h ; r2_soft_water = true
	or      ps_r2_ls_flags, 80000h ; r2_soft_particles = true

REGISTER_CC_INT det_rad_value, "r__detail_radius", 31h, 0F0h
REGISTER_CC_TOKEN soft_shadows_token, "r2_soft_shadows", soft_shadows
REGISTER_CC_TOKEN sunshafts_quality_token, "r2_sun_shafts", sunshafts_quality
REGISTER_CC_FLAG ps_r2_ls_flags, 10000h, "r__bloodmarks"
REGISTER_CC_FLAG ps_r2_ls_flags, 40000h, "r2_soft_water"
REGISTER_CC_FLAG ps_r2_ls_flags, 80000h, "r2_soft_particles"
REGISTER_CC_FLAG ps_r2_ls_flags, 100000h, "r2_mblur_toggle"
REGISTER_CC_TOKEN bloom_mode_token, "r2_ls_bloom_mode", bloom_mode

	; делаем вырезанное
	pop		edi
	pop		esi
	pop		ebp
	pop		ebx
	add		esp, 18h
	retn

; дефолтные значения параметров (int)
det_rad_value dd 31h
sunshafts_quality dd 3
soft_shadows dd 3
bloom_mode dd 0

; общий токен
aOff db "st_opt_off", 0
aLow db "st_opt_low", 0
aMid db "st_opt_medium", 0
aHigh db "st_opt_high", 0
quality_token STRUCT
	dd offset aOff
	dd 0
	dd offset aLow
	dd 1
	dd offset aMid
	dd 2
	dd offset aHigh
	dd 3
	db 8 dup (0)
quality_token ENDS

sunshafts_quality_token quality_token <>
soft_shadows_token quality_token <>

; токен режима обычный/усиленный
aNormal db "st_opt_normal", 0
aStrong db "st_opt_strong", 0
mode_token STRUCT
	dd offset aNormal
	dd 0
	dd offset aStrong
	dd 1
	db 8 dup (0)
mode_token ENDS

bloom_mode_token mode_token <>