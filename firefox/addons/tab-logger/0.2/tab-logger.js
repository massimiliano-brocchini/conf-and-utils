//mozrepl custom interactor (test release)

var tablogger= {
    handleInput: function(repl, input) {
		var [w, t, url] = input.replace(/^\s+|\s+$/g, '').split(/\s+/, 3);

		var mediator = Components.classes["@mozilla.org/appshell/window-mediator;1"].getService(Components.interfaces.nsIWindowMediator);
		var browserEnumerator = mediator.getEnumerator("navigator:browser");

		if (w > '0' && t > '0') { //attiva il tab con indirizzo 'url'

			var found = false;
			while (!found && browserEnumerator.hasMoreElements()) {
				var browserWin = browserEnumerator.getNext();
				var tabbrowser = browserWin.gBrowser;
				var numtabs    = tabbrowser.browsers.length;

				for (var i = 0; i < numtabs; i++) {
					var browser = tabbrowser.getBrowserAtIndex(i);
					if (url == browser.currentURI.spec) {
						tabbrowser.selectedTab = tabbrowser.tabContainer.childNodes[i];
						browserWin.focus();
						found = true;
						break;
					}
				}
			}

		} else { //salva l'elenco dei tab su file

			var lines = [];
			var w = 1, t = 1;

			// Windows
			while(browserEnumerator.hasMoreElements()) {
				var browserWin = browserEnumerator.getNext();
				var tabbrowser = browserWin.gBrowser;
				var numtabs    = tabbrowser.browsers.length;

				// Tabs
				for(var i = 0; i < numtabs; i++) {
					var browser = tabbrowser.getBrowserAtIndex(i);
					lines.push(( w + "\t" + (t++)) + "\t" + browser.contentDocument.title.replace("\t", " ") + "\t" + browser.currentURI.spec);
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

    },

    onStart: function(repl) {},

    onStop: function(repl) {},

    getPrompt: function(repl) {},
};

