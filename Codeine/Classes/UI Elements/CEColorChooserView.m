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

#import "CEColorChooserView.h"
#import "CEColorChooserView+Private.h"
#import "CEPreferences.h"

@implementation CEColorChooserView

@synthesize backgroundColor     = _backgroundColor;
@synthesize representedObject   = _representedObject;
@synthesize delegate            = _delegate;

- ( void )dealloc
{
    [ _backgroundColor  release ];
    [ _foregroundColor  release ];
    [ _color            release ];
    [ _title            release ];
    [ _font             release ];
    [ _textField        release ];
    [ _colorWell        release ];
    
    [ super dealloc ];
}

- ( void )drawRect: ( NSRect )rect
{
    [ _backgroundColor setFill ];
    
    NSRectFill( rect );
}

- ( void )setFrame: ( NSRect )frame
{
    [ super setFrame: frame ];
    
    if( NSEqualRects( frame, NSZeroRect ) )
    {
        return;
    }
    
    if( _textField == nil )
    {
        {
            NSRect colorWellFrame;
            NSRect textFieldFrame;
            NSSize size;
            
            colorWellFrame = NSMakeRect
            (
                ( CGFloat )0,
                ( CGFloat )2,
                frame.size.height - ( CGFloat )4,
                frame.size.height - ( CGFloat )4
            );
            
            colorWellFrame.origin.x = ( frame.size.width - colorWellFrame.size.width ) - ( CGFloat )2;
            
            _colorWell = [ [ NSColorWell alloc ] initWithFrame: colorWellFrame ];
            
            [ _colorWell setColor:  _color ];
            [ _colorWell setTarget: self ];
            [ _colorWell setAction: @selector( changeColor: ) ];
            
            size           = [ _title sizeWithAttributes: [ NSDictionary dictionaryWithObject: _font forKey: NSFontAttributeName ] ];
            textFieldFrame = NSMakeRect
            (
                ( frame.size.height - size.height ) / ( CGFloat )2,
                ( frame.size.height - size.height ) / ( CGFloat )2,
                frame.size.width - colorWellFrame.size.width - ( ( frame.size.height - size.height ) / ( CGFloat )2 ),
                size.height
            );
            
            _textField                  = [ [ NSTextField alloc ] initWithFrame: textFieldFrame ];
            _textField.textColor        = _foregroundColor;
            _textField.backgroundColor  = [ NSColor clearColor ];
            _textField.stringValue      = _title;
            
            [ _textField setEditable:   NO ];
            [ _textField setSelectable: NO ];
            [ _textField setBezeled:    NO ];
            [ _textField setFont:       _font ];
            
            [ self addSubview: _textField ];
            [ self addSubview: _colorWell ];
        }
    }
}

- ( NSColor * )foregroundColor
{
    @synchronized( self )
    {
        return _foregroundColor;
    }
}

- ( NSColor * )color
{
    @synchronized( self )
    {
        return _color;
    }
}

- ( NSString * )title
{
    @synchronized( self )
    {
        return _title;
    }
}

- ( NSFont * )font
{
    @synchronized( self )
    {
        return _font;
    }
}

- ( void )setForegroundColor: ( NSColor * )foregroundColor
{
    @synchronized( self )
    {
        if( _foregroundColor != foregroundColor )
        {
            RELEASE_IVAR( _foregroundColor );
            
            _foregroundColor = [ foregroundColor retain ];
            
            if( _textField != nil )
            {
                _textField.textColor = _foregroundColor;
            }
        }
    }
}

- ( void )setColor: ( NSColor * )color
{
    @synchronized( self )
    {
        if( _color != color )
        {
            RELEASE_IVAR( _color );
            
            _color = [ color retain ];
            
            if( _colorWell != nil )
            {
                _colorWell.color = _color;
            }
        }
    }
}

- ( void )setTitle: ( NSString * )title
{
    @synchronized( self )
    {
        if( _title != title )
        {
            RELEASE_IVAR( _title );
            
            _title = [ title copy ];
            
            if( _textField != nil )
            {
                _textField.stringValue = _title;
            }
        }
    }
}

- ( void )setFont: ( NSFont * )font
{
    @synchronized( self )
    {
        if( _font != font )
        {
            RELEASE_IVAR( _font );
            
            _font = [ font retain ];
            
            if( _textField != nil )
            {
                _textField.font = _font;
            }
        }
    }
}

@end
