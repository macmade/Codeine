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

#import "CEEditorRulerView.h"
#import "CEEditorRulerView+Private.h"
#import "CEEditorMarker.h"
#import "CEPreferences.h"
#import "CEDocument.h"
#import "CESourceFile.h"
#import "CEFixItViewController.h"

NSString * const CEEditorRulerViewException = @"CEEditorRulerViewException";

@implementation CEEditorRulerView

@synthesize document = _document;

- ( void )dealloc
{
    [ NOTIFICATION_CENTER removeObserver: self ];
    
    RELEASE_IVAR( _textView );
    RELEASE_IVAR( _linesRect );
    RELEASE_IVAR( _document );
    
    [ super dealloc ];
}

- ( void )setClientView: ( NSView * )view
{
    NSException * e;
    
    [ super setClientView: view ];
    
    if( view != nil && [ view isKindOfClass: [ NSTextView class ] ] == NO )
    {
        e = [ NSException exceptionWithName: CEEditorRulerViewException reason: @"Bad client view - Kind must be NSTextView" userInfo: nil ];
        
        @throw e;
    }
    
    if( view != nil && view != _textView )
    {
        [ NOTIFICATION_CENTER removeObserver: self name: NSTextViewDidChangeSelectionNotification   object: _textView ];
        [ NOTIFICATION_CENTER removeObserver: self name: NSTextStorageDidProcessEditingNotification object: _textView.textStorage ];

        RELEASE_IVAR( _textView );
        
        _textView = ( NSTextView * )[ view retain ];
        
        [ NOTIFICATION_CENTER addObserver: self selector: @selector( textViewSelectionDidChange: )   name: NSTextViewDidChangeSelectionNotification   object: _textView ];
        [ NOTIFICATION_CENTER addObserver: self selector: @selector( textStorageDidProcessEditing: ) name: NSTextStorageDidProcessEditingNotification object: _textView.textStorage ];
    }
    
}

- ( void )drawRect: ( NSRect )rect
{
    NSColor      * color1;
    NSColor      * color2;
    NSColor      * color3;
    NSGradient   * gradient;
    
    [ [ NSColor clearColor ] setFill ];
    
    if( rect.size.width < self.ruleThickness )
    {
        return;
    }
    
    if( _hasApplicationObserver == NO )
    {
        [ NOTIFICATION_CENTER addObserver: self selector: @selector( applicationStateDidChange: ) name: NSApplicationDidBecomeActiveNotification object: APPLICATION ];
        [ NOTIFICATION_CENTER addObserver: self selector: @selector( applicationStateDidChange: ) name: NSApplicationDidResignActiveNotification object: APPLICATION ];
        
        _hasApplicationObserver = YES;
    }
    
    [ [ NSColor windowFrameColor ] setFill ];
    
    NSRectFill( rect );
    
    rect.size.width -= ( CGFloat )1;
    
    color1   = [ NSColor colorWithDeviceWhite: ( CGFloat )0.95 alpha: ( CGFloat )1 ];
    color2   = [ NSColor colorWithDeviceWhite: ( CGFloat )0.80 alpha: ( CGFloat )1 ];
    color3   = [ NSColor colorWithDeviceWhite: ( CGFloat )0.85 alpha: ( CGFloat )1 ];
    color1   = [ color1 colorUsingColorSpaceName: NSDeviceRGBColorSpace ];
    color2   = [ color2 colorUsingColorSpaceName: NSDeviceRGBColorSpace ];
    color3   = [ color3 colorUsingColorSpaceName: NSDeviceRGBColorSpace ];
    gradient = [ [ NSGradient alloc ] initWithColorsAndLocations: color3, ( CGFloat )0, color1, ( CGFloat )0.10, color2, ( CGFloat )1, nil ];
    
    [ gradient drawInRect: rect angle: ( CGFloat )0 ];
    [ gradient release ];
    
    [ self drawHashMarksAndLabelsInRect: rect ];
}

- ( void )drawHashMarksAndLabelsInRect: ( NSRect )rect
{
    NSString                * text;
    NSTextContainer         * textContainer;
    NSMutableDictionary     * attributes;
    NSRange                   range;
    NSUInteger                start;
    NSUInteger                end;
    NSUInteger                contentsEnd;
    NSRectArray               rectArray;
    NSUInteger                rectCount;
    NSRange                   selectedRange;
    NSRect                    lineRect;
    NSUInteger                line;
    NSRange                   glyphRange;
    NSRect                    visibleRect;
    NSRange                   lineRange;
    CEEditorMarker          * marker;
    NSArray                 * diagnostics;
    CKDiagnostic            * diagnostic;
    NSImage                 * image;
    NSRect                    imageRect;
    
    if( _textView == nil )
    {
        return;
    }
    
    text = _textView.textStorage.string;
    
    range.location  = 0;
    range.length    = 1;
    start           = 0;
    end             = 0;
    contentsEnd     = 0;
    line            = 0;
    
    selectedRange   = NSMakeRange( NSNotFound, 0 );
    textContainer   = [ _textView.layoutManager.textContainers objectAtIndex: 0 ];
    attributes      = [self textAttributes ];
    visibleRect     = [ [ [ self scrollView ] contentView ] bounds ];
    glyphRange      = [ _textView.layoutManager glyphRangeForBoundingRect: visibleRect inTextContainer: textContainer ];
    
    if( text.length == 0 )
    {
        return;
    }
    
    lineRange.location = 0;
    lineRange.length   = 1;
    
    while( lineRange.location < glyphRange.location )
    {
        lineRange = [ text lineRangeForRange: lineRange ];
        
        lineRange.location = lineRange.location + lineRange.length;
        lineRange.length   = 1;
        
        line++;
    }
    
    range.location = glyphRange.location;
    diagnostics    = [ _document.sourceFile.translationUnit.diagnostics retain ];
    
    while( range.location + range.length <= text.length )
    {
        [ text getLineStart: &start end: &end contentsEnd: &contentsEnd forRange: range ];
        
        rectCount = 0;
        rectArray = [ _textView.layoutManager rectArrayForCharacterRange: range withinSelectedCharacterRange: selectedRange inTextContainer: textContainer rectCount: &rectCount ];
        
        if( rectCount == 0 )
        {
            continue;
        }
        
        lineRect = rectArray[ 0 ];
        
        lineRect.origin.y  -= visibleRect.origin.y;
        lineRect.origin.x   = ( CGFloat )0;
        lineRect.size.width = ( CGFloat )rect.size.width - ( CGFloat )5;
        
        marker = [ self markerForLine: line ];
        
        if( marker != nil )
        {
            [ marker drawRect: NSMakeRect( lineRect.origin.x, lineRect.origin.y, lineRect.size.width + ( CGFloat )5, lineRect.size.height ) ];
            [ attributes setObject: [ NSColor whiteColor ] forKey: NSForegroundColorAttributeName ];
        }
        else
        {
            [ attributes setObject: [ NSColor grayColor ] forKey: NSForegroundColorAttributeName ];
        }
        
        for( diagnostic in diagnostics )
        {
            if( diagnostic.line == line + 1 )
            {
                lineRange = [ text lineRangeForRange: NSMakeRange( _textView.selectedRange.location, 0 ) ];
                
                if( diagnostic.range.location >= lineRange.location && diagnostic.range.location <= lineRange.location + lineRange.length )
                {
                    continue;
                }
                
                if( diagnostic.severity == CKDiagnosticSeverityFatal || diagnostic.severity == CKDiagnosticSeverityError )
                {
                    image = [ NSImage imageNamed: @"Error" ];
                }
                else if( diagnostic.severity == CKDiagnosticSeverityWarning )
                {
                    image = [ NSImage imageNamed: @"Warning" ];
                }
                else if( diagnostic.severity == CKDiagnosticSeverityNote )
                {
                    image = [ NSImage imageNamed: @"Notice" ];
                }
                else
                {
                    image = nil;
                }
                
                if( image != nil )
                {
                    imageRect            = lineRect;
                    imageRect.origin.x  += ( CGFloat )2;
                    imageRect.size.width = imageRect.size.height;
                    
                    [ image drawInRect: imageRect fromRect: NSZeroRect operation: NSCompositeSourceOver fraction: ( CGFloat )1 respectFlipped: YES hints: nil ];
                }
                
                break;
            }
        }
        
        [ [ NSString stringWithFormat: @"%lu", line + 1 ] drawInRect: lineRect withAttributes: attributes ];
        [ self setRect: rectArray[ 0 ] forLine: line ];
        
        range.location = end;
        
        line++;
    }
    
    [ diagnostics release ];
}

- ( CGFloat )requiredThickness
{
    NSUInteger        lines;
    NSUInteger        digits;
    NSUInteger        i;
    NSMutableString * string;
    NSSize            size;
    NSUInteger        width;
    double            tmp;
    
    lines  = _textView.numberOfHardLines;
    
    if( lines > 0 )
    {
        tmp    = log10( lines ) + 1;
        digits = ( NSUInteger )tmp;
    }
    else
    {
        digits = 1;
    }
    
    string = [ NSMutableString string ];
    
    for( i = 0; i < digits; i++ )
    {
        [ string appendString: @"X" ];
    }
    
    size  = [ string sizeWithAttributes: [ self textAttributes ] ];
    width = ( NSUInteger )MAX( 20, size.width + 10 + size.height + 4 );
    
    return ( CGFloat )width;
}

- ( void )mouseDown: ( NSEvent * )e
{
	NSPoint                 location;
    NSUInteger              line;
    NSRect                  visibleRect;
    NSArray               * diagnostics;
    CKDiagnostic          * diagnostic;
    BOOL                    hasDiagnostic;
    CEFixItViewController * controller;
	
	location    = [ self convertPoint: e.locationInWindow fromView: nil ];
    visibleRect = [ [ [ self scrollView ] contentView ] bounds ];
    location.y += visibleRect.origin.y;
    line        = [ self lineForPoint: location ];
    
    if( line == NSNotFound )
    {
        return;
    }
    
    hasDiagnostic = NO;
    diagnostic    = nil;
    diagnostics   = [ _document.sourceFile.translationUnit.diagnostics retain ];
    
    for( diagnostic in diagnostics )
    {
        if( diagnostic.line - 1 == line )
        {
            hasDiagnostic = YES;
            break;
        }
    }
    
    [ diagnostics release ];
    
    
    if( hasDiagnostic == YES )
    {
        controller = [ [ CEFixItViewController alloc ] initWithDiagnostic: diagnostic ];
        
        [ controller openInPopoverRelativeToRect: NSMakeRect( location.x, location.y, self.frame.size.width, ( CGFloat )1 ) ofView: self preferredEdge: NSMaxYEdge ];
        [ controller autorelease ];
    }
    else if( [ self markerForLine: line ] == nil )
    {
        [ self addMarkerForLine: line ];
    }
    else
    {
        [ self removeMarkerForLine: line ];
    }
}

@end
