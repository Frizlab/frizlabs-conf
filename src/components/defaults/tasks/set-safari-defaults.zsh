# Setup some defaults for Safari (and Safari Technology Preview)

local -r SAFARI_TOOLBAR_ITEMS_KEY="OrderedToolbarItemIdentifiers"
local -r SAFARI_TOOLBAR_CONFIG_DEFAULT_KEY="NSToolbar Configuration BrowserToolbarIdentifier-v4.6"
local -r SAFARI_TOOLBAR_CONFIG_DEFAULT_ITEMS_KEY="TB Default Item Identifiers"
local -r SAFARI_TOOLBAR_CONFIG_ITEMS_KEY="TB Item Identifiers"
local -r SAFARI_TOOLBAR_CONFIG_ITEMS_VALUE="(CombinedSidebarTabGroupToolbarIdentifier, SidebarSeparatorToolbarItemIdentifier, UnifiedTabBarToolbarIdentifier, NewTabToolbarIdentifier)"

for b in Safari SafariTechnologyPreview; do
	
	start_task "set search engine ($b)"
	{ res_check "$RES" &&   catchout RES  libdefaults__set_str "com.apple.$b" SearchProviderShortName  DuckDuckGo     && RES_LIST+=("$RES") } # After  SearchProviderIdentifierMigratedToSystemPreference
	{ res_check "$RES" &&   catchout RES  libdefaults__set_str "com.apple.$b" SearchProviderIdentifier com.duckduckgo && RES_LIST+=("$RES") } # Before SearchProviderIdentifierMigratedToSystemPreference
	log_task_from_res_list RES_LIST
	
	start_task "disable narrow tabs ($b)"
	catchout RES  libdefaults__set_bool "com.apple.$b" EnableNarrowTabs 0
	log_task_from_res "$RES"
	
	# We used to have a very complicated setup here where we tried and anticipate the changes to the toolbar that the show standalone tab bar setting entails.
	# However after some testing it seems changing this single key is enough, and the rest follows whenever it wants.
	start_task "use separate tab layout ($b)"
	catchout RES  libdefaults__set_bool "com.apple.$b" ShowStandaloneTabBar 1
	log_task_from_res "$RES"
	
done
