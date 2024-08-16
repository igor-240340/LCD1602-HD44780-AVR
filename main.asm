            .INCLUDE <M328PDEF.INC>

            .EQU SP=RAMEND-256              ; ПОД СТЕКОМ - СТРОКА 16 СИМВОЛОВ С '\0' В КОНЦЕ.
            
            .DSEG
            .ORG SP+1                       ;
STRRAM:     .BYTE 256                       ; УКАЗАТЕЛЬ НА ASCII СТРОКУ С ЧИСЛОМ В SRAM.

            .CSEG                           ;
            .ORG 0x00                       ;

            JMP RESET                       ;

            .INCLUDE "LCD1602.ASM"

            ;
            ;
RESET:      LDI YL,LOW(SP)                  ;
            LDI YH,HIGH(SP)                 ;
            OUT SPL,YL                      ;
            OUT SPH,YH                      ;

            LDI ZL,LOW(STRPRG<<1)           ; ЧИТАЕМ ЧИСЛОВУЮ СТРОКУ ИЗ ПАМЯТИ ПРОГРАММ В SRAM.
            LDI ZH,HIGH(STRPRG<<1)          ;
            LDI XL,LOW(STRRAM)              ;
            LDI XH,HIGH(STRRAM)             ;
READ:       LPM R0,Z+                       ;
            ST X+,R0                        ;
            AND R0,R0                       ; ПРОЧИТАЛИ СИМВОЛ КОНЦА СТРОКИ NUL?
            BRNE READ                       ; НЕТ, ПРОДОЛЖАЕМ.

            RCALL INITLCD                   ;
            
            ;
            ;
MAIN:       LDI XL,LOW(STRRAM)              ; ЭМУЛЯЦИЯ ВЫВОДА ПЕРВОГО ОПЕРАНДА.
            LDI XH,HIGH(STRRAM)             ;
            RCALL PRNTSTR                   ;

            RCALL DELAY20MS                 ;

            RCALL CURSL1END                 ; ЭМУЛЯЦИЯ ВЫВОДА СИМВОЛА ОПЕРАТОРА.
            LDI R16,'/'                     ;
            MOV CHAR,R16                    ;
            RCALL PRNTCHR                   ;

            RCALL DELAY20MS                 ;
            RCALL DELAY20MS                 ;

            RCALL CURSL2BEG                 ;

            RCALL DELAY20MS                 ;

            LDI XL,LOW(STRRAM)              ; ЭМУЛЯЦИЯ ВЫВОДА ВТОРОГО ОПЕРАНДА.
            LDI XH,HIGH(STRRAM)             ;
            RCALL PRNTSTR                   ;

            RCALL DELAY20MS                 ;
            RCALL DELAY20MS                 ;

            RCALL CLEARLCD                  ; ОЧИЩАЕМ ЭКРАН.

            RCALL DELAY20MS                 ;

            RCALL DSBLCURS                  ; ДЕАКТИВИРУЕМ КУРСОР.

            LDI XL,LOW(STRRAM)              ; ВЫВОДИМ РЕЗУЛЬТАТ.
            LDI XH,HIGH(STRRAM)             ;
            RCALL PRNTSTR                   ;
            
            RCALL DELAY20MS                 ;
            RCALL DELAY20MS                 ;

            RCALL CLEARLCD                  ; ОЧИЩАЕМ ЭКРАН.

            RCALL DELAY20MS                 ;

            RCALL ENBLCURS                  ; АКТИВИРУЕМ КУРСОР.

            LDI R16,'H'                     ;
            MOV CHAR,R16                    ;
            RCALL PRNTCHR                   ;

;---------------------------------------------------------------------------------------
; BEGIN: ПРИМЕР СДВИГА ДИСПЛЕЯ.
;---------------------------------------------------------------------------------------
;            RCALL DELAY20MS                 ;
;            LDI R20,24                      ;
;RPTSHFTL:   RCALL SHFTLFT                   ;
;            RCALL DELAY20MS                 ;
;            DEC R20                         ;
;            BRNE RPTSHFTL                   ;

;            RCALL DELAY20MS                 ;
;            LDI R20,24                      ;
;RPTSHFTR:   RCALL SHFTRGHT                  ;
;            RCALL DELAY20MS                 ;
;            DEC R20                         ;
;            BRNE RPTSHFTR                   ;
;---------------------------------------------------------------------------------------
; END: ПРИМЕР СДВИГА ДИСПЛЕЯ.
;---------------------------------------------------------------------------------------

END:        RJMP END

;STRPRG:     .DB "1.3012952804E-02",0
;STRPRG:     .DB "-7.100000045E+38",0
STRPRG:     .DB "-45.1002340045",0
;STRPRG:     .DB "1234567890123456",0
;STRPRG:     .DB "1234567890123456ABCDEFGHIJKLMNOPQRSTUVWX",0
