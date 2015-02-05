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

#import "CEEditorTextView+Private.h"
#import "CEPreferences.h"
#import "CEEditorLayoutManager.h"

@implementation CEEditorTextView( Private )

- ( void )drawPageGuideInRect: ( NSRect )rect
{
    CGFloat     margin;
    CGSize      size;
    NSRect      lineRect;
    NSColor   * backgroundColor;
    NSColor   * color;
    CGFloat     h;
    CGFloat     s;
    CGFloat     b;
    
    margin = [ ( CEEditorLayoutManager * )( self.layoutManager ) firstGlyphLeftMargin ];
    size   = [ ( CEEditorLayoutManager * )( self.layoutManager ) glyphSize ];
    
    h               = ( CGFloat )0;
    s               = ( CGFloat )0;
    b               = ( CGFloat )0;
    backgroundColor = [ [ [ CEPreferences sharedInstance ] backgroundColor ] colorUsingColorSpaceName: NSDeviceRGBColorSpace ];
    
    [ backgroundColor getHue: &h saturation: &s brightness: &b alpha: NULL ];
    
    if( b < ( CGFloat )0.5 )
    {
        color = [ NSColor colorWithDeviceHue: h saturation: s brightness: b + ( CGFloat )0.2 alpha: 1 ];
    }
    else
    {
        color = [ NSColor colorWithDeviceHue: h saturation: s brightness: b - ( CGFloat )0.2 alpha: 1 ];
    }
    
    lineRect            = rect;
    lineRect.origin.x   = margin + ( size.width * ( CGFloat )[ [ CEPreferences sharedInstance ] pageGuideColumn ] );
    lineRect.size.width = ( CGFloat )1;
    
    [ color setFill ];
    
    NSRectFill( lineRect );
    
    if( b < ( CGFloat )0.5 )
    {
        color = [ NSColor colorWithDeviceHue: h saturation: s brightness: b + ( CGFloat )0.015 alpha: 1 ];
    }
    else
    {
        color = [ NSColor colorWithDeviceHue: h saturation: s brightness: b - ( CGFloat )0.015 alpha: 1 ];
    }
    
    rect.origin.x    = lineRect.origin.x + lineRect.size.width;
    rect.size.width -= lineRect.origin.x + lineRect.size.width;
    
    [ color setFill ];
    
    NSRectFill( rect );
}

- ( void )drawTabStopsInRect: ( NSRect )rect
{
    CGFloat     margin;
    CGSize      size;
    CGFloat     h;
    CGFloat     s;
    CGFloat     b;
    NSUInteger  count;
    NSRect      tabRect;
    NSRect      lineRect;
    NSColor   * color;
    NSColor   * backgroundColor;
	NSUInteger  tabWidth;
	NSUInteger  pageGuideColumn;
	BOOL        showPageGuide;
    
    margin = [ ( CEEditorLayoutManager * )( self.layoutManager ) firstGlyphLeftMargin ];
    size   = [ ( CEEditorLayoutManager * )( self.layoutManager ) glyphSize ];
    
    h               = ( CGFloat )0;
    s               = ( CGFloat )0;
    b               = ( CGFloat )0;
    backgroundColor = [ [ [ CEPreferences sharedInstance ] backgroundColor ] colorUsingColorSpaceName: NSDeviceRGBColorSpace ];
    
    [ backgroundColor getHue: &h saturation: &s brightness: &b alpha: NULL ];
    
    if( b < ( CGFloat )0.5 )
    {
        color = [ NSColor colorWithDeviceHue: h saturation: s brightness: b + ( CGFloat )0.035 alpha: 1 ];
    }
    else
    {
        color = [ NSColor colorWithDeviceHue: h saturation: s brightness: b - ( CGFloat )0.035 alpha: 1 ];
    }
    
	pageGuideColumn	= [ [ CEPreferences sharedInstance ] pageGuideColumn ];
	showPageGuide	= [ [ CEPreferences sharedInstance ] showPageGuide ];
	tabWidth		= [ [ CEPreferences sharedInstance ] tabWidth ];
    tabRect			= NSMakeRect
    (
        margin,
        0,
        size.width * ( CGFloat )tabWidth,
        size.height
    );
    
    [ color setFill ];
    
    count = 0;
    
    while( tabRect.origin.x < rect.size.width )
    {
        if( count != pageGuideColumn || showPageGuide == NO )
        {
            lineRect = NSMakeRect( tabRect.origin.x, rect.origin.y, ( CGFloat )1, rect.size.height );
            
            NSRectFill( lineRect );
        }
        
        tabRect.origin.x += tabRect.size.width;
        
        count += tabWidth;
    }
}

- ( NSRect )drawRectForRange: ( NSRange )range
{
    NSString  * text;
    NSRange     startRange;
    NSRange     endRange;
    NSUInteger  end;
    NSRange     glyphRange;
    NSRect      boundingRect;
    CGFloat     y;
    CGFloat     w;
    CGFloat     h;
    
    text       = self.textStorage.string;
    startRange = [ text lineRangeForRange: NSMakeRange( range.location, 0 ) ];
    end        = NSMaxRange( range ) - 1;
    
    if( end >= text.length )
    {
        return NSZeroRect;
    }
    
    if( end < range.location )
    {
        end = range.location;
    }
    
    endRange     = [ text lineRangeForRange: NSMakeRange( end, 0 ) ];
    glyphRange   = [ self.layoutManager glyphRangeForCharacterRange: NSMakeRange( startRange.location, ( NSMaxRange( endRange ) - startRange.location ) - 1 ) actualCharacterRange: NULL ];
    boundingRect = [ self.layoutManager boundingRectForGlyphRange: glyphRange inTextContainer: self.textContainer ];
    y            = boundingRect.origin.y;
    w            = self.bounds.size.width;
    h            = boundingRect.size.height;
    
    return NSOffsetRect( NSMakeRect( ( CGFloat )0, y, w, h ), self.textContainerOrigin.x, self.textContainerOrigin.y );
}

- ( void )drawCurrentLineHighlight: ( NSRect )rect
{
    NSString * text;
    NSRange    selection;
    NSRange    lineRange;
    
    ( void )rect;
    
    selection = self.selectedRange;
    text      = self.textStorage.string;
    
    if( selection.length > 0 )
    {
        return;
    }
    
    if( selection.location <= text.length )
    {
        lineRange = [ text lineRangeForRange: NSMakeRange( selection.location, 0 ) ];
        
        [ [ [ CEPreferences sharedInstance ] currentLineColor ] setFill ];
        
        NSRectFill( [ self drawRectForRange: lineRange ] );
    }
}

- ( void )selectionDidChange: ( NSNotification * )notification
{
    ( void )notification;
    
    [ self setNeedsDisplay: YES ];
}

@end
