prepare_rendertarget proc	; IDirect3DSurface9 * prepare_rendertarget(IDirect3DSurface9 *surf, CTexture *tex, const char *texture_name, int width, int height, int format)
surface = dword ptr 4h
texture = dword ptr 8h
texture_name = dword ptr 0Ch
_width = dword ptr 10h
_height = dword ptr 14h
format	= dword ptr 18h
tex_1	= dword ptr -4
tex_2	= dword ptr -8
	sub		esp, 8
	xor		ecx, ecx
	mov		edx, [esp+8+texture]
	mov		[edx], ecx
	mov     ecx, ds:HW
	mov     edx, [ecx+8]
	mov		ebx, [esp+8+surface]			; t_noise_hd_surf
	; создадим DirectX-текстуру под шум
	push    ebx
	mov     esi, 1
	push    esi
	mov		ecx, [esp+10h+format]
	push    ecx
	push    0
	push    esi
	mov		ecx, [esp+1Ch+_height]
	push	ecx
	mov		ecx, [esp+20h+_width]
	push	ecx
	push    edx
	call    _D3DXCreateTexture ; D3DXCreateTexture(x,x,x,x,x,x,x,x)
	test    eax, eax
	; если не вышло - вылетаем
	jge     short loc_3A77712
	mov     ecx, ds:Debug
	push    offset byte_3AA95E7
	push    offset aCrendertargetC ; "CRenderTarget::CRenderTarget"
	push    1A8h
	push    offset atest ; "E:\\stalker\\sources\\trunk\\xr_3da\\xrRende"...
	push    offset atest ; "D3DXCreateTexture (HW.pDevice,TEX_jitte"...
	push    eax
	call    ds:xrDebug__error
loc_3A77712:                          
	; создадим внутриигровую текстуру (CTexture) под шум 
	mov     ecx, ds:Device
	mov     ecx, [ecx+1D4h]
	lea     eax, [esp+8+texture_name]
	push    eax
	call    ds:CResourceManager___CreateTexture
	test    eax, eax
	mov     [esp+8+tex_1], eax
	jz      short loc_3A7773B
	add     [eax+4], esi
	mov     eax, [esp+8+tex_1]
loc_3A7773B:                       
	test    eax, eax
	mov     [esp+8+tex_2], eax
	jz      short loc_3A77746
	add     [eax+4], esi
loc_3A77746:                         
	mov     esi, [esp+8+texture]
	; обычная лабуда с пересчетом ссылок в умных указателях на текстуру
	mov     ecx, esi
	call    ds:resptr_base_CTexture____dec
	mov     edx, [esp+8+tex_2]
	lea     ecx, [esp+8+tex_1]
	mov     [esi], edx
	call    ds:resptr_base_CTexture____dec
	; устанавливаем соответствие между созданной DirectX текстурой и внутриигровой текстурой
	mov     eax, [ebx]
	mov     ecx, [esi]
	push    eax
	call    ds:CTexture__surface_set
	mov     eax, [ebx]
	add		esp, 8
	retn	18h
prepare_rendertarget endp

aCrendertargetC db "CRenderTarget::CRenderTarget", 0
atest db "sorry", 0
byte_3AA95E7 db 0