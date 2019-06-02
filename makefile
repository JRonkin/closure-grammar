files = ClosureLexer.g4 ClosureParser.g4
compile-lang = java -jar /usr/local/lib/antlr-4.7.2-complete.jar -Dlanguage='$@' -o generated/'$@' ClosureLexer.g4; java -jar /usr/local/lib/antlr-4.7.2-complete.jar -Dlanguage='$@' -o generated/'$@' ClosureParser.g4


all: Cpp CSharp Go Java JavaScript Python2 Python3 Swift

Cpp: $(files)
	$(compile-lang)

CSharp: $(files)
	$(compile-lang)

Go: $(files)
	$(compile-lang)

Java: $(files)
	$(compile-lang)

JavaScript: $(files)
	$(compile-lang)

Python2: $(files)
	$(compile-lang)

Python3: $(files)
	$(compile-lang)

Swift: $(files)
	$(compile-lang)
