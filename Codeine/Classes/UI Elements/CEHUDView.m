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

#import "CEHUDView.h"

@implementation CEHUDView

- ( id )initWithFrame: ( NSRect )frame
{
    CGFloat h;
    CGFloat s;
    CGFloat b;
    
    if( ( self = [ super initWithFrame: frame ] ) )
    {
        _cornerRadius     = ( CGFloat )10;
        _backgroundColor1 = [ [ [ NSColor lightGrayColor ] colorUsingColorSpaceName: NSDeviceRGBColorSpace ] retain ];
        _textColor        = [ [ NSColor whiteColor ] retain ];
        _font             = [ [ NSFont boldSystemFontOfSize: [ NSFont smallSystemFontSize ] ] retain ];
        
        [ _backgroundColor1 getHue: &h saturation: &s brightness: &b alpha: NULL ];
        
        _backgroundColor2 = [ [ NSColor colorWithDeviceHue: h saturation: s brightness: b - ( CGFloat )0.1 alpha: ( CGFloat )1 ] retain ];
    }
    
    return self;
}

- ( void )dealloc
{
    RELEASE_IVAR( _backgroundColor1 );
    RELEASE_IVAR( _backgroundColor2 );
    RELEASE_IVAR( _textColor );
    RELEASE_IVAR( _font );
    RELEASE_IVAR( _title );
    
    [ super dealloc ];
}

- ( CGFloat )cornerRadius
{
    @synchronized( self )
    {
        return _cornerRadius;
    }
}

- ( NSColor * )backgroundColor1
{
    @synchronized( self )
    {
        return _backgroundColor1;
    }
}

- ( NSColor * )backgroundColor2
{
    @synchronized( self )
    {
        return _backgroundColor2;
    }
}

- ( NSColor * )textColor
{
    @synchronized( self )
    {
        return _textColor;
    }
}

- ( NSFont * )font
{
    @synchronized( self )
    {
        return _font;
    }
}

- ( NSString * )title
{
    @synchronized( self )
    {
        return _title;
    }
}

- ( void )setCornerRadius: ( CGFloat )cornerRadius
{
    @synchronized( self )
    {
        _cornerRadius = cornerRadius;
        
        [ self setNeedsDisplay: YES ];
    }
}

- ( void )setBackgroundColor1: ( NSColor * )color
{
    @synchronized( self )
    {
        if( color != _backgroundColor1 )
        {
            [ _backgroundColor1 release ];
            
            _backgroundColor1 = [ [ color colorUsingColorSpaceName: NSDeviceRGBColorSpace ] retain ];
            
            [ self setNeedsDisplay: YES ];
        }
    }
}

- ( void )setBackgroundColor2: ( NSColor * )color
{
    @synchronized( self )
    {
        if( color != _backgroundColor2 )
        {
            [ _backgroundColor2 release ];
            
            _backgroundColor2 = [ [ color colorUsingColorSpaceName: NSDeviceRGBColorSpace ] retain ];
            
            [ self setNeedsDisplay: YES ];
        }
    }
}

- ( void )setTextColor: ( NSColor * )color
{
    @synchronized( self )
    {
        if( color != _textColor )
        {
            [ _textColor release ];
            
            _textColor = [ [ color colorUsingColorSpaceName: NSDeviceRGBColorSpace ] retain ];
            
            [ self setNeedsDisplay: YES ];
        }
    }
}

- ( void )setFont: ( NSFont * )font
{
    @synchronized( self )
    {
        if( font != _font )
        {
            [ _font release ];
            
            _font = [ font retain ];
            
            [ self setNeedsDisplay: YES ];
        }
    }
}

- ( void )setTitle: ( NSString * )title
{
    @synchronized( self )
    {
        if( title != _title )
        {
            [ _title release ];
            
            _title = [ title copy ];
            
            [ self setNeedsDisplay: YES ];
        }
    }
}

- ( void )drawRect: ( NSRect )rect
{
    NSBezierPath            * path;
    NSGradient              * gradient;
    NSMutableDictionary     * attributes;
    NSMutableParagraphStyle * paragraphStyle;
    NSSize                    size;
    
    path     = [ NSBezierPath bezierPath ];
    gradient = [ [ NSGradient alloc ] initWithColorsAndLocations: _backgroundColor1, ( CGFloat )0, _backgroundColor2, ( CGFloat )1, nil ];
    
    [ path appendBezierPathWithRoundedRect: rect xRadius: _cornerRadius yRadius: _cornerRadius ];
    [ gradient drawInBezierPath: path angle: ( CGFloat )-90 ];
    [ gradient release ];
    attributes     = [ NSMutableDictionary dictionaryWithCapacity: 10 ];
    paragraphStyle = [ [ [ NSParagraphStyle defaultParagraphStyle ] mutableCopy ] autorelease ];
    
    [ paragraphStyle setAlignment: NSCenterTextAlignment ];
    [ paragraphStyle setLineBreakMode: NSLineBreakByTruncatingMiddle ];
    
    [ attributes setObject: _textColor              forKey: NSForegroundColorAttributeName ];
    [ attributes setObject: [ NSColor clearColor ]  forKey: NSBackgroundColorAttributeName ];
    [ attributes setObject: paragraphStyle          forKey: NSParagraphStyleAttributeName ];
    [ attributes setObject: _font                   forKey: NSFontAttributeName ];
    
    size              = [ _title sizeWithAttributes: attributes ];
    rect.size.height -= ( rect.size.height - size.height ) / ( CGFloat )2;
    
    [ _title drawInRect: rect withAttributes: attributes ];
}

@end
