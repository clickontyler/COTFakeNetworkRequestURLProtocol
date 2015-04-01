//
//  COTFakeNetworkRequestURLProtocol.m
//

#import "COTFakeNetworkRequestURLProtocol.h"

@implementation COTFakeNetworkRequestURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    if(![[request.URL.host lowercaseString] containsString:@"your-server's-domain-name"]) {
        return NO;
    }

    NSData *data = [COTFakeNetworkRequestURLProtocol dataForRequest:request];
    return data ? YES : NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

+ (NSData *)dataForRequest:(NSURLRequest *)request
{
    NSArray *testData = [[NSArray alloc] initWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"TestNetworkData" ofType:@"plist"]];
    for(NSDictionary *dict in testData) {
        if([dict[@"path"] isEqualToString:request.URL.path]) {
            if([request.HTTPMethod isEqualToString:dict[@"method"]]) {
                NSString *response = dict[@"response"];
                return [response dataUsingEncoding:NSUTF8StringEncoding];
            }
        }
    }

    return nil;
}

- (void)startLoading
{
    NSDictionary *headers = nil; // or something like @{ @"Content-Type" : @"application/json" };
    
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[self request].URL statusCode:200 HTTPVersion:@"1.1" headerFields:headers];

    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    [[self client] URLProtocol:self didLoadData:[COTFakeNetworkRequestURLProtocol dataForRequest:[self request]]];
    [[self client] URLProtocolDidFinishLoading:self];
}

- (void)stopLoading
{
    
}

@end
