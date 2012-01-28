#import "Reader.h"
#import "Reading.h"
#import "CachedPassage.h"

extern NSString *SECRET_KEY;

@interface Reader ()

@property (nonatomic, retain, readwrite) DataManager *dataManager;
@property (nonatomic, retain, readwrite) Settings *settings;

- (NSString *)css;

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
    [CachedPassage clearAllCachedPassages];
}

- (NSString *)baseURL {
    return [NSString stringWithFormat:@"http://www.esvapi.org/v2/rest/passageQuery?key=%@&include-footnotes=false&include-audio-link=false", SECRET_KEY];
}

- (NSString *)javascriptToUpdateStyling {
    NSMutableArray *strings = [NSMutableArray array];
    [strings addObject:[NSString stringWithFormat:@"var css = \"%@\"", self.css]];
    [strings addObject:@"var scrollFraction = window.scrollY / document.height;"];
    [strings addObject:@"var styleNode = document.styleSheets[0].ownerNode"];
    [strings addObject:@"var parentNode = styleNode.parentNode;"];
    [strings addObject:@"parentNode.removeChild(styleNode);"];
    [strings addObject:@"styleNode = document.createElement('style');"];
    [strings addObject:@"styleNode.innerHTML = css;"];
    [strings addObject:@"parentNode.appendChild(styleNode);"];
    [strings addObject:@"window.scrollTo(0, scrollFraction * document.height);"];
    
    return [strings componentsJoinedByString:@"\n"];
}

- (NSString *)css {
    if (self.settings.invert.boolValue) {
        return [NSString stringWithFormat:@"body{background-color:#fff;color:#000;font-family:Cochin;font-size:%fpt;}a{text-decoration:none;color:#333;}p{margin-top:0.7em;margin-bottom:0.7em;}h3{text-align:left;margin-bottom:5px;}span.verse-num{font-size:70%%;font-weight:bold;margin-left:0.5em;margin-right:-0.2em;vertical-align:text-top;color:#333;}span.chapter-num{font-size:70%%;vertical-align:text-top;font-weight:bold;color:#333;}span.woc{color:#900;}div.esv-text p{text-indent:2em;}div.esv-text p.same-paragraph{text-indent:0;}div.block-indent p{text-indent:0;padding-left:2.5em;margin-left:0;}span.indent{padding-left:2em;}span.indent-2,span.psalm-doxology-line{padding-left:4em;}span.declares-line{padding-left:6em;}span.small-caps{font-variant:small-caps;}span.selah{font-style:italic;margin-left:1em;}p.extra-space{margin-top:2em;}div.block-indent span.verse-num,div.block-indent span.woc{padding-left:0;}h4{font-weight:normal;}h4.speaker{padding-left:10em;font-variant:small-caps;margin-bottom:-1em;}h4.textual-note{font-variant:small-caps;}h4.psalm-acrostic-title{font-variant:small-caps;}h4.psalm-title{}span.footnote{font-size:80%%;padding-right:.5em;padding-left:0em;vertical-align:text-top;}div.footnotes h3{margin-top:0;margin-bottom:0;}div.footnotes p{text-indent:0;}span.footnote-ref{font-weight:bold;}p.copyright{text-indent:0;}object.audio{margin:0 0 0 10px;padding:0;}", self.settings.fontSize.floatValue];
    } else {
        return [NSString stringWithFormat:@"body{background-color:#000;color:#fff;font-family:Cochin;font-size:%fpt;}a{text-decoration:none;color:#ccc;}p{margin-top:0.7em;margin-bottom:0.7em;}h3{text-align:left;margin-bottom:5px;}span.verse-num{font-size:70%%;font-weight:bold;margin-left:0.5em;margin-right:-0.2em;vertical-align:text-top;color:#ccc;}span.chapter-num{font-size:70%%;vertical-align:text-top;font-weight:bold;color:#ccc;}span.woc{color:#f77;}div.esv-text p{text-indent:2em;}div.esv-text p.same-paragraph{text-indent:0;}div.block-indent p{text-indent:0;padding-left:2.5em;margin-left:0;}span.indent{padding-left:2em;}span.indent-2,span.psalm-doxology-line{padding-left:4em;}span.declares-line{padding-left:6em;}span.small-caps{font-variant:small-caps;}span.selah{font-style:italic;margin-left:1em;}p.extra-space{margin-top:2em;}div.block-indent span.verse-num,div.block-indent span.woc{padding-left:0;}h4{font-weight:normal;}h4.speaker{padding-left:10em;font-variant:small-caps;margin-bottom:-1em;}h4.textual-note{font-variant:small-caps;}h4.psalm-acrostic-title{font-variant:small-caps;}h4.psalm-title{}span.footnote{font-size:80%%;padding-right:.5em;padding-left:0em;vertical-align:text-top;}div.footnotes h3{margin-top:0;margin-bottom:0;}div.footnotes p{text-indent:0;}span.footnote-ref{font-weight:bold;}p.copyright{text-indent:0;}object.audio{margin:0 0 0 10px;padding:0;}", self.settings.fontSize.floatValue];        
    }
}

- (NSString *)htmlFormatContent:(NSString *)content {
    return [NSString stringWithFormat:@"<html><head><style type=\"text/css\">%@</style></head><body>%@</body></html>", self.css, content];
}

- (NSString *)preview {
    return [self htmlFormatContent:@"<div class='esv'><h2>Genesis 1:1-3</h2>\n<div class='esv-text'><h3 id='p01001001.01-1'>The Creation of the World</h3>\n<p class='chapter-first' id='p01001001.06-1'><span class='chapter-num' id='v01001001-1'>1:1&nbsp;</span>In the beginning, God created the heavens and the earth. <span class='verse-num' id='v01001002-1'>2&nbsp;</span>The earth was without form and void, and darkness was over the face of the deep. And the Spirit of God was hovering over the face of the waters.</p>\n <p id='p01001003.01-1'><span class='verse-num' id='v01001003-1'>3&nbsp;</span>And God said, &#8220;Let there be light,&#8221; and there was light.  (<a href='http://www.esv.org' class='copyright'>ESV</a>)</p>\n</div>\n</div><div>Scripture taken from The Holy Bible, English Standard Version. Copyright &copy;2001 by <a href=\"http://www.crosswaybibles.org\">Crossway Bibles</a>, a publishing ministry of Good News Publishers. Used by permission. All rights reserved. Text provided by the <a href=\"http://www.gnpcb.org/esv/share/services/\">Crossway Bibles Web Service</a>.</div>"];
}

- (UIColor *)backgroundColor {
    return self.settings.invert.boolValue ? [UIColor whiteColor] : [UIColor blackColor];
}

- (UIColor *)textColor {
    return self.settings.invert.boolValue ? [UIColor blackColor] : [UIColor whiteColor];
}

- (UIImage *)fontSizeImage {
    return [UIImage imageNamed:reader.settings.invert.boolValue ? @"font_size_white.png" : @"font_size_black.png"];
}

- (UIImage *)brightnessImage {
    return [UIImage imageNamed:reader.settings.invert.boolValue ? @"brightness_white.png" : @"brightness_black.png"];    
}

- (UIImage *)topGradient {
    return [UIImage imageNamed:reader.settings.invert.boolValue ? @"gradient_top_white.png" : @"gradient_top_black.png"];
}

- (UIImage *)bottomGradient {
    return [UIImage imageNamed:reader.settings.invert.boolValue ? @"gradient_bottom_white.png" : @"gradient_bottom_black.png"];
}

- (UIImage *)todayImage {
    return [UIImage imageNamed:reader.settings.invert.boolValue ? @"today_white.png" : @"today_black.png"];    
}


@end
