# Setup some defaults for the Character Picker

start_task "Character Picker: set the favorite characters"
catchout RES  libdefaults__set_plist com.apple.CharacterPicker Favorites:com.apple.CharacterPicker.DefaultDataStorage "
	(
		\"com.apple.cpk:{\\\"char\\\":\\\"\\U03a9\\\"}\", /* Ω */
		\"com.apple.cpk:{\\\"char\\\":\\\"\\U0130\\\"}\", /* İ */
		\"com.apple.cpk:{\\\"char\\\":\\\"\\U0131\\\"}\", /* ı */
		\"com.apple.cpk:{\\\"char\\\":\\\"\\U0219\\\"}\", /* ș */
		\"com.apple.cpk:{\\\"char\\\":\\\"\\U0103\\\"}\", /* ă */
		\"com.apple.cpk:{\\\"char\\\":\\\"\\U021b\\\"}\"  /* ț */
	)
"
log_task_from_res "$RES"
