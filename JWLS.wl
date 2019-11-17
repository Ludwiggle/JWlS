#!/usr/bin/env wolframscript

______________________________________________________________________


argv = Rest@$ScriptCommandLine
argc = Length@argv

(* Default value *)
$nbTmp = "/tmp/JWLS"

unrecognized =
  (* Use ReplaceAll to parse arguments from beginning of argv. *)
  argv //.
    {

      (* For robustness, translate from {"--arg=value"} syntax
         to {"--arg", "value"} syntax. *)
      {argEqVal_, rest___} /; (
        (* Construct a list of matches of the form --arg=value and put
           them in the form {"--arg", "value"}. *)
          matches =
            StringCases[argEqVal,
              RegularExpression["--([^=]+)=(.*)"] :> {"--$1", "$2"}];
              (* There should only be one such match. *)
              Length[matches] == 1
      ) :>
       (* Replace the single match while preserving the rest of the
          list. *)
       Join[matches[[1]], {rest}],

      {"--url",    val_, rest___} :> ($nbURL = val; {rest}),
      {"--tmpdir", val_, rest___} :> ($nbTmp = val; {rest})
    };

(* Throw error if something left over. *)
If[Length[unrecognized] > 0,
  Print["Unrecognized arguments from: ", StringRiffle[unrecognized]];
  Exit[1]
]

(* Delete temporary variables *)
matches =.
unrecognized = .

Print[$nbURL]
Print[$nbTmp]

______________________________________________________________________


(* Lazily-evaluated notebook URL function which starts
   notebook as needed. *)
nbAddrF := ReadString@"!jupyter notebook list"~
           StringCases~Shortest["http://"~~__~~"/"]//
           If[# == {}
               ,(Print["\n$:"<>#]; Run@#)& @"jupyter notebook &";
                 Pause@1; nbAddrF
               ,Print["\n~: "<>First@#]; First@#<>"files/"
             ]&

(* If URL is specified from command line, then use that.
   Otherwise, run the function above. *)
If[ValueQ[$nbURL],
  $nbAddr = $nbURL <> "/files/", 
  $nbAddr = nbAddrF
]

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

catoutF := ghostRun["cat "<>Streams[][[1,1]]<>" > " <> $nbTmp <> "/wlout.txt"]

______________________________________________________________________


$Line = 0
Dialog[]
