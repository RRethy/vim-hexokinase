hexokinase:
	git init && git submodule update && cd hexokinase/ && go build

.PHONE: clean

clean:
	rm -rf hexokinase/
