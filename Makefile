.PHONY: hexokinase
hexokinase:
	rm -rf hexokinase/ ; go get -u github.com/rrethy/hexokinase

.PHONY: clean
clean:
	rm -rf hexokinase/
