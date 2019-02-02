#!/bin/bash

rm /tmp/.wlin.fifo 2&>/dev/null
mkfifo /tmp/.wlin.fifo

rm /tmp/.wlout.txt 2&>/dev/null
touch /tmp/.wlout.txt

tail -f /tmp/.wlin.fifo | wolframscript -c '
    
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
    Show@g_Image := "echo " <> $nbAddr <> Export["out.png",g,"PNG"] //
                     (Run@#; Return@Last@StringSplit@#)&
                    
    Show@g_ := "echo " <> $nbAddr <> Export["out.pdf",g,"PDF"] // 
                (Run@#; Return@Last@StringSplit@#)&
    Protect@Show
"----------------------------------------------------------------------"          
    SetOptions[$Output,FormatType->OutputForm]
    
    ghostRun := (Run@#; $Line=$Line-1; Return[])&
    
    emptylogF := "> " <> Streams[][[1,1]] // ghostRun
    
    catoutF := "cat " <> Streams[][[1,1]] <> " > /tmp/.wlout.txt" // 
                ghostRun
"----------------------------------------------------------------------"    
    $Line = 0
    Dialog[]' 


