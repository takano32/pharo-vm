handler search
findMethodWithPrimitive: primitive FromContext: senderContext UpToContext: homeContext
	"See findUnwindThroughContext:.  Alas this is mutually recursive with
	 findMethodWithPrimitive:FromFP:SP:ThroughContext: instead of iterative.
	 We're doing the simplest thing that could possibly work.  Niceties can wait."
	| theContext theMethod |
	self assert: (senderContext = objectMemory nilObject or: [objectMemory isContext: senderContext]).
	self assert: (homeContext = objectMemory nilObject or: [objectMemory isContext: homeContext]).
	theContext := senderContext.
	[theContext = objectMemory nilObject ifTrue:
		[^theContext].
	 self isMarriedOrWidowedContext: theContext] whileFalse:
		[theContext = homeContext ifTrue: [^0].
		 (objectMemory fetchPointer: ClosureIndex ofObject: theContext) = objectMemory nilObject ifTrue:
		 	[theMethod := objectMemory fetchPointer: MethodIndex ofObject: theContext.
			 (self primitiveIndexOf: theMethod) == primitive ifTrue:
				[^theContext]].
		 theContext := objectMemory fetchPointer: SenderIndex ofObject: theContext].
	(self isWidowedContext: theContext) ifTrue:
		[^objectMemory nilObject].
	^self
		findMethodWithPrimitive: primitive
		FromFP: (self frameOfMarriedContext: theContext)
		UpToContext: homeContext