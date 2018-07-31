	; создаем новый класс CBlender_ikvision
	
	; таблица виртуальных функций дл€ нового класса
CBlender_ikvision__vfptr dd offset IBlender__getName
	dd offset CBlender_ikvision__getComment
	dd offset IBlender__Save
	dd offset IBlender__Load
	dd offset CBlender_light_occq__canBeLMAPped
	dd offset CBlender_light_occq__canBeLMAPped
	dd offset CBlender_ikvision__Compile
	dd offset CBlender_ikvision___scalar_deleting_destructor

	; коммент
CBlender_ikvision__getComment proc
	mov		eax, offset aIKVisComment
	retn
CBlender_ikvision__getComment endp

	; деструктор
CBlender_ikvision___scalar_deleting_destructor proc
arg_0 = byte ptr 4
	push    esi
	mov     esi, ecx
	mov     dword ptr [esi], offset CBlender_ikvision__vfptr
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
CBlender_ikvision___scalar_deleting_destructor endp

	; компил€ци€
CBlender_ikvision__Compile proc
	push    esi
	mov     esi, [esp+8]
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
	push    offset aIKvis ; "ogse_ikvision"
	push    offset aNull ; "null"
	mov     ecx, esi
	call    ds:CBlender_Compile__r_Pass
	
REGISTER_SAMPLER_RTF "$user$position", "s_position"
REGISTER_SAMPLER_CLF "$user$generic1", "s_distort"
REGISTER_SAMPLER_CLF "$user$generic0", "s_image"
REGISTER_SAMPLER_CUSTOM "$user$jitter_0", "s_jitter_0", 0, 1, 2, 0, 2
REGISTER_SAMPLER_CUSTOM "$user$jitter_1", "s_jitter_1", 0, 1, 2, 0, 2
REGISTER_SAMPLER_CUSTOM "$user$jitter_5", "s_jitter_5", 0, 1, 2, 0, 2

	mov     ecx, esi
	call    ds:CBlender_Compile__r_End
	pop     esi
	retn    4
CBlender_ikvision__Compile endp

aIKVisComment db "INTERNAL:ikvision", 0
aIKvis db "ogse_ikvision", 0
aNull db "null", 0