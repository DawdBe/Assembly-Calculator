;SOME IMPORTANT NOTES : 
;to pritn a string u can use print_msg MACRO as the following: 
; print_msg <ur_stirng_variable>

;TO READ A NUMBER YOU CAN USE READ_DIC as the following: 
;CAll READ_DIC

; TO PRINT A NUMBER YOU CAN USE PRINT_DIC MACRO as the following: 
; MOV AX, DX // NOTE: UR NUMBER SHOULD BE IN DX 
; CALL PRINT_DIC

.MODEL SMALL
.STACK 100H
print_msg MACRO msg
              MOV AH, 9             ; Write string to screen
              MOV DX, OFFSET msg
              INT 21H
ENDM

clear_screen MACRO
                 MOV AH, 00h
                 MOV AL, 03h
                 INT 10h
ENDM
.DATA
    ; Messages
    menu_msg       DB '1. AND (&)',0DH, 0AH,'2. OR (|) ',0DH, 0AH,'3. XOR (^) ',0DH, 0AH,'4. ADD (+) ',0DH, 0AH,'5. SUB (-) ',0DH, 0AH,'6. MUL (*) ',0DH, 0AH,'7. DIV (/) ',0DH, 0AH,'8. To Binary', 0DH, 0AH,'9. To Decimal', 0DH, 0AH,'10. To Hexa', 0DH, 0AH,'11. Exit', 0DH, 0AH, '$'
    number_msg     DB 'Enter the number: $'
    num1_msg       DB 'Enter the first number : $'
    num2_msg       DB 'Enter the second number : $'
    dividend_msg   DB 'Enter the Dividend : $'
    divisor_msg    DB 'Enter the Divisor : $'
    quotient_msg   DB 'Quotient: $'
    reminder_msg   DB '                    Reminder: $'
    
    result_msg_BIN DB 'The operation in BIN: $'
    result_msg_DEC DB 'The operation in DEC: $'
    result_msg_HEX DB 'The operation in HEX: $'
    error_msg      DB 'Error! Enter a valid choice$', 0DH, 0AH, '$'
    newline        DB 0DH, 0AH, '$'
    chose_base_msg DB 'Chose the base: ',0DH, 0AH,'1. DICIMAL',0DH, 0AH,'2. BINARY',0DH, 0AH,'3 HEX',0DH, 0AH,'$'
    zero_erro      DB 0AH, 0AH, 'Error! DIVITION BY ZERO!!!!!!!! $'
    and_of         DB ' & $'
    or_of          DB ' | $'
    xor_of         DB ' ^ $'
    add_of         DB ' + $'
    sub_of         DB ' - $'
    mul_of         DB ' x $'
    div_of         DB ' / $'
    equal          DB ' = $'
    to_bin_msg     DB '   To Binary =  $'
    to_dec_msg     DB '   To Decimal =  $'
    to_hex_msg     DB '   To Hexa =  $'

    ; Variables
    num1           DW ?
    num2           DW ?
    result         DW ?
    rest           DW ?
    operator       DW ?
    isNegative     DB ?
    base           DB ?
    opi            DW ?
.CODE
MAIN PROC
                                MOV          AX, @DATA
                                MOV          DS, AX

    MAIN_LOOP:                  
    ; Display base choise menu
                                print_msg    chose_base_msg

                                MOV          AH, 01H
                                INT          21H

                                CMP          AL, '3'
                                JNE          CHECK_BASE
                                MOV          base, 3
                                JMP          exit

    CHECK_BASE:                 
                                CMP          AL, '2'
                                JNE          DICIMAL
                                MOV          base, 2
                                JMP          exit

    DICIMAL:                    
                        
                                MOV          base, 1

    exit:                       

                            

    ; Display the main menu
                                CALL         print_menu

    ; Read user choice
                                CAll         READ_DIC
                                MOV          AX, DX
                                MOV          opi, AX
    ; Process the choice
                                CMP          AX, 1
                                JE           DO_AND
                                CMP          AX, 2
                                JE           DO_OR
                                CMP          AX, 3
                                JE           DO_XOR
                                CMP          AX, 4
                                JE           DO_ADD
                                CMP          AX, 5
                                JE           DO_SUB
                                CMP          AX, 6
                                JE           DO_MUL
                                CMP          AX, 7
                                JE           DO_DIV
                                CMP          AX, 8
                                JE           TO_BIN_f
                                CMP          AX, 9
                                JE           TO_DEC_f
                                CMP          AX, 10
                                JE           TO_HEX_f
                                CMP          AX, 11
                                JE           EXIT_PROGRAM

    ; If the choice is invalid
                                CALL         print_error
                                JMP          MAIN_LOOP

    DO_AND:                     
                                MOV          operator, '&'
                                CALL         handle_logical_operation
                                JMP          SHOW_RESULT

    DO_OR:                      
                                MOV          operator, '|'
                                CALL         handle_logical_operation
                                JMP          SHOW_RESULT

    DO_XOR:                     
                                MOV          operator, '^'
                                CALL         handle_logical_operation
                                JMP          SHOW_RESULT

    DO_ADD:                     
                                MOV          operator, '+'
                                CALL         handle_arithmetic_operation
                                JMP          SHOW_RESULT

    DO_SUB:                     
                                MOV          operator, '-'
                                CALL         handle_arithmetic_operation
                                JMP          SHOW_RESULT

    DO_MUL:                     
                                MOV          operator, '*'
                                CALL         handle_arithmetic_operation
                                JMP          SHOW_RESULT

    DO_DIV:                     
                                MOV          operator, '/'
                                CALL         handle_arithmetic_operation
                                JMP          SHOW_RESULT
    SHOW_RESULT:                
                                CALL         SHOW_RESULT_p
                                JMP          MAIN_LOOP

    TO_BIN_f:                   
                                CAll         TO_BIN
                                JMP          MAIN_LOOP

    TO_DEC_f:                   
                                CAll         TO_DEC
                                JMP          MAIN_LOOP

    TO_HEX_f:                   
                                CAll         TO_HEX
                                JMP          MAIN_LOOP

    EXIT_PROGRAM:               
                                MOV          AH, 4CH
                                INT          21H
MAIN ENDP

    ; --------------------------------------
    ; ADD PROC CODE HERE
    ; --------------------------------------
    
TO_BIN PROC
                                print_msg    number_msg
                                CAll         READ_NUMBER
                                MOV          AX, DX
                                MOV          num1, AX
                                clear_screen
                                MOV          DX, num1
                                MOV          AX, DX
                                CAll         PRINT_NUMBER
                                print_msg    to_bin_msg
                                MOV          DX, num1
                                MOV          AX, DX
                                CAll         PRINT_BIN
                                print_msg    newline
                                print_msg    newline
                                RET
TO_BIN ENDP

TO_DEC PROC
                                print_msg    number_msg
                                CAll         READ_NUMBER
                                MOV          AX, DX
                                MOV          num1, AX
                                clear_screen
                                MOV          DX, num1
                                MOV          AX, DX
                                CAll         PRINT_NUMBER
                                print_msg    to_dec_msg
                                MOV          DX, num1
                                MOV          AX, DX
                                CAll         PRINT_DIC
                                print_msg    newline
                                print_msg    newline
                                RET
TO_DEC ENDP

TO_HEX PROC
                                print_msg    number_msg
                                CAll         READ_NUMBER
                                MOV          AX, DX
                                MOV          num1, AX
                                clear_screen
                                MOV          DX, num1
                                MOV          AX, DX
                                CAll         PRINT_NUMBER
                                print_msg    to_hex_msg
                                MOV          DX, num1
                                MOV          AX, DX
                                CAll         PRINT_HEX
                                print_msg    newline
                                print_msg    newline
                                JMP          MAIN_LOOP
TO_HEX ENDP

    ;description
SHOW_RESULT_p PROC
    
                                clear_screen
                                CALL         print_result
                                print_msg    newline
                                print_msg    newline
                                print_msg    newline
                                RET
SHOW_RESULT_p ENDP
    ; --------------------------------------
    ; READ_DIC: Reads a signed integer
    ; --------------------------------------
READ_BIN PROC
                                MOV          DX, 0                          ; Result storage
                                MOV          CX, 0
                                MOV          isNegative, 0

    READ_LOOP_BIN:              
                                MOV          AH, 01H                        ; Read character
                                INT          21H

                                CMP          CX, 0                          ; First character?
                                JNE          CHECK_DIGIT_BIN

                                CMP          AL, '-'                        ; Handle negative sign
                                JNE          CHECK_DIGIT_BIN
                                MOV          isNegative, 1
                                INC          CX                             ; Mark first character processed
                                JMP          READ_LOOP_BIN

    CHECK_DIGIT_BIN:            
                                CMP          AL, 0DH                        ; Check Enter
                                JE           END_READ_BIN
                                CMP          AL, '0'                        ; Validate digit
                                JB           READ_LOOP_BIN
                                CMP          AL, '1'
                                JA           READ_LOOP_BIN

    ; Convert and process digit
                                SUB          AL, 30H
                                MOV          BL, AL                         ; Save digit in BL
                                MOV          AX, DX                         ; Current result
                                MOV          SI, 2
                                MUL          SI                             ; AX = DX * 2
                                ADD          AX, BX                         ; Add new digit
                                MOV          DX, AX                         ; Update result

                                INC          CX                             ; Mark that digits have been processed
                                CMP          CX, 16
                                JE           END_READ_BIN
                                JMP          READ_LOOP_BIN

    END_READ_BIN:               
                                CMP          isNegative, 1
                                JNE          STORE_RESULT_BIN
                                NEG          DX                             ; Apply negative sign if needed

    STORE_RESULT_BIN:           

                                RET
READ_BIN ENDP
    ; --------------------------------------
    ; PRINT_DIC: Prints a signed number
    ; --------------------------------------
PRINT_BIN PROC
                                MOV          CX, 16
                                MOV          SI, 0
                                MOV          BX, DX
    PRINT_LOOP_BIN:             
                                SHL          BX,1
                                JNC          CHECK_ZERO
                                MOV          AL, '1'
                                MOV          SI, 1
                                JMP          PRINT_CHAR_BIN

    CHECK_ZERO:                 
                                CMP          SI, 0
                                JZ           SKIP_ZERO
                                MOV          AL,'0'
    PRINT_CHAR_BIN:             
                                MOV          DL, AL
                                MOV          AH, 02H
                                INT          21H
    SKIP_ZERO:                  
                                LOOP         PRINT_LOOP_BIN

                                CMP          SI, 0
                                JNE          END_P
                                MOV          DL, '0'                        ; Print '0' if all bits are 0
                                MOV          AH, 02H
                                INT          21H
    END_P:                      

                                RET
PRINT_BIN ENDP

READ_HEX PROC
                                MOV          CX, 0                          ; Counter for first character check
                                MOV          DX, 0                          ; Result storage
                                MOV          BX, 0
                                MOV          isNegative, 0

    READ_LOOP_HEX:              
                                MOV          AH, 01H                        ; Read character
                                INT          21H

                                CMP          CX, 0                          ; First character?
                                JNE          CHECK_DIGIT_HEX

                                CMP          AL, '-'                        ; Handle negative sign
                                JNE          CHECK_DIGIT_HEX
                                MOV          isNegative, 1
                                INC          CX                             ; Mark first character processed
                                JMP          READ_LOOP_HEX

    CHECK_DIGIT_HEX:            
                                CMP          AL, 0DH                        ; Check Enter
                                JE           END_READ_HEX

                                CMP          AL, '0'                        ; Validate digit
                                JB           READ_LOOP_HEX
                                CMP          AL, '9'
                                JBE          DICIMAL_NUMBER
                                CMP          AL, 'A'
                                JB           READ_LOOP_HEX
                                CMP          AL, 'F'
                                JA           READ_LOOP_HEX

    ; Convert and process digit
                                CMP          AL, 'A'
                                JNB          NO_DICIMAL_NUMBER
    DICIMAL_NUMBER:             

                                SUB          AL, 30H
                                JMP          SAVE_DIGIT
    NO_DICIMAL_NUMBER:          
                                SUB          AL,'A' - 10
    
    SAVE_DIGIT:                 

                                MOV          BL, AL                         ; Save digit in BL
                                MOV          AX, DX                         ; Current result
                                MOV          SI, 16
                                MUL          SI                             ; AX = DX * 16
                                ADD          AX, BX                         ; Add new digit
                                MOV          DX, AX                         ; Update result

                                INC          CX                             ; Mark that digits have been processed
                                JMP          READ_LOOP_HEX

    END_READ_HEX:               
                                CMP          isNegative, 1
                                JNE          STORE_RESULT_HEX
                                NEG          DX                             ; Apply negative sign if needed

    STORE_RESULT_HEX:           

                                RET
READ_HEX ENDP
    ; --------------------------------------
    ; PRINT_DIC: Prints a signed number
    ; --------------------------------------
PRINT_HEX PROC
                                PUSH         CX
                                PUSH         DX
                                PUSH         AX

                                CMP          AX, 0
                                JGE          PRINT_POSITIVE_HEX

    ; Handle negative number
                                MOV          DL, '-'
                                MOV          AH, 02H
                                INT          21H
                                POP          AX
                                PUSH         AX
                                NEG          AX

    PRINT_POSITIVE_HEX:         
                                MOV          CX, 0                          ; Digit counter

    CONVERT_LOOP_HEX:           
                                MOV          DX, 0
                                MOV          BX, 16
                                DIV          BX                             ; Extract digit
                                PUSH         DX                             ; Save digit
                                INC          CX
                                CMP          AX, 0
                                JNE          CONVERT_LOOP_HEX
                                         

    PRINT_LOOP_HEX:             
                                POP          DX
                                CMP          DL,10
                                JB           PIRNT_DIGIT
                                ADD          DL, 'A' - 10
                                JMP          PRINT_CHAR_HEX
    PIRNT_DIGIT:                
                                ADD          DL, 30H                        ; Convert to ASCII
    PRINT_CHAR_HEX:             
                                MOV          AH, 02H
                                INT          21H
                                LOOP         PRINT_LOOP_HEX
    
    END_PRINT_HEX:              
                                POP          AX
                                POP          DX
                                POP          CX
                                RET
PRINT_HEX ENDP

READ_DIC PROC
                                MOV          CX, 0                          ; Counter for first character check
                                MOV          DX, 0                          ; Result storage
                                MOV          isNegative, 0

    READ_LOOP_DIC:              
                                MOV          AH, 01H                        ; Read character
                                INT          21H

                                CMP          CX, 0                          ; First character?
                                JNE          CHECK_DIGIT_DIC

                                CMP          AL, '-'                        ; Handle negative sign
                                JNE          CHECK_DIGIT_DIC
                                MOV          isNegative, 1
                                INC          CX                             ; Mark first character processed
                                JMP          READ_LOOP_DIC

    CHECK_DIGIT_DIC:            
                                CMP          AL, 0DH                        ; Check Enter
                                JE           END_READ_DIC

                                CMP          AL, '0'                        ; Validate digit
                                JB           READ_LOOP_DIC
                                CMP          AL, '9'
                                JA           READ_LOOP_DIC

    ; Convert and process digit
                                SUB          AL, 30H
                                MOV          BL, AL                         ; Save digit in BL
                                MOV          AX, DX                         ; Current result
                                MOV          SI, 10
                                MUL          SI                             ; AX = DX * 10
                                ADD          AX, BX                         ; Add new digit
                                MOV          DX, AX                         ; Update result

                                INC          CX                             ; Mark that digits have been processed
                                JMP          READ_LOOP_DIC

    END_READ_DIC:               
                                CMP          isNegative, 1
                                JNE          STORE_RESULT_DIC
                                NEG          DX                             ; Apply negative sign if needed

    STORE_RESULT_DIC:           

                                RET
READ_DIC ENDP
    ; --------------------------------------
    ; PRINT_DIC: Prints a signed number
    ; --------------------------------------
PRINT_DIC PROC
                                PUSH         CX
                                PUSH         DX
                                PUSH         AX

                                CMP          AX, 0
                                JGE          PRINT_POSITIVE_DIC

    ; Handle negative number
                                MOV          DL, '-'
                                MOV          AH, 02H
                                INT          21H
                                POP          AX
                                PUSH         AX
                                NEG          AX

    PRINT_POSITIVE_DIC:         
                                MOV          CX, 0                          ; Digit counter

    CONVERT_LOOP_DIC:           
                                MOV          DX, 0
                                MOV          BX, 10
                                DIV          BX                             ; Extract digit
                                PUSH         DX                             ; Save digit
                                INC          CX
                                CMP          AX, 0
                                JNE          CONVERT_LOOP_DIC
                                         

    PRINT_LOOP_DIC:             
                                POP          DX
                                ADD          DL, 30H                        ; Convert to ASCII
                                MOV          AH, 02H
                                INT          21H
                                LOOP         PRINT_LOOP_DIC
    
    END_PRINT_DIC:              
                                POP          AX
                                POP          DX
                                POP          CX
                                RET
PRINT_DIC ENDP

READ_NUMBER PROC
    
                                CMP          base, 1
                                JNE          CHECK_BA
                                CALL         READ_DIC
                                JMP          exit_p

    CHECK_BA:                   
                                CMP          base, 2
                                JNE          HEX1
                                CAll         READ_BIN
                                JMP          exit_p

    HEX1:                       
                                CALL         READ_HEX

    exit_p:                     
                                
                                RET
                                                 

READ_NUMBER ENDP

PRINT_NUMBER PROC
                                CMP          base, 1
                                JNE          CHECK_BAS
                                CALL         PRINT_DIC
                                JMP          exit_pr

    CHECK_BAS:                  
                                CMP          base, 2
                                JNE          HEX2
                                CAll         PRINT_BIN
                                JMP          exit_pr

    HEX2:                       
                                CALL         PRINT_HEX

    exit_pr:                    
    
                                RET
PRINT_NUMBER ENDP
handle_logical_operation PROC
                                CALL         get_numbers
    
                                MOV          CX, operator
                                CMP          operator, '&'
                                JE           AND_OP
                                CMP          operator, '|'
                                JE           OR_OP
                                CMP          operator, '^'
                                JE           XOR_OP

    AND_OP:                     
                                CALL         and_numbers
                                RET

    OR_OP:                      
                                CALL         or_numbers
                                RET

    XOR_OP:                     
                                CALL         xor_numbers
                                RET
handle_logical_operation ENDP

handle_arithmetic_operation PROC
                                CALL         get_numbers
    
    
                                MOV          CX, operator
                                CMP          operator, '+'
                                JE           ADD_OP
                                CMP          operator, '-'
                                JE           SUB_OP
                                CMP          operator, '*'
                                JE           MUL_OP
                                CMP          operator, '/'
                                JE           DIV_OP

    ADD_OP:                     
                                CALL         add_numbers
                                RET

    SUB_OP:                     
                                CALL         sub_numbers
                                RET

    MUL_OP:                     
                                CALL         mul_numbers
                                RET

    DIV_OP:                     
                                CALL         div_numbers
                                RET
handle_arithmetic_operation ENDP

get_numbers PROC
    ; Request first number input
                                CMP          operator, '/'
                                JE           read_dividend
                                print_msg    newline
                                print_msg    num1_msg
                                print_msg    newline

                                CAll         READ_NUMBER
                                MOV          num1, DX
                                JMP          second_op

    read_dividend:              
                                print_msg    newline
                                print_msg    dividend_msg
                                print_msg    newline

                                CAll         READ_NUMBER
                                MOV          num1, DX

    ; Request second number input
    second_op:                  
                                CMP          operator, '/'
                                JE           read_divisor
                                print_msg    newline
                                print_msg    num2_msg
                                print_msg    newline
                                CAll         READ_NUMBER
                                MOV          num2, DX
                                JMP          end_get_num
    read_divisor:               
                                print_msg    newline
                                print_msg    divisor_msg
                                print_msg    newline

                                CAll         READ_NUMBER
                                MOV          num2, DX
    end_get_num:                

                                RET
get_numbers ENDP


    ; ---------------------------
    ; Logical operations
    ; ---------------------------
and_numbers PROC
                                MOV          AX, num1
                                AND          AX, num2
                                MOV          result, AX
                                RET
and_numbers ENDP

or_numbers PROC
                                MOV          AX, num1
                                OR           AX, num2
                                MOV          result, AX
                                RET
or_numbers ENDP

xor_numbers PROC
                                MOV          AX, num1
                                XOR          AX, num2
                                MOV          result, AX
                                RET
xor_numbers ENDP

    ; ---------------------------
    ; Arithmetic operations
    ; ---------------------------
add_numbers PROC
                                MOV          AX, num1
                                ADD          AX, num2
                                MOV          result, AX
                                RET
add_numbers ENDP

sub_numbers PROC
                                MOV          AX, num1
                                SUB          AX, num2
                                MOV          result, AX
                                RET
sub_numbers ENDP

mul_numbers PROC
                                MOV          AX, num1
                                MOV          BX, num2
                                CMP          AX, 0
                                JL           signed_mul
                                CMP          BX, 0
                                JL           signed_mul
                                MUL          BX
                                JMP          end_mul
    signed_mul:                 
                                IMUL         BX
    end_mul:                    
                                MOV          result, AX
                                RET
mul_numbers ENDP

div_numbers PROC
                                MOV          AX, num1
                                MOV          BX, num2
                                CMP          BX, 0
                                JE           DIV_ERROR                      ; Prevent division by zero
                                MOV          DX, 0
                                CMP          AX, 0
                                JL           signed_div
                                CMP          BX, 0
                                JL           signed_div
                                DIV          BX
                                JMP          end_div
    signed_div:                 
                                IDIV         BX
    end_div:                    
                                MOV          result, AX
                                MOV          rest, DX
                                print_msg    newline
                                RET

    DIV_ERROR:                  
                                print_msg    zero_erro
                                MOV          result, 0
                                RET
div_numbers ENDP

    ; ---------------------------
    ; Print messages
    ; ---------------------------
print_menu PROC

                                print_msg    newline
                                print_msg    menu_msg
                                print_msg    newline
                                RET
print_menu ENDP

print_result PROC
                                MOV          AX, opi
                                CMP          AX, 1
                                JE           print_AND_f
                                CMP          AX, 2
                                JE           print_OR_f
                                CMP          AX, 3
                                JE           print_XOR_f
                                CMP          AX, 4
                                JE           print_ADD_f
                                CMP          AX, 5
                                JE           print_SUB_f
                                CMP          AX, 6
                                JE           print_MUL_f
                                CMP          AX, 7
                                JE           print_DIV_f
    print_AND_f:                
                                CAll         print_AND
                                JMP          exit_result
    print_OR_f:                 
                                CAll         print_OR
                                JMP          exit_result
    print_XOR_f:                
                                CAll         print_XOR
                                JMP          exit_result
    print_ADD_f:                
                                CAll         print_ADD
                                JMP          exit_result
    print_SUB_f:                
                                CAll         print_SUB
                                JMP          exit_result
    print_MUL_f:                
                                CAll         print_MUL
                                JMP          exit_result
    print_DIV_f:                
                                CAll         print_DIV
                                JMP          exit_result
    exit_result:                

                                RET
print_result ENDP

print_AND PROC
    
    ;print the resutl in bin
                                print_msg    newline
                                print_msg    result_msg_BIN
                                MOV          DX, num1
                                MOV          AX, DX
                                CAll         PRINT_BIN

                                print_msg    and_of
                                MOV          DX, num2
                                MOV          AX, DX
                                CAll         PRINT_BIN
                                print_msg    equal
                                
                                MOV          DX, result
                                MOV          AX, DX
                                CALL         PRINT_BIN

    ;print the resutl in dic
                                print_msg    newline
                                print_msg    result_msg_DEC
                                MOV          DX, num1
                                MOV          AX, DX
                                CAll         PRINT_DIC

                                print_msg    and_of
                                MOV          DX, num2
                                MOV          AX, DX
                                CAll         PRINT_DIC
                                print_msg    equal
                                
                                MOV          DX, result
                                MOV          AX, DX
                                CAll         PRINT_DIC

    ;print the result in hex
                                print_msg    newline
                                print_msg    result_msg_HEX
                                MOV          DX, num1
                                MOV          AX, DX
                                CAll         PRINT_HEX

                                print_msg    and_of
                                MOV          DX, num2
                                MOV          AX, DX
                                CAll         PRINT_HEX
                                print_msg    equal
                                
                                MOV          DX, result
                                MOV          AX, DX
                                CAll         PRINT_HEX
                                RET
print_AND ENDP

print_OR PROC
    
    ;print the resutl in bin
                                print_msg    newline
                                print_msg    result_msg_BIN
                                MOV          DX, num1
                                MOV          AX, DX
                                CAll         PRINT_BIN

                                print_msg    or_of
                                MOV          DX, num2
                                MOV          AX, DX
                                CAll         PRINT_BIN
                                print_msg    equal
                                
                                MOV          DX, result
                                MOV          AX, DX
                                CALL         PRINT_BIN

    ;print the resutl in dic
                                print_msg    newline
                                print_msg    result_msg_DEC
                                MOV          DX, num1
                                MOV          AX, DX
                                CAll         PRINT_DIC

                                print_msg    or_of
                                MOV          DX, num2
                                MOV          AX, DX
                                CAll         PRINT_DIC
                                print_msg    equal
                                
                                MOV          DX, result
                                MOV          AX, DX
                                CAll         PRINT_DIC

    ;print the result in hex
                                print_msg    newline
                                print_msg    result_msg_HEX
                                MOV          DX, num1
                                MOV          AX, DX
                                CAll         PRINT_HEX

                                print_msg    or_of
                                MOV          DX, num2
                                MOV          AX, DX
                                CAll         PRINT_HEX
                                print_msg    equal
                                
                                MOV          DX, result
                                MOV          AX, DX
                                CAll         PRINT_HEX
                                RET
print_OR ENDP

print_XOR PROC
    
    ;print the resutl in bin
                                print_msg    newline
                                print_msg    result_msg_BIN
                                MOV          DX, num1
                                MOV          AX, DX
                                CAll         PRINT_BIN

                                print_msg    xor_of
                                MOV          DX, num2
                                MOV          AX, DX
                                CAll         PRINT_BIN
                                print_msg    equal
                                
                                MOV          DX, result
                                MOV          AX, DX
                                CALL         PRINT_BIN

    ;print the resutl in dic
                                print_msg    newline
                                print_msg    result_msg_DEC
                                MOV          DX, num1
                                MOV          AX, DX
                                CAll         PRINT_DIC

                                print_msg    xor_of
                                MOV          DX, num2
                                MOV          AX, DX
                                CAll         PRINT_DIC
                                print_msg    equal
                                
                                MOV          DX, result
                                MOV          AX, DX
                                CAll         PRINT_DIC

    ;print the result in hex
                                print_msg    newline
                                print_msg    result_msg_HEX
                                MOV          DX, num1
                                MOV          AX, DX
                                CAll         PRINT_HEX

                                print_msg    xor_of
                                MOV          DX, num2
                                MOV          AX, DX
                                CAll         PRINT_HEX
                                print_msg    equal
                                
                                MOV          DX, result
                                MOV          AX, DX
                                CAll         PRINT_HEX
                                RET
print_XOR ENDP

print_ADD PROC
    
    ;print the resutl in bin
                                print_msg    newline
                                print_msg    result_msg_BIN
                                MOV          DX, num1
                                MOV          AX, DX
                                CAll         PRINT_BIN

                                print_msg    add_of
                                MOV          DX, num2
                                MOV          AX, DX
                                CAll         PRINT_BIN
                                print_msg    equal
                                
                                MOV          DX, result
                                MOV          AX, DX
                                CALL         PRINT_BIN

    ;print the resutl in dic
                                print_msg    newline
                                print_msg    result_msg_DEC
                                MOV          DX, num1
                                MOV          AX, DX
                                CAll         PRINT_DIC

                                print_msg    add_of
                                MOV          DX, num2
                                MOV          AX, DX
                                CAll         PRINT_DIC
                                print_msg    equal
                                
                                MOV          DX, result
                                MOV          AX, DX
                                CAll         PRINT_DIC

    ;print the result in hex
                                print_msg    newline
                                print_msg    result_msg_HEX
                                MOV          DX, num1
                                MOV          AX, DX
                                CAll         PRINT_HEX

                                print_msg    add_of
                                MOV          DX, num2
                                MOV          AX, DX
                                CAll         PRINT_HEX
                                print_msg    equal
                                
                                MOV          DX, result
                                MOV          AX, DX
                                CAll         PRINT_HEX
                                RET
print_ADD ENDP

print_SUB PROC
    
    ;print the resutl in bin
                                print_msg    newline
                                print_msg    result_msg_BIN
                                MOV          DX, num1
                                MOV          AX, DX
                                CAll         PRINT_BIN

                                print_msg    sub_of
                                MOV          DX, num2
                                MOV          AX, DX
                                CAll         PRINT_BIN
                                print_msg    equal
                                
                                MOV          DX, result
                                MOV          AX, DX
                                CALL         PRINT_BIN

    ;print the resutl in dic
                                print_msg    newline
                                print_msg    result_msg_DEC
                                MOV          DX, num1
                                MOV          AX, DX
                                CAll         PRINT_DIC

                                print_msg    sub_of
                                MOV          DX, num2
                                MOV          AX, DX
                                CAll         PRINT_DIC
                                print_msg    equal
                                
                                MOV          DX, result
                                MOV          AX, DX
                                CAll         PRINT_DIC

    ;print the result in hex
                                print_msg    newline
                                print_msg    result_msg_HEX
                                MOV          DX, num1
                                MOV          AX, DX
                                CAll         PRINT_HEX

                                print_msg    sub_of
                                MOV          DX, num2
                                MOV          AX, DX
                                CAll         PRINT_HEX
                                print_msg    equal
                                
                                MOV          DX, result
                                MOV          AX, DX
                                CAll         PRINT_HEX
                                RET
print_SUB ENDP

print_MUL PROC
    
    ;print the resutl in bin
                                print_msg    newline
                                print_msg    result_msg_BIN
                                MOV          DX, num1
                                MOV          AX, DX
                                CAll         PRINT_BIN

                                print_msg    mul_of
                                MOV          DX, num2
                                MOV          AX, DX
                                CAll         PRINT_BIN
                                print_msg    equal
                                
                                MOV          DX, result
                                MOV          AX, DX
                                CALL         PRINT_BIN

    ;print the resutl in dic
                                print_msg    newline
                                print_msg    result_msg_DEC
                                MOV          DX, num1
                                MOV          AX, DX
                                CAll         PRINT_DIC

                                print_msg    mul_of
                                MOV          DX, num2
                                MOV          AX, DX
                                CAll         PRINT_DIC
                                print_msg    equal
                                
                                MOV          DX, result
                                MOV          AX, DX
                                CAll         PRINT_DIC

    ;print the result in hex
                                print_msg    newline
                                print_msg    result_msg_HEX
                                MOV          DX, num1
                                MOV          AX, DX
                                CAll         PRINT_HEX

                                print_msg    mul_of
                                MOV          DX, num2
                                MOV          AX, DX
                                CAll         PRINT_HEX
                                print_msg    equal
                                
                                MOV          DX, result
                                MOV          AX, DX
                                CAll         PRINT_HEX
                                RET
print_MUL ENDP

print_DIV PROC
    
    ;print the resutl in bin
                                print_msg    newline
                                print_msg    result_msg_BIN
                                MOV          DX, num1
                                MOV          AX, DX
                                CAll         PRINT_BIN

                                print_msg    div_of
                                MOV          DX, num2
                                MOV          AX, DX
                                CAll         PRINT_BIN
                                print_msg    equal
                                print_msg    newline
                                
                                print_msg    quotient_msg
                                MOV          DX, result
                                MOV          AX, DX
                                CALL         PRINT_BIN

                                print_msg    reminder_msg
                                MOV          DX, rest
                                MOV          AX, DX
                                CALL         PRINT_BIN

    ;print the resutl in dic
                                print_msg    newline
                                print_msg    result_msg_DEC
                                MOV          DX, num1
                                MOV          AX, DX
                                CAll         PRINT_DIC

                                print_msg    div_of
                                MOV          DX, num2
                                MOV          AX, DX
                                CAll         PRINT_DIC
                                print_msg    equal
                                print_msg    newline
                                
                                print_msg    quotient_msg
                                MOV          DX, result
                                MOV          AX, DX
                                CALL         PRINT_DIC

                                print_msg    reminder_msg
                                MOV          DX, rest
                                MOV          AX, DX
                                CALL         PRINT_DIC

    ;print the result in hex
                                print_msg    newline
                                print_msg    result_msg_HEX
                                MOV          DX, num1
                                MOV          AX, DX
                                CAll         PRINT_HEX

                                print_msg    div_of
                                MOV          DX, num2
                                MOV          AX, DX
                                CAll         PRINT_HEX
                                print_msg    equal
                                print_msg    newline
                                
                                print_msg    quotient_msg
                                MOV          DX, result
                                MOV          AX, DX
                                CALL         PRINT_DIC

                                print_msg    reminder_msg
                                MOV          DX, rest
                                MOV          AX, DX
                                CALL         PRINT_DIC
                                RET
print_DIV ENDP

print_error PROC
                                print_msg    error_msg
                                print_msg    newline
                            
                                RET
print_error ENDP

END MAIN