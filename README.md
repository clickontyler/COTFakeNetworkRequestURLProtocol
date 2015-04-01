# COTFakeNetworkRequestURLProtocol
A extremely bare-bones, simple way to return fake network requests when running tests.

```
@interface YourTestClass : XCTestCase

@end

@implementation APIClientTests

- (void)setUp
{
    [super setUp];
    [NSURLProtocol registerClass:[COTFakeNetworkRequestURLProtocol class]];
}

- (void)tearDown
{
    [NSURLProtocol unregisterClass:[COTFakeNetworkRequestURLProtocol class]];
    [super tearDown];
}
```

Then just make your network requests as normal. They'll be routed through to your fake data stored in `TestNetworkData.plist`.
