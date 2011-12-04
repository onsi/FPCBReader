#import "Reader.h"
#import "Reading.h"

@interface Reader ()

@property (nonatomic, retain, readwrite) DataManager *dataManager;
@property (nonatomic, retain, readwrite) Settings *settings;

@end

@implementation Reader

@synthesize
dataManager = dataManager_,
settings = settings_;

- (id)init {
    self = [super init];
    if (self) {
        self.dataManager = [[[DataManager alloc] init] autorelease];
    }
    
    return self;
}

- (void)dealloc {
    self.dataManager = nil;
    self.settings = nil;
    [super dealloc];
}

- (void)performSetUp {
    self.settings = [Settings settings];
    [Reading populateReadings];
}

- (NSString *)htmlFormatContent:(NSString *)content {
    NSString *css;
    if (self.settings.invert.boolValue) {
        css = [NSString stringWithFormat:@"<style type=\"text/css\">\nbody {\n	background-color:#fff;\n	color:#000;\n	font-family:Cochin; font-size:%fpt;\n}\n\na {\n	text-decoration:none;\n	color:#333;\n}\n\np {\n	margin-top:0.7em;\n	margin-bottom:0.7em;\n}\n\nh3 {\n	text-align: left;\n	margin-bottom:5px;\n}\n	\nspan.verse-num {\n	font-size: 70%%;\n	font-weight: bold;\n	margin-left: 0.5em;\n	margin-right: -0.2em;\n	vertical-align: text-top;\n	color:#333;\n}\n\nspan.chapter-num {\n	font-size: 70%%;\n	vertical-align: text-top;\n	font-weight: bold;\n	color:#333;\n}\n\nspan.woc {\n	color:  #900;\n}\n		\ndiv.esv-text p {\n	text-indent: 2em;\n}\n	\ndiv.esv-text p.same-paragraph {\n	text-indent: 0;\n}\n	\ndiv.block-indent p {\n	text-indent: 0;\n	padding-left: 2.5em;\n	margin-left: 0;\n}\n	\nspan.indent {\n	padding-left: 2em;\n}\n	\nspan.indent-2, span.psalm-doxology-line {\n	padding-left: 4em;\n}\n	\nspan.declares-line {\n	padding-left: 6em;\n}\n	\nspan.small-caps {\n	font-variant: small-caps;\n}\n	\nspan.selah {\n	font-style: italic;\n	margin-left: 1em;\n}\n\np.extra-space {\n	margin-top: 2em;\n}\n\ndiv.block-indent span.verse-num, div.block-indent span.woc  {\n	padding-left: 0;\n}\n\nh4 {\n	font-weight: normal;\n}\n\nh4.speaker {\n	padding-left: 10em;\n	font-variant: small-caps;\n	margin-bottom: -1em;\n}\n\nh4.textual-note {\n	font-variant: small-caps;	\n}\n\nh4.psalm-acrostic-title {\n	font-variant: small-caps;\n}\n\nh4.psalm-title {\n}\n\nspan.footnote {\n	font-size: 80%%;\n	padding-right: .5em;\n	padding-left: 0em;\n	vertical-align: text-top;\n}\n\ndiv.footnotes h3 {\n	margin-top: 0;\n	margin-bottom: 0;\n}\n\ndiv.footnotes p {\n	text-indent: 0;\n}\n\nspan.footnote-ref {\n	font-weight: bold;\n}\n\np.copyright {\n	text-indent: 0;\n}\n\nobject.audio {\n	margin: 0 0 0 10px;\n	padding: 0;\n}\n</style>", self.settings.fontSize.floatValue];
    } else {
        css = [NSString stringWithFormat:@"<style type=\"text/css\">\nbody {\n	background-color:#000;\n	color:#fff;\n	font-family:Cochin; font-size:%fpt;\n}\n\na {\n	text-decoration:none;\n	color:#ccc;\n}\n\np {\n	margin-top:0.7em;\n	margin-bottom:0.7em;\n}\n\nh3 {\n	text-align: left;\n	margin-bottom:5px;\n}\n	\nspan.verse-num {\n	font-size: 70%%;\n	font-weight: bold;\n	margin-left: 0.5em;\n	margin-right: -0.2em;\n	vertical-align: text-top;\n	color:#ccc;\n}\n\nspan.chapter-num {\n	font-size: 70%%;\n	vertical-align: text-top;\n	font-weight: bold;\n	color:#ccc;\n}\n\nspan.woc {\n	color: #f77;\n}\n		\ndiv.esv-text p {\n	text-indent: 2em;\n}\n	\ndiv.esv-text p.same-paragraph {\n	text-indent: 0;\n}\n	\ndiv.block-indent p {\n	text-indent: 0;\n	padding-left: 2.5em;\n	margin-left: 0;\n}\n	\nspan.indent {\n	padding-left: 2em;\n}\n	\nspan.indent-2, span.psalm-doxology-line {\n	padding-left: 4em;\n}\n	\nspan.declares-line {\n	padding-left: 6em;\n}\n	\nspan.small-caps {\n	font-variant: small-caps;\n}\n	\nspan.selah {\n	font-style: italic;\n	margin-left: 1em;\n}\n\np.extra-space {\n	margin-top: 2em;\n}\n\ndiv.block-indent span.verse-num, div.block-indent span.woc  {\n	padding-left: 0;\n}\n\nh4 {\n	font-weight: normal;\n}\n\nh4.speaker {\n	padding-left: 10em;\n	font-variant: small-caps;\n	margin-bottom: -1em;\n}\n\nh4.textual-note {\n	font-variant: small-caps;	\n}\n\nh4.psalm-acrostic-title {\n	font-variant: small-caps;\n}\n\nh4.psalm-title {\n}\n\nspan.footnote {\n	font-size: 80%%;\n	padding-right: .5em;\n	padding-left: 0em;\n	vertical-align: text-top;\n}\n\ndiv.footnotes h3 {\n	margin-top: 0;\n	margin-bottom: 0;\n}\n\ndiv.footnotes p {\n	text-indent: 0;\n}\n\nspan.footnote-ref {\n	font-weight: bold;\n}\n\np.copyright {\n	text-indent: 0;\n}\n\nobject.audio {\n	margin: 0 0 0 10px;\n	padding: 0;\n}\n</style>", self.settings.fontSize.floatValue];        
    }
    
    return [NSString stringWithFormat:@"<html><head>%@</head><body>%@</body></html>", css, content];
}

- (NSString *)preview {
    return [self htmlFormatContent:@"<div class='esv'><h2>Genesis 1:1-3</h2>\n<div class='esv-text'><h3 id='p01001001.01-1'>The Creation of the World</h3>\n<p class='chapter-first' id='p01001001.06-1'><span class='chapter-num' id='v01001001-1'>1:1&nbsp;</span>In the beginning, God created the heavens and the earth. <span class='verse-num' id='v01001002-1'>2&nbsp;</span>The earth was without form and void, and darkness was over the face of the deep. And the Spirit of God was hovering over the face of the waters.</p>\n <p id='p01001003.01-1'><span class='verse-num' id='v01001003-1'>3&nbsp;</span>And God said, &#8220;Let there be light,&#8221; and there was light.  (<a href='http://www.esv.org' class='copyright'>ESV</a>)</p>\n</div>\n</div>"];
}

- (UIColor *)backgroundColor {
    return self.settings.invert.boolValue ? [UIColor whiteColor] : [UIColor blackColor];
}

- (UIColor *)textColor {
    return self.settings.invert.boolValue ? [UIColor blackColor] : [UIColor whiteColor];
}


@end
