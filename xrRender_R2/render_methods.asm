; ѕоследовательность рендера:
; 1) устанавливаем рендертаргет (CRenderTarget::u_setrt).  уда будем рисовать.
; 2) устанавливаем режим куллинга (CBackend__set_CullMode). ќпредел€ет пор€док обхода вершин при рендеринге. ќбычно устанавливать 3 (D3DRSCULL_CCW).
; 3) устанавливаем стейт дл€ стенсила (CBackend::set_Stencil). “очно не знаю, когда нужно туда писать, дл€ полноэкранных квадов, как правило, запись в стенсил отключена.
; 4) устанавливаем режим записи в текстуру (CBackend::set_ColorWriteEnable). ”станавливать 15, можно часто не перезаписывать.
; 5) лочим вершинный/индексный буфер (_VertexStream::Lock)
; 6) загон€ем в буфер вершины/индексы. ¬ершины устанавливаютс€ согласно декларации.
; 7) разлочиваем буфер (_VertexStream::Unlock)
; 8) устанавливаем шейдер (CBackend::set_Element)
; 9) устанавливаем геометрию (CBackend__set_Geometry)
; 10) устанавливаем константы (CBackend__set_c_const_char_vector4 и др.)
; 11) рендерим (CBackend__Render)

DISABLE_STENCIL MACRO
	mov     ecx, ds:RCache
	push    1
	push    1
	push    1
	push    0
	push    0
	push    0
	push    8
	push    0
	call    ds:CBackend__set_Stencil	
ENDM	

FILL_VERTEX_BUFFER_AA_GEOMETRY MACRO
local normal_height
; 5) лочим вершинный/индексный буфер (_VertexStream::Lock)
	lea     ecx, [esp+170h-134h]	; offset
	push    ecx
	mov     eax, [ebx+128h]
	mov     edx, [eax+14h]
	push    edx
	push    4
	mov		ecx, ds:RCache
	call    ds:_VertexStream__Lock	; в eax указатель на кусок видеопам€ти
	
; 6) загон€ем в буфер вершины/индексы. ¬ершины устанавливаютс€ согласно декларации.	
	mov		edx, ds:Device
	fild	dword ptr [edx+100h]
	mov     ecx, [edx+104h]
	fstp    dword ptr [esp+170h-150h+4]
	test    ecx, ecx
	fild    dword ptr [edx+104h]
	jge     short normal_height
	fadd    ds:__real@4f800000
	
normal_height:
	movss   xmm1, ps_r2_lt_smooth
	fstp    dword ptr [esp+170h-15Ch]
	movss   xmm3, ds:__real@3f000000
	movss   xmm2, dword ptr [esp+170h-150h+4]
	movss   xmm5, dword ptr [esp+170h-15Ch]
	movaps  xmm0, xmm1
	divss   xmm0, xmm2
	movaps  xmm4, xmm0
	movss   dword ptr [esp+170h-150h], xmm0
	mulss   xmm4, xmm3
	divss   xmm1, xmm5
	addss   xmm2, xmm3
	mulss   xmm2, xmm0
	movss   dword ptr [esp+170h-0ECh], xmm4
	movaps  xmm0, xmm5
	movaps  xmm4, xmm1
	addss   xmm0, xmm3
	mulss   xmm4, xmm3
	mulss   xmm0, xmm1
	movss   dword ptr [esp+170h-154h], xmm1
	movss   dword ptr [esp+170h-0E8h], xmm4
	movss   dword ptr [esp+170h-0E4h], xmm2
	movss   dword ptr [esp+170h-0E0h], xmm0
	movss   xmm3, ds:EPS_4
	movss   xmm0, dword ptr [esp+14h]
	movss   xmm2, dword ptr [esp+16Ch-0DCh]
	movss   xmm1, dword ptr [esp+16Ch-150h+4]
	movss   xmm7, dword ptr [esp+16Ch-150h]
	movss   dword ptr [eax], xmm3
	movss   dword ptr [eax+8], xmm3
	addss   xmm0, xmm3
	movss   dword ptr [eax+4], xmm0
	movss   dword ptr [esp+16Ch-140h], xmm0
	movss   xmm0, ps_r2_lt_smooth
	movss   dword ptr [eax+0Ch], xmm0
	movss   xmm0, dword ptr [esp+16Ch-0E8h]
	movss   dword ptr [eax+10h], xmm0
	movss   dword ptr [eax+14h], xmm2
	movaps  xmm4, xmm0
	subss   xmm4, xmm1
	movss   dword ptr [eax+18h], xmm4
	addss   xmm1, xmm0
	movaps  xmm5, xmm2
	subss   xmm5, xmm7
	movss   dword ptr [eax+1Ch], xmm5
	movss   dword ptr [eax+20h], xmm1
	movaps  xmm6, xmm7
	addss   xmm6, xmm2
	movss   dword ptr [eax+24h], xmm6
	movss   dword ptr [eax+28h], xmm1
	movss   dword ptr [eax+2Ch], xmm5
	movss   dword ptr [eax+30h], xmm4
	movss   dword ptr [eax+34h], xmm6
	movss   dword ptr [eax+44h], xmm1
	movss   dword ptr [eax+38h], xmm4
	movss   dword ptr [eax+3Ch], xmm2
	movss   dword ptr [eax+40h], xmm2
	movss   dword ptr [eax+48h], xmm0
	movss   dword ptr [eax+4Ch], xmm5
	movss   dword ptr [eax+50h], xmm6
	movss   dword ptr [eax+54h], xmm0
	add     eax, 58h
	movss   dword ptr [esp+16Ch-15Ch], xmm1
	movss   xmm1, ps_r2_lt_smooth ; float ps_r2_lt_smooth
	movss   dword ptr [eax+0Ch], xmm1
	movss   xmm1, dword ptr [esp+16Ch-0E4h]
	movss   dword ptr [eax], xmm3
	movss   dword ptr [eax+4], xmm3
	movss   dword ptr [eax+8], xmm3
	movss   dword ptr [eax+10h], xmm0
	movss   dword ptr [eax+14h], xmm1
	movss   dword ptr [esp+14h], xmm6
	movss   dword ptr [eax+18h], xmm4
	add     eax, 58h
	movaps  xmm6, xmm1
	subss   xmm6, xmm7
	movss   dword ptr [eax-3Ch], xmm6
	movss   xmm7, dword ptr [esp+16Ch-15Ch]
	movss   dword ptr [eax-38h], xmm7
	movss   xmm7, dword ptr [esp+16Ch-150h]
	addss   xmm7, xmm1
	movss   dword ptr [eax-34h], xmm7
	movss   dword ptr [eax-2Ch], xmm6
	movss   dword ptr [esp+16Ch-150h], xmm7
	movss   xmm7, dword ptr [esp+16Ch-15Ch]
	movss   dword ptr [eax-30h], xmm7
	movss   dword ptr [eax-28h], xmm4
	movss   xmm7, dword ptr [esp+16Ch-150h]
	movss   dword ptr [eax-24h], xmm7
	movss   dword ptr [eax-20h], xmm4
	movss   dword ptr [eax-1Ch], xmm1
	movss   dword ptr [eax-18h], xmm1
	movss   xmm4, dword ptr [esp+16Ch-15Ch]
	movss   dword ptr [eax-14h], xmm4
	movss   dword ptr [eax-10h], xmm0
	movss   dword ptr [eax-8], xmm7
	movss   dword ptr [eax-4], xmm0
	movss   dword ptr [eax-0Ch], xmm6
	movss   xmm0, dword ptr [esp+16Ch-148h]
	movss   dword ptr [eax+8], xmm3
	movss   xmm7, dword ptr [esp+16Ch-150h+4]
	addss   xmm0, xmm3
	movss   dword ptr [eax], xmm0
	movss   dword ptr [esp+16Ch-148h], xmm0
	movss   xmm0, dword ptr [esp+16Ch-140h]
	movss   dword ptr [eax+4], xmm0
	movss   xmm0, ps_r2_lt_smooth ; float ps_r2_lt_smooth
	movss   dword ptr [eax+0Ch], xmm0
	movss   xmm0, dword ptr [esp+16Ch-0E0h]
	movss   dword ptr [eax+14h], xmm2
	movss   dword ptr [eax+10h], xmm0
	movss   dword ptr [eax+1Ch], xmm5
	movaps  xmm4, xmm0
	subss   xmm4, xmm7
	movss   dword ptr [eax+18h], xmm4
	addss   xmm7, xmm0
	movss   dword ptr [eax+20h], xmm7
	movss   dword ptr [esp+16Ch-150h+4], xmm7
	movss   xmm7, dword ptr [esp+14h]
	movss   dword ptr [eax+24h], xmm7
	movss   xmm7, dword ptr [esp+16Ch-150h+4]
	movss   dword ptr [eax+28h], xmm7
	movss   xmm7, dword ptr [esp+14h]
	movss   dword ptr [eax+2Ch], xmm5
	movss   dword ptr [eax+30h], xmm4
	movss   dword ptr [eax+34h], xmm7
	movss   dword ptr [eax+3Ch], xmm2
	movss   dword ptr [eax+40h], xmm2
	movss   xmm2, dword ptr [esp+16Ch-150h+4]
	movss   dword ptr [eax+38h], xmm4
	movss   dword ptr [eax+44h], xmm2
	movss   dword ptr [eax+4Ch], xmm5
	movss   xmm5, dword ptr [esp+16Ch-148h]
	movss   dword ptr [eax+48h], xmm0
	movss   dword ptr [eax+50h], xmm7
	movss   dword ptr [eax+54h], xmm0
	add     eax, 58h
	movss   dword ptr [eax+4], xmm3
	movss   dword ptr [eax+8], xmm3
	movss   xmm3, ps_r2_lt_smooth ; float ps_r2_lt_smooth
	movss   dword ptr [eax+0Ch], xmm3
	movss   xmm3, dword ptr [esp+16Ch-150h]
	movss   dword ptr [eax], xmm5
	movss   dword ptr [eax+10h], xmm0
	movss   dword ptr [eax+14h], xmm1
	movss   dword ptr [eax+18h], xmm4
	movss   dword ptr [eax+1Ch], xmm6
	movss   dword ptr [eax+20h], xmm2
	movss   dword ptr [eax+24h], xmm3
	movss   dword ptr [eax+28h], xmm2
	movss   dword ptr [eax+2Ch], xmm6
	movss   dword ptr [eax+30h], xmm4
	movss   dword ptr [eax+34h], xmm3
	movss   dword ptr [eax+38h], xmm4
	movss   dword ptr [eax+3Ch], xmm1
	movss   dword ptr [eax+40h], xmm1
	movss   dword ptr [eax+44h], xmm2
	movss   dword ptr [eax+48h], xmm0
	movss   dword ptr [eax+4Ch], xmm6
	movss   dword ptr [eax+50h], xmm3
	movss   dword ptr [eax+54h], xmm0
	
; 7) разлочиваем буфер (_VertexStream::Unlock)	
	mov     eax, [ebx+128h]
	mov     ecx, [eax+14h]
	push    ecx
	mov     ecx, ds:RCache
	push    4
	call    ds:_VertexStream__Unlock
ENDM

CRenderTarget__u_setrt_one proc
rt_1 = dword ptr 4
rt_2 = dword ptr -4
rt_3 = dword ptr -8
;this = ebx
	sub		esp, 8
	xor		edx, edx
	mov		[esp+8+rt_3], edx
	mov		[esp+8+rt_2], edx
	mov		edx, ds:HW
	mov     edx, [edx+10h]
	push    edx             ; _3
	lea     eax, [esp+0Ch+rt_3]
	push    eax             ; _2
	lea     ecx, [esp+10h+rt_2]
	push    ecx             ; this
	mov     eax, [esp+14h+rt_1]
	mov     ecx, ebx
	call    CRenderTarget__u_setrt
	lea     ecx, [esp+8+rt_2]
	call    ds:resptr_base___dec
	lea     ecx, [esp+8+rt_3]
	call    ds:resptr_base___dec
	add		esp, 8
	retn	4
CRenderTarget__u_setrt_one endp

; –ендер установленной в буфер геометрии с изменением статистики и записью констант дл€ шейдеов
;void CBackend::Render(_D3DPRIMITIVETYPE T, unsigned int baseV, unsigned int startV, unsigned int countV, unsigned int startI, unsigned int PC)
;{
;	++stat.calls;
;	stat.polys += countV;
;	stat.verts += PC;
;	if ( constants.a_pixel.b_dirty || constants.a_vertex.b_dirty )
;		constants.flush();
;	HW.pDevice->DrawIndexedPrimitive(T, baseV, startV, countV, startI, PC);
;}
RENDER_QUAD MACRO OFF:REQ
	push    2
	push    0
	push    4
	push    0
	push    OFF
	push    4
	mov		ecx, ds:RCache
	call 	CBackend__Render
ENDM

CBackend__Render proc near
; this = ecx
T               = dword ptr  4		;D3DPRIMITIVETYPE
baseV           = dword ptr  8		;BaseVertexIndex
startV          = dword ptr  0Ch	;MinVertexIndex
countV          = dword ptr  10h	;NumVertices
startI          = dword ptr  14h	;startIndex
PC              = dword ptr  18h	;primCount

	add     dword ptr [ecx+22D0h], 1
	push    esi
	mov     esi, [esp+4+countV]
	add     [ecx+22CCh], esi
	push    edi
	mov     edi, [esp+8+PC]
	add     [ecx+22C8h], edi
	add     ecx, 1F0h      ; this
	cmp     dword ptr [ecx+1010h], 0
	jnz     short loc_4073D5
	cmp     dword ptr [ecx+2030h], 0
	jz      short loc_4073DA

loc_4073D5:                          
	call    R_constants__flush_cache

loc_4073DA:                            
	mov     edx, [esp+8+startI]
	mov     eax, ds:HW				; CHW *HW
	mov		eax, [eax+8]			; IDirect3DDevice9 *pDevice
	mov     ecx, [eax]				; IDirect3DDevice9_vftable
	push    edi						; primCount
	push    edx						; startIndex
	mov     edx, [esp+10h+startV]
	push    esi						; NumVertices
	push    edx						; MinVertexIndex
	mov     edx, [esp+18h+baseV]
	push    edx						; BaseVertexIndex
	mov     edx, [esp+1Ch+T]
	push    edx						; type
	push    eax						; this
	mov     eax, [ecx+148h]
	call    eax						;void DrawIndexedPrimitive(D3DPRIMITIVETYPE,INT BaseVertexIndex,UINT MinVertexIndex,UINT NumVertices,UINT startIndex,UINT primCount)
	pop     edi
	pop     esi
	retn    18h
CBackend__Render endp

; ”становка режима куллинга
;void CBackend::set_CullMode(unsigned int _mode)
;{
;	if ( cull_mode != _mode ) {
;		cull_mode = _mode;
;		HW.pDevice->SetRenderState(D3DRS_CULLMODE, _mode);
;	}
;}
DISABLE_CULLING MACRO
	mov		ecx, ds:RCache
	push	0
	call	CBackend__set_CullMode
ENDM

CBackend__set_CullMode proc near
_mode           = dword ptr  4
;this = ecx
	mov     eax, [esp+_mode]
	cmp     [ecx+2264h], eax
	jz      short exit
	mov     [ecx+2264h], eax
	mov     ecx, ds:HW			; CHW *HW
	mov     ecx, [ecx+8]		; IDirect3DDevice9 *pDevice
	mov     edx, [ecx]			; IDirect3DDevice9 vftable
	push    eax
	mov     eax, [edx+0E4h]
	push    16h
	push    ecx
	call    eax					; SetRenderState
exit: 
	retn    4
CBackend__set_CullMode endp

; ”становка геометрии дл€ рендеринга
;void CBackend::set_Geometry(SGeometry *_geom)
;{
;	if ( decl != _geom->dcl->dcl) {
;		decl = _geom->dcl->dcl;
;		HW.pDevice->SetVertexDeclaration(_geom->dcl->dcl);
;	}
;	if ( vb != _geom->vb || vb_stride != _geom-vb_stride ) {
;		vb_stride = _geom->vb_stride;
;		vb = _geom->vb;
;		HW.pDevice->SetStreamSource(0, _geom->vb, 0, _geom->vb_stride);
;	}
;	if ( ib != _geom->ib ) {
;		ib = _geom->ib;
;		HW.pDevice->SetIndices(_geom->ib);
;	}
;}

SET_AA_GEOMETRY MACRO
	mov		ecx, [ebx+128h]
	push	ecx
	mov     ecx, ds:RCache
	call	CBackend__set_Geometry
ENDM

CBackend__set_Geometry proc near

_geom           = dword ptr  4
;this = ecx
	push    esi
	push    edi
	mov     edi, [esp+8+_geom]
	mov     eax, [edi+8]
	mov     eax, [eax+8]
	mov     esi, ecx
	cmp     [esi+1DCh], eax
	jz      short same_decl
	mov     [esi+1DCh], eax
	mov     ecx, ds:HW
	mov     ecx, [ecx+8]
	mov     edx, [ecx]
	push    eax
	mov     eax, [edx+15Ch]
	push    ecx
	call    eax		;SetVertexDeclaration

same_decl:
	mov     eax, [edi+0Ch]
	cmp     [esi+1E0h], eax
	mov     ecx, [edi+14h]
	jnz     short not_same_vb
	cmp     [esi+1E8h], ecx
	jz      short same_vb_and_stride
	
not_same_vb:
	push    ebx
	push    ecx
	push    0
	mov     [esi+1E8h], ecx
	mov     [esi+1E0h], eax
	mov     edx, ds:HW
	mov     edx, [edx+8]
	mov     ebx, [edx]
	mov     ecx, [ebx+190h]
	push    eax
	push    0
	push    edx
	call    ecx
	pop     ebx

same_vb_and_stride:
	mov     eax, [edi+10h]
	cmp     [esi+1E4h], eax
	jz      short same_ib
	mov     [esi+1E4h], eax
	mov     ecx, ds:HW
	mov     ecx, [ecx+8]
	mov     edx, [ecx]
	push    eax
	mov     eax, [edx+1A0h]
	push    ecx
	call    eax

same_ib:
	pop     edi
	pop     esi
	retn    4
CBackend__set_Geometry endp

; ”становка констант
CBackend__set_c_const_char_vector4 proc near
n               = dword ptr  4	;name
A               = dword ptr  8	;vector
;this = ecx
	push    esi
	mov     esi, ecx
	mov     ecx, [esi+2230h] ; this
	test    ecx, ecx
	jz      exit
	mov     eax, [esp+4+n]
	push    eax             ; S
	lea     edx, [esp+8+n]
	push    edx             ; result
	call    R_constant_table__get_char_const
	mov     edx, [eax]
	test    edx, edx
	jz      loc_405390
	mov     ecx, [esp+4+A]
	add     esi, 1F0h
	test    byte ptr [edx+0Ah], 1
	push    edi
	jz      short loc_405337
	movzx   eax, word ptr [edx+0Ch]
	fld     dword ptr [ecx]
	shl     eax, 4
	add     eax, esi
	fstp    dword ptr [eax]
	fld     dword ptr [ecx+4]
	fstp    dword ptr [eax+4]
	fld     dword ptr [ecx+8]
	fstp    dword ptr [eax+8]
	fld     dword ptr [ecx+0Ch]
	fstp    dword ptr [eax+0Ch]
	movzx   eax, word ptr [edx+0Ch]
	cmp     eax, [esi+1004h]
	lea     edi, [eax+1]
	jnb     short loc_40531F
	mov     [esi+1004h], eax

loc_40531F:
	cmp     edi, [esi+1008h]
	jbe     short loc_40532D
	mov     [esi+1008h], edi

loc_40532D:
	mov     dword ptr [esi+1010h], 1

loc_405337:
	test    byte ptr [edx+0Ah], 2
	jz      short loc_40538F
	movzx   eax, word ptr [edx+10h]
	fld     dword ptr [ecx]
	shl     eax, 4
	lea     edi, [esi+1020h]
	add     eax, edi
	fstp    dword ptr [eax]
	fld     dword ptr [ecx+4]
	fstp    dword ptr [eax+4]
	fld     dword ptr [ecx+8]
	fstp    dword ptr [eax+8]
	fld     dword ptr [ecx+0Ch]
	fstp    dword ptr [eax+0Ch]
	movzx   eax, word ptr [edx+10h]
	cmp     eax, [edi+1004h]
	lea     ecx, [eax+1]
	jnb     short loc_405377
	mov     [edi+1004h], eax

loc_405377:
	cmp     ecx, [edi+1008h]
	jbe     short loc_405385
	mov     [edi+1008h], ecx

loc_405385: 
	mov     dword ptr [esi+2030h], 1

loc_40538F: 
	pop     edi

loc_405390:
	mov     eax, [esp+4+n]
	test    eax, eax
	jz      short exit
	add     dword ptr [eax], 0FFFFFFFFh
	mov     ecx, [esp+4+n]
	cmp     dword ptr [ecx], 0
	jnz     short exit
	mov     eax, [ecx+4]
	add     ecx, 4
	test    eax, eax
	jz      short loc_4053BE
	add     dword ptr [eax], 0FFFFFFFFh
	mov     eax, [ecx]
	cmp     dword ptr [eax], 0
	jnz     short loc_4053BE
	mov     dword ptr [ecx], 0

loc_4053BE: 
	mov     ecx, [esp+4+n]
	push    ecx
	mov     ecx, ds:_Memory
	call    ds:xrMemory__mem_free

exit:
	pop     esi
	retn    8
CBackend__set_c_const_char_vector4 endp

CBackend__set_c_const_char_four_float proc
n               = dword ptr  4
x               = dword ptr  8
vector			= dword ptr  -10h

	sub		esp, 10h
	mov		ecx, [esp+10h+x]
	mov		[esp+10h+vector], ecx
	xor		ecx, ecx
	mov		[esp+10h+vector+4], ecx
	mov		[esp+10h+vector+8], ecx
	mov		[esp+10h+vector+0Ch], ecx
	lea		ecx, [esp+10h+vector]
	push	ecx
	mov		ecx, [esp+14h+n]
	push	ecx	
	mov		ecx, ds:RCache
	call	CBackend__set_c_const_char_vector4
	add		esp, 10h
	retn	8
CBackend__set_c_const_char_four_float endp

ps_r2_lt_smooth dd 1.0
__real@3f000000 dd 0.5
__real@4f800000 dd 4.2949673e9
EPS_4 dd 0.00001