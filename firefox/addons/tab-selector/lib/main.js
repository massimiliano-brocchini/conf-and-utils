var data       = require("sdk/self").data;
var windows    = require("sdk/windows").browserWindows;
var tabs       = require("sdk/tabs");
var system     = require("sdk/system");
var file_io    = require("sdk/io/file");
var prefs      = require("sdk/simple-prefs").prefs;
var text_entry = require("sdk/panel").Panel({
  width             : 100,
  height            : 45,
  contentURL        : data.url("text-entry.html"),
  contentScriptFile : data.url("get-text.js")
});

var w=require("sdk/widget").Widget({
  id         : "tab-selector",
  label      : "Tab Selector",
  contentURL : data.url("icon.png"),
  panel      : text_entry
});


// {{{ tab logging
var profile = file_io.basename(system.pathFor("ProfD"));
var writer;

function log_open_tabs() {
	writer = file_io.open(prefs.pref_path+"tab-selector-"+profile,"w");
	for (var w_idx in windows) {
		t = windows[w_idx].tabs;
		for (var t_idx in windows[w_idx].tabs) {
			writer.write(w_idx + "|" + t_idx + "|" + t[t_idx].title + "|" + t[t_idx].url + "|" + (t.activeTab==t[t_idx]) +"|\n");
		}
	}
	writer.close();
}

tabs.on('load'     , log_open_tabs);
tabs.on('open'     , log_open_tabs);
tabs.on('close'    , log_open_tabs);
tabs.on('activate' , log_open_tabs);

// }}}


// {{{ tab activation
var { Hotkey } = require("sdk/hotkeys");

var popup = Hotkey({
	combo   : prefs.pref_shortcut,
	onPress : function() {
		text_entry.show({ position: { bottom: 0, right: 0}  });
	}
});

text_entry.on("show", function() {
  text_entry.port.emit("show");
});
 
// text inserted -> activate tag
text_entry.port.on("text-entered", function (text) {
  var idx = Math.min(tabs.length,text)-1;
  tabs[idx].activate();
  text_entry.hide();
});
// }}}
