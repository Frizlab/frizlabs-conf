# Setup some defaults for the Character Picker

start_task "Character Picker: set the favorite characters"
# Note: We have left the Unicode escapes of the characters but we could definitely replace them with the actual characters (e.g. replace “\\U03a9” with “Ω”).
catchout RES  libdefaults__set_plist com.apple.CharacterPicker Favorites:com.apple.CharacterPicker.DefaultDataStorage "
	(
		\"com.apple.cpk:{\\\"char\\\":\\\"\\U03a9\\\"}\", /* Ω */
		\"com.apple.cpk:{\\\"char\\\":\\\"\\U0251\\\"}\", /* ɑ (lowercase alpha) */
		\"com.apple.cpk:{\\\"char\\\":\\\"\\U0130\\\"}\", /* İ */
		\"com.apple.cpk:{\\\"char\\\":\\\"\\U0131\\\"}\", /* ı */
		\"com.apple.cpk:{\\\"char\\\":\\\"\\U0219\\\"}\", /* ș */
		\"com.apple.cpk:{\\\"char\\\":\\\"\\U0103\\\"}\", /* ă */
		\"com.apple.cpk:{\\\"char\\\":\\\"\\U021b\\\"}\"  /* ț */
	)
"
log_task_from_res "$RES"
