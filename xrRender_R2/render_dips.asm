; свободные регистры: esi, ecx, edx, eax
; ebx - this
new_render_dips:
	call	CRenderTarget__phase_bloom
;================================================
;	МАСКА САНШАФТОВ
;================================================
; 1) устанавливаем рендертаргет (CRenderTarget::u_setrt). Куда будем рисовать.
	lea		esi, [ebx+198h]	;t_sunshafts_mask
	push	esi
	call	CRenderTarget__u_setrt_one
	
;2) устанавливаем режим куллинга (CBackend__set_CullMode). Определяет порядок обхода вершин при рендеринге. Обычно устанавливать 0 (D3DRSCULL_NONE).
DISABLE_CULLING
	
; 3) устанавливаем стейт для стенсила (CBackend::set_Stencil). Точно не знаю, когда нужно туда писать, для полноэкранных квадов, как правило, запись в стенсил отключена.
DISABLE_STENCIL
	
; 4) устанавливаем режим записи в текстуру (CBackend::set_ColorWriteEnable). Устанавливать 15, можно часто не перезаписывать.
	; уже готово
	
; 5) загоняем вершины в буфер
FILL_VERTEX_BUFFER_AA_GEOMETRY

; 8) устанавливаем шейдер (CBackend::set_Element)
	mov		eax, [ebx+194h]
	add     eax, 8			; E[0]
	push	0
	push    eax
	mov     ecx, ds:RCache
	call    ds:CBackend__set_Element

; 9) устанавливаем геометрию (CBackend__set_Geometry)
SET_AA_GEOMETRY
	
; 10) устанавливаем константы (CBackend__set_c_const_char_vector4 и др.)
	; в данном проходе не нужны
; 11) рендерим (CBackend__Render). Тут простой квад, ничего сложного
	mov		ecx, [esp+170h-134h]
	RENDER_QUAD ecx
;COMMENT @
;================================================
;	БЛЮР САНШАФТОВ - 1 проход
;================================================
; 1) устанавливаем рендертаргет (CRenderTarget::u_setrt). Куда будем рисовать.
	lea		esi, [ebx+19Ch]	;t_sunshafts
	push	esi
	call	CRenderTarget__u_setrt_one
	
;2) устанавливаем режим куллинга (CBackend__set_CullMode). Определяет порядок обхода вершин при рендеринге. Обычно устанавливать 3 (D3DRSCULL_CCW).
;	DISABLE_CULLING
	
; 3) устанавливаем стейт для стенсила (CBackend::set_Stencil). Точно не знаю, когда нужно туда писать, для полноэкранных квадов, как правило, запись в стенсил отключена.
;	DISABLE_STENCIL
	
; 4) устанавливаем режим записи в текстуру (CBackend::set_ColorWriteEnable). Устанавливать 15, можно часто не перезаписывать.
	; уже готово
	
; 5) лочим вершинный/индексный буфер (_VertexStream::Lock)
FILL_VERTEX_BUFFER_AA_GEOMETRY
	
; 8) устанавливаем шейдер (CBackend::set_Element)
	mov		eax, [ebx+194h]
	add     eax, 0Ch	;	E[1]
	push	0
	push    eax
	mov     ecx, ds:RCache
	call    ds:CBackend__set_Element

; 9) устанавливаем геометрию (CBackend__set_Geometry)
SET_AA_GEOMETRY
	
; 10) устанавливаем константы (CBackend__set_c_const_char_vector4 и др.)
	push	first_blur_pass
	push	offset quant
	mov		ecx, ds:RCache
	call	CBackend__set_c_const_char_four_float
; 11) рендерим (CBackend__Render). Тут простой квад, ничего сложного
	mov		ecx, [esp+170h-134h]
	RENDER_QUAD ecx

;COMMENT @
;================================================
;	БЛЮР САНШАФТОВ - 2 проход
;================================================
; 1) устанавливаем рендертаргет (CRenderTarget::u_setrt). Куда будем рисовать.
	lea		esi, [ebx+198h]		;t_sunshafts_mask
	push	esi
	call	CRenderTarget__u_setrt_one
	
;2) устанавливаем режим куллинга (CBackend__set_CullMode). Определяет порядок обхода вершин при рендеринге. Обычно устанавливать 3 (D3DRSCULL_CCW).
;	DISABLE_CULLING
	
; 3) устанавливаем стейт для стенсила (CBackend::set_Stencil). Точно не знаю, когда нужно туда писать, для полноэкранных квадов, как правило, запись в стенсил отключена.
;	DISABLE_STENCIL
	
; 4) устанавливаем режим записи в текстуру (CBackend::set_ColorWriteEnable). Устанавливать 15, можно часто не перезаписывать.
	; уже готово
	
; 5) лочим вершинный/индексный буфер (_VertexStream::Lock)
FILL_VERTEX_BUFFER_AA_GEOMETRY
	
; 8) устанавливаем шейдер (CBackend::set_Element)
	mov		eax, [ebx+194h]
	add     eax, 10h	;	E[2]
	push	0
	push    eax
	mov     ecx, ds:RCache
	call    ds:CBackend__set_Element

; 9) устанавливаем геометрию (CBackend__set_Geometry)
SET_AA_GEOMETRY
	
; 10) устанавливаем константы (CBackend__set_c_const_char_vector4 и др.)
	push	second_blur_pass
	push	offset quant
	mov		ecx, ds:RCache
	call	CBackend__set_c_const_char_four_float
; 11) рендерим (CBackend__Render). Тут простой квад, ничего сложного
	mov		ecx, [esp+170h-134h]
	RENDER_QUAD ecx
	
;================================================
;	БЛЮР САНШАФТОВ - 3 проход
;================================================
; 1) устанавливаем рендертаргет (CRenderTarget::u_setrt). Куда будем рисовать.
	lea		esi, [ebx+19Ch]		;t_sunshafts
	push	esi
	call	CRenderTarget__u_setrt_one
	
;2) устанавливаем режим куллинга (CBackend__set_CullMode). Определяет порядок обхода вершин при рендеринге. Обычно устанавливать 3 (D3DRSCULL_CCW).
;	DISABLE_CULLING
	
; 3) устанавливаем стейт для стенсила (CBackend::set_Stencil). Точно не знаю, когда нужно туда писать, для полноэкранных квадов, как правило, запись в стенсил отключена.
;	DISABLE_STENCIL
	
; 4) устанавливаем режим записи в текстуру (CBackend::set_ColorWriteEnable). Устанавливать 15, можно часто не перезаписывать.
	; уже готово
	
; 5) лочим вершинный/индексный буфер (_VertexStream::Lock)
FILL_VERTEX_BUFFER_AA_GEOMETRY
	
; 8) устанавливаем шейдер (CBackend::set_Element)
	mov		eax, [ebx+194h]
	add     eax, 0Ch	;	E[1]
	push	0
	push    eax
	mov     ecx, ds:RCache
	call    ds:CBackend__set_Element

; 9) устанавливаем геометрию (CBackend__set_Geometry)
SET_AA_GEOMETRY
	
; 10) устанавливаем константы (CBackend__set_c_const_char_vector4 и др.)
	push	third_blur_pass
	push	offset quant
	mov		ecx, ds:RCache
	call	CBackend__set_c_const_char_four_float
; 11) рендерим (CBackend__Render). Тут простой квад, ничего сложного
	mov		ecx, [esp+170h-134h]
	RENDER_QUAD ecx
;@
	jmp back_to_new_render_dips

first_blur_pass dd 0.1
second_blur_pass dd 0.07
third_blur_pass dd 0.03
quant db "vector_quant", 0