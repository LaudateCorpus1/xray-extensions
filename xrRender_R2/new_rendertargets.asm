new_rendertargets:
	mov     esi, ds:resptrcode_crt__create ; resptrcode_crt::create(char const *,uint,uint,_D3DFORMAT)
; sun shafts mask
	xor		ecx, ecx
	mov		[edi+198h], ecx
	push    71h		;D3DFMT_A16B16G16R16F
	mov		ecx, [edi+8]
	push    ecx		;height
	mov		ecx, [edi+4]
	push    ecx		;width
	push    offset aSSMask ; "$user$sun_shafts_mask"
	lea     ecx, [edi+198h]
	call    esi ; resptrcode_crt::create(char const *,uint,uint,_D3DFORMAT) ; resptrcode_crt::create(char const *,uint,uint,_D3DFORMAT)
; sun shafts rt
	xor		ecx, ecx
	mov		[edi+19Ch], ecx
	push    71h		;D3DFMT_A16B16G16R16F
	mov		ecx, [edi+8]
	push    ecx		;height
	mov		ecx, [edi+4]
	push    ecx		;width
	push    offset aSS ; "$user$sun_shafts"
	lea     ecx, [edi+19Ch]
	call    esi ; resptrcode_crt::create(char const *,uint,uint,_D3DFORMAT) ; resptrcode_crt::create(char const *,uint,uint,_D3DFORMAT)
	
	jmp	exit_CRenderTarget_constructor

aSSMask db "$user$sun_shafts_mask", 0
aSS db "$user$sun_shafts", 0