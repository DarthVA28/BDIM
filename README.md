# BDIM
An interpreter for a Basic Decimal Integer Machine implementation using [SML-NJ](https://www.smlnj.org/).

## Writing a BDIM File 
A Basic Decimal Integer Machine (BDIM) may be used to do simple integer computations and implement elementary algorithms. Each instruction is a 4-tuple, which instructs the interpreter to store and perform operations on constants stored in the memory. There are 16 opcodes supported by the interpreter.

```
0 0 0 0: halt
1 v k _: mem[k] := v (input)
2 i k _: mem[k] := mem[i]
3 i k _: mem[k] := not mem[i]
4 i j _: mem[k] := mem[i] or mem[j]
5 i j _: mem[k] := mem[i] and mem[j]
6 i j _: mem[k] := mem[i] + mem[j]
7 i j _: mem[k] := mem[i] - mem[j]
8 i j k: mem[k] := mem[i] * mem[j]
9 i j k: mem[k] := mem[i] div mem[j]
10 i j k: mem[k] := mem[i] mod mem[j]
11 i j k: mem[k] := (mem[i] = mem[j])
12 i j k: mem[k] := (mem[i] > mem[j])
13 i c _: if mem[i] goto code[c]
14 c _ _: goto code[c]
15 i _ _: output: print mem[i]
16 v k c: mem[k] := c (constant)
```

Comments should be marked with a ```#```.

## BDIM Example 
The following BDIM file finds the sum to the nth term of an AP. 

```
(1,0,0,0) #a 
(1,0,0,1) #d
(1,0,0,2) #n
(16,1,0,3) #1
(16,2,0,4) #2
(7,2,3,5) #n-1
(8,4,0,6) #2*a
(8,1,5,7) #(n-1)*d
(6,6,7,8) #2*a + (n-1)d
(8,8,2,9) #n*(a+l)
(9,9,4,10) #sum
(15,10,0,0)
(0,0,0,0)
```


## Interpreting the BDIM File
The instructions of the BDIM file should be saved in a ```file.bdim``` format. Ensure that you have SML-NJ installed. Run SML-NJ in the directory with the BDIM file and the interpreter, then type the following commands:
```
use "bdim.sml";
interpret("file.bdim");
```
Interact with the interpreter as defined in the BDIM file. 

