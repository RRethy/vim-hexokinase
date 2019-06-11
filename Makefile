.PHONY: hexokinase
hexokinase:
	git init && git submodule update && cd hexokinase/ && go build

.PHONY: clean
clean:
	rm -rf hexokinase/
