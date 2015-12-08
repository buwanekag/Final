//
//  NSDate+HTTP.m
//  Pods
//
//  Created by Martín Fernández on 12/19/14.
//
//

#import "NSDate+HTTP.h"

@implementation NSDate (HTTP)

+ (NSString *)HTTPDateString
{
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  formatter.dateFormat       = @"EEE, dd MMM yyyy HH:mm:ss z";
  formatter.timeZone         = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
  formatter.locale           = [NSLocale localeWithLocaleIdentifier:@"en_US"];

  return [formatter stringFromDate:[NSDate date]];
}

@end
