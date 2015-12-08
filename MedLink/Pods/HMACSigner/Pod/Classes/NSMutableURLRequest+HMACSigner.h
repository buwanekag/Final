//
//  NSMutableURLRequest+HMACSigner.h
//  Pods
//
//  Created by Martín Fernández on 12/19/14.
//
//

#import <Foundation/Foundation.h>

@interface NSMutableURLRequest (HMACSigner)

/**
*  Signs the NSMutableURLRequest using HMAC + SHA1. Authorization Header and
*  Content-MD5 headers are added to the request.
*
*  @param accessIdentifier The identifier of the user
*  @param secret           The secret of the use
*/
- (void)signWithAccessIdentifier:(NSString *)accessIdentifier
                       andSecret:(NSString *)secret;

@end
