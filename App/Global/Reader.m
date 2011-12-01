#import "Reader.h"
#import "Reading.h"

@interface Reader ()

@property (nonatomic, retain, readwrite) DataManager *dataManager;

@end

@implementation Reader

@synthesize
    dataManager = dataManager_;

- (id)init {
    self = [super init];
    if (self) {
        self.dataManager = [[[DataManager alloc] init] autorelease];
    }
    
    return self;
}

- (void)dealloc {
    self.dataManager = nil;
    [super dealloc];
}

- (void)performSetUp {
    [Reading populateReadings];
}

- (NSString *)htmlFormatContent:(NSString *)content {
    NSString *css = @"<style type=\"text/css\">\nbody {\n	background-color:#000;\n	color:#fff;\n	font-family:Cochin;\n}\n\na {\n	text-decoration:none;\n	color:#ccc;\n}\n\np {\n	margin-top:0.7em;\n	margin-bottom:0.7em;\n}\n\nh2 {\n	display:none;\n}\n\nh3 {\n	text-align: left;\n	margin-bottom:5px;\n}\n	\nspan.verse-num {\n	font-size: 70%;\n	font-weight: bold;\n	margin-left: 0.5em;\n	margin-right: -0.2em;\n	vertical-align: text-top;\n	color:#ccc;\n}\n\nspan.chapter-num {\n	font-size: 70%;\n	vertical-align: text-top;\n	font-weight: bold;\n	color:#ccc;\n}\n\nspan.woc {\n	color: #f77;\n}\n		\ndiv.esv-text p {\n	text-indent: 2em;\n}\n	\ndiv.esv-text p.same-paragraph {\n	text-indent: 0;\n}\n	\ndiv.block-indent p {\n	text-indent: 0;\n	padding-left: 2.5em;\n	margin-left: 0;\n}\n	\nspan.indent {\n	padding-left: 2em;\n}\n	\nspan.indent-2, span.psalm-doxology-line {\n	padding-left: 4em;\n}\n	\nspan.declares-line {\n	padding-left: 6em;\n}\n	\nspan.small-caps {\n	font-variant: small-caps;\n}\n	\nspan.selah {\n	font-style: italic;\n	margin-left: 1em;\n}\n\np.extra-space {\n	margin-top: 2em;\n}\n\ndiv.block-indent span.verse-num, div.block-indent span.woc  {\n	padding-left: 0;\n}\n\nh4 {\n	font-weight: normal;\n}\n\nh4.speaker {\n	padding-left: 10em;\n	font-variant: small-caps;\n	margin-bottom: -1em;\n}\n\nh4.textual-note {\n	font-variant: small-caps;	\n}\n\nh4.psalm-acrostic-title {\n	font-variant: small-caps;\n}\n\nh4.psalm-title {\n}\n\nspan.footnote {\n	font-size: 80%;\n	padding-right: .5em;\n	padding-left: 0em;\n	vertical-align: text-top;\n}\n\ndiv.footnotes h3 {\n	margin-top: 0;\n	margin-bottom: 0;\n}\n\ndiv.footnotes p {\n	text-indent: 0;\n}\n\nspan.footnote-ref {\n	font-weight: bold;\n}\n\np.copyright {\n	text-indent: 0;\n}\n\nobject.audio {\n	margin: 0 0 0 10px;\n	padding: 0;\n}\n</style>";
    
    return [NSString stringWithFormat:@"<html><head>%@</head><body>%@</body></html>", css, content];
}

@end
