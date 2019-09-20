//
//  MenuState.m
//  BlockBlaster
//
//  Created by Robert Backman on 31/05/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//

#import "WeaponShopScene.h"
#import "TokenControl.h"
#import "GameScene.h"

@interface WeaponShopScene (Private)
- (void)initMenuItems;
@end

@implementation WeaponShopScene

@synthesize tokenOrigin;
@synthesize activeToken;


- (void) dealloc
{

	[menuBackground release];
	[tokenImage release];
	[sellBut release];
	[buyBut release];
	[resumeBut release];

	[super dealloc];
}

-(void)loadImages
{
	_ResourceManager = [ResourceManager sharedResourceManager];

	[_ResourceManager loadShopImages];
	imagesLoaded = YES;

	menuBackground = [[_ResourceManager _shopSheet] getSpriteAtXYWH:0 y:0 w:8 h:5];
	
	tokenImage =[[_ResourceManager _shopTokenSheet] getSpriteAtX:3 y:3];
	[tokenImage setScale:0.5];
	activeToken = nil;
	token_controls = [[NSMutableArray alloc] init];
	sellBut  = [[MenuControl alloc] initWithImage:[[_ResourceManager _shopSheet]getSpriteAtXYWH:2 y:5 w:2 h:1] location:sellPos centerOfImage:YES type:weap_sell];
	buyBut    = [[MenuControl alloc] initWithImage:[[_ResourceManager _shopSheet]getSpriteAtXYWH:0 y:5 w:2 h:1] location:buyPos centerOfImage:YES type:weap_buy];
	resumeBut = [[MenuControl alloc] initWithImage:[[_ResourceManager _shopSheet]getSpriteAtXYWH:4 y:5 w:3 h:1] location:resumePos centerOfImage:YES type:weap_resume];
	
	[sellBut setBounds:Vector2fMake(78, 32) offset:Vector2fZero]; //Vector2fMake(-28, -16)];
	[buyBut setBounds:Vector2fMake(78, 32) offset:Vector2fZero]; //Vector2fMake(-28, -16)];
	[resumeBut setBounds:Vector2fMake(160, 32) offset:Vector2fZero]; //Vector2fMake(-16, -16)];
	
	if([_stats resumed])
	{
		for(Token* tk in [_stats tokenInventory])
		{
			[self addTokenControl:tk];
		}
		maxH = tokenOrigin.y+([token_controls count]/2)*100;
	}
	else
	{
		[self initMenuItems];
	}
	
}
-(void)unloadImages
{
	
	[token_controls removeAllObjects];
	[token_controls release];
	imagesLoaded = NO;
	firstThrough = YES;
	[menuBackground release];
	[tokenImage release];
	[sellBut release];
	[buyBut release];
	[resumeBut release];
	[_ResourceManager unloadShopImages];

}
- (id)init {
	
	if(self = [super init]) {
		
		imagesLoaded=NO;
		tokenToSelect = nil;
	
		
				
        _sceneFadeSpeed = 3.0f;
        sceneAlpha = 0.0f;
	
		[self setSceneState:kSceneState_TransitionIn];
		nextSceneKey = nil;
		
		cols = 2;
		rows = 6;
		
		
		maxL = MAXH - 105;
		tokenOrigin = Vector2fMake(84,maxL);
		maxH = tokenOrigin.y+120;
		
		
		textOrigin = Vector2fMake(320, 300);
		
		buyPos = Vector2fMake(349, 85);
		sellPos = Vector2fMake(431, 85);
		resumePos = Vector2fMake(386, 29);
		/*buyPos = Vector2fMake(378, 98);
		sellPos = Vector2fMake(458, 98);
		resumePos = Vector2fMake(405, 42);
		*/
		
		
		tokenBound = makeRec(Vector2fMake(120, 120), 256, 256, 0, 0);
		
		// Init anglecode font and message

		tokenToSelect = nil;
		line1=nil;
		line2 =nil;
		line3 = nil;
		line4=nil;
		
	}
	return self;
}


- (void)initMenuItems {
	
	[[_stats tokenInventory] removeAllObjects ];
	
	token_controls = [[NSMutableArray alloc] init];
	
	MissileToken*   mtok = [[MissileToken alloc] initWithType:STANDARD_MISSLE ];
	[ self addTokenControl:mtok ];
	if([_stats quickPlay])
	{
		[mtok upgrade];	
	}
	[ mtok release ];
	 
	mtok = [[MissileToken alloc] initWithType:EXPLOSIVE_MISSLE ];
	[ self addTokenControl:mtok ];
	[ mtok release ];
	
	mtok = [[MissileToken alloc] initWithType:GUIDED_MISSLE ];
	[ self addTokenControl:mtok ];
	if([_stats quickPlay])
	{
		[mtok upgrade];	
	}
	[ mtok release ];
	
	LaserToken*    ltok = [[LaserToken alloc] initWithType:STANDARD_LASER];
	[ self addTokenControl:ltok ];
	[ltok upgrade];	
	
	[ ltok release ];
	
	 mtok = [[MissileToken alloc] initWithType:NARROW_RANGE_MISSLE ];
	[ self addTokenControl:mtok ];
	[ mtok release ];

	mtok = [[MissileToken alloc] initWithType:CLUSTER_MISSLE ];
	[ self addTokenControl:mtok ];
	[ mtok release ];
	
	
	
	ltok = [[LaserToken alloc] initWithType:DOUBLE_LASER];
	[ self addTokenControl:ltok ];
	[ ltok release ];
	
	ltok = [[LaserToken alloc] initWithType:TRIPLE_LASER];
	[ self addTokenControl:ltok ];
	[ ltok release ];
	

	ShieldToken*   stok = [[ShieldToken alloc] initWithType:STANDARD_SHIELD];
	[self addTokenControl:stok];
	if([_stats quickPlay])
	{
		[stok upgrade];	
	}
	[ stok release ];
	
	stok = [[ShieldToken alloc] initWithType:REFLECTOR_SHIELD];
	[self addTokenControl:stok];
	[ stok release ];

	GuardianToken* gtok = [[GuardianToken alloc] initWithType:STANDARD_GUARDIAN];
	[self addTokenControl:gtok];
	[ gtok release ];
	
	for(TokenControl* tk in token_controls)
	{
		[_stats addToken:[tk _token] ];
	}
	
	//maxL = maxH -  ([token_controls count]/2)*64;
	maxH = tokenOrigin.y+([token_controls count]/2)*100;
}

-(void)addTokenControl:(Token*)theToken;
{
	[theToken loadImage:YES];
	int num = [token_controls count];
	int i = num / cols;
	int j = num % cols;
	Vector2f p  = Vector2fMake(120*j, i*120);
	
	TokenControl* tc = [[TokenControl alloc] initWithImage:tokenImage offset:p token:theToken weapShop:YES];
	[tc setBounds:Vector2fMake(104,104) offset:Vector2fMake(0, 0)];
	
	[token_controls addObject:tc];
	[tc release];
}

- (void)updateWithDelta:(GLfloat)aDelta {
	

		
	switch (sceneState) {
		case kSceneState_Running:
		{
			for(AbstractControl* c in token_controls)
			{
				[c updateWithDelta:aDelta];	
			}
			
			[sellBut updateWithDelta:aDelta]; 
			[buyBut updateWithDelta:aDelta]; 
			[resumeBut updateWithDelta:aDelta]; 
						
			if([_director tutorialMode])
			{
				[nextBut updateWithDelta:aDelta];
			}
			if([resumeBut selected])
			{
				[resumeBut deselect];
				
						if([_director tutorialMode])
						{
							tokenToSelect = nil;
							showNext = NO;
							[nextBut release];
							[tutBackdrop release];
							showArrow = NO;
							[tutArrow release];
							tutBackdrop = nil;
							tokenToSelectImage = nil;
							[tokenToSelectImage release];
							sceneState = kSceneState_TransitionOut;
							[_director saveGameState];
							nextSceneKey = @"game";
						}
						else
						{
							sceneState = kSceneState_TransitionOut;
							 [_director saveGameState];
							nextSceneKey = @"game";
						}
			}
		}
		break;
						
		case kSceneState_TransitionOut:
			sceneAlpha -= _sceneFadeSpeed * aDelta;
            [_director setGlobalAlpha:sceneAlpha];
			if(sceneAlpha < 0){
				sceneAlpha = 0;
                // If the scene being transitioned to does not exist then transition
                // this scene back in
				if(![_director setCurrentSceneToSceneWithKey:nextSceneKey])
				{
                    sceneState = kSceneState_TransitionIn;
				}
				else{
					
					[self unloadImages];
					sceneState = kSceneState_TransitionIn;
				}
			}
			break;
			
		case kSceneState_TransitionIn:

			// I'm not using the delta value here as the large map being loaded causes
            // the first delta to be passed in to be very big which takes the alpha
            // to over 1.0 immediately, so I've got a fixed delta for the fade in.
			if(sceneAlpha==0)
			{		
				[super updateWithDelta:aDelta];
				
				[self loadImages];
				
				if([_stats quickPlay])
				{
					sceneState = kSceneState_TransitionOut;
					[_director saveGameState];
					nextSceneKey = @"game";
				}
				if([_director tutorialMode])
				{
					tutorialStep = WEAPON_SHOP_TUTORIAL_START;
					[self tutProceed];
				}
				
				
			}
          if(![_stats quickPlay])
		  {	
			sceneAlpha += _sceneFadeSpeed * 0.02f;
            [_director setGlobalAlpha:sceneAlpha];
		  }
			if(sceneAlpha >= 1.0f) {
				sceneState = kSceneState_Running;
			}
			break;
		default:
			break;
	}

}


- (void)setSceneState:(uint)theState {
	sceneState = theState;
	if(sceneState == kSceneState_TransitionOut)
		sceneAlpha = 1.0f;
	if(sceneState == kSceneState_TransitionIn)
		sceneAlpha = 0.0f;
}

- (void)updateWithTouchLocationBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
    UITouch *touch = [[event touchesForView:aView] anyObject];
	CGPoint location;
	location = touchToScene([touch locationInView:aView]);
    
	// Flip the y location ready to check it against OpenGL coordinates

	startPos = location.y;
	originStart = tokenOrigin.y;
	
	if(imagesLoaded)
	{
			for(TokenControl* tc in token_controls)
			{
				[tc setHitTime:0];
				if([tc hit:CGPointToVector2f(location)])
				{
					[tc setTokenHit:YES];
				}
				else
				{
					[tc setTokenHit:NO];
				}
			}
	}
	
}


- (void)updateWithTouchLocationMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView{
    UITouch *touch = [[event touchesForView:aView] anyObject];
	CGPoint location;
	location = touchToScene([touch locationInView:aView]);
    
	bool move = YES;;
	if([_director tutorialMode])
	{
		if(tutorialStep>=WEAPON_SHOP_TUTORIAL_SELECT_LASER)
		{
			move = NO;
		}
		
	}
	
	if(move)
	{
		float ny = originStart - (startPos - location.y);
		if(ny<maxL)ny=maxL;
		if(ny>maxH)ny = maxH;
		tokenOrigin.y =  ny;
	}
}

- (void)updateWithTouchLocationEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView
{

	if(imagesLoaded)
	{
	UITouch *touch = [[event touchesForView:aView] anyObject];
	Vector2f location;
	location = CGPointToVector2f(touchToScene([touch locationInView:aView]));
   
	if([_director tutorialMode])
	{
	//	printf("click pos %g %g\n",location.x,location.y);
		bool beenHit = NO;
		if(showNext)
		{
			if([nextBut updateWithLocation:location])
			{
				beenHit = YES;
				tutorialStep = tutorialNextStep;
				[self tutProceed];
				
			}
		}
		
		if(!beenHit)
		{
			if(tutorialStep < WEAPON_SHOP_TUTORIAL_PRESS_RESUME)
			{
				for(TokenControl* tc in token_controls)
				{
					if([tc hit:location])
					{
						[tc updateWithLocation:location];
					}
					else
					{
						[tc setTokenHit:NO];
					}
				}
			}
		}
		switch (tutorialStep)
		{
				
			case WEAPON_SHOP_TUTORIAL_SELECT_LASER:
			{
				
				if([activeToken token_type] == LASER_TOKEN)
				{
					if([activeToken sub_type]==STANDARD_LASER)
					{
						tutorialStep = tutorialNextStep;
						[self tutProceed];
					}
				}
			}break;
			case WEAPON_SHOP_TUTORIAL_SELECT_MISSLE:
			{
				if([activeToken token_type] == MISSLE_TOKEN)
				{
					if([activeToken sub_type] == GUIDED_MISSLE)
					{
						tutorialStep = tutorialNextStep;
						[self tutProceed];
					}
				}
			}break;
				
			case WEAPON_SHOP_TUTORIAL_PRESS_BUY_1:
			case WEAPON_SHOP_TUTORIAL_PRESS_BUY_2:
			{
				if([buyBut updateWithLocation:location])
				{
					if([activeToken token_type] == LASER_TOKEN)
					{
						if([activeToken sub_type]==STANDARD_LASER)
						{
							if([_stats addCoins:-[activeToken cost]])
								[activeToken upgrade];	
							tutorialStep = tutorialNextStep;
							[self tutProceed];
						}
					}
				}
			}break;
			case WEAPON_SHOP_TUTORIAL_PRESS_BUY_3:
				if([buyBut updateWithLocation:location])
				{
					if([activeToken token_type] == MISSLE_TOKEN)
					{
						if([activeToken sub_type] == GUIDED_MISSLE)
						{
							if([_stats addCoins:-[activeToken cost]])
								[activeToken upgrade];	
							tutorialStep = tutorialNextStep;
							[self tutProceed];
							tokenToSelect = nil;
				
						}
					}
				}
				break;
			case WEAPON_SHOP_TUTORIAL_PRESS_RESUME:
				[resumeBut updateWithLocation:location];
			break;
				
		}
		
		

		
	}
	else
	{
		
		for(TokenControl* tc in token_controls)
		{
			if([tc hit:location])
			{
				[tc updateWithLocation:location];
			}
			else
			{
				[tc setTokenHit:NO];
			}
		}
		
		if([sellBut updateWithLocation:location])
		{
			if(activeToken)
			{
				if([_stats addCoins:(int)(0.4f*[activeToken cost])])
				[activeToken sellToken];
				activeToken = nil;
			}
		}
		if([buyBut updateWithLocation:location])
		{
			if([_stats addCoins:-[activeToken cost]])
				[activeToken upgrade];	
		}
		
		[resumeBut updateWithLocation:location];
				

		
	}
	}
}


- (void)transitionToSceneWithKey:(NSString*)theKey {
	sceneState = kSceneState_TransitionOut;
	sceneAlpha = 1.0f;
}

-(void)tutProceed
{


	
		
	[line1 release];
	[line2 release];
	[line3 release];
	[line4 release];
	
		switch (tutorialStep) {
			case WEAPON_SHOP_TUTORIAL_START:
	
				tutPos = Vector2fMake(10, 300);
				tutArrow = [[Image alloc] initWithImage:@"arrow.png"];
				[tutArrow setPivot:CGPointMake(0,32)];
				[tutArrow setAlpha:0.75];
				//[tutArrow setTextureOffsetY:0];
				tutPointTo = Vector2fMake(231, 218);
				showArrow = NO;
				
				tutBackdrop = [[_ResourceManager _shopSheet]getSpriteAtX:0 y:7];
				[tutBackdrop setScaleV:Vector2fMake(5, 2)];
				//[tutBackdrop setAlpha:0.75];
				nextBut = [[MenuControl alloc] initWithImage:[[_ResourceManager _shopSheet]getSpriteAtXYWH:0 y:6 w:2 h:1] location:Vector2fMake(tutPos.x + 220 , tutPos.y -80 ) centerOfImage:YES type:0];
				[nextBut setBounds:Vector2fMake(128, 64) offset:Vector2fZero];
				line1 = @"Welcome to Block Blaster";
				line2 = @"This is where you can purchase or upgrade.";
				line3 = @"weapons. scroll through the list below and have a.";
				line4 = @"look at the weapons. then press NEXT to proceed";
				showNext = YES;
				tokenToSelectImage = [[_ResourceManager _shopTokenSheet] getSpriteAtX:2 y:3];
				tutorialNextStep = WEAPON_SHOP_TUTORIAL_SELECT_LASER;
				break;
			case WEAPON_SHOP_TUTORIAL_SELECT_LASER:
				tokenOrigin.y = maxL;
				
				showArrow = YES;
				showNext = NO;
				for(TokenControl* tk in token_controls)
				{
					if([[tk _token] token_type] == LASER_TOKEN)
					{
						if([[tk _token] sub_type]==STANDARD_LASER)
						{	
							tokenToSelect = tk;
						}
						
					}
				}
				tutPointTo = Vector2fMake(204, 99);
				line1 = @"search through the weapons to find the ";
				line2 = @"standard laser cannnon (highlighted green)";
				line3 = @"to the right are the selected weapons statistics.";
				line4 = @" " ; 
				tutorialNextStep = WEAPON_SHOP_TUTORIAL_PRESS_BUY_1 ;
				break;
			case WEAPON_SHOP_TUTORIAL_PRESS_BUY_1:
				tutPointTo = Vector2fMake(340, 82);
				line1 = @"press BUY to purchase the weapon at level 1 ";
				line2 = @"This will place it in your inventory ";
				line3 = @" ";
				line4 = @" " ; 
				tutorialNextStep = WEAPON_SHOP_TUTORIAL_PRESS_BUY_2;
			break;
			case WEAPON_SHOP_TUTORIAL_PRESS_BUY_2:
				tutPointTo = Vector2fMake(340, 82);
				line1 = @"press BUY again to upgrade it to level 2";
				line2 = @"this will enhance the stats like the firerate";
				line3 = @"or the energy..etc";
				line4 = @" ";
				tutorialNextStep = WEAPON_SHOP_TUTORIAL_SELECT_MISSLE;
			break;
			case WEAPON_SHOP_TUTORIAL_SELECT_MISSLE:
				tutPointTo = Vector2fMake(87,96);
				for(TokenControl* tk in token_controls)
				{
					if([[tk _token] token_type] == MISSLE_TOKEN)
					{
						if([[tk _token] sub_type]==GUIDED_MISSLE)
						{	
							tokenToSelect = tk;
						}
						
					}
				}
				
				line1 = @"Next select the guided missile";
				line2 = @" ";
				line3 = @" ";
				line4 = @" ";
				tutorialNextStep = WEAPON_SHOP_TUTORIAL_PRESS_BUY_3;
			break;
			case WEAPON_SHOP_TUTORIAL_PRESS_BUY_3:
				tutPointTo = Vector2fMake(340, 82);
				line1 = @"press BUY to put the missile in your inventory";
				line2 = @" ";
				line3 = @" ";
				line4 = @" ";
				tutorialNextStep = WEAPON_SHOP_TUTORIAL_PRESS_RESUME;
			break;

			case WEAPON_SHOP_TUTORIAL_PRESS_RESUME:
				showNext = NO;
				tokenToSelect=nil;
				tutPointTo = Vector2fMake(367, 30);
				line1 = @"Once your out of money its time to play..";
				line2 = @"Lets blast some blocks!!";
				line3 = @"";
				line4 = @"Click resume when your done";
			
			break;
			case WEAPON_SHOP_TUTORIAL_TIP_1:
				showNext = YES;
				line1 = @"You can also sell your weapons here, but you ";
				line2 = @"will only get a portion of the original value. ";
				line3 = @" ";
				line4 = @"press NEXT to continue";
						break;
				
			default:
				line1 = @" ";
				line2 = @" ";
				line3 = @" ";
				line4 = @" ";
				
				break;
	}
	

	
	
}
- (void)render {
	
	if(imagesLoaded)
	{
		
		activatOpenGl();
		
		
	for(TokenControl* tc in token_controls)
	{
		[tc render:YES];	
	}
	
	if(tokenToSelect)
	{
		if(tokenToSelectImage) [tokenToSelectImage renderAtPoint:Vector2fToCGPoint([tokenToSelect location]) centerOfImage:YES];
	}
	
	[menuBackground renderAtPoint:CGPointMake(0, 0) centerOfImage:NO];
	

		[buyBut render];
		[sellBut render];
		[resumeBut render];	
		
		
		if([_director tutorialMode])
		{
			if(tutBackdrop) [tutBackdrop renderAtPoint:CGPointMake(tutPos.x-8, tutPos.y - 100)  centerOfImage:NO];
			if(showNext)[nextBut render];
			if(showArrow)
			{
				Vector2f dir = Vector2fSub(Vector2fMake(MAXW/2, MAXH/2), tutPointTo	);
				float _tutangle = RADIANS_TO_DEGREES(Vector2fangle(dir));
				[tutArrow setRotation:-_tutangle];
				[tutArrow renderAtPoint:Vector2fToCGPoint(tutPointTo) centerOfImage:NO];
			}
				
		}
	
	
	
	
	
		
		
	AngelCodeFont* font = [_ResourceManager _font16];
	
	[font setColourFilterRed:1 green:1 blue:1 alpha:1];
	
	if(activeToken!=nil)
	{
		
		[font drawStringAt:CGPointMake(textOrigin.x, textOrigin.y) text:[NSString stringWithFormat:@"%@ %@",[activeToken sub_type_name], [activeToken name]]];
		[font drawStringAt:CGPointMake(textOrigin.x, textOrigin.y-16) text:[NSString stringWithFormat:@"level %d",[activeToken token_level]]];
		
		if(![activeToken owned])
		{
			[font drawStringAt:CGPointMake(textOrigin.x, textOrigin.y-128)  text:[ NSString stringWithFormat:@"not in inventory"] ];
		}
		else if([activeToken unlimited])
		{
			[font drawStringAt:CGPointMake(textOrigin.x, textOrigin.y-128)  text:[ NSString stringWithFormat:@"unlimited"	] ];	
		}
		else
		{
			if([activeToken token_type]==GUARDIAN_TOKEN)[font drawStringAt:CGPointMake(textOrigin.x, textOrigin.y-128)  text:[NSString stringWithFormat:@"%dx available",[activeToken num]]];
			else [font drawStringAt:CGPointMake(textOrigin.x, textOrigin.y-128)  text:[NSString stringWithFormat:@"%dx amo",[activeToken num]]];

		}
		
		[font drawStringAt:CGPointMake(textOrigin.x, textOrigin.y-48)		text:[NSString stringWithFormat:@"reload rate %g",(float)([activeToken reloadRate]*0.03f)]];
		
		if(![activeToken owned]) 
		{
			[ font drawStringAt:CGPointMake(textOrigin.x, textOrigin.y-144) text:[NSString stringWithFormat:@"cost: %d",[activeToken cost]] ];	
		}
		else
		{
			[ font drawStringAt:CGPointMake(textOrigin.x, textOrigin.y-144) text:[NSString stringWithFormat:@"upgrade cost: %d",[activeToken cost]] ];	
		}																									
		
		switch ([activeToken token_type]) {
			case MISSLE_TOKEN:
				[font drawStringAt:CGPointMake(textOrigin.x, textOrigin.y-64) text: [NSString stringWithFormat:@"explosion radius: %g",[(MissileToken*)activeToken  explosionRadius] ] ];	
				if([activeToken sub_type]==CLUSTER_MISSLE)
				[font drawStringAt:CGPointMake(textOrigin.x, textOrigin.y-80) text: [NSString stringWithFormat:@"cluster num: %d",[(MissileToken*)activeToken  clusterNum] ] ];	
						
				break;
			case SHIELDS_TOKEN:
				[font drawStringAt:CGPointMake(textOrigin.x, textOrigin.y-64) text: [NSString stringWithFormat:@"Max Enrgy: %g",[(ShieldToken*)activeToken  maxEnergy] ] ];	
				break;
			default:
				break;
		}
		
	}
	[font drawStringAt:CGPointMake(textOrigin.x, textOrigin.y-160) text:[NSString stringWithFormat:@"budget: %d",[_stats player_coins]]  ];	

	


	
	
	if([_director tutorialMode])
	{
		
		[font setColourFilterRed:1 green:1 blue:1 alpha:1];
	
		if(line1)[font drawStringAt:CGPointMake(tutPos.x, tutPos.y) text:line1];
		if(line2)[font drawStringAt:CGPointMake(tutPos.x, tutPos.y-16) text:line2];
		if(line3)[font drawStringAt:CGPointMake(tutPos.x, tutPos.y-32) text:line3];
		if(line4)[font drawStringAt:CGPointMake(tutPos.x, tutPos.y-48) text:line4];
		
		
	}
	deactivateOpenGl();
	}

}


@end
