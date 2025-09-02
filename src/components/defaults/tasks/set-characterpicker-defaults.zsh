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
		\"com.apple.cpk:{\\\"char\\\":\\\"\\U021b\\\"}\", /* ț */
		\"com.apple.cpk:{\\\"char\\\":\\\"\\U03bc\\\"}\", /* μ (lowercase mu, official abbreviation for “micro-”). Not to be confused with µ (U+00B5), which is the legacy codepoint for the same thing. See <https://en.wikipedia.org/wiki/Micro->. */
		\"com.apple.cpk:{\\\"char\\\":\\\"→\\\"}\",       /* Sub-section MARK prefix in Xcode. Also quite simply the best right arrow there is. */
		\"com.apple.cpk:{\\\"char\\\":\\\"×\\\"}\",       /* The multiplication sign. */
		\"com.apple.cpk:{\\\"char\\\":\\\"₋\\\"}\",       /* Separator for the “gender me”    group of XibLoc. */
		\"com.apple.cpk:{\\\"char\\\":\\\"¦\\\"}\",       /* Separator for the “gender other” group of XibLoc. */
		\"com.apple.cpk:{\\\"char\\\":\\\"↔\\\"}\",       /* Best left and right arrow, sometimes used in filenames in my projects. */
		\"com.apple.cpk:{\\\"char\\\":\\\"←\\\"}\",       /* Best left arrow. */
		\"com.apple.cpk:{\\\"char\\\":\\\"↑\\\"}\",       /* Best up   arrow. */
		\"com.apple.cpk:{\\\"char\\\":\\\"↓\\\"}\",       /* Best down arrow. */
		\"com.apple.cpk:{\\\"char\\\":\\\"𝓕\\\"}\",       /* My brand, kind of :) */
		\"com.apple.cpk:{\\\"char\\\":\\\"№\\\"}\",       /* Abbreviation for number (in French mostly AFAIK). */
		\"com.apple.cpk:{\\\"char\\\":\\\"⍼\\\"}\"        /* Right angle with downwards zigzag arrow. See <https://ionathan.ch/2022/04/09/angzarr.html>. */
	)
"
log_task_from_res "$RES"
