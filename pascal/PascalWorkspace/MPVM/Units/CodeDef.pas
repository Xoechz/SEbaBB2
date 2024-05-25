(* MiniPascal/MidiPascal VM op code definitions. *)
(* GHO, 13.05.2017 *)
UNIT CodeDef;

INTERFACE

TYPE
	(* MiniPascal/MidiPascal VM op code. *)
	OpCode = (loadConstOpc, loadValOpc, storeOpc,
		addOpc, subOpc, multOpc, divOpc,
    readOpc, writeOpc,
    endOpc,
		jumpOpc, jumpZeroOpc);

IMPLEMENTATION

END.
