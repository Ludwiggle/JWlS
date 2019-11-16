#!/usr/bin/env wolframscript

______________________________________________________________________


nbAddrF := ReadString@"!jupyter notebook list"~
           StringCases~Shortest["http://"~~__~~"/"]//
           If[# == {}
               ,(Print["\n$:"<>#]; Run@#)& @"jupyter notebook &";
                 Pause@1; nbAddrF
               ,Print["\n~: "<>First@#]; First@#<>"files/"
             ]&

$nbAddr = nbAddrF

______________________________________________________________________


show@g_Image := "echo "<>$nbAddr<>Export["JWLSout/out.png",g,"PNG"]//
                 (Run@#; Return@Last@StringSplit@#)&

show@g_ := "echo "<>$nbAddr<>Export["JWLSout/out.pdf",g,"PDF"]//
           (Run@#; Return@Last@StringSplit@#)&

show@g_Graphics3D := "wolframplayer -nosplash "<>Export["JWLSout/out.nb",g] // Run


Protect@show

$PrePrint = Shallow[ #,{Infinity,12}]&;

______________________________________________________________________


SetOptions[$Output,FormatType->OutputForm, PageWidth->120]


ghostRun := (Run@#; $Line = $Line-1; Return[])&

emptylogF := ghostRun["> "<>Streams[][[1,1]]]

catoutF := ghostRun["cat "<>Streams[][[1,1]]<>" > /tmp/JWLS/wlout.txt"]

______________________________________________________________________


$Line = 0
Dialog[]
