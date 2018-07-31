	; создаем новый класс CBlender_sunshafts
	
	; таблица виртуальных функций дл€ нового класса
CBlender_sunshafts__vfptr dd offset IBlender__getName
	dd offset CBlender_sunshafts__getComment
	dd offset IBlender__Save
	dd offset IBlender__Load
	dd offset CBlender_light_occq__canBeLMAPped
	dd offset CBlender_light_occq__canBeLMAPped
	dd offset CBlender_sunshafts__Compile
	dd offset CBlender_sunshafts___scalar_deleting_destructor

	; коммент
CBlender_sunshafts__getComment proc
	mov		eax, offset aComment
	retn
CBlender_sunshafts__getComment endp

	; деструктор
CBlender_sunshafts___scalar_deleting_destructor proc
arg_0 = byte ptr 4
	push    esi
	mov     esi, ecx
	mov     dword ptr [esi], offset CBlender_sunshafts__vfptr
	call    ds:IBlender___IBlender
	test    [esp+4+arg_0], 1
	jz      short exit
	mov     ecx, ds:_Memory
	push    esi
	call    ds:xrMemory__mem_free
exit:
	mov     eax, esi
	pop     esi
	retn    4
CBlender_sunshafts___scalar_deleting_destructor endp

	; компил€ци€
CBlender_sunshafts__Compile proc
	push    esi
	mov     esi, [esp+4+4]	;C
	push    esi
	call    ds:IBlender__Compile
	push    0              
	push    0
	push    1
	push    2
	push    0
	push    0
	push    0
	push    0
	mov		ecx, [esi+48h]
	cmp		ecx, 3
	jnb		_3
	cmp		ecx, 2
	jnb		_2
	cmp		ecx, 1
	jnb		_1
; E[0]
	push    offset aPS_0 ; "ogse_sunshafts_mask_gen"
	push    offset aVS ; "null"
	mov     ecx, esi
	call    ds:CBlender_Compile__r_Pass	
REGISTER_SAMPLER_RTF "$user$position", "s_position"
REGISTER_SAMPLER_CLF "$user$generic0", "s_image"
	jmp		exit
	
_1:
; E[1]
	push    offset aPS_2 ; "ogse_sunshafts_gen_main"
	push    offset aVS ; "null"
	mov     ecx, esi
	call    ds:CBlender_Compile__r_Pass
REGISTER_SAMPLER_CUSTOM "$user$sun_shafts_mask", "s_sun_shafts_temp", 0, 1, 2, 0, 2
	jmp		exit
	
_2:	
; E[2]
	push    offset aPS_2 ; "ogse_sunshafts_gen"
	push    offset aVS ; "null"
	mov     ecx, esi
	call    ds:CBlender_Compile__r_Pass
REGISTER_SAMPLER_CUSTOM "$user$sun_shafts", "s_sun_shafts_temp", 0, 1, 2, 0, 2
	jmp		exit
	
_3:	
; E[3]
	push    offset aPS_2 ; "ogse_sunshafts_gen"
	push    offset aVS ; "null"
	mov     ecx, esi
	call    ds:CBlender_Compile__r_Pass
REGISTER_SAMPLER_CUSTOM "$user$sun_shafts_mask", "s_sun_shafts_temp", 0, 1, 2, 0, 2
	jmp		exit

exit:
	mov     ecx, esi
	call    ds:CBlender_Compile__r_End
	pop     esi
	retn    4
CBlender_sunshafts__Compile endp

aComment db "INTERNAL:sunshafts", 0
aPS_0 db "sunshafts_mask", 0
;aPS_1 db "ogse_sunshafts_gen_main", 0
aPS_2 db "sunshafts", 0
aVS db "null", 0