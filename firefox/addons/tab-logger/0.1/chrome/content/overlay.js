var tablogger = {

	save: function() {
		var mediator = Components.classes["@mozilla.org/appshell/window-mediator;1"].getService(Components.interfaces.nsIWindowMediator);  

		var lines = [];

		var w = 1, t = 1;
		var browserEnumerator = mediator.getEnumerator("navigator:browser");  
		// Windows
		while(browserEnumerator.hasMoreElements()) {
			var browserWin = browserEnumerator.getNext();
			var tabbrowser = browserWin.gBrowser;

			var nbrowsers = tabbrowser.browsers.length;

			// Tabs
			for(var i = 0; i < nbrowsers; i++) {
				var browser = tabbrowser.browsers[i];
				lines.push(( w + " " + (t++)) + " " + browser.contentDocument.title.replace("\t", " "));
			}

			++w;
			t = 1;
		}

		var file = Components.classes["@mozilla.org/file/directory_service;1"].getService(Components.interfaces.nsIProperties).get("Home", Components.interfaces.nsIFile);

		if(file && file.exists()) {
			file.append(".tablogger.list");

			var foStream = Components.classes["@mozilla.org/network/file-output-stream;1"].createInstance(Components.interfaces.nsIFileOutputStream);
			foStream.init(file, 0x02 | 0x08 | 0x20, 0666, 0); //filestream: write only | create | truncate if already existent
			var converter = Components.classes["@mozilla.org/intl/converter-output-stream;1"].createInstance(Components.interfaces.nsIConverterOutputStream);
			converter.init(foStream, "UTF-8", 0, 0);
			converter.writeString(lines.join("\n"));
			converter.close();
		}
	}

};

window.addEventListener("load", tablogger.save, false);
