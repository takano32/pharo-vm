process primitive support
addLastLink: proc toList: aList 
	"Add the given process to the end of the given linked list
	 and set the backpointer of process to its new list."
	| lastLink |
	self assert: (objectMemory isForwarded: aList) not.
	self assert: (objectMemory fetchPointer: NextLinkIndex ofObject: proc) = objectMemory nilObject.
	(self isEmptyList: aList)
		ifTrue: [objectMemory storePointer: FirstLinkIndex ofObject: aList withValue: proc]
		ifFalse:
			[lastLink := objectMemory fetchPointer: LastLinkIndex ofObject: aList.
			 self assert: lastLink ~= proc.
			 objectMemory storePointer: NextLinkIndex ofObject: lastLink withValue: proc].
	objectMemory storePointer: LastLinkIndex ofObject: aList withValue: proc.
	objectMemory storePointer: MyListIndex ofObject: proc withValue: aList