
#import <WebKit/WebKit.h>

@interface WebViewGM:NSObject <WKUIDelegate, WKNavigationDelegate>
{
}

@property(nonatomic, strong) WKWebView *webView;
@property(nonatomic, strong) UIImageView *imageView;

@end


