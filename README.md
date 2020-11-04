Hey there!

Here is a second chapter on this ASM's series. This time, I'm bringing you a similar post to the last one, only this time we are changing the ISA.

You may be wondering, ARM? ISA? what's going on here?

Let's go step by step.

## :question: What is ARM?

ARM is a type of processors licensed by a Cambridge company named Acorn RISC Machine (ARM). The main differences between an ARM processor and an Intel processor for example are two. 

The first one is that ARM doesn't manufacture it's own processors, they mostly design and create Licenses to their technology and sell it as Intellectual property, unlike Intel which designs, manufactures and sell their processors

The other main difference is in their design philosophy. Intel fabricates **CISC** processors while ARM designs **RISC** processors. I'm planning to delve a little bit further on CISC vs RISC in another post, however here is a brief explanation about the differences:

- RISC: Reduced Instruction Set Computer
- CISC: Complex Instruction Set Computing
  
RISC basically is composed of as few instructions as possible which makes it easier for the developer to learn how to program on that ISA while CISC has a ton of functions (or instructions) built hardware-style on the processor. The basic advantage CISC has over RISC is that it consumes less memory on it's instructions execution. RISC however is far easier to understand.

![Alt Text](https://dev-to-uploads.s3.amazonaws.com/i/v2dfie993s97bd8xp2xj.png)

## :question: What is an ISA?

An ISA is the Instruction Set Architecture which the processor provides to the user in order to let him/her communicate with the processor.

Everything must be clicking in concept by now, so let's move on. (If it's not clear by now, it's okay, it's a really complicated matter)

![Alt Text](https://dev-to-uploads.s3.amazonaws.com/i/22ortm6oid1h41g24b7b.png)

## :tada: Try it yourself!

If you want to try this example, you are going to need either an ARM emulator, a Raspberry Pi, an Android phone, or whatever machine with an ARM processor that you possess. If you want to try an emulator, you can give [this one](https://azm.azerialabs.com/) a go

## :earth_americas: Hello World!

If you haven't read my previous post on this series (Which you totally should by now), an ASM file is composed of various sections where the variables are defined and/or initialized and a __.text__ section where the code is declared.

```armasm
msg: .ascii      "Hello World!\n"
len = . - msg           /* This means: take your Stack Pointer actual position and subtract the size of the msg variable */
```

Just like last time, we define a variable msg where our message will be declared (duh) and a __len__ variable which will store the length of the message (this is extremely necessary on ASM programming since the Write syscall needs the message length as it's the third parameter)

```armasm
.text

.globl _start           /* We are declaring _start as a global function for the machine */
```

The next step is to define the __.text__ section in which our code will be written. We are also telling the program that the _start function is going to be a global function. This is telling the computer: Hey!, you can use this function wherever you want from now on.

```armasm
_start:
  /* Printing the message */
    mov     %r0, $1     /* We set the number 1 on r0, which will represent STDOUT */
    ldr     %r1, =msg   /* ldr loads a 32 bit constant on the dst register. In this case r1 */
    ldr     %r2, =len   /* In r2 we are loading the length of the message */
    mov     %r7, $4     /* ARM processors use r7 for the syscalls. Syscall 4 is 'write' */
    swi     $0          /* Software interrupt. AKA syscall */
```

This section, which seems really intimidating, is just passing the parameters needed for the Write Syscall on Linux. Let's remember what that syscall needs on it's signature (This means, let's look on [Wikipedia](https://en.wikipedia.org/wiki/Write_(system_call))):

1. The file code (file descriptor or fd).
2. The pointer to a buffer where the data is stored (buf).
3. The number of bytes to write from the buffer (nbytes).

Really straightforward. On r0 we are using the STDOUT as our file code. r1 will take the message string while r2 loads the string's length. ARM uses r7 to get the syscall which will be used. In this case, it's SYSCALL 4 (write). Lastly, we use swi (SoftWare Interrupt) to call Write.

```armasm
    /* Now we need to exit the program */
    mov     %r0, $0     /* We are going to return a 0 because the program was ran correctly */
    mov     %r7, $1     /* Again a syscall. This time Syscall 1 is 'exit' */
    swi     $0          /* invoke syscall */
```

Our last step is to exit the program with another syscall. This time is Syscall 1 (exit) which only get's one parameter as it's return code.

We need to run this program now. Let's compile it then. I saved the file as __helloWorld.S__

```bash
arm-linux-gnueabihf-as -o helloWorld.o helloWorld.S
arm-linux-gnueabihf-ld -s -o helloWorld helloWorld.o

./helloWorld
```

So, we created our .o object with the first command and then we link it on the second one while creating an executable named helloWorld which we run on our third line. You should get a lovely __Hello World!__ message if everything is ok.

![Alt Text](https://dev-to-uploads.s3.amazonaws.com/i/b5e1z979oz8ft3ziy6cw.png)

Link to the DEV.to Post
