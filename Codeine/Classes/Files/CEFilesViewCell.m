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

#import "CEFilesViewCell.h"
#import "CEFilesViewItem.h"
#import "CEFile.h"

static CEFilesViewCell * __prototypeCell = nil;

static void __exit( void ) __attribute__( ( destructor ) );
static void __exit( void )
{
    [ __prototypeCell release ];
}

@implementation CEFilesViewCell

+ ( id )prototypeCell
{
    if( __prototypeCell == nil )
    {
        __prototypeCell = [ [ self alloc ] init ];
    }
    
    return __prototypeCell;
}

- ( id )copyWithZone: ( NSZone * )zone
{
    id cell;
    
    cell = [ super copyWithZone: zone ];
    
    return cell;
}

- ( void )selectWithFrame: ( NSRect )rect inView: ( NSView * )controlView editor: ( NSText * )editor delegate: ( id )delegate start: ( NSInteger )selStart length: ( NSInteger )selLength
{
    rect = NSMakeRect
    (
        rect.origin.x + rect.size.height + 20,
        rect.origin.y + 3,
        rect.size.width - ( rect.size.height + 14 ),
        rect.size.height - 6
    );
    
    [ super selectWithFrame: rect inView: controlView editor: editor delegate: delegate start: selStart length: selLength ];
    
    if( [ editor isKindOfClass: [ NSTextView class ] ] )
    {
        [ ( NSTextView * )editor setTextContainerInset: NSMakeSize( -2, 1 ) ];
    }
    
    [ editor setFont: [ NSFont systemFontOfSize: [ NSFont smallSystemFontSize ] ] ];
}

- ( NSText * )setUpFieldEditorAttributes: ( NSText * )editor
{   
    [ editor setDrawsBackground: NO ];
    
    return editor;
}

- ( void )drawWithFrame: ( NSRect )frame inView: ( NSView * )view
{
    NSString                * text;
    NSImage                 * icon;
    CEFilesViewItem          * item;
    NSColor                 * color;
    NSFont                  * font;
    NSMutableParagraphStyle * paragraphStyle;
    NSDictionary            * attributes;
    CGRect                    textRect;
    
    ( void )frame;
    ( void )view;
    
    frame.origin.x   += ( CGFloat )10;
    frame.size.width -= ( CGFloat )10;
    
    item = ( CEFilesViewItem * )[ self objectValue ];
    
    if( [ item isKindOfClass: [ CEFilesViewItem class ] ] == NO )
    {
        return;
    }
    
    if( item.type == CEFilesViewItemTypeFS || item.type == CEFilesViewItemTypeBookmark || item.type == CEFilesViewItemTypeDocument )
    {
        {
            CGRect         rect;
            NSBezierPath * path;
            NSError      * error;
            NSColor      * labelColor;
            NSGradient   * gradient;
            CGFloat        h;
            CGFloat        s;
            CGFloat        b;
            
            if( [ FILE_MANAGER fileExistsAtPath: item.file.path ] == YES )
            {
                error       = nil;
                labelColor  = nil;
                
                [ item.file.url getResourceValue: &labelColor forKey: NSURLLabelColorKey error: &error ];
                
                if( labelColor != nil )
                {
                    rect              = frame;
                    rect.origin.x    += frame.size.height + ( CGFloat )5;
                    rect.origin.y    += ( CGFloat )1;
                    rect.size.width  -= frame.size.height + ( CGFloat )5;
                    rect.size.height -= ( CGFloat )2;
                    path              = [ NSBezierPath bezierPath ];
                    
                    if( self.backgroundStyle == NSBackgroundStyleDark )
                    {
                        rect.origin.x    += ( rect.size.width - rect.size.height );
                        rect.size.height -= ( CGFloat )6;
                        rect.origin.y    += ( CGFloat )3;
                        rect.size.width   = rect.size.height;
                    }
                    
                    if( rect.size.width > 10 )
                    {
                        labelColor = [ labelColor colorUsingColorSpaceName: NSDeviceRGBColorSpace ];
                        
                        [ labelColor getHue: &h saturation: &s brightness: &b alpha: NULL ];
                        
                        if( APPLICATION.isActive == YES )
                        {
                            labelColor  = [ NSColor colorWithDeviceHue: h saturation: s brightness: b alpha: ( self.backgroundStyle == NSBackgroundStyleDark ) ? ( CGFloat )1 : ( CGFloat )0.5 ];
                        }
                        else
                        {
                            labelColor  = [ NSColor colorWithDeviceHue: ( CGFloat )0 saturation: ( CGFloat )0 brightness: ( CGFloat )0.75 alpha: ( self.backgroundStyle == NSBackgroundStyleDark ) ? ( CGFloat )1 : ( CGFloat )0.5 ];
                        }
                        
                        gradient = [ [ NSGradient alloc ] initWithColorsAndLocations:   [ NSColor whiteColor ], ( CGFloat )0.0,
                                                                                        labelColor,             ( CGFloat )1.0,
                                                                                        nil
                                   ];
                        
                        [ path appendBezierPathWithRoundedRect: rect xRadius: ( CGFloat )10 yRadius: ( CGFloat )10 ];
                        
                        [ gradient drawInBezierPath: path angle: ( CGFloat )90 ];
                        [ gradient release ];
                        
                        gradient = [ [ NSGradient alloc ] initWithStartingColor:    [ NSColor colorWithCalibratedWhite: ( CGFloat )0 alpha: ( CGFloat )0.25 ]
                                                          endingColor:              [ NSColor colorWithCalibratedWhite: ( CGFloat )0 alpha: ( CGFloat )0.5 ]
                                   ];
                        
                        rect.origin.x    += ( CGFloat )0.25;
                        rect.origin.y    += ( CGFloat )0.25;
                        rect.size.width  -= ( CGFloat )0.5;
                        rect.size.height -= ( CGFloat )0.5;
                        
                        [ path appendBezierPath: [ NSBezierPath bezierPathWithRoundedRect: rect xRadius: ( CGFloat )10 yRadius: ( CGFloat )10 ] ];
                        [ path setWindingRule: NSEvenOddWindingRule ];
                        [ gradient drawInBezierPath: path angle: ( CGFloat )90 ];
                        [ gradient release ];
                    }
                }
            }
        }
    }
    
    text            = item.displayName;
    icon            = [ item.icon imageWithSize: ( CGFloat )16 ];
    color           = ( self.isHighlighted == YES ) ? [ NSColor alternateSelectedControlTextColor ] : [ NSColor textColor ];
    font            = [ NSFont systemFontOfSize: [ NSFont smallSystemFontSize ] ];
    paragraphStyle  = [ [ NSMutableParagraphStyle new ] autorelease ];
    
    [ paragraphStyle setLineBreakMode: NSLineBreakByTruncatingMiddle ];
    
    attributes = [ NSDictionary dictionaryWithObjectsAndKeys:   color,          NSForegroundColorAttributeName,
                                                                font,           NSFontAttributeName,
                                                                paragraphStyle, NSParagraphStyleAttributeName,
                                                                nil
                 ];
    
    textRect = CGRectMake
    (
        frame.origin.x + frame.size.height + ( CGFloat )10,
        frame.origin.y + ( ( frame.size.height - [ NSFont smallSystemFontSize ] ) / ( CGFloat )2 ),
        frame.size.width - ( frame.size.height + ( CGFloat )10 ),
        frame.size.height
    );
    
    [ text drawInRect: textRect withAttributes: attributes ];
    
    {
        NSAffineTransform  * transform;
        NSImageInterpolation interpolation;
        CGFloat              yOffset;
        CGRect               drawRect;
        CGRect               fromRect;
        CGFloat              height;
        
        [ [ NSGraphicsContext currentContext ] saveGraphicsState ];
        
        interpolation   = [ [ NSGraphicsContext currentContext ] imageInterpolation ];
        yOffset         = frame.origin.y;
        
        if( view.isFlipped == YES )
        {
            transform = [ NSAffineTransform transform ];
            
            [ transform translateXBy: ( CGFloat )0 yBy: frame.size.height ];
            [ transform scaleXBy: ( CGFloat )1 yBy: ( CGFloat )-1 ];
            [ transform concat ];	
            
            yOffset = -( frame.origin.y );
        }
        
        if( icon.size.height <= frame.size.height )
        {
            yOffset += ( frame.size.height - icon.size.height ) / ( CGFloat )2;
            height   = icon.size.height;
        }
        else
        {
            height = frame.size.height - ( CGFloat )2;
        }
        
        drawRect = NSMakeRect
        (
            frame.origin.x + ( CGFloat )5,
            yOffset,
            height,
            height
        );
        
        fromRect = NSMakeRect
        (
            ( CGFloat )0,
            ( CGFloat )0,
            icon.size.width,
            icon.size.height
        );
        
        if( APPLICATION.isActive == NO )
        {
            icon = [ icon grayscaleImage ];
        }
        
        [ [ NSGraphicsContext currentContext ] setImageInterpolation: NSImageInterpolationHigh ];	
        [ icon drawInRect: drawRect fromRect: fromRect operation: NSCompositeSourceOver fraction: ( CGFloat )1 ];
        [ [ NSGraphicsContext currentContext ] setImageInterpolation: interpolation ];
        [ [ NSGraphicsContext currentContext ] restoreGraphicsState ];
    }
}

@end
