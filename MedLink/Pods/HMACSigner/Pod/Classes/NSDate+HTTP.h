//
//  NSDate+HTTP.h
//  Pods
//
//  Created by Martín Fernández on 12/19/14.
//
//

#import <Foundation/Foundation.h>

@interface NSDate (HTTP)

/**
 *  Generates a NSString with the representation of the
 *  HTTP format.
 *
 *  Example: 'Tue, 24 Jun 2014 20:04:02 GMT'
 *
 *  @return The string representation of the data.
 */
+ (NSString *)HTTPDateString;

@end
