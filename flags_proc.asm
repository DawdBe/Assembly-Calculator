print_msg MACRO msg
              MOV AH, 9             ; Write string to screen
              MOV DX, OFFSET msg
              INT 21H
ENDM

    ; Flag messages
    zero_flag_msg      DB 'Zero Flag (ZF): ', '$'
    sign_flag_msg      DB 'Sign Flag (SF): ', '$'
    carry_flag_msg     DB 'Carry Flag (CF): ', '$'
    parity_flag_msg    DB 'Parity Flag (PF): ', '$'
    aux_carry_flag_msg DB 'Auxiliary Carry Flag (AF): ', '$'