//
//  Simple.m
//  ComputerMediaManger
//
//  Created by  on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Simple.h"

@implementation Simple

+ (void) sayGoodBye {
    NSLog(@"GoodBye...");
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void) dealloc {
    NSLog(@"deallocating Simple....");
    [super dealloc];
}

- (void) sayHello:(NSString *)name {
    NSMutableString *message = [[NSMutableString alloc] 
                                initWithString:@"Hello there "];
    [message appendString:name];
    
    NSLog(message);
    
    personName = [name retain];
    
    [message release];
}

- (void) sayName {
    NSLog(self->personName);
}

- (void) startPlay:(NSString *)title audienceMembers:(int)audienceValue supportingActor:(NSString *)actorValue extrasNeeded:(int)extrasValue{
    
    NSLog(@"Title: %@", title);
    NSLog(@"AudienceValue: %d", audienceValue);
    NSLog(@"Actor: %@", actorValue);
    NSLog(@"Extras: %d", extrasValue);
    
}
@end
