/* Generate a link error if heap and stack don't fit into RAM */
_Min_Heap_Size = 0; /* required amount of heap */
_Min_Stack_Size = 0x40; /* required amount of stack */

MEMORY
{
    FLASH (rx) : ORIGIN = 0x00000000, LENGTH = 0x00001000 /* 4 Kbytes */
    RAM (rwx) :  ORIGIN = 0x10000000, LENGTH = 0x00000400 /* 1 Kbyte */
}

/* Highest address of the user mode stack */
sram_end = ORIGIN(RAM) + LENGTH(RAM);
_estack = sram_end;


SECTIONS
{
    .text :
    {
        _text = .;
        KEEP(*(.isr_vector))
        KEEP(*(.text.Reset_Handler))
        KEEP(*(.text.Default_Handler))
        *(.text*)
        *(.rodata*)
        . = ALIGN(4);
        _etext = .;
        _sidata = .;
    } > FLASH

    .data : AT (_sidata)
    {
        _sdata = .;
        *(vtable)
        *(.data*)
        _edata = .;
    } > RAM

    .bss :
    {
        _sbss = .;
        *(.bss*)
        *(COMMON)
        _ebss = .;
    } > RAM
    
	/* User_heap_stack section, used to check that there is enough RAM left */
	._user_heap_stack :
	{
		. = ALIGN(4);
	    PROVIDE ( end = . );
	    PROVIDE ( _end = . );
	    PROVIDE ( __end__ = . ); 
	    . = . + _Min_Heap_Size;
	    . = . + _Min_Stack_Size;
	    . = ALIGN(4);
	} >RAM
}
