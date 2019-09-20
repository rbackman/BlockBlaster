//
//  Monk.h
//  Tutorial1
//
//  Created by Robert Backman on 22/06/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractEntity.h"

@class GameScene;
@class Token;

enum{
	EXPLOSIVE_BLOCK,
	INDESTRUCTABLE_BLOCK,
	COLOR_BLOCK,
};
@interface Block : AbstractEntity {

	SearchNode* searchNode;
	int blockType;
	int animationCount;

	bool rotating;
	bool animated;

	float explosionRadius;
}

// Designated initializer which allows this actor to be placed on the tilemap using
// tilemap grid locations.

- (id)initWithLocation:(Vector2f)aLocation ;

@property (nonatomic, assign) SearchNode* searchNode;


@property (nonatomic)int blockType;



@end
