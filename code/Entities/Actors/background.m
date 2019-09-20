

#import "background.h"
#import "GameScene.h"

@implementation Background
@synthesize du;


- (void)dealloc {
    [animation release];
	[image release];
    [super dealloc];
}

-(void)makeJet
{
	animation = [[Animation alloc] init];
	for(int i = 0;i<4;i++)
	{
		[animation addFrameWithImage:[[_resourceManager _spriteSheet16] getSpriteAtXYWH:0 y:12+i w:7 h:1] delay:0.5 imageScale:1];	
	}
}
- (id)initWithLocation:(Vector2f)aLocation  BGtype:(int)tp
{
    self = [super init];
	if (self != nil) {
		BGtype = tp;
		type = BACKGROUND;
		
		alive = YES;
		_size.width = 64;
		_size.height = 64;
		animation = nil;
		// Set the actors location to the vector location which was passed in
        position = aLocation;
       
		scaleBackground = 0.3 + 0.5* RANDOM_0_TO_1();
		
		zDepth = scaleBackground*20.0f;
		
		switch (BGtype) {
			case SQUARE_64_SCAFOLD:
				  _speed = 2*[_stats game_scroll_speed];
				
				image = [[_resourceManager _spriteSheet64] getSpriteAtX:1 y:0]; 
				[image setRotation:90];
			break;
				
			case SQUARE_32_SCAFOLD:
				  _speed = 0.5f*[_stats game_scroll_speed];
				image = [[_resourceManager _spriteSheet32] getSpriteAtX:2 y:6]; 
				
				[image setRotation:90];
			break;
			case WALL_BLOCK:
				image = [[_resourceManager _spriteSheet64] getSpriteAtX:0 y:2];
				_speed = [_stats game_scroll_speed];
				break;
			case STARS:
				image = [[Image alloc] initWithImage:@"BlueStars.png"] ;       
				_speed = 0.0f;
				position.x = 0;
				position.y = 32;
				break;
				
			case SPACE_STATION:
				image =  [[_resourceManager _gameTokenSheet] getSpriteAtXYWH:4 y:0 w:4 h:4]; 
				[image setScale:0.75];
				_speed = 0.8f;
				[image setRotation:RANDOM_MINUS_1_TO_1()*24.0f];
				zDepth = -1;
				break;
			case SPACESHIP_CARGO:
				image =  [[_resourceManager _spriteSheet64] getSpriteAtXYWH:3 y:2 w:5 h:1]; 
				[image setScale:scaleBackground];
				_speed = scaleBackground*0.3f*[_stats game_scroll_speed];
			//[self makeJet];
				jetOffset = Vector2fMultiply(Vector2fMake(-60, 0), scaleBackground);
				break;
			case SPACESHIP_BATTLECRUISER:
				image =  [[_resourceManager _spriteSheet64] getSpriteAtXYWH:3 y:3 w:4 h:1];   
				[image setScale:scaleBackground];
				_speed = scaleBackground*0.3f*[_stats game_scroll_speed];
			//	[self makeJet];
				jetOffset = Vector2fMultiply(Vector2fMake(-40, 0), scaleBackground);
				break;
			case SPACESHIP_FISH:
				image =  [[_resourceManager _spriteSheet64] getSpriteAtXYWH:4 y:1 w:2 h:1];     
				[image setScale:scaleBackground];
				_speed = scaleBackground*0.3f*[_stats game_scroll_speed];
				jetOffset = Vector2fMultiply(Vector2fMake(-20, 0), scaleBackground);
			//	[self makeJet];
				break;
				
			default:
				break;
	
		}
	
		du=0;
		//[image setRotation:0];
        if(animation)
		{
			[animation setCurrentFrame:0];
			[animation setRunning:YES];
			[animation setPingPong:NO];
			[animation setRepeat:YES];	
		}



    }
    return self;
}

- (void)update:(GLfloat)aDelta 
{
    
    // If we do not have access to the currentscene then grab it
	//[super update:aDelta];
	
    if(animation)[animation update:aDelta];
    if(BGtype==STARS)
	{
		//du+= 0.0002f;
		dx+= 0.001f;
		//[image setDy:-du];
		[image setDx:dx];
		
		//if(du>=1) du=0;
		//if(dx>=1) dx=0;
		
		/*if(LANDSCAPE_MODE) 
		{
			[image setDy:-du];
		}
		else 
		{
			[image setDx:du];
		}*/
		 
	}
	else
		position.x -= _speed;
   
	
    if(position.x < - 96)[super destroy];

}

- (void)render {
	if(BGtype==STARS)
	{
		[image renderAtPoint:Vector2fToCGPoint(position) centerOfImage:NO];
	}
	else{
			
			[image renderAtPoint:Vector2fToCGPoint(position) centerOfImage:TRUE];
		}
}

@end

