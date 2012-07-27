
//auto-initializaiton code
if (typeof document.addEventListener === 'function') Kalendae.util.domReady(function () {
	var els = util.$$('.auto-kal'),
		i = els.length,
		e,
		options,
		optionsRaw;

	while (i--) {
		e = els[i];
		optionsRaw = e.getAttribute('data-kal');
		options = (optionsRaw == null || optionsRaw == "") ? {} : (new Function('return {' + optionsRaw + '};'))();
                options['id'] = options['id'] || 'default';
		if (e.tagName === 'INPUT') {
			//if element is an input, bind a popup calendar to the input.
		        Kalendae[options['id']] = new Kalendae.Input(e, options);
		} else {
			//otherwise, insert a flat calendar into the element.
			Kalendae[options['id']] = new Kalendae(util.merge(options, {attachTo:e}));
		}
		
	}
});
