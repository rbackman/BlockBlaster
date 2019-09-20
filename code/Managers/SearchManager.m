//
//  SearchManager.m
//  BlockBlaster
//
//  Created by Robert backman on 12/9/2009.
//  Copyright 2009 Robert Backman. All rights reserved.
//


#import "SearchManager.h"
#import "Common.h"
#import "SynthesizeSingleton.h"
#import "Image.h"
#import "AbstractEntity.h"
#import "SpriteSheet.h"
#import "DrawingPrimitives.h"
#import "BezierCurve.h"
#import "GameScene.h"
#import "Block.h"

@implementation SearchManager



SYNTHESIZE_SINGLETON_FOR_CLASS(SearchManager);

@synthesize _spriteSheet16;
@synthesize pathFound;
@synthesize first;
@synthesize last;
@synthesize expanding;
@synthesize startEndFound;

- (void)dealloc 
{
	[_searchNodes release];
	[front_nodes release];
	[super dealloc];
}


- (id)init {
	self = [super init];
	if (self != nil) 
	{
		_searchNodes = [[NSMutableArray alloc]init];
		curCol = 0;
		pathFound = NO;
		startEndFound = NO;
		expanding = NO;
		
		front_nodes = [[NSMutableArray alloc] init];
	}
	return self;
}


-(void)newCol
{
	curCol++;	
	//should update connections here
}

-(void)updateQueue
{
	if(expanding)
	{
		//first find the node with the minimum weight to expand
		minWeight=500;
		for(SearchNode* n in front_nodes)
		{
			if([n weight]<minWeight) minWeight = [n weight];
		}
		
		//expand all the nodes that have the lowest weight
		NSMutableArray* discardedNodes = [[NSMutableArray alloc] init];	
		for(SearchNode* n in front_nodes)
		{
			if([n weight]==minWeight)
			{ 
				[discardedNodes addObject:n];
			}
		}
		
		//expand all the nodes that are to be remove
		expanding = NO;
		for(SearchNode* n in discardedNodes)
		{
			if([self expandNode:n]) expanding = YES;
		}
		//remove them from the queue
		[front_nodes removeObjectsInArray:discardedNodes];
	}
	
}

-(void) add:(SearchNode*)n parent:(SearchNode*)prnt
{
	
	//[n setColor:RED];
	[n setVisited:YES];
	
	if(prnt)
	{
		[n setParent:prnt];
		[n setWeight:[prnt weight]+1];
	}
	else [n setWeight:1];
	
	[front_nodes addObject:n];
}

-(void)reset
{
	minWeight = 500;
	pathFound = NO;
	expanding = YES;
	startEndFound = NO;
	closestDisStart=300;
	closestDisEnd = 300;
	[front_nodes removeAllObjects];

}

-(void)addNode:(int)ht pos:(Vector2f)p
{
	SearchNode* n = [SearchNode alloc];
	[n initWithLocation:p spritesheet:_spriteSheet16 height:ht column:curCol blocked:NO];
	[_searchNodes addObject:n];
	[n release];
}

-(void)addBlockedNode:(int)ht pos:(Vector2f)p ent:(Block*)ent 
{
	SearchNode* n = [SearchNode alloc];
	[n initWithLocation:p spritesheet:_spriteSheet16 height:ht column:curCol blocked:YES];
 //TODO: fix this if you want search
	//[n setParent:(AbstractEntity*)ent];
	[ent setSearchNode:n];
	
	[_searchNodes addObject:n];
	[n release];
}


-(void)updateNodes:(float)delta
{
	for(SearchNode* n in _searchNodes)
	{
		[n update:delta];
	}
}

-(bool)findStartEnd:(AbstractEntity*)start to:(AbstractEntity*)end
{	
	origin = start;
	destination = end;
	startEndFound = NO;
	
	for(SearchNode* n in _searchNodes)
	{
		if(![n blocked])
		{
			float ds = Vector2fDistance([start position], [n position]);
			float de = Vector2fDistance([end position], [n position]);
			if(ds<closestDisStart)
			{
				closestDisStart = ds;
				first = n;
			}
			if(de<closestDisEnd)
			{
				 closestDisEnd = de;
				last = n;
			}
		}
	}
	
	if(closestDisStart< 300 && closestDisEnd <300) 
	{

			[destination setBeenTargeted:YES];
			startEndFound = YES; 

	}
return startEndFound;
}

-(bool) expandNode:(SearchNode*)n {
	bool expandable = NO;
	if(n == last)
	{
		pathFound = YES;
		expanding = NO;
		//	printf("found the end\n"); //expandable =  false;//found end
	}
	else
	{
		
		if([n r])
		{
			if(![[n r] blocked] && ![[n r] visited]) 
			{
				[self add:[n r] parent:n]; 
				expandable = true;
			}
		}
		if(![n lgone])
			if([n l])
			{
				if(![[n l] blocked] && ![[n l] visited])
				{
					[self add:[n l] parent:n]; 
					expandable = true;
				}
			}
		if([n u])
		{
			if(![[n u] blocked] && ![[n u] visited]) {
				[self add:[n u] parent:n]; 
				expandable =  true;
			}
		}
		if([n d])
		{
			if(![[n d] blocked]&& ![[n d] visited]) {
				[self add:[n d] parent:n]; 
				expandable =  true;
			}
		}
		
	}
	return expandable;
}

-(void)runSearch
{
	if(startEndFound)
	{
		[self reset];
		for(SearchNode* n in _searchNodes)
		{
			[n setVisited:NO];	
			[n setWeight:500];
		}
		int count = 0;
		[self add:first parent:nil];
		while(expanding && !pathFound && count++ < 12) [self updateQueue];	
	}	
}

-(void)update
{
	
	NSMutableArray *discardedNodes = [NSMutableArray array];
	
	for(SearchNode* n1 in _searchNodes)
		{
			
			if(![n1 alive]) 
			{
				[[n1 r] setLgone:YES];
				[discardedNodes addObject:n1];
			}
			else
			{
				int h1,c1;
				h1 = [n1 ht];
				c1 = [n1 col];
				
					for(SearchNode* n2 in _searchNodes)
					{
						int h2,c2;
						h2 = [n2 ht];
						c2 = [n2 col];
						if(h2==h1 && c2==c1)
						{
							//same node
						}
						else
						{
							if(c2 == c1-1 && h1 == h2) //left node
							{
								[n1 setL:n2];
								[n2 setR:n1];
							}
							if(c2 == c1+1 && h1 == h2) //right node
							{
								[n1 setR:n2];
								[n2 setL:n1];
							}
							if(c2 == c1 && h2 == h1+1) //up node
							{
								[n1 setU:n2];
								[n2 setD:n1];
							}
							if(c2 == c1 && h2 == h1-1) //down node
							{
								[n1 setD:n2];
								[n2 setU:n1];
							}
					
						}
					}
				
			}
		}
	
	[_searchNodes removeObjectsInArray:discardedNodes];			
}
-(bool)getPath:(NSMutableArray*)pth
{
	if(pathFound)
	{
		SearchNode* nextNode = last;
		int cnt = 0;
		NSMutableArray* pthTemp = [[NSMutableArray alloc] init];
		
		while(nextNode != first ) 
		{
			if([nextNode parent])
			{
				[pthTemp addObject:nextNode];
				nextNode = [nextNode parent];
				cnt++;
			}
			else{
				printf("parent node disapeared\n");
			}
			
		}
		
		for(int i=1;i<=cnt;i++)
		{
			[pth addObject:[pthTemp objectAtIndex:cnt-i]];	
		}
	}
	return pathFound;
}
-(void)render
{
	//if(pathFound)
	//	drawLine(Vector2fToCGPoint([first position]),Vector2fToCGPoint( [last position] ));
	

	if( pathFound )
	{
		//Vector2f ca,cb,cc,cd;
	//	int cnt =0;
		SearchNode* nextNode = last;
		while(nextNode != first ) 
			{
				
			/*	switch(cnt)
				{
					case 0: ca = [nextNode position]; break;
					case 1: cb = [nextNode position]; break;
					case 2: cc = [nextNode position]; break;
					case 3: {
						cd = [nextNode position]; cnt = 0;
						BezierCurve* curve = [[BezierCurve alloc] initCurveFrom:ca controlPoint1:cb controlPoint2:cc endPoint:cd segments:6];
						[curve render];
						[curve release];
					}break;
				}
				cnt++;
				*/
				if([nextNode parent])
				{
				drawLine(Vector2fToCGPoint([nextNode position]),Vector2fToCGPoint( [ [nextNode parent] position] ));
				nextNode = [nextNode parent];
				}
				else{
					printf("parent node disapeared\n");
				}
				
			}
		drawLine(Vector2fToCGPoint([origin position]),Vector2fToCGPoint( [ first position] ));
		drawLine(Vector2fToCGPoint([destination position]),Vector2fToCGPoint( [ last position] ));
	}
if(SEARCH_DEBUG)for(SearchNode* n in _searchNodes) [n render];
//	for(SearchNode* n in front_nodes) [n render];
}

@end
