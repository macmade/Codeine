/*******************************************************************************
 * Copyright (c) 2012, Jean-David Gadina - www.xs-labs.com
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 *  -   Redistributions of source code must retain the above copyright notice,
 *      this list of conditions and the following disclaimer.
 *  -   Redistributions in binary form must reproduce the above copyright
 *      notice, this list of conditions and the following disclaimer in the
 *      documentation and/or other materials provided with the distribution.
 *  -   Neither the name of 'Jean-David Gadina' nor the names of its
 *      contributors may be used to endorse or promote products derived from
 *      this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 ******************************************************************************/
 
/* $Id$ */

#import "CEColorLabelView.h"

static NSString * const __trackingKey = @"CEColorLabelViewTrackingKey";

@implementation CEColorLabelView

@synthesize delegate = _delegate;

- ( id )init
{
    if( ( self = [ self initWithFrame: NSMakeRect( ( CGFloat )0, ( CGFloat )0, ( CGFloat )200, ( CGFloat )50 ) ] ) )
    {}
    
    return self;
}

- ( id )initWithFrame: ( NSRect )frame
{
    if( ( self = [ super initWithFrame: frame ] ) )
    {
        _colors   = [ [ WORKSPACE fileLabelColors ] retain ];
        _labels   = [ [ WORKSPACE fileLabels      ] retain ];
        _tracking = [ [ NSMutableArray alloc ] initWithCapacity: _colors.count ];
        
        if( _colors.count != _labels.count )
        {
            [ self release ];
            
            return nil;
        }
        
        _trackingColorIndex = NSNotFound;
        _selectedColorIndex = 0;
    }
    
    return self;
}

- ( id )initWithCoder: ( NSCoder * )coder
{
    if( ( self = [ super initWithCoder: coder ] ) )
    {
        _colors   = [ [ WORKSPACE fileLabelColors ] retain ];
        _labels   = [ [ WORKSPACE fileLabels      ] retain ];
        _tracking = [ [ NSMutableArray alloc ] initWithCapacity: _colors.count ];
        
        if( _colors.count != _labels.count )
        {
            [ self release ];
            
            return nil;
        }
        
        _trackingColorIndex = NSNotFound;
        _selectedColorIndex = 0;
    }
    
    return self;
}

- ( void )dealloc
{
    NSTrackingArea * area;
    
    for( area in _tracking )
    {
        [ self removeTrackingArea: area ];
    }
    
    RELEASE_IVAR( _colors );
    RELEASE_IVAR( _labels );
    RELEASE_IVAR( _tracking );
    RELEASE_IVAR( _selectedColor );
    
    [ super dealloc ];
}

- ( NSColor * )selectedColor
{
    @synchronized( self )
    {
        return _selectedColor;
    }
}

- ( void )setSelectedColor: ( NSColor * )color
{
    NSColor  * availableColor;
    NSUInteger i;
    
    @synchronized( self )
    {
        if( _selectedColor != color )
        {
            RELEASE_IVAR( _selectedColor );
            
            _selectedColorIndex = NSNotFound;
            _selectedColor      = [ color retain ];
            i                   = 0;
            
            for( availableColor in _colors )
            {
                if( [ availableColor isEqual: color ] )
                {
                    _selectedColorIndex = i;
                    break;
                }
                
                i++;
            }
        }
        
        if( _selectedColorIndex == NSNotFound )
        {
            _selectedColorIndex = 0;
        }
    }
}

- ( void )mouseEntered: ( NSEvent * )event
{
    NSDictionary * data;
    NSNumber     * index;
    
    data  = event.userData;
    index = [ data objectForKey: __trackingKey ];
    
    if( index == nil )
    {
        _trackingColorIndex = NSNotFound;
    }
    else
    {
        _trackingColorIndex = [ index unsignedIntegerValue ];
    }
    
    [ self setNeedsDisplay: YES ];
}

- ( void )mouseExited: ( NSEvent * )event
{
    ( void )event;
    
    _trackingColorIndex = NSNotFound;
    
    [ self setNeedsDisplay: YES ];
}

- ( void )mouseDown: ( NSEvent * )event
{
    ( void )event;
    
    if( _trackingColorIndex != NSNotFound && _trackingColorIndex < _colors.count )
    {
        _selectedColorIndex = _trackingColorIndex;
        _trackingColorIndex = NSNotFound;
        
        [ self setNeedsDisplay: YES ];
        
        if( _delegate != nil && [ _delegate respondsToSelector: @selector( colorLabelView:didSelectColor: ) ] )
        {
            [ _delegate colorLabelView: self didSelectColor: [ _colors objectAtIndex: _selectedColorIndex ] ];
        }
    }
}

- ( void )drawRect: ( NSRect )rect
{
    NSColor         * color;
    NSString        * label;
    NSUInteger        i;
    NSRect            colorRect;
    NSRect            dotRect;
    NSGradient      * gradient;
    NSBezierPath    * path;
    CGFloat           r;
    CGFloat           g;
    CGFloat           b;
    NSFont          * font;
    
    ( void )rect;
    
    font = [ NSFont menuFontOfSize: 14 ];
    
	[ L10N( "Label" ) drawAtPoint: NSMakePoint( ( CGFloat )20, ( CGFloat )30 ) withAttributes: [ NSDictionary dictionaryWithObject: font forKey: NSFontAttributeName ] ];
    
    i = 0;
    
    for( color in _colors )
    {
        label = [ _labels objectAtIndex: i ];
        
        color = [ color colorUsingColorSpaceName: NSDeviceRGBColorSpace ];
        r     = ( CGFloat )0;
        g     = ( CGFloat )0;
        b     = ( CGFloat )0;
        
        [ color getHue: &r saturation: &g brightness: &b alpha: NULL ];
        
        colorRect.origin.x    = ( CGFloat )20 * ( CGFloat )( i + 1 );
        colorRect.origin.y    = ( CGFloat )5;
        colorRect.size.width  = ( CGFloat )16;
        colorRect.size.height = ( CGFloat )16;
        
        dotRect  = NSInsetRect( colorRect, ( CGFloat )2, ( CGFloat )2 );
        
        if( _tracking.count == i )
        {
            {
                NSTrackingAreaOptions options;
                NSDictionary        * trackInfo;
                NSTrackingArea      * area;
                
                trackInfo = [ NSDictionary dictionaryWithObject: [ NSNumber numberWithUnsignedInteger: i ] forKey: __trackingKey ];
                options   = NSTrackingEnabledDuringMouseDrag
                          | NSTrackingMouseEnteredAndExited
                          | NSTrackingActiveInActiveApp
                          | NSTrackingActiveAlways;
                area      = [ [ NSTrackingArea alloc ] initWithRect: colorRect options: options owner: self userInfo: trackInfo ];
                
                [ _tracking addObject: area ];
                [ self addTrackingArea: area ];
                [ area release ];
            }
        }
        
        if( _trackingColorIndex == i )
        {
            {
                NSDictionary * attributes;
                
                attributes = [ NSDictionary dictionaryWithObjectsAndKeys:   font,   NSFontAttributeName,
                                                                            color,  NSForegroundColorAttributeName,
                                                                            nil
                             ];
                
                [ label drawAtPoint: NSMakePoint( ( CGFloat )70, ( CGFloat )30 ) withAttributes: attributes ];
            }
        }
        
        if( _trackingColorIndex == i || _selectedColorIndex == i )
        {
            {
                NSRect highlightRect;
                
                highlightRect = NSMakeRect( dotRect.origin.x - 3, dotRect.origin.y - 3, dotRect.size.width + 6, dotRect.size.height + 6 );
                
                path     = [ NSBezierPath bezierPathWithOvalInRect: highlightRect ];
                gradient = [ [ NSGradient alloc ] initWithStartingColor:    [ NSColor colorWithCalibratedWhite: ( CGFloat )0 alpha: ( CGFloat )0.1 ]
                                                  endingColor:              [ NSColor colorWithCalibratedWhite: ( CGFloat )0 alpha: ( CGFloat )0.5 ]
                           ];
                           
                [ path appendBezierPath: [ NSBezierPath bezierPathWithOvalInRect: NSInsetRect( highlightRect, ( CGFloat )1, ( CGFloat )1 ) ] ];
                [ path setWindingRule: NSEvenOddWindingRule ];
                [ gradient drawInBezierPath: path angle: ( CGFloat )-90 ];
                [ gradient release ];
            }
        }
        
        if( _selectedColorIndex == i )
        {
            {
                NSRect selectedRect;
                
                selectedRect = NSMakeRect( dotRect.origin.x - 2, dotRect.origin.y - 2, dotRect.size.width + 4, dotRect.size.height + 4 );
                
                path     = [ NSBezierPath bezierPathWithOvalInRect: selectedRect ];
                gradient = [ [ NSGradient alloc ] initWithStartingColor:    [ NSColor colorWithCalibratedWhite: ( CGFloat )0.25 alpha: ( CGFloat )0.1 ]
                                                  endingColor:              [ NSColor colorWithCalibratedWhite: ( CGFloat )0.25 alpha: ( CGFloat )0.5 ]
                           ];
                
                [ path appendBezierPath: [ NSBezierPath bezierPathWithOvalInRect: NSInsetRect( dotRect, ( CGFloat )1, ( CGFloat )1 ) ] ];
                [ path setWindingRule: NSEvenOddWindingRule ];
                [ gradient drawInBezierPath: path angle: ( CGFloat )-90 ];
                [ gradient release ];
            }
        }
        
        if( r > ( CGFloat )0 && b > ( CGFloat )0 && b > ( CGFloat )0 )
        {
            path     = [ NSBezierPath bezierPathWithOvalInRect: dotRect ];
            gradient = [ [ NSGradient alloc ] initWithColorsAndLocations:   [ NSColor whiteColor ], ( CGFloat )0.0,
                                                                            color,                  ( CGFloat )1.0,
                                                                            nil
                       ];
            
            [ gradient drawInBezierPath: path angle: ( CGFloat )-90 ];
            [ gradient release ];
        }
        
		path     = [ NSBezierPath bezierPathWithOvalInRect: dotRect ];
		gradient = [ [ NSGradient alloc ] initWithStartingColor:    [ NSColor colorWithCalibratedWhite: ( CGFloat )0 alpha: ( CGFloat )0.1 ]
                                          endingColor:              [ NSColor colorWithCalibratedWhite: ( CGFloat )0 alpha: ( CGFloat )0.5 ]
                   ];
        
		[ path appendBezierPath: [ NSBezierPath bezierPathWithOvalInRect: NSInsetRect( dotRect, ( CGFloat )1, ( CGFloat )1 ) ] ];
		[ path setWindingRule: NSEvenOddWindingRule ];
        [ gradient drawInBezierPath: path angle: ( CGFloat )-90 ];
        [ gradient release ];
        
        i++;
    }
}

@end
