//
//  TileSet.m
//  BlockBlaster
//
//  Created by Robert Backman on 05/04/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//

#import "TileSet.h"


@implementation TileSet

@synthesize tileSetID;
@synthesize name;
@synthesize firstGID;
@synthesize lastGID;
@synthesize tileWidth;
@synthesize tileHeight;
@synthesize spacing;
@synthesize tiles;


- (id)initWithImageNamed:(NSString*)aImage name:(NSString*)aTileSetName tileSetID:(int)tsID firstGID:(int)aFirstGlobalID tileWidth:(int)aTileWidth tileHeight:(int)aTileHeight spacing:(int)aSpacing {
	if (self != nil) {
		tiles = [[SpriteSheet alloc] initWithImageNamed:aImage spriteWidth:aTileWidth spriteHeight:aTileHeight spacing:aSpacing imageScale:1.0f];
		tileSetID = tsID;
		name = aTileSetName;
		firstGID = aFirstGlobalID;
		horizontalTiles = [tiles horizontal];
		verticalTiles = [tiles vertical];
		lastGID = horizontalTiles * verticalTiles + firstGID - 1;
		tileWidth = aTileWidth;
		tileHeight = aTileHeight;
		spacing = aSpacing;
	}
	return self;
}


- (bool)containsGlobalID:(int)aGlobalID {
	// If the global ID which has been passed is within the global IDs in this
	// tileset then return YES
	return (aGlobalID >= firstGID) && (aGlobalID <= lastGID);
}


- (int)getTileX:(int)aTileID {
	return aTileID % horizontalTiles;
}


- (int)getTileY:(int)aTileID {
	return aTileID / horizontalTiles;
}


- (void)dealloc {
	[tiles release];
	[super dealloc];
}

@end
