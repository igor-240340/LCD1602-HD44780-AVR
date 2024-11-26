            .INCLUDE <m328pdef.inc>

            .EQU SP=RAMEND-256              ; Under the stack: a string with a '\0' terminator.
            
            .DSEG
            .ORG SP+1                       ;
STRRAM:     .BYTE 256                       ; Pointer to a numeric ASCII string in SRAM.

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

            LDI ZL,LOW(STRPRG<<1)           ; Read the numeric string from program memory into SRAM.
            LDI ZH,HIGH(STRPRG<<1)          ;
            LDI XL,LOW(STRRAM)              ;
            LDI XH,HIGH(STRRAM)             ;
READ:       LPM R0,Z+                       ;
            ST X+,R0                        ;
            AND R0,R0                       ; NUL?
            BRNE READ                       ; No, continue.

            RCALL INITLCD                   ;
            
            ;
            ;
MAIN:       ;RCALL CHREXMPL
            ;RCALL INPEXMPL
            RCALL SHFTEXMPL
            RJMP END                        ;

            ;
            ; Example of sequential character output with a delay between each character.
            ; NOTE: Addresses the issue of skipping every other character during output.
CHREXMPL:   LDI R16,'1'                     ; Output without delay.
            MOV CHAR,R16                    ;
            RCALL PRNTCHR                   ;
            LDI R16,'2'                     ;
            MOV CHAR,R16                    ;
            RCALL PRNTCHR                   ;
            LDI R16,'3'                     ;
            MOV CHAR,R16                    ;
            RCALL PRNTCHR                   ;

            RCALL DELAY1S                   ;
                        
            LDI R16,'4'                     ; Output with delay - this is where the issue with skipping occurred.
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
INPEXMPL:   LDI XL,LOW(STRRAM)              ; Emulation of the first operand output.
            LDI XH,HIGH(STRRAM)             ;
            RCALL PRNTSTR                   ;

            RCALL DELAY1S                   ;

            RCALL CURSL1END                 ; Emulation of the operator character output.
            LDI R16,'/'                     ;
            MOV CHAR,R16                    ;
            RCALL PRNTCHR                   ;

            RCALL DELAY1S                   ;

            RCALL CURSL2BEG                 ;

            RCALL DELAY1S                   ;

            LDI XL,LOW(STRRAM)              ; Emulation of the second operand output.
            LDI XH,HIGH(STRRAM)             ;
            RCALL PRNTSTR                   ;

            RCALL DELAY1S                   ;

            RCALL CLEARLCD                  ; Clear the screen.

            RCALL DELAY1S                   ;

            RCALL DSBLCURS                  ; Deactivate the cursor.

            LDI XL,LOW(STRRAM)              ; Output the result.
            LDI XH,HIGH(STRRAM)             ;
            RCALL PRNTSTR                   ;
            
            RCALL DELAY1S                   ;

            RCALL CLEARLCD                  ; Clear the screen.

            RCALL DELAY1S                   ;

            RCALL ENBLCURS                  ; Activate the cursor.

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
            ; Delay 1s (8MHz).
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
