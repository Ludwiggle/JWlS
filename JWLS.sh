#!/bin/bash

mkdir JWLSout 2>/dev/null

rm -r /tmp/JWLS 2>/dev/null
mkdir /tmp/JWLS 2>/dev/null


mkfifo /tmp/JWLS/wlin.fifo
touch /tmp/JWLS/wlout.txt

tail -f /tmp/JWLS/wlin.fifo | wolframscript -c '
    
"______________________________________________________________________"         
    nbAddrF := ReadString@"!jupyter notebook list" ~
               StringCases ~ Shortest["http://"~~__~~"/"] //
               If [ #=={}, 
                    (Print["\n$:"<>#]; Run@#) &@ "jupyter notebook &"; 
                      Pause@1; nbAddrF,
                    Print["\n~: " <> First@#]; 
                      First@# <> "files/" 
                  ]&
    
    $nbAddr = nbAddrF
"----------------------------------------------------------------------"
    Unprotect@Show
    Show@g_Image := "echo " <> $nbAddr <> Export["JWLSout/out.png",g,"PNG"] //
                     (Run@#; Return@Last@StringSplit@#)&
                    
    Show@g_ := "echo " <> $nbAddr <> Export["JWLSout/out.pdf",g,"PDF"] // 
                (Run@#; Return@Last@StringSplit@#)&
    Protect@Show
    
    $PrePrint = Shallow[#,{Infinity,10}]&
"----------------------------------------------------------------------"          
    SetOptions[$Output,FormatType->OutputForm]
    
    ghostRun := (Run@#; $Line=$Line-1; Return[])&
    
    emptylogF := "> " <> Streams[][[1,1]] // ghostRun
    
    catoutF := "cat " <> Streams[][[1,1]] <> " > /tmp/JWLS/wlout.txt" // 
                ghostRun
"----------------------------------------------------------------------"    
    $Line = 0
    Dialog[]' 


