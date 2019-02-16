// search box
user_pref("browser.search.widget.inNavBar", true);

// {{{ old usual navigation bar layout
// -- basic, no extensions -- user_pref("browser.uiCustomization.state", "{\"placements\":{\"widget-overflow-fixed-list\":[],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"home-button\",\"urlbar-container\",\"search-container\",\"downloads-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"developer-button\",\"webide-button\"],\"dirtyAreaCache\":[\"PersonalToolbar\",\"nav-bar\",\"TabsToolbar\",\"toolbar-menubar\"],\"currentVersion\":15,\"newElementCount\":3}");
user_pref("browser.uiCustomization.state", "{\"placements\":{\"widget-overflow-fixed-list\":[],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"home-button\",\"urlbar-container\",\"search-container\",\"downloads-button\",\"ublock0_raymondhill_net-browser-action\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"developer-button\",\"webide-button\",\"ublock0_raymondhill_net-browser-action\"],\"dirtyAreaCache\":[\"PersonalToolbar\",\"nav-bar\",\"TabsToolbar\",\"toolbar-menubar\"],\"currentVersion\":15,\"newElementCount\":3}");
user_pref("browser.uidensity", 1);
// remove pocket
user_pref("browser.pageActions.persistedActions", "{\"version\":1,\"ids\":[\"bookmark\",\"bookmarkSeparator\",\"copyURL\",\"emailLink\",\"addSearchEngine\",\"sendToDevice\",\"pocket\",\"screenshots_mozilla_org\"],\"idsInUrlbar\":[\"bookmark\"]}");
// }}}

// unknown effect
user_pref("ui.key.menuAccessKeyFocuses", false);

// disable accessibility tools accessing firefox
user_pref("accessibility.force_disabled", 1);

// find as you type
user_pref("accessibility.typeaheadfind", true);

// ask download location
user_pref("browser.download.useDownloadDir", false);

// {{{ remove as much as possible from new tab page / homepage
user_pref("browser.startup.homepage", "about:blank");
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr", false);
user_pref("browser.newtabpage.activity-stream.feeds.section.highlights", false);
user_pref("browser.newtabpage.activity-stream.feeds.snippets", false);
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);
user_pref("browser.newtabpage.activity-stream.prerender", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includeBookmarks", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includeDownloads", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includePocket", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includeVisited", false);
user_pref("browser.newtabpage.activity-stream.showSearch", false);
user_pref("browser.newtabpage.enabled", false);
// }}}

// hide unwanted search engines
user_pref("browser.search.hiddenOneOffs", "Bing,Amazon.com,DuckDuckGo,Twitter");

// {{{ keep url bar less "smart"
user_pref("browser.urlbar.matchBuckets", "general:5,suggestion:Infinity");
user_pref("browser.urlbar.searchSuggestionsChoice", false);
user_pref("browser.urlbar.suggest.bookmark", false);
user_pref("browser.urlbar.suggest.openpage", false);
user_pref("browser.urlbar.suggest.searches", false);
// disable reader view icon
user_pref("reader.parse-on-load.enabled", false);
// }}}

// don't report usage data to Mozilla
user_pref("datareporting.healthreport.uploadEnabled", false);

// {{{ don't allow web sites to ask persmission to access camera, microphone and location
user_pref("permissions.default.camera", 2);
user_pref("permissions.default.microphone", 2);
user_pref("permissions.default.geo", 2);
// }}}

// always send do not track to web sites
user_pref("privacy.donottrackheader.enabled", true);

// don't remember logins
user_pref("signon.rememberSignons", false);

// new tabs are positioned at far righ
user_pref("browser.tabs.insertRelatedAfterCurrent", false);


// {{{ ublock origin extension
user_pref("extensions.webextensions.uuids", "{\"formautofill@mozilla.org\":\"2b4d850f-5f87-4434-83f8-fc83695bfd69\",\"screenshots@mozilla.org\":\"d6f82199-539a-4992-9bcd-d53bce97d7fb\",\"webcompat-reporter@mozilla.org\":\"ab7c6ff2-2008-4fa8-90fb-53069b07cc35\",\"webcompat@mozilla.org\":\"3be50e2a-0055-4467-9b34-74e7173738b9\",\"fxmonitor@mozilla.org\":\"cbaf63d7-c7ea-4dd9-b809-f6a7ca3b6482\",\"uBlock0@raymondhill.net\":\"3bda80a8-4121-49ab-96db-00f3285dd2f9\"}");
user_pref("network.dns.disablePrefetch", true);
user_pref("network.http.speculative-parallel-limit", 0);
user_pref("network.predictor.enabled", false);
user_pref("network.prefetch-next", false);
// }}}

// remove about:config warning
user_pref("general.warnOnAboutConfig", false);

//middle mouse button clicked outside a link doesn't try to load clipboard content as URL
user_pref("middlemouse.contentLoadURL", false); 
