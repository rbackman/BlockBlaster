//
//  main.m
//  BlockBlaster
//
//  Created by Robert Backman on 28/02/2009.
//  Copyright Robert Backman 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
    printf("app started\n");
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, @"BlockBlasterAppDelegate");
    [pool release];
    return retVal;
}
