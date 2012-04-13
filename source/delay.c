/******************************************
* Name: delay.c                     
* Desc: Delay subroutines
* Date: 2007-9-14
* Author: fgb
******************************************/

// Note: Since temp is an int, the maximun value for the delay is 8.2ms (time=8192)
//       Tried with long, but the assembly code might need to be modified
unsigned int temp;

void delay_us( unsigned int time ) {  
    // Need to waste ~40 inst/us (for 40MIPS)
    temp = 8 * time - 3; // #3 obtained testing btg delays
	asm volatile("LOOP: dec _temp");	
	asm volatile("cp0 _temp");
	asm volatile("bra z, DONE");
	asm volatile("bra LOOP");
	asm volatile("DONE:");
}

//void delay_ms( unsigned int time ) 
//{  
//}
