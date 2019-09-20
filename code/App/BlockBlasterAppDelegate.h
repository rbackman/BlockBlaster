//
//  Tutorial1.h
//  BlockBlaster
//
//  Created by Robert Backman on 28/02/2009.
//  Copyright Robert Backman 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EAGLView;
@class Director;


@interface BlockBlasterAppDelegate : NSObject <UIApplicationDelegate> 
{
    UIWindow *window;
    EAGLView *glView;
	Director *director;
}
-(void)addTextField:(UITextField*)textField;
@end

