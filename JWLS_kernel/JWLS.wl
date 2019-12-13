#!/usr/bin/env wolframscript

______________________________________________________________________

(* This section parses command line arguments *)

argv = Rest@$ScriptCommandLine;
argc = Length@argv;

(* Default value *)
$JWLSnbTmp = "/tmp/JWLS";

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

      {"--url",    val_, rest___} :> ($JWLSnbURL = val;     {rest}),
      {"--no-player", rest___}    :> ($JWLSnoPlayer = True; {rest}),
      {"--tmpdir", val_, rest___} :> ($JWLSnbTmp = val;     {rest})
    };

(* Throw error if something left over. *)
If[Length[unrecognized] > 0,
  Print["Unrecognized arguments from: ", StringRiffle[unrecognized]];
  Exit[1]
];

(* Delete temporary variables *)
matches =.;
unrecognized =.;

Print[$JWLSnbURL];
Print[$JWLSnbTmp];

______________________________________________________________________


(* Lazily-evaluated notebook URL function which starts
   notebook as needed. *)
JWLSnbAddrF := ReadString@"!jupyter notebook list"~
           StringCases~Shortest["http://"~~__~~"/"]//
           If[# == {}
               ,(Print["\n$:"<>#]; Run@#)& @"jupyter notebook &";
                 Pause@1; JWLSnbAddrF
               ,Print["\n~: "<>First@#]; First@#<>"files/"
             ]&;

(* If URL is specified from command line, then use that.
   Otherwise, run the function above. *)
If[ValueQ[$JWLSnbURL],
  $JWLSnbAddr = $JWLSnbURL,
  $JWLSnbAddr = JWLSnbAddrF
];

______________________________________________________________________


$JWLSgraphicsBaseName := ($JWLSnbTmp <> "/output_files/" <> IntegerString[Hash[#], 36])&;

JWLSexportAndShowLink[g_, ext_String] :=
  "echo "<>$JWLSnbAddr<>"/"<>FileNameTake@Export[$JWLSgraphicsBaseName[g] <> ext,g]//
                 (Run@#; Return@Last@StringSplit@#)&;

runplayer[g_] := "wolframplayer -nosplash " <>
                Export[$JWLSgraphicsBaseName[g] <> ".nb",g] // Run;
  showpdf[g_] := JWLSexportAndShowLink[g, ".pdf"];
  showpng[g_] := JWLSexportAndShowLink[g, ".png"];
   shownb[g_] := If[$JWLSnoPlayer===True, JWLSexportAndShowLink[g, ".nb"], runplayer[g]];

show[g_Image]      := showpng[g];
show[g_Graphics]   := showpdf[g];
show[g_Graphics3D] :=  shownb[g];
show[g_]           := showpdf[g];

Protect@show;

$PrePrint = Shallow[ #,{Infinity,12}]&;

______________________________________________________________________


SetOptions[$Output,FormatType->OutputForm, PageWidth->120];


JWLSghostRun := ($lastRes=%; Run@#; $Line = $Line-1; $lastRes; Return[])&;

JWLSemptylogF := JWLSghostRun["> "<>Streams[][[1,1]]];

JWLScatoutF := JWLSghostRun["cat "<>Streams[][[1,1]]<>" > " <> $JWLSnbTmp <> "/wlout.txt"];

______________________________________________________________________


$Line = 0;
Dialog[];
