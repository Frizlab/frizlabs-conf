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
	
	start_task "use compact tab layout ($b)"
	{ res_check "$RES" &&   catchout RES  libdefaults__set_bool  "com.apple.$b" ShowStandaloneTabBar 0                                                                                                                                                                                                                 && RES_LIST+=("$RES") }
	{ res_check "$RES" &&   catchout RES  libdefaults__set_plist "com.apple.$b" "$SAFARI_TOOLBAR_ITEMS_KEY"                                             "$SAFARI_TOOLBAR_CONFIG_ITEMS_VALUE"                                                                                                                           && RES_LIST+=("$RES") } # Might be useless
	{ res_check "$RES" &&   catchout RES  libdefaults__add_dict  "com.apple.$b" "$SAFARI_TOOLBAR_CONFIG_DEFAULT_KEY" "$SAFARI_TOOLBAR_CONFIG_ITEMS_KEY" "$SAFARI_TOOLBAR_CONFIG_ITEMS_VALUE"                                                                                                                           && RES_LIST+=("$RES") }
	{ res_check "$RES" && { catchout RES  run_and_log_keep_stdout ./lib/update-safari-default-toolbar-for-compact-tab-layout.swift "com.apple.$b" "$SAFARI_TOOLBAR_CONFIG_DEFAULT_KEY" || log_task_failure "error while running update-safari-default-toolbar-for-compact-tab-layout (do you have Xcode installed?)" } && RES_LIST+=("$RES") } # Might be useless
	log_task_from_res_list RES_LIST
	
done
