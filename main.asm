            .INCLUDE <m328pdef.inc>

            .EQU SP=RAMEND-256              ; Под стеком - строка с '\0' в конце.
            
            .DSEG
            .ORG SP+1                       ;
STRRAM:     .BYTE 256                       ; Указатель на ASCII-строку с числом в SRAM.

            .CSEG                           ;
            .ORG 0x00                       ;

            JMP RESET                       ;

            .INCLUDE "lcd1602.asm"

            ;
            ;
RESET:      LDI YL,LOW(SP)                  ;
            LDI YH,HIGH(SP)                 ;
            OUT SPL,YL                      ;
            OUT SPH,YH                      ;

            LDI ZL,LOW(STRPRG<<1)           ; Читаем числовую строку из памяти программ в SRAM.
            LDI ZH,HIGH(STRPRG<<1)          ;
            LDI XL,LOW(STRRAM)              ;
            LDI XH,HIGH(STRRAM)             ;
READ:       LPM R0,Z+                       ;
            ST X+,R0                        ;
            AND R0,R0                       ; Прочитали символ конца строки NUL?
            BRNE READ                       ; Нет, продолжаем.

            RCALL INITLCD                   ;
            
            ;
            ;
MAIN:       ;RCALL CHREXMPL
            ;RCALL INPEXMPL
            RCALL SHFTEXMPL
            RJMP END                        ;

            ;
            ; Пример последовательного вывода символов с задержкой между выводом каждого.
            ; К проблеме вывода символов через одну позицию.
CHREXMPL:   LDI R16,'1'                     ; Вывод без задержки.
            MOV CHAR,R16                    ;
            RCALL PRNTCHR                   ;
            LDI R16,'2'                     ;
            MOV CHAR,R16                    ;
            RCALL PRNTCHR                   ;
            LDI R16,'3'                     ;
            MOV CHAR,R16                    ;
            RCALL PRNTCHR                   ;

            RCALL DELAY1S                   ;
                        
            LDI R16,'4'                     ; Вывод с задержкой - здесь и была проблема с пропусками.
            MOV CHAR,R16                    ;
            RCALL PRNTCHR                   ;

            RCALL DELAY1S                   ;

            LDI R16,'5'                     ;
            MOV CHAR,R16                    ;
            RCALL PRNTCHR                   ;

            RCALL DELAY1S                   ;

            LDI R16,'6'                     ;
            MOV CHAR,R16                    ;
            RCALL PRNTCHR                   ;

            RET

            ;
            ;
INPEXMPL:   LDI XL,LOW(STRRAM)              ; Эмуляция вывода первого операнда.
            LDI XH,HIGH(STRRAM)             ;
            RCALL PRNTSTR                   ;

            RCALL DELAY1S                   ;

            RCALL CURSL1END                 ; Эмуляция вывода символа оператора.
            LDI R16,'/'                     ;
            MOV CHAR,R16                    ;
            RCALL PRNTCHR                   ;

            RCALL DELAY1S                   ;

            RCALL CURSL2BEG                 ;

            RCALL DELAY1S                   ;

            LDI XL,LOW(STRRAM)              ; Эмуляция вывода второго операнда.
            LDI XH,HIGH(STRRAM)             ;
            RCALL PRNTSTR                   ;

            RCALL DELAY1S                   ;

            RCALL CLEARLCD                  ; Очищаем экран.

            RCALL DELAY1S                   ;

            RCALL DSBLCURS                  ; Деактивируем курсор.

            LDI XL,LOW(STRRAM)              ; Выводим результат.
            LDI XH,HIGH(STRRAM)             ;
            RCALL PRNTSTR                   ;
            
            RCALL DELAY1S                   ;

            RCALL CLEARLCD                  ; Очищаем экран.

            RCALL DELAY1S                   ;

            RCALL ENBLCURS                  ; Активируем курсор.

            LDI R16,'H'                     ;
            MOV CHAR,R16                    ;
            RCALL PRNTCHR                   ;

            RET

            ;
            ;
SHFTEXMPL:  LDI XL,LOW(STRRAM)              ;
            LDI XH,HIGH(STRRAM)             ;
            RCALL PRNTSTR                   ;
            RCALL DELAY20MS                 ;
            
            LDI R20,24                      ;
RPTSHFTL:   RCALL SHFTLFT                   ;
            RCALL DELAY20MS                 ;
            DEC R20                         ;
            BRNE RPTSHFTL                   ;

            RCALL DELAY20MS                 ;
            LDI R20,24                      ;
RPTSHFTR:   RCALL SHFTRGHT                  ;
            RCALL DELAY20MS                 ;
            DEC R20                         ;
            BRNE RPTSHFTR                   ;
            
            RET

END:        RJMP END

            ;
            ; Задержка 1s (8MHz).
            ; NOTE: Assembly code auto-generated by utility from Bret Mulvey.
DELAY1S:    LDI R16,41
            LDI R17,150
            LDI R18,125
D1:         DEC R18
            BRNE D1
            DEC R17
            BRNE D1
            DEC R16
            BRNE D1
            RJMP PC+1
            RET

;STRPRG:     .DB "1.3012952804E-02",0
;STRPRG:     .DB "-7.100000045E+38",0
;STRPRG:     .DB "-45.1002340045",0
;STRPRG:     .DB "1234567890123456",0
STRPRG:     .DB "1234567890123456ABCDEFGHIJKLMNOPQRSTUVWX",0
