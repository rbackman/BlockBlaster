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

enum{
	FILL_BLOCK=0,
	TOP_UP_BLOCK,
	TOP_DOWN_BLOCK,
	BOT_UP_BLOCK,
	BOT_DOWN_BLOCK
};
@interface wallBlock : AbstractEntity {
	int blockType;
	int blockID;
    int _tileWidth, _tileHeight;
	bool endBlock;
	Tri _tri;
	Rec _rec;
}

// Designated initializer which allows this actor to be placed on the tilemap using
// tilemap grid locations.
- (id)initWithLocation:(Vector2f)aLocation   type:(int)tp;
-(Vector2f)getSafePos:(Vector2f)loc;
@property (nonatomic)bool endBlock;

@end
