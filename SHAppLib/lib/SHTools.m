//
//  SHTools.m
//  SHAppLib
//
//  Created by Sovanna Hing on 28/10/2013.
//
//  Copyright (c) 2013, Sovanna Hing.
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//    * Redistributions of source code must retain the above copyright
//      notice, this list of conditions and the following disclaimer.
//    * Redistributions in binary form must reproduce the above copyright
//      notice, this list of conditions and the following disclaimer in the
//      documentation and/or other materials provided with the distribution.
//    * Neither the name of the <organization> nor the
//      names of its contributors may be used to endorse or promote products
//      derived from this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
//  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "SHTools.h"
#import "NSString+StringEncoding.h"

@implementation SHTools

#pragma mark - device

+ (BOOL)isIphone5
{
    UIScreen * __weak screen = [UIScreen mainScreen];
    if ([[self class] isIphone] &&
        screen.scale == 2.f &&
        screen.bounds.size.height == 568) {
        return YES;
    }
    return NO;
}

+ (BOOL)isIphone
{
    UIDevice * __weak device = [UIDevice currentDevice];
    return ([device userInterfaceIdiom] == UIUserInterfaceIdiomPhone);
}

+ (BOOL)isIpad
{
    UIDevice * __weak device = [UIDevice currentDevice];
    return ([device userInterfaceIdiom] == UIUserInterfaceIdiomPad);
}

+ (BOOL)isIOS7
{
    UIDevice * __weak device = [UIDevice currentDevice];
    int v = [[device systemVersion] intValue];
    return (v < 7 ? false : true);
}

#pragma mark - string

+ (NSString *)stringFromObject:(id)object
{
    return [NSString stringWithFormat:@"%@", object];
}

+ (NSString *)stringKeyValueFromDictionary:(NSDictionary *)dic
{
    NSMutableArray *tmp = [NSMutableArray array];
    for (id key in dic) {
        NSString *kv = [NSString stringWithFormat:@"%@=%@",
                        key, [dic objectForKey:key]];
        [tmp addObject:kv];
    }
    return [tmp componentsJoinedByString:@"&"];
}

+ (NSString *)stringEncodedParamsFromDictionary:(NSDictionary *)dic
{
    NSError * __autoreleasing error;
    NSData *data = [NSJSONSerialization
                    dataWithJSONObject:dic
                    options:NSJSONWritingPrettyPrinted
                    error:&error];
    if (!data) {
        [NSException raise:[error debugDescription]
                    format:@"Make sure that your json object is valid"];
    }
    
    NSString *string = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    return [string stringEncode];
}

#pragma mark - json

+ (NSDictionary *)jsonFromData:(id)data
{
    NSError * __autoreleasing error = nil;
    NSDictionary *json = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:NSJSONReadingMutableContainers
                          error:&error];
    if (json && [json isKindOfClass:[NSDictionary class]]) {
        return json;
    } else {
        Log(@"%@", [error localizedDescription]);
        [NSException raise:[error debugDescription] format:nil];
    }
    
    return nil;
}

@end
