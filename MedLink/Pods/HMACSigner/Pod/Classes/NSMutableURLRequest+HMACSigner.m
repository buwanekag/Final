//
//  NSMutableURLRequest+HMACSigner.m
//  Pods
//
//  Created by Martín Fernández on 12/19/14.
//
//

#import "NSMutableURLRequest+HMACSigner.h"

#import "NSDate+HTTP.h"
#import "NSString+Crypto.h"

@implementation NSMutableURLRequest (HMACSigner)

#pragma mark - Public API

- (void)signWithAccessIdentifier:(NSString *)accessIdentifier
                       andSecret:(NSString *)secret {

  [self setHMACHeaders];

  NSString *encryptedCanonicalString = [[self HMACCanonicalString] HMACSHA1WithSecret:secret];

  NSString *header = [NSString stringWithFormat:@"APIAuth %@:%@",accessIdentifier,encryptedCanonicalString];
  [self addValue:header forHTTPHeaderField:@"Authorization"];
}

#pragma mark - Private API

- (NSString *)uriString {

  BOOL hasQueryParams    = self.URL.query.length > 0;
  NSString *query        = hasQueryParams ? [NSString stringWithFormat:@"?%@", [self decodeURLString:self.URL.query]] : @"" ;

  NSString *relativePath = [self.URL relativePath];
  return [NSString stringWithFormat:@"%@%@",relativePath,query];
}

- (NSString *)contentType {
  return [self valueForHTTPHeaderField:@"Content-Type"];
}

- (NSString *)HTTPBodyString {
  return [[NSString alloc] initWithData:self.HTTPBody encoding:NSUTF8StringEncoding];
}

- (NSString *)HTTPBodyMD5 {
  return [[self HTTPBodyString] base64MD5];
}

- (NSString *)HMACCanonicalString {
  NSString *contentType = [self contentType];
  NSString *bodyMD5     = [self HTTPBodyMD5];
  NSString *uri         = [self uriString];
  NSString *httpDate    = [self valueForHTTPHeaderField:@"Date"];

  [self setValue:bodyMD5 forHTTPHeaderField:@"Content-MD5"];
  [self setValue:httpDate forHTTPHeaderField:@"Date"];

  return [NSString stringWithFormat:@"%@,%@,%@,%@",contentType,bodyMD5,uri,httpDate];
}

- (void)setHMACHeaders {
  NSString *bodyMD5     = [self HTTPBodyMD5];
  NSString *httpDate    = [self valueForHTTPHeaderField:@"Date"] ? [self valueForHTTPHeaderField:@"Date"] : [NSDate HTTPDateString];

  [self setValue:bodyMD5 forHTTPHeaderField:@"Content-MD5"];
  [self setValue:httpDate forHTTPHeaderField:@"Date"];
}

- (NSString*)decodeURLString:(NSString *)string
{
  return (__bridge NSString *) CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef) string, CFSTR(""), kCFStringEncodingUTF8);
}

@end
