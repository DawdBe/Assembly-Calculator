;SOME IMPORTANT NOTES : 
;to pritn a string u can use print_msg MACRO as the following: 
; print_msg <ur_stirng_variable>

;TO READ A NUMBER YOU CAN USE READ_NUMBER as the following: 
;CAll READ_NUMBER

; TO PRINT A NUMBER YOU CAN USE PRINT_NUMBER MACRO as the following: 
; MOV AX, DX // NOTE: UR NUMBER SHOULD BE IN DX 
; CALL PRINT_NUMBER

.MODEL SMALL
.STACK 100H
print_msg MACRO msg
              MOV AH, 9             ; Write string to screen
              MOV DX, OFFSET msg
              INT 21H
ENDM

.DATA
    ; Messages
    menu_msg   DB '1. AND (&)',0DH, 0AH,'2. OR (|) ',0DH, 0AH,'3. XOR (^) ',0DH, 0AH,'4. ADD (+) ',0DH, 0AH,'5. SUB (-) ',0DH, 0AH,'6. MUL (*) ',0DH, 0AH,'7. DIV (/) ',0DH, 0AH,'8. Exit$', 0DH, 0AH, '$'
    num1_msg   DB 'Enter the first number : $'
    num2_msg   DB 'Enter the second number : $'
    result_msg DB 'Result: $'
    error_msg  DB 'Error! Enter a valid choice$', 0DH, 0AH, '$'
    newline    DB 0DH, 0AH, '$'

    ; Variables
    num1       DW ?
    num2       DW ?
    result     DW ?
    operator   DB ?
    isNegative DB ?
.CODE
MAIN PROC
                                MOV       AX, @DATA
                                MOV       DS, AX

    MAIN_LOOP:                  
    ; Display the main menu
                                CALL      print_menu

    ; Read user choice
                                CAll      READ_NUMBER
                                MOV       AX, DX
    ; Process the choice
                                CMP       AX, '1'
                                JE        DO_AND
                                CMP       AX, '2'
                                JE        DO_OR
                                CMP       AX, '3'
                                JE        DO_XOR
                                CMP       AX, '4'
                                JE        DO_ADD
                                CMP       AX, '5'
                                JE        DO_SUB
                                CMP       AX, '6'
                                JE        DO_MUL
                                CMP       AX, '7'
                                JE        DO_DIV
                                CMP       AX, '8'
                                JE        EXIT_PROGRAM

    ; If the choice is invalid
                                CALL      print_error
                                JMP       MAIN_LOOP

    DO_AND:                     
                                MOV       operator, '&'
                                CALL      handle_logical_operation
                                JMP       SHOW_RESULT

    DO_OR:                      
                                MOV       operator, '|'
                                CALL      handle_logical_operation
                                JMP       SHOW_RESULT

    DO_XOR:                     
                                MOV       operator, '^'
                                CALL      handle_logical_operation
                                JMP       SHOW_RESULT

    DO_ADD:                     
                                MOV       operator, '+'
                                CALL      handle_arithmetic_operation
                                JMP       SHOW_RESULT

    DO_SUB:                     
                                MOV       operator, '-'
                                CALL      handle_arithmetic_operation
                                JMP       SHOW_RESULT

    DO_MUL:                     
                                MOV       operator, '*'
                                CALL      handle_arithmetic_operation
                                JMP       SHOW_RESULT

    DO_DIV:                     
                                MOV       operator, '/'
                                CALL      handle_arithmetic_operation
                                JMP       SHOW_RESULT

    SHOW_RESULT:                
                                CALL      print_result
                                JMP       MAIN_LOOP

    EXIT_PROGRAM:               
                                MOV       AH, 4CH
                                INT       21H
MAIN ENDP

    ; --------------------------------------
    ; ADD PROC CODE HERE
    ; --------------------------------------
    

    ; --------------------------------------
    ; READ_NUMBER: Reads a signed integer
    ; --------------------------------------
READ_NUMBER PROC
                                MOV       CX, 0                          ; Counter for first character check
                                MOV       DX, 0                          ; Result storage
                                MOV       isNegative, 0

    READ_LOOP:                  
                                MOV       AH, 01H                        ; Read character
                                INT       21H

                                CMP       CX, 0                          ; First character?
                                JNE       CHECK_DIGIT

                                CMP       AL, '-'                        ; Handle negative sign
                                JNE       CHECK_DIGIT
                                MOV       isNegative, 1
                                INC       CX                             ; Mark first character processed
                                JMP       READ_LOOP

    CHECK_DIGIT:                
                                CMP       AL, 0DH                        ; Check Enter
                                JE        END_READ

                                CMP       AL, '0'                        ; Validate digit
                                JB        READ_LOOP
                                CMP       AL, '9'
                                JA        READ_LOOP

    ; Convert and process digit
                                SUB       AL, 30H
                                MOV       BL, AL                         ; Save digit in BL
                                MOV       AX, DX                         ; Current result
                                MOV       SI, 10
                                MUL       SI                             ; AX = DX * 10
                                ADD       AX, BX                         ; Add new digit
                                MOV       DX, AX                         ; Update result

                                INC       CX                             ; Mark that digits have been processed
                                JMP       READ_LOOP

    END_READ:                   
                                CMP       isNegative, 1
                                JNE       STORE_RESULT
                                NEG       DX                             ; Apply negative sign if needed

    STORE_RESULT:               

                                RET
READ_NUMBER ENDP
    ; --------------------------------------
    ; PRINT_NUMBER: Prints a signed number
    ; --------------------------------------
PRINT_NUMBER PROC
                                PUSH      CX
                                PUSH      DX
                                PUSH      AX

                                CMP       AX, 0
                                JGE       PRINT_POSITIVE

    ; Handle negative number
                                MOV       DL, '-'
                                MOV       AH, 02H
                                INT       21H
                                POP       AX
                                PUSH      AX
                                NEG       AX

    PRINT_POSITIVE:             
                                MOV       CX, 0                          ; Digit counter

    CONVERT_LOOP:               
                                MOV       DX, 0
                                MOV       BX, 10
                                DIV       BX                             ; Extract digit
                                PUSH      DX                             ; Save digit
                                INC       CX
                                CMP       AX, 0
                                JNE       CONVERT_LOOP
                                         

    PRINT_LOOP:                 
                                POP       DX
                                ADD       DL, 30H                        ; Convert to ASCII
                                MOV       AH, 02H
                                INT       21H
                                LOOP      PRINT_LOOP
    
    END_PRINT:                  
                                POP       AX
                                POP       DX
                                POP       CX
                                RET
PRINT_NUMBER ENDP

handle_logical_operation PROC
                                CALL      get_numbers
    
                                CMP       operator, '&'
                                JE        AND_OP
                                CMP       operator, '|'
                                JE        OR_OP
                                CMP       operator, '^'
                                JE        XOR_OP

    AND_OP:                     
                                CALL      and_numbers
                                RET

    OR_OP:                      
                                CALL      or_numbers
                                RET

    XOR_OP:                     
                                CALL      xor_numbers
                                RET
handle_logical_operation ENDP

handle_arithmetic_operation PROC
                                CALL      get_numbers
    
                                CMP       operator, '+'
                                JE        ADD_OP
                                CMP       operator, '-'
                                JE        SUB_OP
                                CMP       operator, '*'
                                JE        MUL_OP
                                CMP       operator, '/'
                                JE        DIV_OP

    ADD_OP:                     
                                CALL      add_numbers
                                RET

    SUB_OP:                     
                                CALL      sub_numbers
                                RET

    MUL_OP:                     
                                CALL      mul_numbers
                                RET

    DIV_OP:                     
                                CALL      div_numbers
                                RET
handle_arithmetic_operation ENDP

get_numbers PROC
    ; Request first number input
                                print_msg newline
                                print_msg num1_msg
                                print_msg newline
                                CALL      READ_NUMBER
                                MOV       num1, DX

    ; Request second number input
                                print_msg newline
                                print_msg num2_msg
                                print_msg newline
                                CALL      READ_NUMBER
                                MOV       num2, DX
                                RET
get_numbers ENDP


    ; ---------------------------
    ; Logical operations
    ; ---------------------------
and_numbers PROC
                                MOV       AX, num1
                                AND       AX, num2
                                MOV       result, AX
                                RET
and_numbers ENDP

or_numbers PROC
                                MOV       AX, num1
                                OR        AX, num2
                                MOV       result, AX
                                RET
or_numbers ENDP

xor_numbers PROC
                                MOV       AX, num1
                                XOR       AX, num2
                                MOV       result, AX
                                RET
xor_numbers ENDP

    ; ---------------------------
    ; Arithmetic operations
    ; ---------------------------
add_numbers PROC
                                MOV       AX, num1
                                ADD       AX, num2
                                MOV       result, AX
                                RET
add_numbers ENDP

sub_numbers PROC
                                MOV       AX, num1
                                SUB       AX, num2
                                MOV       result, AX
                                RET
sub_numbers ENDP

mul_numbers PROC
                                MOV       AX, num1
                                MOV       BX, num2
                                MUL       BX
                                MOV       result, AX
                                RET
mul_numbers ENDP

div_numbers PROC
                                XOR       DX, DX
                                MOV       AX, num1
                                MOV       BX, num2
                                CMP       BX, 0
                                JE        DIV_ERROR                      ; Prevent division by zero
                                DIV       BX
                                MOV       result, AX
                                RET

    DIV_ERROR:                  
                                print_msg error_msg
                                MOV       result, 0
                                RET
div_numbers ENDP

    ; ---------------------------
    ; Print messages
    ; ---------------------------
print_menu PROC

                                print_msg newline
                                print_msg menu_msg
                                print_msg newline
                                RET
print_menu ENDP

print_result PROC
                                print_msg newline
                                print_msg result_msg
                                MOV       DX, result
                                MOV       AX, DX
                                CALL      PRINT_NUMBER
                                print_msg newline
                                RET
print_result ENDP

print_error PROC
                                print_msg error_msg
                                print_msg newline
                            
                                RET
print_error ENDP

END MAIN
