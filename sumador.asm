.include "./m328Pdef.inc"
;Fabio Anaya, Maria Clara Lacouture, Pablo Restrepo 
start:
	clc	;verificar el carry en 0
	cln	;verificar el signo en 0
	clz	;verificar el zero en 0
	ldi r16,0b00001100	;inicializamos variable 1
	ldi r17,0b00000010	;inicializamos variable 2
	ldi r18,0b00000000	;inicializa variable de negativo1
	ldi r19,0b00000000	;inicializa variable de negativo2
	ldi r20,0b00000000	;inicializa variable carry
	rol r16		;se hace movimiento izquierda
	rol r16		;se hace movimiento izquierda
	rol r16		;se hace movimiento izquierda
	rol r16		;se hace movimiento izquierda
	brcs neg1	;se verifica si es negativo con el 5 bit 
re1:			;punto en donde se devuelve después del branch
	ror r16		;se devuelve a la derecha
	ror r16		;se devuelve a la derecha
	ror r16		;se devuelve a la derecha
	ror r16		;se devuelve a la derecha
	rol r17		;se hace movimiento izquierda
	rol r17		;se hace movimiento izquierda
	rol r17		;se hace movimiento izquierda
	rol r17		;se hace movimiento izquierda
	brcs neg2	;se verifica si es negativo con el 5 bit 
re2:			;punto en donde se devuelve después del branch
	ror r17		;se devuelve a la derecha
	ror r17		;se devuelve a la derecha
	ror r17		;se devuelve a la derecha
	ror r17		;se devuelve a la derecha
	cp r18,r19	;compara los signos, r18 para r16 y r19 para r17
	breq suma	;si ambos signos son iguales, se ejecuta una suma normal
	brmi res1	;si r17 es negativo, entonces se resta r16 con r17
	brpl res2	;si r16 es negativo, entonces se resta r17 con r16
cont:			;punto en donde se devuelve después del branch
	clc		;setea carry en 0
	ror r16		;se hace movimiento derecha
	ror r16		;se hace movimiento derecha
	ror r16		;se hace movimiento derecha
	ror r16		;se hace movimiento derecha
	ror r16		;se hace movimiento derecha
	brcs tcarry	;se comprueba si hay bit demás (5bits despues de la suma)
cont1:			;se devuelve después de la comprobación de bits demás
	rol r16		;se devuelve a la izquierda
	rol r16		;se devuelve a la izquierda
	rol r16		;se devuelve a la izquierda
	rol r16		;se devuelve a la izquierda
	rol r16		;se devuelve a la izquierda
	brts fneg	;se completa la negatividad del numero
cont2:			;punto despues del negativo
	rjmp fin	;jump al fin del codigo
neg1:			;si el primer numero es negativo
	ldi r18,0b00000001;se guarda el signo
	clc		;se elimina el signo del carry
	rjmp re1	;retorna
neg2:			;si el segundo numero es negativo
	ldi r19,0b00000001;se guarda el signo
	clc		;se elimina el signo del carry
	rjmp re2	;retorna
suma:			;se realiza suma normal	
	add r16,r17	;suma
	rjmp cont	;retorna
res1:			;si el segundo numero es negativo
	cln		;se setea a 0 flag negativo 
	cp r16,r17	;se comparan los numeros
	brmi res12	;si r17 es mayor, entra
	sub r16,r17	;sino se resta normal
	rjmp cont	;regresa
res12:			;si r17 es mayor
	sub r17,r16	;resta
	mov r16,r17	;se coloca el resultado en r16
	set		;se dice que el resultado es negativo(setea T)
	rjmp cont	;regresa 	
res2:			;si el primer numero es negativo
	cln		;se setea a 0 flag negativo 
	cp r17,r16	;se comparan los numeros
	brmi res22	;si r16 es mayor, entra
	sub r17,r16	;sino se resta normal
	mov r16,r17	;se coloca el resultado en r16
	rjmp cont	;regresa
res22:			;si r16 es mayor
	sub r16,r17	;resta
	set		;se dice que el resultado es negativo(setea T)
	rjmp cont	;regresa
tcarry:			;si hay "carry" acumulado
	clc		;se coloca el carry en 0
	rol r16		;se mueve a la derecha
	sec		;se coloca el carry en el último bit
	ror r16		;se devuelve a la derecha
	rjmp cont1	;regresa
fneg:			;si el numero resultante es negativo
	rol r16		;se hace movimiento izquierda	
	rol r16		;se hace movimiento izquierda	
	rol r16		;se hace movimiento izquierda	
	rol r16		;se hace movimiento izquierda	
	sec		;se setea el 5bit como negativo
	ror r16		;se devuelve a la derecha
	ror r16		;se devuelve a la derecha
	ror r16		;se devuelve a la derecha
	ror r16		;se devuelve a la derecha
	rjmp cont2	;se devuelve
fin:			;fin del codigo
	ldi r20,0b00111111;se va a utilizar estos bits del puerto	
	out DDRB,r20	;se prepara para ser utilizado
	out PortB,r16 	;se muestra el resultado.
