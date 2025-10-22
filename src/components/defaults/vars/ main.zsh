# Not -r because we modify this variable in the env specific vars file.
typeset -a DEFAULTS__XCODE_THEME_ACTIONS=(
	"mono"
)

# Not -r because we can modify this variable in the env specific vars file.
# Only useful when filter mode is whitelist.
typeset -a DEFAULTS__DARK_MODE_FOR_SAFARI_WHITELISTED_SITES=(
	"https://ipfs.io/ipfs/QmbpRxBZ5HDZDVRoeAU8xFYnoP4r5eGCxdkmfFW3JbA6mq/"
	"https://web.archive.org/web/20150908004746/https://developer.apple.com/library/mac/documentation/cocoa/conceptual/coredata/Articles/cdNSAttributes.html"
	"https://web.archive.org/web/20150922144626/https://developer.apple.com/library/mac/documentation/General/Conceptual/DevPedia-CocoaCore/KVO.html"
	"https://web.archive.org/web/20150922144639/https://developer.apple.com/library/mac/documentation/General/Conceptual/DevPedia-CocoaCore/KeyValueCoding.html"
	"https://www.itcodar.com/sql/sql-database-design-best-practice-addresses.html"
	"https://www.reddit.com/dev/api/oauth"
	
	"a.simplemdm.com"
	"academy.realm.io"
	"access.redhat.com"
	"admin.gandi.net"
	"admin.google.com"
	"airbnb.com"
	"akismet.com"
	"alexcharlton.co"
	"alexkutas.com"
	"allocine.fr"
	"alstudio.cz1.quickconnect.to"
	"amazon.fr"
	"ameli.fr"
	"andybargh.com"
	"andyibanez.com"
	"api.slack.com"
	"app.mailjet.com"
	"app.pagerduty.com"
	"app.pallet.com"
	"apple.github.io"
	"apple.stackexchange.com"
	"appleid.apple.com"
	"appsloveworld.com"
	"appstoreconnect.apple.com" # Thanks Apple for not supporting the Dark Mode you introduced…
	"ascii-code.com"
	"asciidoctor.org"
	"askubuntu.com"
	"auth0.com"
	"autoentrepreneur.urssaf.fr"
	"autoitscript.com"
	"baeldung.com"
	"bbs.archlinux.org"
	"betterprogramming.pub"
	"bigthink.com"
	"bionconsulting.com"
	"blog.6nok.org"
	"blog.canopas.com"
	"blog.cubieserver.de"
	"blog.gnoack.org"
	"blog.hobbyistsoftware.com"
	"blog.httpwatch.com"
	"blog.jooq.org"
	"blog.logrocket.com"
	"blog.ploeh.dk"
	"blog.rsisecurity.com"
	"blog.searce.com"
	"blog.waleedkhan.name"
	"blogs.microsoft.com"
	"brainyquote.com"
	"britishgeologicalsurvey.github.io"
	"bsonspec.org"
	"bugs.debian.org"
	"bugs.webkit.org"
	"build5nines.com"
	"business.paypal.com"
	"businessinsider.com"
	"cagankiraz.medium.com"
	"calendly.com"
	"calmcode.io"
	"carlosbecker.com"
	"cdimage.ubuntu.com"
	"cfspart.impots.gouv.fr"
	"chiark.greenend.org.uk"
	"cloud.google.com"
	"cloudflare.com"
	"cobeisfresh.com"
	"cocoacasts.com"
	"codeburst.io"
	"codeopinion.com"
	"community.cloudflare.com"
	"community.judo.app"
	"community.synology.com"
	"community.ui.com"
	"computerhistory.org"
	"console.cloud.google.com"
	"crockford.com"
	"crossover.com"
	"crossposter.masto.donte.com.br"
	"crt.sh"
	"css-tricks.com"
	"cuisine.journaldesfemmes.fr"
	"cyberciti.biz"
	"danielroelfs.com"
	"dash.teams.cloudflare.com"
	"dashboard.stripe.com"
	"database.guide"
	"datascience.stackexchange.com"
	"davemeehan.com"
	"dba.stackexchange.com"
	"dbadiaries.com"
	"dbohdan.com"
	"debian.org"
	"devbits.app"
	"developer.pagerduty.com"
	"developer.twitter.com"
	"developers.facebook.com"
	"devops.stackexchange.com"
	"devroom.io"
	"digitalocean.com"
	"discuss.hashicorp.com"
	"disk-decipher.app"
	"distro.ibiblio.org"
	"dmarcly.com"
	"docs.ansible.com"
	"docs.asciidoctor.org"
	"docs.cleverbridge.com"
	"docs.datomic.com"
	"docs.getutm.app"
	"docs.gitea.io"
	"docs.gitlab.com"
	"docs.k3s.io"
	"docs.opencv.org"
	"docs.oracle.com"
	"dsp.stackexchange.com"
	"easy-readers.ro"
	"eclecticlight.co"
	"econsulat.ro"
	"elastic.co"
	"elonmusk.today"
	"en.wikipedia.org"
	"en.wiktionary.org"
	"english.stackexchange.com"
	"epita-alumni.org"
	"epochconverter.com"
	"ericasadun.com"
	"esker.com"
	"eterna.com.au"
	"evian-tourisme.com"
	"explainextended.com"
	"fluxcd.io"
	"forum.affinity.serif.com"
	"forums.docker.com"
	"fr.babbel.com"
	"fr.wikipedia.org"
	"freedesktop.org"
	"fullstackml.com"
	"funet.fi"
	"furbo.org"
	"fusionauth.io"
	"galaxus.ch"
	"garysieling.com"
	"geekpeek.net"
	"girlsaskguys.com"
	"git-scm.com"
	"github.blog"
	"gitolite.com"
	"gitpay.me"
	"gksoft.com"
	"gnu.org"
	"goaskalice.columbia.edu"
	"golinuxcloud.com"
	"grabbyaliens.com"
	"graphql.org"
	"groups.google.com"
	"hackerfactor.com"
	"heckj.github.io"
	"help.sap.com"
	"howtogeek.com"
	"howtouselinux.com"
	"htmjs.dev"
	"httpwg.org"
	"hub.docker.com"
	"icann.org"
	"iknowwhatyoudownload.com"
	"ikyle.me"
	"imageoptim.com"
	"impots.gouv.fr"
	"infoq.com"
	"investopedia.com"
	"iosexample.com"
	"issuehunt.io"
	"iterm2.com"
	"itsolutionstuff.com"
	"jllnmercier.medium.com"
	"jobs.apple.com"
	"jobs.lever.co"
	"jwt.io"
	"kaggle.com"
	"kernel.org"
	"konradreiche.com"
	"kubernetes.io"
	"la-maison-bleue.fr"
	"lafibre.info"
	"learn.hashicorp.com"
	"learn.microsoft.com"
	"leboncoin.fr"
	"lickability.com"
	"lifehacker.com"
	"lingohub.com"
	"linkedin.com"
	"lists.w3.org"
	"lloydatkinson.net"
	"lmdb.tech"
	"loc.gov"
	"lucumr.pocoo.org"
	"macg.co"
	"mackungfu.org"
	"macports.org"
	"mail-archive.com"
	"maligned.transilien.com"
	"mamutuelle.mgen.fr"
	"man7.org"
	"marcosantadev.com"
	"marketplace.visualstudio.com"
	"martiancraft.com"
	"martinfowler.com"
	"mathstat.dal.ca"
	"matklad.github.io"
	"matteomanferdini.com"
	"medium.com"
	"metebalci.com"
	"mhash.sourceforge.net"
	"mon-compte.enedis.fr"
	"mongodb.com"
	"monip.org"
	"moovago.com"
	"mroi.github.io"
	"mxtoolbox.com"
	"my-json-server.typicode.com"
	"mynixos.com"
	"n-skvortsov-1997.github.io"
	"n8n.io"
	"nango.dev"
	"netspi.com"
	"news.ycombinator.com"
	"nginx.com"
	"nixos.org"
	"nixpacks.com"
	"nlpdemystified.org"
	"marchintosh.com"
	"matomo.org"
	"microsoft.com"
	"oauth.com"
	"oauth.net"
	"objc.io"
	"oilshell.org"
	"old.reddit.com"
	"oldlinux.org"
	"oleb.net"
	"one.dash.cloudflare.com"
	"openfolder.sh"
	"openid.net"
	"openldap.org"
	"openradar.appspot.com"
	"opensource.com"
	"openssl.org"
	"oreilly.com"
	"osintframework.com"
	"oss.issuehunt.io"
	"ottverse.com"
	"pagerduty.com"
	"parisaeroport.fr"
	"passkeys.directory"
	"passkeys.io"
	"paulbourke.net"
	"pbrown.me"
	"pdq.com"
	"people.skolelinux.org"
	"perfect.org"
	"piglei.com"
	"pioneli.com"
	"pkl-lang.org"
	"pointfree.co"
	"portal.azure.com"
	"postgis.net"
	"postgreshelp.com"
	"postgresonline.com"
	"postgresqltutorial.com"
	"powerdmarc.com"
	"predemande-permisdeconduire.ants.gouv.fr"
	"prestigere.gercop-extranet.com"
	"prieres-catholiques.net"
	"privatebin.info"
	"projecteuler.net"
	"proxie.app"
	"psql-tips.org"
	"pvdz.ee"
	"pyimagesearch.com"
	"pynative.com"
	"quickbirdstudios.com"
	"quillette.com"
	"quora.com"
	"qwerty.dev"
	"rapidapi.com"
	"raspberry-pi.developpez.com"
	"raspberrypi.stackexchange.com"
	"redis.io"
	"rerb-leblog.fr"
	"retrocomputing.stackexchange.com"
	"rfc.zeromq.org"
	"rfc-editor.org"
	"ruby-doc.org"
	"rutorrent.frostland.fr"
	"salesforce.stackexchange.com"
	"salon.com"
	"scriptingosx.com"
	"searx.be"
	"sebastiancarlos.medium.com"
	"security.stackexchange.com"
	"serverfault.com"
	"service-public.fr"
	"shafik.github.io"
	"showrss.info"
	"simpleromanian.com"
	"simplicityissota.substack.com"
	"social.msdn.microsoft.com"
	"social.technet.microsoft.com"
	"softwareengineering.stackexchange.com"
	"soundproofingguide.com"
	"specifications.freedesktop.org"
	"sqltutorial.org"
	"sslhow.com"
	"stripe.com"
	"sumologic.com"
	"superuser.com"
	"support.discord.com"
	"swiftleejobs.com"
	"swiftpackageregistry.com"
	"swiftui-lab.com"
	"systranbox.com"
	"szopa.medium.com"
	"tableflipapp.com"
	"talent.io"
	"tapas.io"
	"tech.olx.com"
	"techyourchance.com"
	"tecmint.com"
	"text.npr.org"
	"the-art-of-web.com"
	"thediscoblog.com"
	"thegeekstuff.com"
	"theguardian.com"
	"thehackernews.com"
	"themathdoctors.org"
	"theonion.com"
	"thinking.ajdecon.org"
	"thomasbandt.com"
	"thread.house"
	"timestamp-converter.com"
	"tinycorelinux.net"
	"toml.io"
	"tukaani.org"
	"unicode.org"
	"unix.stackexchange.com"
	"usebruno.com"
	"usernamegenerator.com"
	"v6.testmyipv6.com"
	"vadimbulavin.com"
	"vadimkravcenko.com"
	"validator.w3.org"
	"vaultproject.io"
	"vectordb.com"
	"vertabelo.com"
	"video.stackexchange.com"
	"vigneshwarar.substack.com"
	"vimeo.zendesk.com"
	"vin01.github.io"
	"vlang.io"
	"volt-app.com"
	"vorpus.org"
	"voscomptesenligne.labanquepostale.fr"
	"vsanthanam.com"
	"vultr.com"
	"w3.org"
	"w3schools.com"
	"webmasters.stackexchange.com"
	"wiki.archlinux.org"
	"wiki.csnu.org"
	"wiki.debian.org"
	"wiki.tinycorelinux.net"
	"www3.yggtorrent.wtf"
	"x0r.fr"
	"xdgbasedirectoryspecification.com"
	"xkcd.com"
	"yaml.org"
	"yaml-multiline.info"
	"yolken.net"
	"youperv.com"
	"zewo.io"
	"zompist.com"
	"zufallsheld.de"
)
# Not -r because we can modify this variable in the env specific vars file.
# Only useful when filter mode is blacklist.
typeset -a DEFAULTS__DARK_MODE_FOR_SAFARI_BLACKLISTED_SITES=(
	"https://chunqiuyiyu.github.io/xie/"
	
	"172.16.0.1"
	"localhost"
	
	"frostland.fr"
	
	"togever.co"
	"www.togever.co"
	"admin-frizlab.togever.co"
	"admin-frizlab2.togever.co"
	"admin-dev.togever.co"
	"admin-preprod.togever.co"
	"admin.togever.co"
	"api-frizlab.togever.co"
	"api-frizlab2.togever.co"
	"api-dev.togever.co"
	"api-preprod.togever.co"
	"api.togever.co"
	"app-frizlab.togever.co"
	"app-frizlab2.togever.co"
	"app-dev.togever.co"
	"app-preprod.togever.co"
	"app.togever.co"
	"login-frizlab.togever.co"
	"login-frizlab2.togever.co"
	"login-dev.togever.co"
	"login-preprod.togever.co"
	"login.togever.co"
	"pro-frizlab.togever.co"
	"pro-frizlab2.togever.co"
	"pro-dev.togever.co"
	"pro-preprod.togever.co"
	"pro.togever.co"
	
	"0x44.xyz" # Already dark; does not work
	"404media.co" # Already dark; does not work
	"512kb.club" # Already dynamic, but not detected as such
	"9gag.com"
	"aaronbos.dev" # Already dark
	"about.me"
	"accounts.panic.com"
	"accounts.sapphire.moe" # Already dark; does not work
	"adamtuttle.codes" # Already dynamic, but not detected as such
	"adventofcode.com" # Already dark; does not work
	"aidarwinawards.org" # Already dynamic, but not detected as such
	"ajmoon.com" # Already dark; does not work
	"aleksandrhovhannisyan.com" # Already dynamic, but not detected as such
	"altcha.org" # Already dynamic, but not detected as such
	"anasinorbi.ro"
	"anatolyzenkov.com" # Already dynamic, but not detected as such
	"andrewlock.net" # Already dark; does not work
	"andrews.substack.com" # Already dark; does not work
	"anti-captcha.com"
	"ants.gouv.fr" # Does not work
	"anvaka.github.io" # Already dark; does not work
	"app.amplitude.com" # Already dynamic, but not detected as such
	"app.bitrise.io" # Does not work
	"app.fastmail.com" # Already dynamic, but not detected as such
	"app.n26.com"
	"app.qonto.com" # Already dynamic, but not detected as such
	"app.slack.com" # Already dynamic, but not detected as such
	"app.tea.xyz" # Already dark; does not work
	"appartager.com"
	"apple.com"
	"apps.apple.com" # Already dynamic, but not detected as such
	"archive.org" # Does not work
	"arjun.md" # Already dynamic, but not detected as such
	"arstechnica.com" # Already dark, but not detected as such
	"arvinpoddar.com" # Already dark; does not work
	"ashgw.me" # Already dark
	"ashishb.net" # Already dark; does not work
	"askwwdc.com" # Already dynamic, but not detected as such
	"assure.ameli.fr"
	"auth.eversports.com"
	"auth.wiki" # Already dynamic, but not detected as such
	"auth0.com" # Already dynamic, but not detected as such
	"authors.apple.com"
	"autodiscover.mail.frostland.fr"
	"avanderlee.com" # Already dynamic, but not detected as such
	"aznude.com" # Already dark; does not work
	"babesrater.com" # Not dark, but auto-dark does not work (content images are darkened too)
	"batou.dev"
	"bauble.studio" # Already dynamic, but not detected as such
	"benji.dog" # Already dynamic, but not detected as such
	"beta.music.apple.com"
	"beta.you.com"
	"bienvenueaumontsaintmichel.com"
	"bienvenueaumontsaintmichel.fr"
	"billetreduc.com" # Already dynamic, but not detected as such
	"blackentropy.bearblog.dev" # Already dark; does not work
	"blaines-blog.com" # Already dark; does not work
	"blintzbase.com" # Already dynamic, but not detected as such
	"blog.freron.com" # Already dynamic, but not detected as such
	"blog.howardjohn.info" # Already dark; does not work
	"blog.jim-nielsen.com" # Already dark; does not work
	"blog.jonas.foo" # Already dark; does not work
	"blog.kagi.com" # Already dynamic, but not detected as such
	"blog.mggross.com" # Already dynamic, but not detected as such
	"blog.thenewoil.org" # Already dynamic, but not detected as such
	"blog.tomayac.com" # Already dark; does not work
	"blog.trl.sn"
	"book.swiftwasm.org" # Dynamic-ish; does not work
	"bradley.chatha.dev" # Already dark; does not work
	"brew.sh"
	"browser.kagi.com"
	"browserbench.org"
	"bsky.app" # Already dynamic, but not detected as such
	"buildsettingextractor.com" # Already dark; does not work
	"business.apple.com" # Does not work
	"buttondown.com" # Already dynamic, but not detected as such
	"bwplotka.dev" # Only has worst dark mode selector there is. The one that should not exist. You know, the binary one 🖕
	"calendar.google.com" # Already dynamic, but not detected as such
	"camanis.net"
	"campsite.com" # Already dynamic, but not detected as such
	"canva.com"
	"cborbook.com" # Already dynamic, but not detected as such
	"celebrityrater.com" # Does not work
	"cimgf.com" # Does not work
	"cinemaspathegaumont.com"
	"clipbook.app" # Already dark
	"cloud.livekit.io" # Already dark; does not work
	"cloudsquid.substack.com" # Already dark; makes it light
	"cnpnet.cnp.fr"
	"cocacola.fr"
	"code.visualstudio.com" # Already dynamic, but not detected as such
	"codepen.io" # Already dark; does not work
	"coffee.link" # Already dynamic, but not detected as such
	"coinbase.com" # Already dynamic, but not detected as such
	"community.letsencrypt.org" # Already dynamic, but not detected as such
	"connexion.numericable.fr"
	"contextch.at" # Already dynamic, but not detected as such
	"coppolaemilio.com" # Already dynamic, but not detected as such
	"coryetzkorn.com" # Already dynamic, but not detected as such
	"crablang.org" # Already dark
	"cruzgodar.com" # Already dynamic, but not detected as such
	"cs3110.github.io" # Already dynamic, but not detected as such
	"css-tricks.com"
	"csscolorize.com" # Does not work
	"cuntempire.com" # Does not work
	"customers.securitasdirect.fr" # Already dynamic, but not detected as such
	"daily.dev" # Already dark; does not work
	"daiz.moe" # Already dark; does not work
	"daringfireball.net"
	"dash.cloudflare.com"
	"dashboard.nativeconnect.app"
	"dashboard.twitch.tv" # Already dark
	"data-star.dev" # Already dark; does not work
	"datatracker.ietf.org" # Already dynamic, but not detected as such
	"david.guillot.me" # Already dark; does not work
	"demian.ferrei.ro" # Already dynamic, but not detected as such
	"denodell.com" # Already dynamic, but not detected as such
	"denudeart.com" # Does not work
	"departmentmap.store"
	"designcode.io" # Already dynamic, but not detected as such
	"devblogs.microsoft.com" # Retarded on-off switch for dark mode w/o automatic switching
	"developer.apple.com"
	"developer.okta.com" # Dynamic-ish; does not work
	"developers.cloudflare.com"
	"deviantart.com"
	"dgerrells.com" # Already dark; does not work
	"discord.com"
	"discordapp.com"
	"disneyplus.com"
	"dlo.me" # Already dark; does not work
	"docs.brew.sh"
	"docs.directus.io" # Dynamic-ish; does not work
	"docs.docker.com"
	"docs.duendesoftware.com" # Already dynamic, but not detected as such
	"docs.github.com" # Already dynamic, but not detected as such
	"docs.huly.io" # Already dynamic (kind of), but not detected as such
	"docs.k3s.io" # Already dynamic, but not detected as such
	"docs.page" # Already dark; does not work
	"docs.python.org" # Already dynamic, but not detected as such
	"docs.swift.org" # Already dynamic, but not detected as such
	"draves.org"
	"drive.google.com" # Already dynamic, but not detected as such
	"duckduckgo.com"
	"dudzik.co" # Already dark; does not work
	"duriansoftware.com"
	"dz4k.com" # Already dark; does not work
	"efe.me" # Already dark; does not work
	"eisfunke.com" # Already dark
	"electricsheep.org"
	"enterprisedb.com" # Mostly dark; does not work
	"eporner.com" # Already dark
	"erome.com" # Already dark; does not work
	"espace-assure.gmf.fr"
	"espace-republique.fr"
	"etherscan.io" # Already dynamic, but not detected as such
	"eversports.fr"
	"everytimezone.com"
	"extranet.d-max.fr" # Already dark; does not work
	"facebook.com"
	"facegram.co.za" # Does not work
	"fanvue.com" # Already dynamic, but not detected as such
	"faphouse.com" # Already dynamic (when forced to), but not detected as such
	"fastcall.dev" # Already dark; does not work
	"fastvideoindexer.com"
	"fatbobman.com" # Already dynamic, but not detected as such
	"feathericons.com"
	"figma.com" # Does not work
	"fikfap.com" # Already dark
	"filen.io" # Already dark; does not work
	"fingerprint.goldenowl.ai" # Already dark; does not work
	"finnvoorhees.com" # Already dynamic, but not detected as such
	"fivestars.blog" # Already dynamic, but not detected as such
	"fluence.network" # Already dark
	"foon.uk" # Already dynamic, but not detected as such
	"formulae.brew.sh"
	"forums.macrumors.com"
	"forums.swift.org"
	"fossa.com" # Already dark; does not work
	"frizlab.github.io" # Already dynamic, but not detected as such
	"fuckingswiftui.com"
	"fuckupmysite.com" # Already dark; does not work
	"fuma-nama.vercel.app" # Already dark; does not work
	"fusionauth.io" # Already dynamic, but not detected as such
	"furyroom.fr"
	"gamesbymason.com" # Already dark; does not work
	"geoff.greer.fm" # Already dynamic, but not detected as such
	"geoguessr.com" # Already dark; does not work
	"getwhisky.app" # Already dynamic, but not detected as such
	"ghuntley.com" # Already dynamic, but not detected as such
	"gist.github.com"
	"github.blog" # Already dark; does not work
	"github.com"
	"gitlab.com"
	"gizvault.com" # Already dark; does not work
	"gleam.run" # Does not work
	"glfmn.io" # Already dynamic, but not detected as such
	"gmf.fr"
	"gog.com" # Already dynamic, but not detected as such
	"greptile.com" # Already dynamic, but not detected as such
	"h4x0r.org" # Already dark
	"hackaday.com" # Already dark; does not work
	"happn.app" # Already dark; does not work
	"happn.com"
	"hardbreak.wiki" # Already dynamic, but not detected as such
	"help.kagi.com" # Already dark
	"help.steampowered.com"
	"hi-way.io"
	"hiandrewquinn.github.io" # Already dynamic, but not detected as such
	"hitchdev.com" # Already dark; does not work
	"home.vollink.com"
	"homepages.cwi.nl"
	"honeypot.net" # Already dynamic, but not detected as such
	"hotels.le-mont-saint-michel.com"
	"hotnessrater.com" # Does not work
	"how-did-i-get-here.net" # Already dark; does not work
	"html.spec.whatwg.org" # Already dynamic, but not detected as such
	"htmx.org" # Already dynamic, but not detected as such
	"huly.io" # Already dark, but not detected as such
	"huly.togever.co" # Already dynamic, but not detected as such
	"hulylabs.com" # Already dynamic, but not detected as such
	"hurl.wtf" # Does not work (and already dark)
	"hypermedia.systems" # Already dynamic, but not detected as such
	"ianthehenry.com" # Already dynamic, but not detected as such
	"ibm.com" # Already dynamic, but not detected as such
	"icloud.com"
	"icloud.developer.apple.com"
	"idonthavespotify.sjdonado.com" # Already dark; does not work
	"igen.fr" # Already dynamic, but not detected as such
	"ikea.com"
	"ilmarilauhakangas.fi"
	"inotherwords.app" # Does not work
	"imagemagick.org" # Already dynamic, but not detected as such
	"imaglr.com" # Already dark; does not work
	"imdb.com"
	"inessential.com" # Already dynamic, but not detected as such
	"informatiiconsulare.ro"
	"inspect.new" # Already dark; does not work
	"interieur.gouv.fr" # Already dynamic, but not detected as such
	"jadarma.github.io" # Already dynamic, but not detected as such
	"janet.guide" # Already dynamic, but not detected as such
	"jegeremacartenavigo.fr"
	"jola.dev" # Already dark; does not work
	"jonifen.co.uk" # Already dark; does not work
	"joshtumath.uk" # Already dynamic, but not detected as such
	"joshwcomeau.com" # Dynamic-ish; does not work
	"jpcamara.com" # Already dynamic, but not detected as such
	"jprx.io" # Already dark; does not work
	"js1024.fun" # Already dark; does not work
	"jwt.io" # Already dynamic, but not detected as such
	"k0sproject.io" # Already dark; does not work
	"kagi.com"
	"kaveland.no" # Already dark; does not work
	"keith.github.io" # Already dynamic, but not detected as such
	"kennethnym.com" # Already dynamic, but not detected as such
	"kibty.town" # Already dark; does not work
	"kimcartoon.li" # Already dark
	"kodeco.com" # Already dynamic, but not detected as such
	"kubamartin.com" # Already dark; does not work
	"lapcatsoftware.com"
	"le-mont-saint-michel.com"
	"learn.microsoft.com" # Does not work
	"leetcode.com"
	"lg.com"
	"lgug2z.com" # Already dark, but not detected as such
	"libera.chat" # Already dynamic, but not detected as such
	"lidentitenumerique.laposte.fr"
	"linear.app"
	"linuxize.com" # Already dynamic, but not detected as such
	"livsycode.com" # Already dark; does not work
	"lmnt.me" # Already dark; does not work
	"login-frizlab.togever.co"
	"loneliness.one"
	"lookaway.app" # Already dark; does not work
	"louvre.fr"
	"m365.cloud.microsoft" # Already dynamic, but not detected as such
	"macg.co" # Already dynamic, but not detected as such
	"maciejwalkowiak.com" # Already dynamic, but not detected as such
	"macintoshgarden.org"
	"macintoshrepository.org"
	"macos9lives.com"
	"macrumors.com" # Already dynamic, but not detected as such
	"macstories.net" # Already dynamic, but not detected as such
	"madamevoyeur.com"
	"maml.dev" # Already dynamic, but not detected as such
	"mariahealthandbeauty.mynuskin.com"
	"martinheinz.dev" # Already dark; does not work
	"meatfighter.com" # Already dark
	"mega.nz" # Already dynamic, but not detected as such
	"messenger.com" # Already dynamic, but not detected as such
	"milovana.com" # Already dark
	"mindbodyonline.com"
	"mint-energie.com" # Does not work
	"minus-ze.ro" # Already dynamic, but not detected as such
	"mlumiste.com" # Already dark; does not work
	"mobile.twitter.com"
	"moncompte.numericable.fr"
	"moncompte.sncf.com"
	"mondossiernotaire.fr"
	"mongodb.com" # Already dynamic, but not detected as such
	"mozilla.github.io" # Already dark
	"msha.ke"
	"mxb.dev" # Already dynamic, but not detected as such
	"my.ionos.fr"
	"n0rdy.foo" # Already dark; does not work
	"nativeconnect.app"
	"netnewswire.com"
	"nav.al" # Already dynamic, but not detected as such
	"nextcomputers.org"
	"nextstep33.info"
	"nightwater.email" # Already dark; does not work
	"nitric.io" # Already dark
	"nodegram.org" # Already dark; does not work
	"nodejs.org" # Already dynamic, but not detected as such
	"noob-tv.com"
	"nopeforge.org" # Already dark
	"notes.ghed.in" # Already dynamic, but not detected as such
	"notion.so" # Already dynamic, but not detected as such
	"nsdateformatter.com"
	"nshipster.com" # Already dynamic, but not detected as such
	"nullpt.rs" # Already dark; does not work
	"nuskin.com"
	"obdev.at" # Already dark; does not work
	"obrhubr.org" # Already dynamic, but not detected as such
	"oci.dag.dev" # Already dynamic, but not detected as such
	"ohanaware.com"
	"one.dash.cloudflare.com" # Already dynamic, but not detected as such
	"onedrive.live.com" # Already dynamic, but not detected as such
	"openai.com" # Already dynamic, but not detected as such
	"opensource.apple.com" # Already dynamic, but not detected as such
	"optimizedbyotto.com" # Already dark; does not work
	"oui.sncf"
	"ounapuu.ee" # Already dark
	"outlook.office.com" # Already dynamic, but not detected as such
	"ouverture-pas-facile.fr" # Does not work
	"oxyd.games"
	"packaging.python.org"
	"pangeasoft.net" # Already dark
	"parametric.press"
	"pauladamsmith.com" # Does not work
	"paulefou.com" # Already dark; does not work
	"paulsmith.github.io" # Already dark; does not work
	"pavillonwagram.com"
	"paypal.com"
	"peps.python.org" # Already dynamic, but not detected as such
	"pizzahut.fr"
	"pkg.go.dev" # Already dynamic, but not detected as such
	"pkg.spooky.click" # Already dark; does not work
	"plateforme-covid-idf.aphp.fr"
	"plausible.io" # Already dynamic, but not detected as such
	"podcasts.apple.com" # Already dynamic, but not detected as such
	"pointerpointer.com"
	"polpiella.dev" # Already dynamic, but not detected as such
	"porn-blog.xyz" # Already dark
	"pornbay.org" # Already dark
	"postgresql.org"
	"powerlanguage.co.uk"
	"predemande-permisdeconduire.ants.gouv.fr" # Already dynamic, but not detected as such
	"prepacode-enpc.fr"
	"primevideo.com"
	"psi3.ru" # Already dark; does not work
	"pwascore.com" # Has manual toggle (annoyingly)
	"pwy.io" # Already dark; does not work
	"quic.video" # Already dark
	"quora.com" # Does not work
	"raniseth.com" # Already dynamic, but not detected as such
	"react.dev" # Already dynamic, but not detected as such
	"receive-sms.com"
	"recyclebin.zip" # Already dark; does not work
	"reddit.com"
	"redditp.com"
	"regex101.com" # Already dynamic, but not detected as such
	"responsivepx.com"
	"rexporn.sex" # Dynamic-ish; does not work
	"rlimit.com"
	"rys.io" # Already dark; does not work
	"sailorhg.com"
	"saint-eugene.net" # Does not work
	"samueloph.dev" # Already dark
	"sandbox.cloudflare.com" # Already dynamic, but not detected as such
	"sapphire.moe" # Does not work
	"sashalakhman.com"
	"scottspence.com" # Already dynamic, but not detected as such
	"scrolldit.com"
	"seangoedecke.com" # Already dark; does not work
	"sectigo.com" # Does not work
	"secure.digiposte.fr"
	"selfservicerepair.com"
	"sepolia.app.tea.xyz" # Already dark; does not work
	"sha256algorithm.com"
	"sharesome.com" # Supports dark mode, though manually
	"simonsafar.com" # Already dark; does not work
	"simplewebserver.org" # Already dynamic, but not detected as such
	"sitepoint.com" # Already dynamic, but not detected as such
	"sixcolors.com" # Already dynamic, but not detected as such
	"sketch.com"
	"sncf.com"
	"sniffnet.net" # Already dark; does not work
	"soap2day.ac"
	"soundcloud.com"
	"soundhound.com"
	"sourceforge.net" # Does not work
	"stackoverflow.com"
	"steamcommunity.com"
	"steipete.me" # Already dynamic, but not detected as such
	"stephango.com" # Has manual dark mode, does not work when dark (autodetected on load)
	"stevedylandev.bearblog.dev" # Already dark; does not work
	"stocknear.com" # Does not work
	"store.serif.com"
	"store.steampowered.com"
	"studio.blender.org" # Does not work
	"sundayswift.com" # Already dynamic, but not detected as such
	"support.apple.com"
	"susam.github.io" # Already dark; does not work
	"swift.org"
	"swiftonserver.com" # Already dynamic, but not detected as such
	"swiftpackageindex.com"
	"swiftsenpai.com" # Already dynamic, but not detected as such
	"swifttoolkit.dev" # Already dynamic, but not detected as such
	"swiftwithmajid.com" # Already dark; does not work
	"swiftyplace.com" # Already dynamic, but not detected as such
	"taggart-tech.com" # Already dark; does not work
	"taimapp.io" # Already dark; does not work
	"taquin.net"
	"taylor.gl" # Already dark; turns to light
	"tc39.es" # Already dynamic, but not detected as such
	"tea.xyz" # Already dark; does not work
	"temporal.io" # Already dark; does not work
	"test.hozana.org"
	"theotokos.fr"
	"thetvdb.com"
	"thewatchcartoononline.tv"
	"theyseeyourphotos.com" # Already dark; does not work
	"ticketlouvre.fr"
	"tinyapps.org" # Already dynamic, but not detected as such
	"titledrops.net" # Already dark; does not work
	"tomscheers.github.io" # Already dark; does not work
	"torrentleech.org"
	"tour.gleam.run" # Already dark
	"tpl.house" # Already dark; does not work
	"trace.yshui.dev" # Already dark
	"trench.dev" # Already dark; does not work
	"try.constructor.dev"
	"tryghostship.dev" # Already dark; does not work
	"tucson-josh.com" # Already dark; does not work
	"tumblr.com"
	"tv.apple.com"
	"tvtime.com"
	"twitch.tv" # Already dark
	"twitter.com"
	"typescriptlang.org" # Already dark; does not work
	"underpassapp.com" # Already dynamic, but not detected as such
	"userinyerface.com"
	"useworkflow.dev" # Already dynamic, but not detected as such
	"useyourloaf.com"
	"vale.rocks" # Already dynamic, but not detected as such
	"vapor.codes"
	"vibeinsecurity.com" # Already dark; does not work
	"vimeo.com"
	"vinay.sh" # Already dark; does not work
	"voscomptesenligne.labanquepostale.fr"
	"vuejs.org" # Already dynamic, but not detected as such
	"wannonce.com"
	"watchcartoononline.com"
	"web.archive.org"
	"webmail.imm.fr"
	"webmail.numericable.fr"
	"wheeloftime.fandom.com" # Already dark; does not work
	"wiki.torrentleech.org"
	"wildblue.digital"
	"winonx.com"
	"woob.tech"
	"ww3.yggtorrent.gg"
	"www.apple.com"
	"www.icloud.com"
	"www.tvtime.com"
	"www2.impots.gouv.fr"
	"www2.yggtorrent.ch"
	"www2.yggtorrent.gg"
	"www3.yggtorrent.nz"
	"www3.yggtorrent.pe"
	"www5.yggtorrent.la"
	"x.com" # Already dynamic, but not detected as such
	"xeiaso.net" # Already dynamic, but not detected as such
	"xn--gckvb8fzb.com" # Already dynamic, but not detected as such
	"xslt.rip" # Already dark; does not work
	"xstumbl.com" # Does not work
	"xvideos.com" # Has “automatic” switching that does not work, but sometimes we do get dark mode anyway…
	"yespark.fr"
	"yggtorrent.ch"
	"yggtorrent.gg"
	"yggtorrent.la"
	"yggtorrent.top" # Does not work
	"you.com"
	"zayenz.se" # Already dark; does not work
	"zazzle.com"
	"zazzle.fr"
	"zx2c4.com" # Already dark; does not work
)


# Sourcing env specific vars file.
test -f "./vars/$COMPUTER_GROUP.zsh" && source "./vars/$COMPUTER_GROUP.zsh" || true
