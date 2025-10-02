# Setup some defaults for Safari (and Safari Technology Preview)

local -r SAFARI_TOOLBAR_ITEMS_KEY="OrderedToolbarItemIdentifiers"
local -r SAFARI_TOOLBAR_CONFIG_DEFAULT_KEY="NSToolbar Configuration BrowserToolbarIdentifier-v4.6"
local -r SAFARI_TOOLBAR_CONFIG_DEFAULT_ITEMS_KEY="TB Default Item Identifiers"
local -r SAFARI_TOOLBAR_CONFIG_ITEMS_KEY="TB Item Identifiers"
local -r SAFARI_TOOLBAR_CONFIG_ITEMS_VALUE="(CombinedSidebarTabGroupToolbarIdentifier, SidebarSeparatorToolbarItemIdentifier, UnifiedTabBarToolbarIdentifier, NewTabToolbarIdentifier)"

for b in Safari SafariTechnologyPreview; do
	
	start_task "$b: set search engine"
	{ res_check "$RES" &&   catchout RES  libdefaults__set_str "com.apple.$b" SearchProviderShortName  DuckDuckGo     && RES_LIST+=("$RES") } # After  SearchProviderIdentifierMigratedToSystemPreference
	{ res_check "$RES" &&   catchout RES  libdefaults__set_str "com.apple.$b" SearchProviderIdentifier com.duckduckgo && RES_LIST+=("$RES") } # Before SearchProviderIdentifierMigratedToSystemPreference
	log_task_from_res_list RES_LIST
	
	start_task "$b: disable narrow tabs"
	catchout RES  libdefaults__set_bool "com.apple.$b" EnableNarrowTabs 0
	log_task_from_res "$RES"
	
	start_task "$b: show status bar"
	catchout RES  libdefaults__set_bool "com.apple.$b" ShowOverlayStatusBar 1
	log_task_from_res "$RES"
	
	start_task "$b: always show the tab bar"
	catchout RES  libdefaults__set_bool "com.apple.$b" AlwaysShowTabBar 1
	log_task_from_res "$RES"
	
done
