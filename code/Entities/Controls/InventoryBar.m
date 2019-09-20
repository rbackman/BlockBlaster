
#import "InventoryBar.h"
#import "MenuControl.h"
#import "Image.h"
#import "TokenControl.h"
#import "Tokens.h"
#import "GameScene.h"
#import "AngelCodeFont.h"
#import "Player.h"
#import "WeaponButton.h"
#import "Bonus.h"

@implementation InventoryBar

@synthesize inventory_closed;

- (void) dealloc
{
	[buyAmmo release];
	[tab release];
	[super dealloc];
}

 -(id)initWithLocation:(Vector2f)p
{
	[super init];
	ownedTokens= [[NSMutableArray alloc] init];
	[self reset];

	return self;
}
-(void)reset
{
	imagesLoaded = NO;
	firstThrough = YES;
	inventory_closed = YES;
	bar_state = INVENTORY_CLOSED;
	sliderScale = SLIDER_MIN_SCALE;
	statsPos = Vector2fMake(15, 280);
	weap_bar_active_button  = nil;
	inventory_active_token = nil;
	

	[ownedTokens removeAllObjects];
	tokensPresent = NO;
	firstThrough =YES;	
	
	inventoryPos.x = 400;
	inventoryPos.y = INVENTORY_MIN_HEIGHT;
	
	weap_bar_position_min = 120;
	weap_bar_position = Vector2fMake(weap_bar_position_min, 32);

	
	weap_bar_retracting = NO;
	weap_bar_retracting_dir = FORWARD;
	
	weap_bar_retract_button_rec = makeRec(Vector2fMake(weap_bar_position.x + 74, 32), 32, 64, 0, 0);
weap_bar_bounds = makeRec(Vector2fMake(2*MAXW/3+32, 32), 280, 64, 0, 0);
	
}
-(void)addBonus:(Vector2f)pos
{
	int numToks = 0;
	int buts[4];
	for(int i=0;i<4;i++)
	{
		if([weap_bar_buttons[i] token] )
		{
			if( [[weap_bar_buttons[i] token] token_type] !=LASER_TOKEN )
			{
			buts[numToks]=i;
			numToks++;
			}
		}
	}
	if(numToks>0)
	{
		int tokToChoose = (int)( RANDOM_0_TO_1() * (numToks+0.5));
		if(tokToChoose>=numToks)tokToChoose=numToks-1;
		
		Token* t = [self getToken:buts[tokToChoose]];
		Vector2f p = [weap_bar_buttons[buts[tokToChoose]] location];
		
		Bonus* b = [[Bonus alloc] initWithLocation:pos goal:p token:t ];
		[_gamescene addBackground:b];
		[b release];
	}
	
}
-(Token*)getToken:(int)i
{
if([weap_bar_buttons[i] token])
	return [weap_bar_buttons[i] token];
else return nil;
}
-(void)unloadImages
{
		imagesLoaded = NO;
	firstThrough = YES;
	[_weapBar release];
	[tab release];
	weap_bar_active_button = nil;
	inventory_active_token = nil;
	[buyAmmo release];
	[ownedTokens removeAllObjects];
	tokensPresent = NO;
	[slider release]; slider = nil;
	[tokenImage release]; tokenImage = nil;
	[green_token_highlight release]; green_token_highlight =nil;
	[statsBackgroud release]; statsBackgroud = nil;
	for(int i=0;i<4;i++)
	{
		[weap_bar_buttons[i] release];
		weap_bar_buttons[i] = nil;
	}
}
-(void)loadImages
{
	
	if(!imagesLoaded)
	{
		_stats = [_director _statManager];
		imagesLoaded = YES;
		inventory_token_bounds = makeRec(Vector2fMake(MAXW/2, 98), MAXW, 65, 0, 0);
		tab = [[MenuControl alloc] initWithImage:[[_ResourceManager _gameTokenSheet] getSpriteAtXYWH:0 y:5 w:2 h:1] location:Vector2fMake(inventoryPos.x,inventoryPos.y+INVENTORY_TAB_HEIGHT) centerOfImage:YES type:1];
		[tab setLocation:Vector2fMake(inventoryPos.x,inventoryPos.y+INVENTORY_TAB_HEIGHT)];
		[tab setBounds:Vector2fMake(160,32) offset:Vector2fMake(0, 14)];
		
			buyAmmoPos = Vector2fMake(200, 200);
		buyAmmo = [[MenuControl alloc] initWithImage:[[_ResourceManager _spriteSheet64] getSpriteAtX:0 y:0 ] location:buyAmmoPos centerOfImage:YES type:1];

		
		statsBackgroud = [[_ResourceManager _spriteSheet32] getSpriteAtX:5 y:0 ];
		[statsBackgroud setScaleV:Vector2fMake(9, 4)];
		[statsBackgroud setAlpha:0.5];

		font = [_ResourceManager _font16];
		SpriteSheet* tokenSheet = [_ResourceManager _gameTokenSheet];
		
		slider = [tokenSheet getSpriteAtX:0 y:0]; [ slider setScaleV:Vector2fMake( sliderScale, 1)];
		tokenImage = [tokenSheet getSpriteAtX:1 y:0];
		green_token_highlight = [tokenSheet getSpriteAtX:2 y:0];
		
		_weapBar   = [[_ResourceManager _spriteSheet64] getSpriteAtXYWH:3 y:4 w:5 h:1]; [_weapBar setScaleV:Vector2fMake(1, 1.1)];
		//_blueBut   = [[_ResourceManager _spriteSheet64] getSpriteAtX:3 y:0];
	
		//_redBut    = [[_ResourceManager _spriteSheet64] getSpriteAtX:2 y:0]; 
		//_yellowBut = [[_ResourceManager _spriteSheet64] getSpriteAtX:4 y:0]; 
		if(AUTO_OPEN_INVENTORY) 
		{
			if(![_director tutorialMode] && ![_stats resumed] && ![_stats quickPlay]) [self openInventory];
		}
		for(int i=0;i<4;i++)
		{
			weap_bar_buttons[i] = [[WeaponButton alloc] initWithOffset:Vector2fMake(128 + i*64 ,weap_bar_position.y)];	
			
			[weap_bar_buttons[i] move:weap_bar_position.x];
		}
	}
}

-(BOOL)closed
{
	return inventory_closed; //(bar_state==INVENTORY_CLOSED);	
}
-(void)openWeapBar
{
	weap_bar_closed = NO;
	weap_bar_retracting = YES;
	weap_bar_retracting_dir = FORWARD;
}
-(void)closeWeapBar
{
	weap_bar_closed = YES;
	weap_bar_retracting = YES;
	weap_bar_retracting_dir = BACKWARDS;
}
-(void)closeInventory
{

	bar_state = INVENTORY_DEACTIVATE;	
}
-(void)openInventory
{
	
	bar_state = INVENTORY_ACTIVE;
}

/*
-(void)fireWeapons
{
	if(![_gamescene paused]) 
	{
		for(int i=0;i<4;i++)
		{
			
			if(butOn[i])
			{	
				Token* tk = [ _stats getToken:i];
				if(tk)
				{
					[[_gamescene _player] fireWeap:tk];
				}
				else butOn[i]=FALSE;
			}
		}
	}
	
}*/
-(void)updateWeaponBar
{
	//Moves the wepon bar if the inventory is closed
	if(weap_bar_retracting && inventory_closed)
	{
		int mv;
		if(weap_bar_retracting_dir == FORWARD) 
			mv=-20;
		else 
			mv =20;
		
		
		
		weap_bar_position.x = weap_bar_position.x + mv;
		weap_bar_retract_button_rec = makeRec(Vector2fMake(weap_bar_position.x + 74, 32), 32, 64, 0, 0);
		
		if(weap_bar_retracting_dir == FORWARD&& weap_bar_position.x < weap_bar_position_min)  
		{
			weap_bar_retracting = NO;	
		}
		else if(weap_bar_retracting_dir == BACKWARDS && weap_bar_position.x>MAXW-100)
		{
			weap_bar_retracting = NO;	
		}
		for(int i=0;i<4;i++)
		{
			[weap_bar_buttons[i] move:weap_bar_position.x];
		}
	}
}
-(bool)tokensToLoad
{
	for	(TokenControl* t in ownedTokens)
	{
		if(![[t _token] loaded]) return YES;
	}
	
	return NO;
}
-(void)updateInventory
{
	switch( bar_state)
	{
		case INVENTORY_ACTIVE:
		{
			if(![self tokensToLoad])
				bar_state = INVENTORY_CLOSED;
			
			[self loadTokens];
			tokenStartPos = MAXW+32;
			tokenPos = tokenStartPos;
			bar_state = INVENTORY_OPENING;
			inventory_closed = NO;
		}
			break;
		case INVENTORY_OPENING:
		{
			inventoryPos.y = inventoryPos.y+3;
			if(inventoryPos.y>=INVENTORY_MAX_HEIGHT)
			{
				[tab updateBounds];
				bar_state = INVENTORY_EXPANDING;
				
			}
		}break;
		case INVENTORY_EXPANDING:
		{
			sliderScale+=1;
			if( sliderScale>=12)
			{
				
				weap_bar_active_button = nil;
				inventory_active_token = nil;
				bar_state = INVENTORY_TOKENS_ENTERING;
				tokenStop =  128;
			}
			[ slider setScaleV:Vector2fMake( sliderScale, 1)];
		}break;
			
		case INVENTORY_DEACTIVATE:
		{
			weap_bar_active_button = nil;
			inventory_active_token = nil;
			bar_state = INVENTORY_TOKENS_LEAVING;

		}break;
			
		case INVENTORY_SHRINKING:
		{
			sliderScale-=1;
			if( sliderScale<=SLIDER_MIN_SCALE)
			{
				sliderScale = SLIDER_MIN_SCALE;
				bar_state = INVENTORY_CLOSING;
			}
			[ slider setScaleV:Vector2fMake( sliderScale, 1)];
		}break;
		case INVENTORY_TOKENS_ENTERING:
		{
			tokenPos -= 15;
			if( tokenPos <= tokenStop  ) {tokenPos = tokenStop; bar_state = INVENTORY_OPEN;}
		}
			break;
		case INVENTORY_TOKENS_LEAVING:
		{
			
			tokenPos += 15;
			if( tokenPos>=tokenStartPos || ![self tokensToLoad]){  tokenPos = tokenStartPos;  bar_state = INVENTORY_SHRINKING;  tokensPresent = NO;}
		}
			break;
		case INVENTORY_CLOSING:
		{
			inventoryPos.y = inventoryPos.y-3;
			if(inventoryPos.y<=INVENTORY_MIN_HEIGHT)
			{
				inventoryPos.y=INVENTORY_MIN_HEIGHT;
				inventory_closed = YES;
				[tab updateBounds];
				inventory_active_token = nil;
				weap_bar_active_button = nil;
				bar_state = INVENTORY_CLOSED;
			}
		}break;
			
	}
}
-(void)update:(float)delta
{
	if(firstThrough)
	{
		[super updateWithDelta:delta];
		[self loadImages];
		//[self loadTokens];
		_gamescene = [_director _gameScene];
	}
	
	for(int i=0;i<4;i++)
	{
		[weap_bar_buttons[i] update:delta];
	}
	
	if([_gamescene paused])
	{
		[self updateInventory];	
		[self updateWeaponBar];
		inventoryPos.x = weap_bar_position.x + INVENTORY_WEAPBAR_OFFSET_X;
		[ tab setLocation:Vector2fMake(inventoryPos.x,inventoryPos.y+INVENTORY_TAB_HEIGHT)];
		[tab updateBounds];
		
		[buyAmmo updateWithDelta:delta];
		if(tokensPresent)
		{
			int i = 0;
			for(TokenControl* t in  ownedTokens)
			{
				if( ![ [t _token] loaded] && ![t following])
				{
					Vector2f pt = Vector2fMake( tokenPos + 70*i  , inventoryPos.y);
					[t setLocation:pt];
					[t updateWithDelta:delta];
					i++;
				}
				if(![ [t _token] loaded] && [t following])
				{
					i++;	
				}
			}
		}
	}
	else
	{
		bar_state=INVENTORY_CLOSED;	
	}
}
-(bool)butOn:(int)i
{
	return [weap_bar_buttons[i] active];	
}

-(void)render
{
	if(imagesLoaded)
	{
		if([_gamescene paused])
		{
			[tab render];
			[slider renderAtPoint:Vector2fToCGPoint(inventoryPos) centerOfImage:YES];
			

		}
		
		[_weapBar renderAtPoint:CGPointMake(weap_bar_position.x + 64, weap_bar_position.y - 34)  centerOfImage:NO]; 
		
		for(int i=0;i<4;i++)
		{
			[weap_bar_buttons[i] render];
		}
				
		if(weap_bar_active_button)
		{
			[green_token_highlight renderAtPoint:Vector2fToCGPoint([weap_bar_active_button location]) centerOfImage:YES];
		}
	
		if(inventory_active_token)
		{
			[statsBackgroud	renderAtPoint:CGPointMake(statsPos.x-5, statsPos.y - 32*4) centerOfImage:NO];
		
			Token* tok = [inventory_active_token _token];
			
			[font drawStringAt:CGPointMake(statsPos.x, statsPos.y) text:[NSString stringWithFormat:@"%@ %@",[tok sub_type_name], [tok name]]];
			[font drawStringAt:CGPointMake(statsPos.x, statsPos.y-16) text:[NSString stringWithFormat:@"level %d",[tok token_level]]];
			if(![tok unlimited])[font drawStringAt:CGPointMake(statsPos.x, statsPos.y-32) text:[NSString stringWithFormat:@"inventory count %d",[tok num]]];
			[font drawStringAt:CGPointMake(statsPos.x, statsPos.y-48) text:[NSString stringWithFormat:@"reload rate %g",(float)([tok reloadRate]*0.03f)]];
			
			if(![[inventory_active_token _token]unlimited])
			{
				[buyAmmo render];
				[font drawStringAt:CGPointMake(buyAmmoPos.x - 55, buyAmmoPos.y+52) text:[NSString stringWithFormat:@"$%d=%dx %@s",[tok amoCost],[tok amoAmount],[tok name] ]];
				
			}
			
			switch ([tok token_type]) {
				case MISSLE_TOKEN:
					[font drawStringAt:CGPointMake(statsPos.x, statsPos.y-64) text: [NSString stringWithFormat:@"explosion radius:%g",[(MissileToken*)tok  explosionRadius] ] ];	
					if([tok sub_type]==CLUSTER_MISSLE)
						[font drawStringAt:CGPointMake(statsPos.x, statsPos.y-80) text: [NSString stringWithFormat:@"cluster num:%d",[(MissileToken*)tok  clusterNum] ] ];	
					
					break;
				case LASER_TOKEN:
						//[font drawStringAt:CGPointMake(statsPos.x, statsPos.y-32) text:[NSString stringWithFormat:@"charge capcity %d",]];
					break;
				default:
					break;
			}

			
		}
		if(tokensPresent)
		{
			for(TokenControl* t in ownedTokens)
			{
				if(![[t _token] loaded])
						[t render:NO];
			}
			if(inventory_active_token)
			{
				if(![[inventory_active_token _token] loaded])
					[green_token_highlight renderAtPoint:Vector2fToCGPoint([inventory_active_token location]) centerOfImage:YES];
			}
		}
		
		if(inventory_active_token)
		{
			[inventory_active_token render]; 
		}


	}
//	
	if(SHOW_BOUNDS)
	{
		[super drawBounds];
		//drawRec(weap_bar_retract_button_rec);
		//drawRec(inventory_token_bounds);
		drawRec(weap_bar_bounds);
	}
}

-(void)loadTokens
{
	tokenStartPos = MAXW+32;
	inventoryPos.y=INVENTORY_MIN_HEIGHT;
	tokenPos = tokenStartPos;
	_stats = [_director _statManager];
	if(!tokensPresent)
	{
		tokensPresent = YES;
		[ownedTokens removeAllObjects];
		int i = 0;
		for(Token* t in [_stats tokenInventory])
		{
			if([t owned])
			{ 
				Vector2f pt = Vector2fMake(tokenPos + 40*i  , inventoryPos.y);
				TokenControl* tc = [[TokenControl alloc] initWithImage:tokenImage offset:pt token:t weapShop:NO];
				[ownedTokens addObject:tc];
				i++;
			}
			
		}
	}
	for(int i=0;i<4;i++)
	{
		[weap_bar_buttons[i] loadToken:[_stats getToken:i]];
	}
}

-(void)autoLoad
{
	[self loadTokens];
	int i=0;
	for(TokenControl* t in ownedTokens)
	{
		if(i<4)
		{
			[_stats setActiveToken:i token:[t _token]];
			[weap_bar_buttons[i] loadToken:[t _token]];
		}
		i++;
	}
	//[_stats setQuickPlay:NO];
}

- (bool)hit:(Vector2f)pos press:(int)prs;
{
	bool bhit = NO;
	if(inventory_closed)
	{
	/*	if([_gamescene paused])
		{
			for(int i=0;i<4;i++)
			{
				if([weap_bar_buttons[i] hit:pos press:PRESS_INVENTORY_CLOSED])
				{
					inventory_active_token = weap_bar_buttons[i];	
				}
			}
		}
		else
		{*/
		if(prs==BEGAN_PRESS)
		{

			for(int i=0;i<4;i++)
			{
				[weap_bar_buttons[i] hit:pos press:PRESS_INVENTORY_CLOSED];
			}
			
		}
		if(prs==END_PRESS)
		{
			if( [tab updateWithLocation:pos ] ) 
			{ 
				[self openInventory];
			} else if(inventory_closed)
			{
				for(int i=0;i<4;i++)
				{
					[weap_bar_buttons[i] hit:pos press:RELEASE_INVENTORY_CLOSED];
				}
			}
			
			/*if(!weap_bar_retracting)
			{
				if(ptInRec(pos, weap_bar_retract_button_rec))
				{	
					if(weap_bar_closed) 
						[self openWeapBar]; 
					else 
						[self closeWeapBar]; 
				}
			}*/
			
			
		}
	}
	else if([_gamescene paused])
	{
		
		switch (prs) 
		{
			case BEGAN_PRESS:
			{
				
				if( [tab updateWithLocation:pos ] ) 
				{ 
					[self closeInventory]; //bar_state = INVENTORY_DEACTIVATE;
				}
				else if(ptInRec(pos, inventory_token_bounds) && [self tokensToLoad])
				{
					
							clickStart = pos.x;
							tokenStart = tokenPos;
							if(tokensPresent)
							{
								int i=0;
								
								for(TokenControl* tc in ownedTokens)
								{
									if([tc hit:pos])
									{
										[tc setFollowing:YES];
										
										
										inventory_active_token = tc;
										[inventory_active_token setLocation:pos];
										[tc updateWithLocation:pos];
										bhit = YES;
									}
									else
									{
									
										[tc setTokenHit:NO];
									}
									i++;
								}	
								if(!bhit)
								{
									inventory_active_token = nil;
									weap_bar_active_button = nil;
								}
							}
							
				}	
				else if(ptInRec(pos, weap_bar_bounds))
				{
					for(int i=0;i<4;i++)
					{
						
						if([weap_bar_buttons[i] hit:pos press:RELEASE_INVENTORY_OPEN])
						{
							
							for(TokenControl* tc in ownedTokens)
							{
								if([tc _token] == [weap_bar_buttons[i] token])
								{
									[weap_bar_buttons[i] unloadToken];
									inventory_active_token = tc;
									weap_bar_active_button = nil;
									[inventory_active_token setFollowing:YES];
									[[inventory_active_token _token] setLoaded:NO];	
									[_stats setActiveToken:i token:nil];
								}
							}	
						}
						
						
					}
				}
			

					
			}break;
						
					
			case MOVE_PRESS:
			{
				if(inventory_active_token)[inventory_active_token setLocation:pos];
				if(ptInRec(pos, inventory_token_bounds))
				{
					tokenPos =  tokenStart - ( clickStart - pos.x);	
				}
			}
				break;
				
			case END_PRESS:
						{
							if([buyAmmo updateWithLocation:pos])
							{
								if([_stats addCoins:-[[inventory_active_token _token] amoCost]])
								{
									[[inventory_active_token _token] addAmo:[[inventory_active_token _token] amoAmount]];
								}
							} 
							else if(inventory_active_token)
							{
								[inventory_active_token setFollowing:NO];
								
								 if(ptInRec(pos, weap_bar_bounds))
								{
									for(int i=0;i<4;i++)
									{
										
										if([weap_bar_buttons[i] hit:pos press:RELEASE_INVENTORY_OPEN])
										{
											//token is loaded
											[[inventory_active_token _token] setLoaded:YES];										
											weap_bar_active_button = weap_bar_buttons[i];
											[weap_bar_active_button unloadToken];
											[weap_bar_active_button loadToken:[inventory_active_token _token]];
											[_stats setActiveToken:i token:[inventory_active_token _token]]; 
											bhit = YES;
											for(int j=0;j<4;j++)
											{
												if(j != i)
												{
													if([[weap_bar_buttons[j] token] token_type] == [[weap_bar_active_button token] token_type])
													{
														if([[weap_bar_buttons[j] token] sub_type] == [[weap_bar_active_button token] sub_type])
														{
															[weap_bar_buttons[j] unloadToken];
															[_stats setActiveToken:j token:nil]; 
														}
													}
												}
											}
											

										}
										
										
									}
									
									
							}
								else if(ptInRec(pos, inventory_token_bounds))
								{
									
									[weap_bar_active_button unloadToken];
									[[inventory_active_token _token] setLoaded:NO];
									weap_bar_active_button = nil;
									inventory_active_token = nil;
								}
									else
								{
									weap_bar_active_button = nil;
									inventory_active_token = nil;
								}
							}
						}
				break;
			default:
				break;
			}
			
	}
	

	if([_director tutorialMode])
	{
		switch([_gamescene tutorialStep])
		{
			case GAME_SCENE_TUTORIAL_LOAD_LASER:
			{
				Token* tk = [inventory_active_token _token];
				if([tk token_type]==LASER_TOKEN)
				{
					if([tk sub_type]==STANDARD_LASER)
					{
						if([tk loaded])
							return YES;
						else 
							return NO;
					}
					else return NO;
				}
				else return NO;
			}break;
			case GAME_SCENE_TUTORIAL_LOAD_MISSLE:
				
			{
				Token* tk = [inventory_active_token _token];
				if([tk token_type]==MISSLE_TOKEN)
				{
					if([tk sub_type]==GUIDED_MISSLE)
					{
						if([tk loaded])
							return YES;
						else 
							return NO;

					}
					else return NO;
				}
				else return NO;
			}break;
			case GAME_SCENE_TUTORIAL_START_SHOOTING:
			{
				if([weap_bar_buttons[1] hit:pos press:PRESS_INVENTORY_CLOSED])
					return YES;
				else return NO;
			}
			case GAME_SCENE_TUTORIAL_START:
			case GAME_SCENE_TUTORIAL_CLOSE_INVENTORY:
			{
				if([tab updateWithLocation:pos ])
				{
					if(bar_state==INVENTORY_CLOSED)
						bar_state = INVENTORY_ACTIVE;
					if(bar_state==INVENTORY_OPEN)
						bar_state = INVENTORY_DEACTIVATE;
					
					return YES;
				}
				else return NO;	
			}
				break;
			case GAME_SCENE_TUTORIAL_TAP_MISSLE:
			{
				for(TokenControl* tc in ownedTokens)
				{
					if([tc hit:pos])
					{
						if([[tc _token] token_type]==MISSLE_TOKEN)
							return YES;
						else return NO;
					}
				}		
			}
				break;

			case GAME_SCENE_TUTORIAL_BUY_AMMO:
			{
				if([buyAmmo updateWithLocation:pos])
				{
					if([_stats addCoins:-[[inventory_active_token _token] amoCost]])
					{
						[[inventory_active_token _token] addAmo:[[inventory_active_token _token] amoAmount]];
					}
					return YES;
				}
			} break;
				
				
		}
	}
	
		/*
		if(inventory_active_token && prs == END_PRESS)
		{
			for(int i=0;i<4;i++)
			{

				if([weap_bar_buttons[i] hit:pos press:RELEASE_INVENTORY_OPEN])
				{
					weap_bar_active_button = weap_bar_buttons[i];
					[weap_bar_buttons[i] loadToken:[inventory_active_token _token]];
					[_stats setActiveToken:i token:[inventory_active_token _token]]; 
					
					for(int j=0;j<4;j++)
					{
						if(j != i)
						{
							if([[weap_bar_buttons[j] token] token_type] == [[weap_bar_active_button token] token_type])
							{
								if([[weap_bar_buttons[j] token] sub_type] == [[weap_bar_active_button token] sub_type])
								{
										[weap_bar_buttons[j] unloadToken];
										[_stats setActiveToken:j token:nil]; 
								}
							}
						}
					}
				}
			}
		}
	
			//	[buyAmmo setBoundsSize:Vector2fMake(32, 32)];
			if([buyAmmo updateWithLocation:pos] && prs == END_PRESS)
			{
				if([_stats addCoins:-[[inventory_active_token _token] amoCost]])
				{
					[[inventory_active_token _token] addAmo:[[inventory_active_token _token] amoAmount]];
				}
			} 
			else if(ptInRec(pos, inventory_token_bounds))
			{
				switch(prs)
				{
					case BEGAN_PRESS:
					{
						clickStart = pos.x;
						tokenStart = tokenPos;
						if(tokensPresent)
						{
							for(TokenControl* tc in ownedTokens)
							{
								[tc setHitTime:0];
								if([tc hit:pos])
								{
									[tc setTokenHit:YES];
									bhit=YES;
								}
								else
								{
									[tc setTokenHit:NO];
								}
							}	
						}
						
					}break;
					case END_PRESS:	
					{
						if(tokensPresent)
						{
							int i=0;
							
							for(TokenControl* tc in ownedTokens)
							{
								if([tc hit:pos])
								{
									inventory_active_token = tc;
									[tc updateWithLocation:pos];
									bhit = YES;
									
									
								}
								else
								{
									[tc setTokenHit:NO];
								}
								i++;
							}	
						}
						
						
						
					}break;
					case MOVE_PRESS: 
					{
						tokenPos =  tokenStart - ( clickStart - pos.x);		
					}	break; 			
				}
				
			}
		}
	
			
	if( [tab updateWithLocation:pos ] ) 
	{ 
		switch (bar_state) 
		{
			case INVENTORY_CLOSED:
				bar_state = INVENTORY_ACTIVE;
				
				break;
			case INVENTORY_OPEN:
				bar_state = INVENTORY_DEACTIVATE;
				break;
			default:
				break;
		}
	}

	if(!weap_bar_retracting)
	{
		if(ptInRec(pos, weap_bar_retract_button_rec))
			{	
			if(weap_bar_closed) 
				[self openWeapBar]; 
			else 
				[self closeWeapBar]; 
			}
	}
	
	
	
	if([_director tutorialMode])
	{
		switch(prs)
		{
		case GAME_SCENE_TUTORIAL_LOAD_LASER:
			{
				Token* tk = [inventory_active_token _token];
				if([tk token_type]==LASER_TOKEN)
				{
					if([tk sub_type]==STANDARD_LASER)
					{
						weap_bar_active_button = weap_bar_buttons[1];
						[weap_bar_buttons[1] loadToken:tk];	
						return YES;
					}
					else return NO;
				}
				else return NO;
			}break;
		case GAME_SCENE_TUTORIAL_LOAD_MISSLE:

			{
				Token* tk = [inventory_active_token _token];
				if([tk token_type]==MISSLE_TOKEN)
				{
						if([tk sub_type]==GUIDED_MISSLE)
						{
							weap_bar_active_button = weap_bar_buttons[0];
							[weap_bar_buttons[0] loadToken:tk];	
							return YES;
						}
						else return NO;
				}
				else return NO;
			 }break;
		case GAME_SCENE_TUTORIAL_START_SHOOTING:
			{
				if([weap_bar_buttons[1] hit:pos press:PRESS_INVENTORY_CLOSED])
					return YES;
				else return NO;
			}
		case GAME_SCENE_TUTORIAL_START:
		case GAME_SCENE_TUTORIAL_CLOSE_INVENTORY:
			{
				if([tab updateWithLocation:pos ])
				{
					if(bar_state==INVENTORY_CLOSED)
						bar_state = INVENTORY_ACTIVE;
					if(bar_state==INVENTORY_OPEN)
						bar_state = INVENTORY_DEACTIVATE;
					
					return YES;
				}
				else return NO;	
			}
			break;
			case GAME_SCENE_TUTORIAL_TAP_MISSLE:
			{
				for(TokenControl* tc in ownedTokens)
				{
					if([tc hit:pos])
					{
						
						inventory_active_token = tc;
						[tc updateWithLocation:pos];
						if([[tc _token] token_type]==MISSLE_TOKEN)
							return YES;
						else return NO;
					}
				}		
			}
				break;
			case GAME_SCENE_TUTORIAL_TAP_LASER:
			{
				for(TokenControl* tc in ownedTokens)
				{
					if([tc hit:pos])
					{
						
						inventory_active_token = tc;
						[tc updateWithLocation:pos];
						if([[tc _token] token_type]==LASER_TOKEN)
							return YES;
						else return NO;
					}
				}		
			}
				break;
			case GAME_SCENE_TUTORIAL_BUY_AMMO:
			{
				if([buyAmmo updateWithLocation:pos])
				{
					if([_stats addCoins:-[[inventory_active_token _token] amoCost]])
					{
						[[inventory_active_token _token] addAmo:[[inventory_active_token _token] amoAmount]];
					}
					return YES;
				}
			} break;

				
		}
	}
*/
	
	return bhit;
}

@end
