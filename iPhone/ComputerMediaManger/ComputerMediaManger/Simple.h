//
//  Simple.h
//  ComputerMediaManger
//
//  Created by  on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Simple : NSObject {
    NSString *personName;
}

+ (void) sayGoodBye;
- (void) sayHello: (NSString *) name;
- (void) sayName;
- (void) startPlay: (NSString *) title audienceMembers: (int) audienceValue supportingActor: (NSString *) actorValue extrasNeeded: (int) extrasValue;

@end
