class_name Cmd

enum {
	Empty, Right, Left, RightIf,
	LeftIf, Take, Put, Inc,
	Dec, BellC, BellD, BellE,
	BellF, BellG, BellA, BellB }

static func charToCmd(c):
	match c:
		" ":
			return Empty
		"]":
			return Right
		"[":
			return Left
		"}":
			return RightIf
		"{":
			return LeftIf
		"<":
			return Take
		">":
			return Put
		"+":
			return Inc
		"-":
			return Dec
		"C":
			return BellC
		"D":
			return BellD
		"E":
			return BellE
		"F":
			return BellF
		"G":
			return BellG
		"A":
			return BellA
		"B":
			return BellB
		_:
			return Empty
