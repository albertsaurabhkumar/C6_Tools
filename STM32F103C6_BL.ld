/**************************************************
**  Processor: S32K144
**  Author: Saurabh Kumar
**  GCC Version: 12.3
**  
**  Linker file for S32_App application for S32K144
**
***************************************************/
ENTRY(Reset_Handler)

MEMORY
{
    VECTAB(rx): ORIGIN = 0x08000000, LENGTH = 0x00000110
    FLASH(rx): ORIGIN = 0x08000114, LENGTH = 0x00005EEC
    SRAM(rwx): ORIGIN = 0x20000000, LENGTH = 0x00002800
}

SECTIONS
{
    .intvec :
    {
    _intvec_start_ = .;
    *(.intvec)
    . = ALIGN(4);
    _intvec_end_ = .;
    } > VECTAB
    
    .text :
    {
    _stext = .;
    *(.text)                 /* .text sections (code) */
    *(.text*)                /* .text* sections (code) */
    *(.rodata)               /* .rodata sections (constants, strings, etc.) */
    *(.rodata*)              /* .rodata* sections (constants, strings, etc.) */
    *(.glue_7)               /* glue arm to thumb code */
    *(.glue_7t)              /* glue thumb to arm code */
    *(.eh_frame)
    KEEP (*(.init))
    KEEP (*(.fini))
    . = ALIGN(4);
    _etext = .;
    } > FLASH

    .data :
    {
   *(.BootAppFlags)
    _sdata_ram = .;
    *(.data)
    . = ALIGN(4);
    _edata_ram = .;
    }> SRAM AT> FLASH

    .bss :
    {
    _bss_start_ = .;
    *(.bss)
    *(.bss*)
    *(.common)
    *(.common*)
    . = ALIGN(4);
    _bss_end_ = .;
    }> SRAM AT> FLASH
}