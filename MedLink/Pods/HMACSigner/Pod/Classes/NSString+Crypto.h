//
//  NSString+Base64MD5.h
//  Pods
//
//  Created by Martín Fernández on 12/19/14.
//
//

#import <Foundation/Foundation.h>

@interface NSString (Crypto)

/**
 *  Calculates the MD5 and encodes the result in base 64
 *
 *  @return The base64 MD5 NSString
 */
- (NSString *)base64MD5;

/**
 *  <#Description#>
 *
 *  @param secret <#secret description#>
 *
 *  @return <#return value description#>
 */
- (NSString *)HMACSHA1WithSecret:(NSString *)secret;

@end
