include blender_ikvision.asm
include blender_sunshafts.asm

CRenderTarget_constructor:
	lea     ecx, [edi+148h]
	call    esi
; IK-vision
;	xor		ebx, ebx
;	mov		esi, ebx
;	mov     [edi+180h], ebx
;	mov     [edi+184h], ebx
;	mov     ecx, ds:_Memory
;	push    144h
;	call    ds:xrMemory__mem_alloc
;	mov     ebx, eax
;	cmp     ebx, esi
;	jz      short cannot_alloc_memory_for_ik_blender
;	mov     ecx, ebx
;	call    ds:IBlender__IBlender
;	mov     dword ptr [ebx], offset CBlender_ikvision__vfptr
;	mov     [ebx+4], esi
;	mov     [ebx+8], esi
;	mov		esi, ebx
;cannot_alloc_memory_for_ik_blender:
;	mov		[edi+180h], esi
;	mov		esi, ds:resptrcode_shader__create
;	push    0
;	push    0
;	push    0
;	push    offset aR2ikvis ; "r2\ogse_ikvision"
;	mov		ebx, [edi+180h]
;	push	ebx
;	lea     ecx, [edi+184h]
;	call    esi
; Sunshafts
	xor		ebx, ebx
	mov		esi, ebx
	mov     [edi+190h], ebx
	mov     [edi+194h], ebx
	mov     ecx, ds:_Memory
	push    144h
	call    ds:xrMemory__mem_alloc
	mov     ebx, eax
	cmp     ebx, esi
	jz      short cannot_alloc_memory_for_ss_blender
	mov     ecx, ebx
	call    ds:IBlender__IBlender
	mov     dword ptr [ebx], offset CBlender_sunshafts__vfptr
	mov     [ebx+4], esi
	mov     [ebx+8], esi
	mov		esi, ebx
cannot_alloc_memory_for_ss_blender:
	mov		[edi+190h], esi
	mov		esi, ds:resptrcode_shader__create
	push    0
	push    0
	push    0
	push    offset aR2sunshafts ; "r2\ogse_sunshafts"
	mov		ebx, [edi+190h]
	push	ebx
	lea     ecx, [edi+194h]
	call    esi
	
	jmp	new_rendertargets
	
exit_CRenderTarget_constructor:
	mov		eax, ds:Device
	jmp back_to_CRenderTarget_constructor
	
CRenderTarget_phase_combine_add:
	lea     ecx, [eax+edx*4+8]
	test	posteffect_flags, 1
	jz		no_ikvision
	mov		ecx, [ebx+184h]
	lea		ecx, [ecx+8]
no_ikvision:
	push    ecx
	jmp back_to_CRenderTarget_phase_combine_add
	
aR2ikvis db "r2\\ogse_ikvision", 0
aR2sunshafts db "r2\\ogse_sunshafts", 0