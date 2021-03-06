smalltalk calling convention
genPushRegisterArgsForAbortMissNumArgs: numArgs
	"Ensure that the register args are pushed before the outer and
	 inner retpcs at an entry miss for arity <= self numRegArgs.  The
	 outer retpc is that of a call at a send site.  The inner is the call
	 from a method or PIC abort/miss to the trampoline."

	"This won't be as clumsy on a RISC.  But putting the receiver and
	 args above the return address means the CoInterpreter has a
	 single machine-code frame format which saves us a lot of work."

	"Iff there are register args convert
		base	->	outerRetpc		(send site retpc)
		sp		->	innerRetpc		(PIC abort/miss retpc)
	 to
		base	->	receiver
					(arg0)
					(arg1)
					outerRetpc
		sp		->	innerRetpc		(PIC abort/miss retpc)"
	numArgs <= cogit numRegArgs ifTrue:
		[self assert: cogit numRegArgs <= 2.
		 numArgs = 0 ifTrue:
			[cogit MoveMw: 0 r: SPReg R: TempReg.
			 cogit PushR: TempReg.
			 cogit MoveMw: BytesPerWord * 2 r: SPReg R: TempReg.
			 cogit MoveR: TempReg Mw: BytesPerWord r: SPReg.
			 cogit MoveR: ReceiverResultReg Mw: 2 * BytesPerWord r: SPReg.
			 ^self].
		 numArgs = 1 ifTrue:
			[cogit MoveMw: BytesPerWord r: SPReg R: TempReg.
			 cogit PushR: TempReg.
			 cogit MoveMw: BytesPerWord r: SPReg R: TempReg.
			 cogit PushR: TempReg.
			 cogit MoveR: ReceiverResultReg Mw: 3 * BytesPerWord r: SPReg.
			 cogit MoveR: Arg0Reg Mw: 2 * BytesPerWord r: SPReg.
			 ^self].
		 numArgs = 2 ifTrue:
			[cogit PushR: Arg1Reg.
			 cogit MoveMw: BytesPerWord * 2 r: SPReg R: TempReg.
			 cogit PushR: TempReg.
			 cogit MoveMw: BytesPerWord * 2 r: SPReg R: TempReg.
			 cogit PushR: TempReg.
			 cogit MoveR: ReceiverResultReg Mw: 4 * BytesPerWord r: SPReg.
			 cogit MoveR: Arg0Reg Mw: 3 * BytesPerWord r: SPReg.
			 ^self]]