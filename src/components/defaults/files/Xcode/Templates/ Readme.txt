Some doc regarding Xcode templates:
  <https://aleahim.com/xcode-templates/>
  <https://www.raywenderlich.com/26582967-xcode-project-and-file-templates>
  <https://diamantidis.github.io/2019/07/21/xcode-custom-templates>

Also see /Applications/Xcode.app/Contents/Developer/Library/Xcode/Templates folder.


Possible Image values found:
	- An SF Symbol image. Will appear blue; don’t know if changing the color is possible, but probably not. Example:
		<key>SystemSymbolName</key>
		<string>building.columns</string>
	- The icon of a file type. The value can be either a UTI or a file extension. Example:
		<key>FileTypeIcon</key>
		<string>public.shell-script</string>
	- An image from a bundle. I did not find the list of the possible bundles, nor the list of images in the ones I found.
	Example:
		<key>BundleIdentifier</key>
		<string>com.apple.dt.IDEKit</string>
		<key>BundleImageName</key>
		<string>framework</string>


Some official doc related to the text templates:
	- <https://help.apple.com/xcode/mac/9.0/index.html?localePath=en.lproj#/devc8a500cb9>
	- <https://help.apple.com/xcode/mac/9.0/index.html?localePath=en.lproj#/dev7fe737ce0>
