primitives
primitiveFFIFloatAt
	"Return a (signed or unsigned) n byte integer from the given byte offset."
	| byteOffset rcvr addr floatValue |
	<export: true>
	<inline: false>
	<var: #floatValue type:'float '>
	byteOffset := interpreterProxy stackIntegerValue: 0.
	rcvr := interpreterProxy stackObjectValue: 1.
	interpreterProxy failed ifTrue:[^0].
	addr := self ffiAddressOf: rcvr startingAt: byteOffset size: 4.
	interpreterProxy failed ifTrue:[^0].
	self cCode:'((int*)(&floatValue))[0] = ((int*)addr)[0]'.
	interpreterProxy pop: 2.
	^interpreterProxy pushFloat: floatValue