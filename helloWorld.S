.data


msg:
    .ascii      "Hello World!\n"
len = . - msg           /* This means: take your Stack Pointer actual position and substract the size of the msg variable */

.text

.globl _start           /* We are declaring _start as a global function for the machine */

_start:
  /* Printing the message */
    mov     %r0, $1     /* We set the number 1 on r0, which will represent STDOUT */
    ldr     %r1, =msg   /* ldr loads a 32 bit constant on the dst register. In this case r1 */
    ldr     %r2, =len   /* In r2 we are loading the length of the message */
    mov     %r7, $4     /* ARM processors use r7 for the syscalls. Syscall 4 is 'write' */
    swi     $0          /* Software Interrupt. AKA syscall */

    /* Now we need to exit the program */
    mov     %r0, $0     /* We are going to return a 0 because the program was ran correctly */
    mov     %r7, $1     /* Again a syscall. This time Syscall 1 is 'exit' */
    swi     $0          /* Software Interrupt. AKA syscall */
