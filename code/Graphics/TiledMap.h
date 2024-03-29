//
//  TileMap.h
//  BlockBlaster
//
//  Created by Robert Backman on 05/04/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDXML.h"
#import "SpriteSheet.h"
#import "TileSet.h"
#import "Layer.h"
#import "Director.h"

// This class will parse the tmx file from the tiled tool available on http://mapeditor.org
// 
// The default output embeds the image into the confguration XML file in base64 and gzipped.  This
// current implementation does not support that output and the preferences of the application need
// to be changed so that the file contains just plain text.  I'll get around to adding support for
// this at some point :o)
//
// This class is used to read the XML output from Tiled.  It can handle multiple layers,
// tilesets and properties on each of these. 
//
// This class uses the KissXML libxml2 wrapper to process XML on the iPhone.  It is quick but very large 
// tilemaps can take some time to process.  A double layer 10,000 tile map takes approx 5 seconds.
//
//
@interface TiledMap : NSObject {

	// Sharte game state instance
	Director *sharedDirector;
	// The width of the map in tiles
	GLuint mapWidth;
	// The height of the map in tiles
	GLuint mapHeight;
	// The width of a tile
	GLuint tileWidth;
	// The height of a tile
	GLuint tileHeight;
	// Current TileSet ID
	GLuint currentTileSetID;
	// Current TileSet Instance
	TileSet *currentTileSet;
	// Current Layer ID
	GLuint currentLayerID;
	// Current Layer instance
	Layer *currentLayer;
    // Tilemap colour filter
    Color4f colourFilter;
	// Array of TileSets in this map
	NSMutableArray *tileSets;
	// Array of Layers in this map
	NSMutableArray *layers;
	// Properties
	NSMutableDictionary *mapProperties;
	NSMutableDictionary *tileSetProperties;

	// ivars needed for tilesets while processing the map file
	NSString *tileSetName;
	int tileSetID;
	int tileSetWidth;
	int tileSetHeight;
	int tileSetFirstGID;
	int tileSetSpacing;
	
	// ivars needed for layers/tiles while processing the map file
	NSString *layerName;
	int layerID;
	int layerWidth;
	int layerHeight;
	int tileX;
	int tileY;
	
	// Array used to store texture and vertices info for rendering
	TileVert *tileVerts;
}

@property (nonatomic, readonly) NSMutableArray *tileSets;
@property (nonatomic, readonly) NSMutableArray *layers;
@property (nonatomic, readonly) GLuint mapWidth;
@property (nonatomic, readonly) GLuint mapHeight;
@property (nonatomic, readonly) GLuint tileWidth;
@property (nonatomic, readonly) GLuint tileHeight;

// Designated selector that loads the tile map details from the supplied file name and extension
- (id)initWithTiledFile:(NSString*)aTiledFile fileExtension:(NSString*)aFileExtension;

// Returns the tileset which contains a tile image with the |aGlobalID| which is passed in
- (TileSet*)findTileSetWithGlobalID:(int)aGlobalID;

// Renders a section of the tile map to a specific location on the screen.  A CGPoint is provided 
// that tells the class where to render the map from and then details of the X and Y location within
// the tile map from where the rendering should start is provided along with how many tiles wide and high
// should be rendered.  Also enables a specific layer within the tile map to be rendered and for
// blending to be turned off to improve performance
- (void)renderAtPoint:(CGPoint)aRenderPoint mapX:(int)aMapTileX mapY:(int)aMapTileY width:(int)aTilesWide height:(int)aTilesHigh layer:(int)aLayerID useBlending:(bool)aUseBlending;

// Returns the layer ID which belongs to the layer whose name matches the |aName| provided
- (int)getLayerIndexWithName:(NSString*)aLayerName;

// Returns the string value for a map property which matches |aKey|.  It also takes a default
// value which is used if no matching key can be found
- (NSString*)getMapPropertyForKey:(NSString*)aKey defaultValue:(NSString*)aDefaultValue;

// Returns the string value for a layer property on the specified layer |aLayerID| with the specified
// |aKey|.  If not match for the key is found then |aDefaultValue| is returned
- (NSString*)getLayerPropertyForKey:(NSString*)aKey layerID:(int)aLayerID defaultValue:(NSString*)aDefaultValue;

// Returns the string value for a tile property on the specified |aGlobalTileID| with the key |aKey|.
// If no match is found for the key then |aDefaultValue| is returned
- (NSString*)getTilePropertyForGlobalTileID:(int)aGlobalTileID key:(NSString*)aKey defaultValue:(NSString*)aDefaultValue;

@end
