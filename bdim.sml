fun parseHelper ( s: string, a,b,c,d, idx: int, iter : int) = 
    if substring(s,idx,1) = ")" 
        then (a,b,c,d)
    else if substring(s,idx,1) = "("
        then parseHelper(s,a,b,c,d,idx+1,iter)
    else if substring(s,idx,1) = ","
        then parseHelper(s,a,b,c,d,idx+1,iter+1)
    else if iter=1
        then parseHelper(s,a^substring(s,idx,1),b,c,d,idx+1,iter)
    else if iter=2
        then parseHelper(s,a,b^substring(s,idx,1),c,d,idx+1,iter)
    else if iter=3
        then parseHelper(s,a,b,c^substring(s,idx,1),d,idx+1,iter)
    else parseHelper(s,a,b,c,d^substring(s,idx,1),idx+1,iter)

fun parse(s) = 
  let 
    val (a,b,c,d) = parseHelper(s,"","","","",0,1)
    val x1 = valOf(Int.fromString(a))
    val x2 = valOf(Int.fromString(b))
    val x3 = valOf(Int.fromString(c))
    val x4 = valOf(Int.fromString(d))
  in
    (x1,x2,x3,x4)
end
   
fun getBDIM (infile : string) = 
    let 
        val bdim = TextIO.openIn infile 
        fun get(bdim) = 
        case TextIO.inputLine bdim of 
            SOME line => line :: get(bdim)
            | NONE      => [] 
    in 
        get(bdim) before TextIO.closeIn bdim
    end

fun parselist([]) = []
    |parselist([x]) = [parse(x)]
    |parselist(x::ls) = parse(x)::parselist(ls)

fun getfile () = valOf(TextIO.inputLine TextIO.stdIn);

fun boolval(a) = 
    if (a = 1) then true
    else false

fun intval(b) = 
    if (b=true) then 1
    else 0

exception indexOutOfBounds
exception nIndex 
exception divError
exception Bool

fun runline(code:(int * int * int * int) vector,idx,mem) = 
    (if idx >= Vector.length(code) then raise indexOutOfBounds
    else 
        let 
            val t = Vector.sub(code, idx)
        in 
            if #1(t) = 0 then 
                print "Execution successful.\n"

            else if #1(t) = 1 then
                (if #4(t) < 0 then raise nIndex
                else
                    let 
                        val x = print("Input value: ")
                        val v = valOf(Int.fromString(valOf(TextIO.inputLine TextIO.stdIn)))
                        val res = Array.update(mem,#4(t),v)
                    in
                        runline(code,idx+1,mem)
                    end) handle nIndex => print("Indices cannot be negative!\n") 

            else if #1(t) = 2 then
            (if #4(t) < 0 orelse #2(t) <0 then raise nIndex
            else
                let 
                    val res = Array.update(mem,#4(t),Array.sub(mem,#2(t)))
                in 
                    runline(code,idx+1,mem)
                end) handle nIndex => print("Indices cannot be negative!\n") 

            else if #1(t) = 3 then
            (if #4(t) < 0 orelse #2(t) <0 then raise nIndex
            else if Array.sub(mem,#2(t)) <> 1 andalso Array.sub(mem,#2(t)) <> 0 then raise Bool 
            else 
                let 
                    val b = boolval(Array.sub(mem,#2(t)))
                    val res = Array.update(mem,#4(t),intval(not b))
                in 
                    runline(code,idx+1,mem)
                end) handle nIndex => print("Indices cannot be negative!\n") 
                |Bool => print("Non boolean cannot be converted to boolean")
                        

            else if #1(t) = 4 then
            (if #4(t) < 0 orelse #2(t) <0 orelse #3(t) < 0 then raise nIndex
            else if Array.sub(mem,#2(t)) <> 1 andalso Array.sub(mem,#2(t)) <> 0 then raise Bool 
            else if Array.sub(mem,#3(t)) <> 1 andalso Array.sub(mem,#3(t)) <> 0 then raise Bool
            else 
                let 
                    val b1 = boolval(Array.sub(mem,#2(t)))
                    val b2 = boolval(Array.sub(mem,#3(t)))
                    val res = Array.update(mem,#4(t),intval(b1 orelse b2))
            
                in 
                    runline(code,idx+1,mem)
                end) handle nIndex => print("Indices cannot be negative!\n") 
                |Bool => print("Non boolean cannot be converted to boolean")

            else if #1(t) = 5 then
            (if #4(t) < 0 orelse #2(t) <0 orelse #3(t) < 0 then raise nIndex
            else if Array.sub(mem,#2(t)) <> 1 andalso Array.sub(mem,#2(t)) <> 0 then raise Bool 
            else if Array.sub(mem,#3(t)) <> 1 andalso Array.sub(mem,#3(t)) <> 0 then raise Bool
            else 
                let 
                    val b1 = boolval(Array.sub(mem,#2(t)))
                    val b2 = boolval(Array.sub(mem,#3(t)))
                    val res = Array.update(mem,#4(t),intval(b1 andalso b2))
                in 
                    runline(code,idx+1,mem)
                end) handle nIndex => print("Indices cannot be negative!\n") 
                |Bool => print("Non boolean cannot be converted to boolean")

            else if #1(t) = 6 then
            (if #4(t) < 0 orelse #2(t) <0 orelse #3(t) < 0 then raise nIndex
            else
                let 
                    val x1 = Array.sub(mem,#2(t))
                    val x2 = Array.sub(mem,#3(t))
                    val res = Array.update(mem,#4(t),x1+x2)
                in 
                    runline(code,idx+1,mem)
                end) handle nIndex => print("Indices cannot be negative!\n") 

            else if #1(t) = 7 then
                (if #4(t) < 0 orelse #2(t) <0 orelse #3(t) < 0 then raise nIndex
                else
                    let 
                        val x1 = Array.sub(mem,#2(t))
                        val x2 = Array.sub(mem,#3(t))
                        val res = Array.update(mem,#4(t),x1-x2)
                    in 
                        runline(code,idx+1,mem)
                    end) handle nIndex => print("Indices cannot be negative!\n") 


            else if #1(t) = 8 then
                (if #4(t) < 0 orelse #2(t) <0 orelse #3(t) < 0 then raise nIndex
                else
                    let 
                        val x1 = Array.sub(mem,#2(t))
                        val x2 = Array.sub(mem,#3(t))
                        val res = Array.update(mem,#4(t),x1*x2)
                    in 
                        runline(code,idx+1,mem)
                    end) handle nIndex => print("Indices cannot be negative!\n") 

            else if #1(t) = 9 then
                (if #4(t) < 0 orelse #2(t) <0 orelse #3(t) < 0 then raise nIndex
                else if Array.sub(mem,#3(t)) = 0 then raise divError
                else
                    let 
                        val x1 = Array.sub(mem,#2(t))
                        val x2 = Array.sub(mem,#3(t))
                        val res = Array.update(mem,#4(t),x1 div x2)
                    in 
                        runline(code,idx+1,mem)
                    end) handle nIndex => print("Indices cannot be negative!\n") 
                    | divError => print("Cannot divide by zero")

            else if #1(t) = 10 then
                (if #4(t) < 0 orelse #2(t) <0 orelse #3(t) < 0 then raise nIndex
                else if Array.sub(mem,#3(t)) = 0 then raise divError
                else
                    let 
                        val x1 = Array.sub(mem,#2(t))
                        val x2 = Array.sub(mem,#3(t))
                        val res = Array.update(mem,#4(t),x1 mod x2)
                    in 
                        runline(code,idx+1,mem)
                    end) handle nIndex => print("Indices cannot be negative!\n") 
                    | divError => print("Cannot divide by zero")

            else if #1(t) = 11 then
                (if #4(t) < 0 orelse #2(t) <0 orelse #3(t) < 0 then raise nIndex
                else
                    let 
                        val x1 = Array.sub(mem,#2(t))
                        val x2 = Array.sub(mem,#3(t))
                        val b = (x1 = x2)
                        val res = Array.update(mem,#4(t),intval(b))
                    in 
                        runline(code,idx+1,mem)
                    end) handle nIndex => print("Indices cannot be negative!\n") 

            else if #1(t) = 12 then
                (if #4(t) < 0 orelse #2(t) <0 orelse #3(t) < 0 then raise nIndex
                else
                    let 
                        val x1 = Array.sub(mem,#2(t))
                        val x2 = Array.sub(mem,#3(t))
                        val b = (x1 > x2)
                        val res = Array.update(mem,#4(t),intval(b))
                    in 
                        runline(code,idx+1,mem)
                    end) handle nIndex => print("Indices cannot be negative!\n") 

            else if #1(t) = 13 then
            (if #4(t) < 0 orelse #2(t) <0 then raise nIndex
            else
                let 
                    val x1 = Array.sub(mem,#2(t))
                    val b = boolval(x1)
                in 
                    if b = true then 
                        runline(code,#4(t),mem)
                    else 
                        runline(code,idx+1,mem)
                end) handle nIndex => print("Indices cannot be negative!\n") 

            else if #1(t) = 14 then
            (if #4(t) < 0 then raise nIndex
            else
                runline(code,#4(t),mem)
            ) handle nIndex => print("Indices cannot be negative!\n") 

            else if #1(t) = 15 then
            (if #2(t) < 0 then raise nIndex
            else
                let 
                    val str = Int.toString(Array.sub(mem,#2(t))) ^ "\n"
                    val output = print(str)
                in 
                    runline(code,idx+1,mem)
                end) handle nIndex => print("Indices cannot be negative!\n") 

            else if #1(t) = 16 then 
            (if #4(t) < 0 orelse #2(t) <0 then raise nIndex
            else
                let 
                        val res = Array.update(mem,#4(t),#2(t))
                    in
                        runline(code,idx+1,mem)
                    end) handle nIndex => print("Indices cannot be negative!\n") 
            else 
                print "An error occured"
            end
        ) handle indexOutOfBounds => print "Reference to a non-existent line"

fun interpret(filename) = 
    let 
        val maxMemSize = 1000;
        val codetemp = parselist(getBDIM(filename))
        val code = Vector.fromList(codetemp)
        val mem = Array.array(maxMemSize,0)
    in 
        runline(code,0,mem)
    end