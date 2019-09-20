//
//  ResourceManager.h
//  BlockBlaster
//
//  Created by Robert Backman on 16/05/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SpriteSheet;
@class Texture2D;
@class AngelCodeFont;

// Class that is responsible for texture resources witihn the game.  This class should be
// used to load any texture.  The class will check to see if an instance of that Texture
// already exists and will return a reference to it if it does.  If not instance already
// exists then it will create a new instance and pass a reference back to this new instance.
// The filename of the texture is used as the key within this class.
//
@interface ResourceManager : NSObject {
    NSMutableDictionary     *_cachedTextures;
	
	SpriteSheet *_spriteSheet8;
	SpriteSheet *_spriteSheet16;
	SpriteSheet *_spriteSheet32;
	SpriteSheet *_spriteSheet64;
	SpriteSheet *_menuSheet;
	SpriteSheet *_shopSheet;
	SpriteSheet* _gameTokenSheet;
	SpriteSheet* _shopTokenSheet;

	AngelCodeFont* _font16;
	AngelCodeFont* _font24;
	AngelCodeFont* _font32;
}

+ (ResourceManager *)sharedResourceManager;
@property (nonatomic, retain) AngelCodeFont* _font24;
@property (nonatomic, retain) AngelCodeFont* _font32;
@property (nonatomic, retain) AngelCodeFont* _font16;
@property (nonatomic, retain) SpriteSheet *_spriteSheet8;
@property (nonatomic, retain) SpriteSheet *_menuSheet;
@property (nonatomic, retain) SpriteSheet *_shopSheet;
@property (nonatomic, retain) SpriteSheet *_spriteSheet16;
@property (nonatomic, retain) SpriteSheet *_spriteSheet32;
@property (nonatomic, retain) SpriteSheet *_spriteSheet64;
@property (nonatomic, retain) SpriteSheet *_gameTokenSheet;
@property (nonatomic, retain) SpriteSheet *_shopTokenSheet;

-(void)loadSettingsImages;
-(void)unloadSettingsImages;
-(void)loadShopImages;
-(void)unloadShopImages;
-(void)loadGameImages;
-(void)unloadGameImages;
-(void)unloadMenuImages;
-(void)loadMenuImages;
-(void)loadHighScoreImages;
-(void)unloadHighScoreImages;


// Selector returns a Texture2D which has a ket of |aTextureName|.  If a texture cannot be
// found with that key then a new Texture2D is created and added to the cache and a 
// reference to this new Texture2D instance is returned.
- (Texture2D*)getTextureWithName:(NSString*)aTextureName;

// Selector that releases a cached texture which has a matching key to |aTextureName|.
- (bool)releaseTextureWithName:(NSString*)aTextureName;

// Selector that releases all cached textures.
- (void)releaseAllTextures;

@end
