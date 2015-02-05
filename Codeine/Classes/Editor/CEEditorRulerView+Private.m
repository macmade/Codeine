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

#import "CEEditorRulerView+Private.h"
#import "CEEditorMarker.h"

@implementation CEEditorRulerView( Private )

- ( void )textStorageDidProcessEditing: ( NSNotification * )notification
{
    ( void )notification;
    
    [ self setNeedsDisplay: YES ];
}

- ( void )textViewSelectionDidChange: ( NSNotification * )notification
{
    ( void )notification;
    
    [ self setNeedsDisplay: YES ];
}

- ( void )applicationStateDidChange: ( NSNotification * )notification
{
    ( void )notification;
    
    [ self setNeedsDisplay: YES ];
}

- ( void )setRect: ( NSRect )rect forLine: ( NSUInteger )line
{
    NSNumber * key;
    NSValue  * value;
    
    if( _linesRect == nil )
    {
        _linesRect = [ [ NSMutableDictionary alloc ] initWithCapacity: 10 ];
    }
    
    key   = [ NSNumber numberWithUnsignedInteger: line ];
    value = [ NSValue valueWithRect: rect ];
    
    [ _linesRect removeObjectForKey: key ];
    [ _linesRect setObject: value forKey: key ];
}

- ( NSRect )rectForLine: ( NSUInteger )line
{
    NSNumber * key;
    NSValue  * value;
    
    if( _textView == nil || _linesRect == nil )
    {
        return NSZeroRect;
    }
    
    for( key in _linesRect )
    {
        if( [ key unsignedIntegerValue ] == line )
        {
            value = [ _linesRect objectForKey: key ];
            
            return [ value rectValue ];
        }
    }
    
    return NSZeroRect;
}

- ( NSUInteger )lineForPoint: ( NSPoint )point
{
    NSNumber * key;
    NSValue  * value;
    NSRect     rect;
    
    if( _textView == nil || _linesRect == nil )
    {
        return NSNotFound;
    }
    
    for( key in _linesRect )
    {
        value = [ _linesRect objectForKey: key ];
        rect  = [ value rectValue ];
        
        if
        (
               point.y >= rect.origin.y
            && point.y <= rect.origin.y + rect.size.height
        )
        {
            return [ key unsignedIntegerValue ];
        }
    }
    
    return NSNotFound;
}

- ( void )addMarkerForLine: ( NSUInteger )line
{
    NSRulerMarker * marker;
    NSArray       * markers;
    NSNumber      * lineNumber;
    
    markers = [ self markers ];
    
    for( marker in markers )
    {
        if( [ ( NSObject * )( marker.representedObject ) isKindOfClass: [ NSNumber class ] ] == NO )
        {
            continue;
        }
        
        lineNumber = ( NSNumber * )( marker.representedObject );
        
        if( [ lineNumber unsignedIntegerValue ] == line )
        {
            return;
        }
    }
    
    marker                   = [ CEEditorMarker new ];
    marker.representedObject = [ NSNumber numberWithUnsignedInteger: line ];
    
    [ self addMarker: marker ];
    [ marker release ];
    [ self setNeedsDisplay: YES ];
}

- ( void )removeMarkerForLine: ( NSUInteger )line
{
    NSRulerMarker * marker;
    NSArray       * markers;
    NSNumber      * lineNumber;
    
    markers = [ NSArray arrayWithArray: [ self markers ] ];
    
    for( marker in markers )
    {
        if( [ ( NSObject * )( marker.representedObject ) isKindOfClass: [ NSNumber class ] ] == NO )
        {
            continue;
        }
        
        lineNumber = ( NSNumber * )( marker.representedObject );
        
        if( [ lineNumber unsignedIntegerValue ] == line )
        {
            [ self removeMarker: marker ];
            [ self setNeedsDisplay: YES ];
            
            return;
        }
    }
}

- ( CEEditorMarker * )markerForLine: ( NSUInteger )line
{
    NSRulerMarker * marker;
    NSArray       * markers;
    NSNumber      * lineNumber;
    
    markers = [ NSArray arrayWithArray: [ self markers ] ];
    
    for( marker in markers )
    {
        if( [ ( NSObject * )( marker.representedObject ) isKindOfClass: [ NSNumber class ] ] == NO )
        {
            continue;
        }
        
        if( [ marker isKindOfClass: [ CEEditorMarker class ] ] == NO )
        {
            continue;
        }
        
        lineNumber = ( NSNumber * )( marker.representedObject );
        
        if( [ lineNumber unsignedIntegerValue ] == line )
        {
            return ( CEEditorMarker * )marker;
        }
    }
    
    return nil;
}

- ( NSMutableDictionary * )textAttributes
{
    NSFont                  * font;
    NSMutableParagraphStyle * paragraphStyle;
    
    if( _attributes == nil )
    {
        _attributes      = [ [ NSMutableDictionary alloc ] initWithCapacity: 10 ];
        font             = [ NSFont systemFontOfSize: ( CGFloat )8 ];
        paragraphStyle   = [ [ [ NSParagraphStyle defaultParagraphStyle ] mutableCopy ] autorelease ];
        
        [ paragraphStyle setAlignment: NSRightTextAlignment ];
        
        [ _attributes setObject: font                   forKey: NSFontAttributeName ];
        [ _attributes setObject: [ NSColor grayColor ]  forKey: NSForegroundColorAttributeName ];
        [ _attributes setObject: [ NSColor clearColor ] forKey: NSBackgroundColorAttributeName ];
        [ _attributes setObject: paragraphStyle         forKey: NSParagraphStyleAttributeName ];
    }
    
    return [ [ _attributes mutableCopy ] autorelease ];
}

@end
