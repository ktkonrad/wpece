kal=src/main.js \
	src/util.js \
	src/auto.js \
	src/input.js \
	src/MinPubSub.js \
	src/moment.js \
	src/moment.ext.js \
	src/jq.js

all: kalendae.js

clean:
	rm -f *.js

minified: kalendae.min.js

minified-test: kalendae.min.errors


kalendae.js: $(kal) src/header.js
	cat src/header.js > $@
	echo "(function (undefined) {" >> $@
	echo "" >> $@
	cat $(kal) >> $@
	echo "" >> $@
	echo "})();" >> $@

kalendae.min.js: kalendae.js
	cat src/header.js > $@
	curl -s \
		--data-urlencode 'js_code@kalendae.js' \
		--data-urlencode 'output_format=text' \
		--data-urlencode 'output_info=compiled_code' \
		http://closure-compiler.appspot.com/compile \
		>> $@
	gzip -c kalendae.min.js | wc -c


kalendae.min.errors: kalendae.js
	curl -s \
		--data-urlencode 'js_code@kalendae.js' \
		--data-urlencode 'output_format=text' \
		--data-urlencode 'output_info=errors' \
		http://closure-compiler.appspot.com/compile
