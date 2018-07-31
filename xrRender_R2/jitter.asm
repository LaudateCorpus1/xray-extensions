add_jitter:
	mov     ecx, esi
	call    edi ; CBlender_Compile::r_Sampler(char const *,char const *,bool,uint,uint,uint,uint)
	
	push    1
	push    0
	push    1
	push    1
	push    1
	push    offset aUserJitter_5 ; "$user$jitter_5"
	push    offset aSnoise ; "s_noise"
	mov     ecx, esi
	call    edi ; CBlender_Compile::r_Sampler(char const *,char const *,bool,uint,uint,uint,uint)

	pop     edi
	retn

aSnoise db "s_noise", 0