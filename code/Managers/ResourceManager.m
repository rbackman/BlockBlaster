//
//  ResourceManager.m
//  BlockBlaster
//
//  Created by Robert Backman on 16/05/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//

#import "ResourceManager.h"
#import "Common.h"
#import "SynthesizeSingleton.h"
#import "Texture2D.h"
#import "SpriteSheet.h"
#import "AngelCodeFont.h"

@implementation ResourceManager

@synthesize _gameTokenSheet;
@synthesize _shopTokenSheet;
@synthesize _spriteSheet16;
@synthesize _spriteSheet32;
@synthesize _spriteSheet64;
@synthesize _font16;
@synthesize _font32;
@synthesize _menuSheet;
@synthesize _shopSheet;
@synthesize _spriteSheet8;
@synthesize _font24;
SYNTHESIZE_SINGLETON_FOR_CLASS(ResourceManager);

- (void)dealloc {
    
    // Release the cachedTextures dictionary.
	[_cachedTextures release];
	[super dealloc];
}


- (id)init {
	// Initialize a dictionary with an initial size to allocate some memory, but it will 
    // increase in size as necessary as it is mutable.
	_cachedTextures = [[NSMutableDictionary dictionaryWithCapacity:10] retain];
	
	_spriteSheet8 = nil;
	_spriteSheet16 = nil;
	_spriteSheet32 = nil;
	_spriteSheet64 = nil;
	_gameTokenSheet = nil;
	
	_font32 = nil;
	_shopTokenSheet = nil;
	_shopSheet = nil;
	
	_font24 = [[AngelCodeFont alloc] initWithFontImageNamed:@"Monospaced24.png" controlFile:@"Monospaced24" scale:1.0 filter:GL_LINEAR];
	_font16 = [[AngelCodeFont alloc] initWithFontImageNamed:@"GillSans16.png" controlFile:@"GillSans16" scale:1.0f filter:GL_LINEAR];

	return self;
}

-(void)unloadMenuImages
{
	[_menuSheet release]; 
	_menuSheet = nil;
}

-(void)loadHighScoreImages
{

	[self loadMenuImages];	
	[self loadSettingsImages];
}
-(void)unloadHighScoreImages
{
	[self unloadMenuImages];
	[self unloadSettingsImages];
}

-(void)loadMenuImages
{
	_menuSheet = [[SpriteSheet alloc] initWithImageNamed:@"MenuButtonSheet.png" spriteWidth:32 spriteHeight:32 spacing:0 imageScale:1];
}
-(void)loadSettingsImages
{
	if(_font32)[_font32 release];
	_font32 =  [[AngelCodeFont alloc] initWithFontImageNamed:@"test.png" controlFile:@"test" scale:1.0f filter:GL_LINEAR];
	
}
-(void)unloadSettingsImages
{
	[_font32 release];
	_font32 = nil;
	
}
-(void)loadShopImages
{
	if(_shopTokenSheet)[_shopTokenSheet release];
	_shopTokenSheet = [[SpriteSheet alloc] initWithImageNamed:@"ShopSheet.png" spriteWidth:128 spriteHeight:128 spacing:0 imageScale:1.0f];
	if(_shopSheet) [_shopSheet release];
	_shopSheet = [[SpriteSheet alloc] initWithImageNamed:@"UpgradeShop.png" spriteWidth:64 spriteHeight:64 spacing:0 imageScale:1];

}
-(void)unloadShopImages
{
	[_shopSheet release];
	_shopSheet = nil;
	[_shopTokenSheet release];
	_shopTokenSheet=nil;
	[_cachedTextures removeAllObjects];
	
}
-(void)loadGameImages
{
	if(!_font32)
		_font32 =  [[AngelCodeFont alloc] initWithFontImageNamed:@"test.png" controlFile:@"test" scale:1.0f filter:GL_LINEAR];
	
	if(!_spriteSheet8) 
		_spriteSheet8 =  [[SpriteSheet alloc] initWithImageNamed:@"spriteSheet8.png" 
												 spriteWidth:8 spriteHeight:8 spacing:0 imageScale:1.0f];
	
	
	if(!_spriteSheet16)
		_spriteSheet16 = [[SpriteSheet alloc] initWithImageNamed:@"spriteSheet16.png" 
												 spriteWidth:16 spriteHeight:16 spacing:0 imageScale:1.0f];
	
	if(!_spriteSheet32)	
		_spriteSheet32 = [[SpriteSheet alloc] initWithImageNamed:@"spriteSheet32.png" 
												 spriteWidth:32 spriteHeight:32 spacing:0 imageScale:1.0f];
	
	if(!_spriteSheet64)	
		_spriteSheet64 = [[SpriteSheet alloc] initWithImageNamed:@"spriteSheet64.png" 
												 spriteWidth:64 spriteHeight:64 spacing:0 imageScale:1.0f];
	if(!_gameTokenSheet)	
		_gameTokenSheet = [[SpriteSheet alloc] initWithImageNamed:@"InventorySheet.png" spriteWidth:64 spriteHeight:64 spacing:0 imageScale:1];
}
-(void)unloadGameImages
{
	[_spriteSheet8 release]; _spriteSheet8 = nil;
	[_spriteSheet16 release]; _spriteSheet16=nil;
	[_spriteSheet32 release]; _spriteSheet32=nil;
	[_spriteSheet64 release]; _spriteSheet64=nil;
	[_gameTokenSheet release]; _gameTokenSheet=nil;
	[_cachedTextures removeAllObjects];
}



- (Texture2D*)getTextureWithName:(NSString*)aTextureName {
    
    // Try to get a texture from cachedTextures with the supplied key.
    Texture2D *_cachedTexture;
    
    // If we can find a texture with the supplied key then return it.
    if(_cachedTexture = [_cachedTextures objectForKey:aTextureName]) {
        if(DEBUG) NSLog(@"INFO - Resource Manager: A cached texture was found with the key '%@'.", aTextureName);
        return _cachedTexture;
    }
    
    // As no texture was found we create a new one, cache it and return it.
    if(DEBUG) NSLog(@"INFO - Resource Manager: A texture with the key '%@' could not be found so creating it.", aTextureName);
    _cachedTexture = [[Texture2D alloc] initWithImage:[UIImage imageNamed:aTextureName] filter:GL_NEAREST];
    [_cachedTextures setObject:_cachedTexture forKey:aTextureName];
    
    // Return the texture which is autoreleased as the caller is responsible for it
    return [_cachedTexture autorelease];
}

- (bool)releaseTextureWithName:(NSString*)aTextureName {

    // Try to get a texture from cachedTextures with the supplied key.
    Texture2D *cachedTexture = [_cachedTextures objectForKey:aTextureName];

    // If a texture was found we can remove it from the cachedTextures and return YES.
    if(cachedTexture) {
        if(DEBUG) NSLog(@"INFO - Resource Manager: A cached texture with the key '%@' was released.", aTextureName);
        [_cachedTextures removeObjectForKey:aTextureName];
        return YES;
    }
    
    // No texture was found with the supplied key so log that and return NO;
    if(DEBUG) NSLog(@"INFO - Resource Manager: A texture with the key '%@' could not be found to release.", aTextureName);
    return NO;
}

- (void)releaseAllTextures {
    if(DEBUG) NSLog(@"INFO - Resource Manager: Releasing all cached textures.");
    [_cachedTextures removeAllObjects];
}


@end
