//
//  main.m
//  ComputerMediaManger
//
//  Created by  on 12/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Simple.h"
int main(int argc, char *argv[])
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    [Simple sayGoodBye];
    
    Simple *simple = [[[Simple alloc] init] autorelease];
//    Simple *simple = [[Simple alloc] init];
    [simple sayHello:@"Marcin"];
    [simple sayName];
    [simple startPlay:@"Title" audienceMembers:10 supportingActor:@"Actor" extrasNeeded:40];
//    [simple release];
    [Simple sayGoodBye];
    
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;
}
