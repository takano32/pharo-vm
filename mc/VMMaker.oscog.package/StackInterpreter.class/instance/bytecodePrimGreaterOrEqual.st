common selector sends
bytecodePrimGreaterOrEqual
	| rcvr arg aBool |
	rcvr := self internalStackValue: 1.
	arg := self internalStackValue: 0.
	(self areIntegers: rcvr and: arg) ifTrue:
		["The C code can avoid detagging since tagged integers are still signed.
		 But this means the simulator must override to do detagging."
		^self cCode: [self booleanCheat: rcvr >= arg]
			inSmalltalk: [self booleanCheat: (objectMemory integerValueOf: rcvr) >= (objectMemory integerValueOf: arg)]].

	self initPrimCall.
	aBool := self primitiveFloatGreaterOrEqual: rcvr toArg: arg.
	self successful ifTrue: [^self booleanCheat: aBool].

	messageSelector := self specialSelector: 5.
	argumentCount := 1.
	self normalSend