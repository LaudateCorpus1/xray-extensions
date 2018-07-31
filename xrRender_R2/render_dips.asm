; ��������� ��������: esi, ecx, edx, eax
; ebx - this
new_render_dips:
	call	CRenderTarget__phase_bloom
;================================================
;	����� ���������
;================================================
; 1) ������������� ������������ (CRenderTarget::u_setrt). ���� ����� ��������.
	lea		esi, [ebx+198h]	;t_sunshafts_mask
	push	esi
	call	CRenderTarget__u_setrt_one
	
;2) ������������� ����� �������� (CBackend__set_CullMode). ���������� ������� ������ ������ ��� ����������. ������ ������������� 0 (D3DRSCULL_NONE).
DISABLE_CULLING
	
; 3) ������������� ����� ��� �������� (CBackend::set_Stencil). ����� �� ����, ����� ����� ���� ������, ��� ������������� ������, ��� �������, ������ � ������� ���������.
DISABLE_STENCIL
	
; 4) ������������� ����� ������ � �������� (CBackend::set_ColorWriteEnable). ������������� 15, ����� ����� �� ��������������.
	; ��� ������
	
; 5) �������� ������� � �����
FILL_VERTEX_BUFFER_AA_GEOMETRY

; 8) ������������� ������ (CBackend::set_Element)
	mov		eax, [ebx+194h]
	add     eax, 8			; E[0]
	push	0
	push    eax
	mov     ecx, ds:RCache
	call    ds:CBackend__set_Element

; 9) ������������� ��������� (CBackend__set_Geometry)
SET_AA_GEOMETRY
	
; 10) ������������� ��������� (CBackend__set_c_const_char_vector4 � ��.)
	; � ������ ������� �� �����
; 11) �������� (CBackend__Render). ��� ������� ����, ������ ��������
	mov		ecx, [esp+170h-134h]
	RENDER_QUAD ecx
;COMMENT @
;================================================
;	���� ��������� - 1 ������
;================================================
; 1) ������������� ������������ (CRenderTarget::u_setrt). ���� ����� ��������.
	lea		esi, [ebx+19Ch]	;t_sunshafts
	push	esi
	call	CRenderTarget__u_setrt_one
	
;2) ������������� ����� �������� (CBackend__set_CullMode). ���������� ������� ������ ������ ��� ����������. ������ ������������� 3 (D3DRSCULL_CCW).
;	DISABLE_CULLING
	
; 3) ������������� ����� ��� �������� (CBackend::set_Stencil). ����� �� ����, ����� ����� ���� ������, ��� ������������� ������, ��� �������, ������ � ������� ���������.
;	DISABLE_STENCIL
	
; 4) ������������� ����� ������ � �������� (CBackend::set_ColorWriteEnable). ������������� 15, ����� ����� �� ��������������.
	; ��� ������
	
; 5) ����� ���������/��������� ����� (_VertexStream::Lock)
FILL_VERTEX_BUFFER_AA_GEOMETRY
	
; 8) ������������� ������ (CBackend::set_Element)
	mov		eax, [ebx+194h]
	add     eax, 0Ch	;	E[1]
	push	0
	push    eax
	mov     ecx, ds:RCache
	call    ds:CBackend__set_Element

; 9) ������������� ��������� (CBackend__set_Geometry)
SET_AA_GEOMETRY
	
; 10) ������������� ��������� (CBackend__set_c_const_char_vector4 � ��.)
	push	first_blur_pass
	push	offset quant
	mov		ecx, ds:RCache
	call	CBackend__set_c_const_char_four_float
; 11) �������� (CBackend__Render). ��� ������� ����, ������ ��������
	mov		ecx, [esp+170h-134h]
	RENDER_QUAD ecx

;COMMENT @
;================================================
;	���� ��������� - 2 ������
;================================================
; 1) ������������� ������������ (CRenderTarget::u_setrt). ���� ����� ��������.
	lea		esi, [ebx+198h]		;t_sunshafts_mask
	push	esi
	call	CRenderTarget__u_setrt_one
	
;2) ������������� ����� �������� (CBackend__set_CullMode). ���������� ������� ������ ������ ��� ����������. ������ ������������� 3 (D3DRSCULL_CCW).
;	DISABLE_CULLING
	
; 3) ������������� ����� ��� �������� (CBackend::set_Stencil). ����� �� ����, ����� ����� ���� ������, ��� ������������� ������, ��� �������, ������ � ������� ���������.
;	DISABLE_STENCIL
	
; 4) ������������� ����� ������ � �������� (CBackend::set_ColorWriteEnable). ������������� 15, ����� ����� �� ��������������.
	; ��� ������
	
; 5) ����� ���������/��������� ����� (_VertexStream::Lock)
FILL_VERTEX_BUFFER_AA_GEOMETRY
	
; 8) ������������� ������ (CBackend::set_Element)
	mov		eax, [ebx+194h]
	add     eax, 10h	;	E[2]
	push	0
	push    eax
	mov     ecx, ds:RCache
	call    ds:CBackend__set_Element

; 9) ������������� ��������� (CBackend__set_Geometry)
SET_AA_GEOMETRY
	
; 10) ������������� ��������� (CBackend__set_c_const_char_vector4 � ��.)
	push	second_blur_pass
	push	offset quant
	mov		ecx, ds:RCache
	call	CBackend__set_c_const_char_four_float
; 11) �������� (CBackend__Render). ��� ������� ����, ������ ��������
	mov		ecx, [esp+170h-134h]
	RENDER_QUAD ecx
	
;================================================
;	���� ��������� - 3 ������
;================================================
; 1) ������������� ������������ (CRenderTarget::u_setrt). ���� ����� ��������.
	lea		esi, [ebx+19Ch]		;t_sunshafts
	push	esi
	call	CRenderTarget__u_setrt_one
	
;2) ������������� ����� �������� (CBackend__set_CullMode). ���������� ������� ������ ������ ��� ����������. ������ ������������� 3 (D3DRSCULL_CCW).
;	DISABLE_CULLING
	
; 3) ������������� ����� ��� �������� (CBackend::set_Stencil). ����� �� ����, ����� ����� ���� ������, ��� ������������� ������, ��� �������, ������ � ������� ���������.
;	DISABLE_STENCIL
	
; 4) ������������� ����� ������ � �������� (CBackend::set_ColorWriteEnable). ������������� 15, ����� ����� �� ��������������.
	; ��� ������
	
; 5) ����� ���������/��������� ����� (_VertexStream::Lock)
FILL_VERTEX_BUFFER_AA_GEOMETRY
	
; 8) ������������� ������ (CBackend::set_Element)
	mov		eax, [ebx+194h]
	add     eax, 0Ch	;	E[1]
	push	0
	push    eax
	mov     ecx, ds:RCache
	call    ds:CBackend__set_Element

; 9) ������������� ��������� (CBackend__set_Geometry)
SET_AA_GEOMETRY
	
; 10) ������������� ��������� (CBackend__set_c_const_char_vector4 � ��.)
	push	third_blur_pass
	push	offset quant
	mov		ecx, ds:RCache
	call	CBackend__set_c_const_char_four_float
; 11) �������� (CBackend__Render). ��� ������� ����, ������ ��������
	mov		ecx, [esp+170h-134h]
	RENDER_QUAD ecx
;@
	jmp back_to_new_render_dips

first_blur_pass dd 0.1
second_blur_pass dd 0.07
third_blur_pass dd 0.03
quant db "vector_quant", 0