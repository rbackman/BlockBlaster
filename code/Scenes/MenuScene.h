//
//  MenuState.h
//  BlockBlaster
//
//  Created by Robert Backman on 31/05/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractScene.h"

@interface MenuScene : AbstractScene {
	
	NSMutableArray *menuEntities;
	Image *menuBackground;
    CGPoint _origin;

}

@end
