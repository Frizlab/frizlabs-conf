# Setup some defaults for the iPhone Simulator

start_task "iPhone Simulator: add user-defined key-equivalents"
catchout RES  libdefaults__set_plist com.apple.iphonesimulator NSUserKeyEquivalents "
	{
		\"Stay On Top\"     = \"@^t\";
		\"Slow Animations\" = \"@^s\";
	}
"
log_task_from_res "$RES"
