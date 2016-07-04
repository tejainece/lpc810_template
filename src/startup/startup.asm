// Startup file

  .syntax unified
  .cpu cortex-m0plus
  .fpu softvfp
  .thumb

.global  g_pfnVectors
.global  Default_Handler

// start address for the initialization values of the .data section.
// defined in linker script
.word  _sidata

// start address for the .data section. defined in linker script
.word  _sdata

// end address for the .data section. defined in linker script
.word  _edata

// start address for the .bss section. defined in linker script
.word  _sbss
// end address for the .bss section. defined in linker script
.word  _ebss

// stack used for SystemInit_ExtMemCtl; always internal RAM used


    .section  .text.Reset_Handler
  .weak  Reset_Handler
  .type  Reset_Handler, %function
Reset_Handler:
  ldr   r0, =_estack
  mov   sp, r0          // set stack pointer
// Copy the data segment initializers from flash to SRAM
  movs  r1, #0
  b  LoopCopyDataInit

CopyDataInit:
  ldr  r3, =_sidata
  ldr  r3, [r3, r1]
  str  r3, [r0, r1]
  adds  r1, r1, #4

LoopCopyDataInit:
  ldr  r0, =_sdata
  ldr  r3, =_edata
  adds  r2, r0, r1
  cmp  r2, r3
  bcc  CopyDataInit
  ldr  r2, =_sbss
  b  LoopFillZerobss
// Zero fill the bss segment
FillZerobss:
  movs  r3, #0
  str   r3, [r2]
  adds   r2, r2, #4

LoopFillZerobss:
  ldr  r3, = _ebss
  cmp  r2, r3
  bcc  FillZerobss

/* Call the clock system intitialization function.*/
  bl  SystemInit
/* Call static constructors */
  //bl __libc_init_array
/* Call the application's entry point.*/
  bl  main
  bx  lr
.size  Reset_Handler, .-Reset_Handler

/**
 * @brief  This is the code that gets called when the processor receives an
 *         unexpected interrupt.  This simply enters an infinite loop, preserving
 *         the system state for examination by a debugger.
 * @param  None
 * @retval None
*/
    .section  .text.Default_Handler,"ax",%progbits
Default_Handler:
Infinite_Loop:
  b  Infinite_Loop
  .size  Default_Handler, .-Default_Handler




// The minimal vector table for a Cortex M0+. Note that the proper constructs
// must be placed on this to ensure that it ends up at physical address
// 0x0000.0000.
   .section  .isr_vector,"a",%progbits
  .type  g_pfnVectors, %object
  .size  g_pfnVectors, .-g_pfnVectors


g_pfnVectors:
	.word  _estack
	.word  Reset_Handler
	.word  NMI_Handler
	.word  HardFault_Handler
	.word  MemManage_Handler
	.word  BusFault_Handler
	.word  UsageFault_Handler
	.word  0
	.word  0
	.word  0
	.word  0
	.word  SVC_Handler
	.word  DebugMon_Handler
	.word  0
	.word  PendSV_Handler
	.word  SysTick_Handler

  	// Chip Level - LPC8xx
	.word  SPI0_IRQHandler				// SPI0 controller
	.word  SPI1_IRQHandler				// SPI1 controller
	.word  0							// Reserved
	.word  UART0_IRQHandler				// UART0
	.word  UART1_IRQHandler				// UART1
	.word  UART2_IRQHandler				// UART2
	.word  0							// Reserved
	.word  0							// Reserved
	.word  I2C_IRQHandler				// I2C controller
	.word  SCT_IRQHandler				// Smart Counter Timer
	.word  MRT_IRQHandler				// Multi-Rate Timer
	.word  CMP_IRQHandler				// Comparator
	.word  WDT_IRQHandler				// PIO1 (0:11)
	.word  BOD_IRQHandler				// Brown Out Detect
	.word  0							// Reserved
	.word  WKT_IRQHandler				// Wakeup timer
	.word  0							// Reserved
	.word  0							// Reserved
	.word  0							// Reserved
	.word  0							// Reserved
	.word  0							// Reserved
	.word  0							// Reserved
	.word  0							// Reserved
	.word  0							// Reserved
	.word  PININT0_IRQHandler			// PIO INT0
	.word  PININT1_IRQHandler			// PIO INT1
	.word  PININT2_IRQHandler			// PIO INT2
	.word  PININT3_IRQHandler			// PIO INT3
	.word  PININT4_IRQHandler			// PIO INT4
	.word  PININT5_IRQHandler			// PIO INT5
	.word  PININT6_IRQHandler			// PIO INT6
	.word  PININT7_IRQHandler			// PIO INT7






// Provide weak aliases for each Exception handler to the Default_Handler.
// As they are weak aliases, any function with the same name will override
// this definition.

   .weak      NMI_Handler
   .thumb_set NMI_Handler,Default_Handler

   .weak      HardFault_Handler
   .thumb_set HardFault_Handler,Default_Handler

   .weak      MemManage_Handler
   .thumb_set MemManage_Handler,Default_Handler

   .weak      BusFault_Handler
   .thumb_set BusFault_Handler,Default_Handler

   .weak      UsageFault_Handler
   .thumb_set UsageFault_Handler,Default_Handler

   .weak      SVC_Handler
   .thumb_set SVC_Handler,Default_Handler

   .weak      DebugMon_Handler
   .thumb_set DebugMon_Handler,Default_Handler

   .weak      PendSV_Handler
   .thumb_set PendSV_Handler,Default_Handler

   .weak      SysTick_Handler
   .thumb_set SysTick_Handler,Default_Handler

   .weak      SPI0_IRQHandler
   .thumb_set SPI0_IRQHandler,Default_Handler

   .weak      SPI1_IRQHandler
   .thumb_set SPI1_IRQHandler,Default_Handler

   .weak      UART0_IRQHandler
   .thumb_set UART0_IRQHandler,Default_Handler

   .weak      UART1_IRQHandler
   .thumb_set UART1_IRQHandler,Default_Handler

   .weak      UART2_IRQHandler
   .thumb_set UART2_IRQHandler,Default_Handler

   .weak      I2C_IRQHandler
   .thumb_set I2C_IRQHandler,Default_Handler

   .weak      SCT_IRQHandler
   .thumb_set SCT_IRQHandler,Default_Handler

   .weak      MRT_IRQHandler
   .thumb_set MRT_IRQHandler,Default_Handler

   .weak      CMP_IRQHandler
   .thumb_set CMP_IRQHandler,Default_Handler

   .weak      WDT_IRQHandler
   .thumb_set WDT_IRQHandler,Default_Handler

   .weak      BOD_IRQHandler
   .thumb_set BOD_IRQHandler,Default_Handler

   .weak      WKT_IRQHandler
   .thumb_set WKT_IRQHandler,Default_Handler

   .weak      PININT0_IRQHandler
   .thumb_set PININT0_IRQHandler,Default_Handler

   .weak      PININT1_IRQHandler
   .thumb_set PININT1_IRQHandler,Default_Handler

   .weak      PININT2_IRQHandler
   .thumb_set PININT2_IRQHandler,Default_Handler

   .weak      PININT3_IRQHandler
   .thumb_set PININT3_IRQHandler,Default_Handler

   .weak      PININT4_IRQHandler
   .thumb_set PININT4_IRQHandler,Default_Handler

   .weak      PININT5_IRQHandler
   .thumb_set PININT5_IRQHandler,Default_Handler

   .weak      PININT6_IRQHandler
   .thumb_set PININT6_IRQHandler,Default_Handler

   .weak      PININT7_IRQHandler
   .thumb_set PININT7_IRQHandler,Default_Handler
