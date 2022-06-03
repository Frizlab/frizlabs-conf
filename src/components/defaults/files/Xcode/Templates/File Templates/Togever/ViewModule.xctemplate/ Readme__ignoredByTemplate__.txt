Regarding the icon:
	- We used the shippingbox.fill SF Symbol to create it, which is clearly what Xcode uses for Swift packages;
	- We did _not_ use SystemSymbolName because the icon is blue when we do this.

Regarding the File Header, we do the same as Apple and prefix it w/ a //-style comment.
Ideally there should be no prefix at all, and the FILEHEADER variable should contain the comment itself.
We keep the comment prefix only because Apple has it in all of its templates.
