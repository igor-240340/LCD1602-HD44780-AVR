# LCD1602-HD44780 Library for AVR MCUs

Original Russian version is located in [dev](https://github.com/igor-240340/LCD1602-HD44780-AVR/tree/dev) branch.

![](/docs/lcd1602.png)

This repository contains an AVR assembly library for interfacing with the LCD1602 display using the HD44780 controller. The library provides essential functions to control the cursor, print characters, and display strings on the LCD.

It is used in the "Hardware Calculator From Scratch" project, which can be found in [this](https://github.com/igor-240340/HardwareCalculatorFromScratch) repository.

## Features

- **Cursor Control**: Move the cursor to the beginning of the first or second line, or to the end of the first line. Hide or display the cursor with or without blinking.
- **Character Printing**: Print single characters to the LCD.
- **String Printing**: Display strings stored in SRAM on the LCD.
- **8-Bit Mode Support**: Operates exclusively in 8-bit mode.
- **Busy Flag Synchronization**: Synchronously waits for the controller to be ready using the busy flag.

## Default Configuration

- **Control Line**: Connected to `PORTC`.
- **Data/Instruction Line**: Connected to `PORTB`.
- **Busy Flag**: Monitored on bit 7 of `PORTB`.

## Functions Overview

### Cursor Control

- **Move to Line Start/End**:
  - `CURSL1BEG`: Move the cursor to the beginning of the first line.
  - `CURSL2BEG`: Move the cursor to the beginning of the second line.
  - `CURSL1END`: Move the cursor to the end of the first line (last visible character).
- **Cursor Visibility**:
  - `DSBLCURS`: Hide the cursor.
  - `ENBLCURS`: Show the blinking cursor.

### Display Control

- **Clear Display**: 
  - `CLEARLCD`: Clear the display and return the cursor to the beginning of the first line.
- **Shift Display**:
  - `SHFTLFT`: Shift the display left by one position.
  - `SHFTRGHT`: Shift the display right by one position.

### Data Writing

- **Print Character**: 
  - `PRNTCHR`: Print a single character stored in the `CHAR` register.
- **Print String**: 
  - `PRNTSTR`: Print a string stored in SRAM, with the address in the `XH:XL` register pair.

### Busy Flag Handling

- **Busy Flag Wait**:
  - `WAITBUSY`: Wait until the busy flag is cleared, indicating that the LCD is ready for the next command.

## Usage

### Basic Initialization

To initialize the LCD, call `INITLCD` at the start of your program:

```assembly
RCALL INITLCD
```

### Displaying Text

To display text, load the string address into `XH:XL` and call `PRNTSTR`:

```assembly
LDI XH, HIGH(STRING_ADDRESS)
LDI XL, LOW(STRING_ADDRESS)
RCALL PRNTSTR
```

### Printing a Single Character

To print a single character, load the character into the `CHAR` register and call `PRNTCHR`:

```assembly
LDI R16, 'A'   ; Load character 'A' into register R16.
MOV CHAR, R16  ; Move the character into the CHAR register.
RCALL PRNTCHR  ; Print the character.
```

### Controlling the Cursor

To move the cursor or control its visibility, use the appropriate function calls:

```assembly
RCALL CURSL1BEG  ; Move cursor to the beginning of the first line.
RCALL ENBLCURS   ; Enable blinking cursor.
```

### Clearing the Display

To clear the display and reset the cursor position:

```assembly
RCALL CLEARLCD
```