//
//  TSCLink+Youtube.m
//  ThunderCloud
//
//  Created by Joel Trew on 15/08/2017.
//  Copyright © 2017 threesidedcube. All rights reserved.
//

#import "TSCLink+Youtube.h"

@implementation TSCLink (Youtube)

- (NSString *)youtubeVideoId
{
    if (![self.linkClass isEqualToString:@"ExternalLink"] || !self.url.absoluteString || ![self.url.absoluteString containsString:@"youtube.com"]) {
        return nil;
    }
    
    NSURLComponents *components = [NSURLComponents componentsWithURL:self.url resolvingAgainstBaseURL:false];
    __block NSString *identifier;
    
    [components.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.name isEqualToString:@"v"] && obj.value) {
            identifier = obj.value;
            *stop = true;
        }
    }];
    
    return identifier;
}


@end
