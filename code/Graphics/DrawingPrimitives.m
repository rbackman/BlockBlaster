/* cocos2d for iPhone
 *
 * http://www.cocos2d-iphone.org
 *
 * Copyright (C) 2008,2009 Ricardo Quesada
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the 'cocos2d for iPhone' license.
 *
 * You will find a copy of this license within the cocos2d for iPhone
 * distribution inside the "LICENSE" file.
 *
 */

#import <OpenGLES/ES1/gl.h>
#import <math.h>
#import <stdlib.h>
#import <string.h>

#import "DrawingPrimitives.h"

void drawPoint( CGPoint point )
{
	glVertexPointer(2, GL_FLOAT, 0, &point);
	//glEnableClientState(GL_VERTEX_ARRAY);
	
	glDrawArrays(GL_POINTS, 0, 1);
	
	//glDisableClientState(GL_VERTEX_ARRAY);	
}

void drawPoints( CGPoint *points, unsigned int numberOfPoints )
{
	glVertexPointer(2, GL_FLOAT, 0, points);
	//glEnableClientState(GL_VERTEX_ARRAY);
	
	glDrawArrays(GL_POINTS, 0, numberOfPoints);
	
	//glDisableClientState(GL_VERTEX_ARRAY);	
}


void drawLine( CGPoint origin, CGPoint destination )
{
	CGPoint vertices[2];
	
	vertices[0] = origin;
	vertices[1] = destination;
	
	glVertexPointer(2, GL_FLOAT, 0, vertices);
	//glEnableClientState(GL_VERTEX_ARRAY);
	
	glDrawArrays(GL_LINES, 0, 2);
	
	//glDisableClientState(GL_VERTEX_ARRAY);
}

void drawTri(Tri t1)
{
	CGPoint tri[3];
	tri[0]=Vector2fToCGPoint(t1.a); tri[1] = Vector2fToCGPoint(t1.b); tri[2] = Vector2fToCGPoint(t1.c);
	drawPoly(tri,3,true);
}
void drawFilledRec(Rec r1)
{
	CGPoint r[4];
	r[0] = Vector2fToCGPoint(r1.a); 
	r[1] = Vector2fToCGPoint(r1.b); 
	r[2] = Vector2fToCGPoint(r1.c);
	r[3] = Vector2fToCGPoint(r1.d);
	drawSolidPoly(r,4,true);
	
}
void drawRec(Rec r1)
{
	CGPoint r[4];
	r[0] = Vector2fToCGPoint(r1.a); 
	r[1] = Vector2fToCGPoint(r1.b); 
	r[2] = Vector2fToCGPoint(r1.c);
	r[3] = Vector2fToCGPoint(r1.d);
	drawPoly(r,4,true);
}
void drawCGRec(CGRect rec)
{
	
	
	float minx = rec.origin.x - rec.size.width/2;
	float maxx = rec.origin.x + rec.size.width/2;
	float miny = rec.origin.y - rec.size.height/2;
	float maxy = rec.origin.y + rec.size.height/2;
	
	
	CGPoint r[4];
	r[0] = CGPointMake(minx, miny); 
	r[1] = CGPointMake(minx, maxy); 
	r[2] = CGPointMake(maxx, maxy); 
	r[3] = CGPointMake(maxx, miny); 
	drawPoly(r,4,true);
	
}

void drawPoly( CGPoint *poli, int points, bool closePolygon )
{
	glDisable(GL_TEXTURE_2D)	;
	
	glVertexPointer(2, GL_FLOAT, 0, poli);
	//glEnableClientState(GL_VERTEX_ARRAY);
	
	glLineWidth(2);
	glColor4f(0, 1, 0, 1);
	glDisable(GL_BLEND);
	
	if( closePolygon )
		glDrawArrays(GL_LINE_LOOP, 0, points);
	else
		glDrawArrays(GL_LINE_STRIP, 0, points);
	
	//glDisableClientState(GL_VERTEX_ARRAY);

	glEnable(GL_TEXTURE_2D);
	
}

void drawSolidPoly( CGPoint *poli, int points, bool closePolygon )
{
	glVertexPointer(2, GL_FLOAT, 0, poli);
	//glEnableClientState(GL_VERTEX_ARRAY);
	
	
	glDrawArrays(GL_TRIANGLE_FAN , 0, points);
	//glDisableClientState(GL_VERTEX_ARRAY);
}

void drawCircle( CGPoint center, float r, float a, int segs, bool drawLineToCenter)
{
	int additionalSegment = 1;
	if (drawLineToCenter)
		additionalSegment++;

	const float coef = 2.0f * (float)M_PI/segs;
	
	float *vertices = malloc( sizeof(float)*2*(segs+2));
	if( ! vertices )
		return;
	
	memset( vertices,0, sizeof(float)*2*(segs+2));
	
	for(int i=0;i<=segs;i++)
	{
		float rads = i*coef;
		float j = r * cosf(rads + a) + center.x;
		float k = r * sinf(rads + a) + center.y;
		
		vertices[i*2] = j;
		vertices[i*2+1] =k;
	}
	vertices[(segs+1)*2] = center.x;
	vertices[(segs+1)*2+1] = center.y;
	
	glVertexPointer(2, GL_FLOAT, 0, vertices);
	//glEnableClientState(GL_VERTEX_ARRAY);
	
	glDrawArrays(GL_LINE_STRIP, 0, segs+additionalSegment);
	
	//glDisableClientState(GL_VERTEX_ARRAY);
	
	free( vertices );
}

void drawQuadBezier(CGPoint origin, CGPoint control, CGPoint destination, int segments)
{
	CGPoint vertices[segments + 1];
	
	float t = 0.0f;
	for(int i = 0; i < segments; i++)
	{
		float x = powf(1 - t, 2) * origin.x + 2.0f * (1 - t) * t * control.x + t * t * destination.x;
		float y = powf(1 - t, 2) * origin.y + 2.0f * (1 - t) * t * control.y + t * t * destination.y;
		vertices[i] = CGPointMake(x, y);
		t += 1.0f / segments;
	}
	vertices[segments] = destination;
	
	glVertexPointer(2, GL_FLOAT, 0, vertices);
	//glEnableClientState(GL_VERTEX_ARRAY);
	
	glDrawArrays(GL_LINE_STRIP, 0, segments + 1);
	
	//glDisableClientState(GL_VERTEX_ARRAY);
}

void drawCubicBezier(CGPoint origin, CGPoint control1, CGPoint control2, CGPoint destination, int segments)
{
	CGPoint vertices[segments + 1];
	
	float t = 0;
	for(int i = 0; i < segments; i++)
	{
		float x = powf(1 - t, 3) * origin.x + 3.0f * powf(1 - t, 2) * t * control1.x + 3.0f * (1 - t) * t * t * control2.x + t * t * t * destination.x;
		float y = powf(1 - t, 3) * origin.y + 3.0f * powf(1 - t, 2) * t * control1.y + 3.0f * (1 - t) * t * t * control2.y + t * t * t * destination.y;
		vertices[i] = CGPointMake(x, y);
		t += 1.0f / segments;
	}
	vertices[segments] = destination;
	
	glVertexPointer(2, GL_FLOAT, 0, vertices);
	//glEnableClientState(GL_VERTEX_ARRAY);
	
	glDrawArrays(GL_LINE_STRIP, 0, segments + 1);
	
	//glDisableClientState(GL_VERTEX_ARRAY);  
}
