compile-lang = java -jar /usr/local/lib/antlr-4.7.2-complete.jar -Dlanguage='$@' -o generated/'$@' ClosureLexer.g4; java -jar /usr/local/lib/antlr-4.7.2-complete.jar -Dlanguage='$@' -o generated/'$@' ClosureParser.g4

all: Cpp CSharp Go Java JavaScript Python2 Python3 Swift

Cpp: ClosureLexer.g4 ClosureParser.g4
	$(compile-lang)

CSharp: ClosureLexer.g4 ClosureParser.g4
	$(compile-lang)

Go: ClosureLexer.g4 ClosureParser.g4
	$(compile-lang)

Java: ClosureLexer.g4 ClosureParser.g4
	$(compile-lang)

JavaScript: ClosureLexer.g4 ClosureParser.g4
	$(compile-lang)

Python2: ClosureLexer.g4 ClosureParser.g4
	$(compile-lang)

Python3: ClosureLexer.g4 ClosureParser.g4
	$(compile-lang)

Swift: ClosureLexer.g4 ClosureParser.g4
	$(compile-lang)
