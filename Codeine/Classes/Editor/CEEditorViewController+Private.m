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

#import "CEEditorViewController+Private.h"
#import "CEPreferences.h"
#import "CEEditorLayoutManager.h"
#import "CEEditorRulerView.h"
#import "CEDocument.h"
#import "CESourceFile.h"
#import "CESyntaxHighlighter.h"
#import "CECodeCompletionViewController.h"

@implementation CEEditorViewController( Private )

- ( void )updateView
{
    NSFont                  * font;
    NSDictionary            * selectionAttributes;
    NSMutableParagraphStyle * paragraphStyle;
    
    _layoutManager.showInvisibles = [ [ CEPreferences sharedInstance ] showInvisibles ];
    _layoutManager.showSpaces     = [ [ CEPreferences sharedInstance ] showSpaces ];
    
    font = [ NSFont fontWithName: [ [ CEPreferences sharedInstance ] fontName ] size: [ [ CEPreferences sharedInstance ] fontSize ] ];
    
    _textView.font                = font;
    _textView.backgroundColor     = [ [ CEPreferences sharedInstance ] backgroundColor ];
    _textView.textColor           = [ [ CEPreferences sharedInstance ] foregroundColor ];
    _textView.insertionPointColor = [ [ CEPreferences sharedInstance ] foregroundColor ];
    
    selectionAttributes = [ NSDictionary dictionaryWithObjectsAndKeys:  [ [ CEPreferences sharedInstance ] selectionColor ],  NSBackgroundColorAttributeName,
                                                                        [ [ CEPreferences sharedInstance ] foregroundColor ], NSForegroundColorAttributeName,
                                                                        nil
                          ];
    
    [ _textView setSelectedTextAttributes: selectionAttributes ];
    
    if( [ [ CEPreferences sharedInstance ] showLineNumbers ] == YES )
    {
        if( _rulerView == nil )
        {
            _rulerView          = [ CEEditorRulerView new ];
            _rulerView.document = _document;
        }
        
        [ [ _textView enclosingScrollView ] setVerticalRulerView: _rulerView ];
        [ [ _textView enclosingScrollView ] setHasHorizontalRuler: NO ];
        [ [ _textView enclosingScrollView ] setHasVerticalRuler: YES ];
        [ [ _textView enclosingScrollView ] setRulersVisible: YES ];
    
        [ _rulerView setScrollView: [ _textView enclosingScrollView ] ];
        [ _rulerView setClientView: _textView ];
    }
    else
    {
        [ [ _textView enclosingScrollView ] setVerticalRulerView: nil ];
        [ [ _textView enclosingScrollView ] setHasHorizontalRuler: NO ];
        [ [ _textView enclosingScrollView ] setHasVerticalRuler: NO ];
        [ [ _textView enclosingScrollView ] setRulersVisible: NO ];
    }
    
    paragraphStyle = [ [ [ NSParagraphStyle defaultParagraphStyle ] mutableCopy ] autorelease ];
    
    [ paragraphStyle setTabStops: [ NSArray array ] ];
    [ paragraphStyle setDefaultTabInterval: ( ( CEEditorLayoutManager * )( _textView.layoutManager ) ).glyphSize.width * ( CGFloat )[ [ CEPreferences sharedInstance ] tabWidth ] ];
    
    [ _textView setDefaultParagraphStyle: paragraphStyle ];
    
    [ _textView.textStorage enumerateAttributesInRange: NSMakeRange( 0, _textView.string.length )
                            options:                    NSAttributedStringEnumerationReverse
                            usingBlock:                 ^( NSDictionary * attributes, NSRange range, BOOL * stop )
                            {
                                NSMutableDictionary * newAttributes;
                                
                                ( void )stop;
                                
                                newAttributes = [ NSMutableDictionary dictionaryWithDictionary: attributes ];
                                
                                [ newAttributes setObject: paragraphStyle forKey: NSParagraphStyleAttributeName ];
                                [ _textView.textStorage setAttributes: newAttributes range: range ];
                            }
    ];
    
    [ _highlighter highlight ];
}

- ( void )selectionDidChange: ( NSNotification * )notification
{
    ( void )notification;
    
    [ self showAutoCompletionDelayed: YES ];
}

- ( void )showAutoCompletion
{
    [ self showAutoCompletionDelayed: NO ];
}

- ( void )showAutoCompletionDelayed: ( BOOL )delayed
{
    __block NSRect rect;
    
    rect = [ _textView.layoutManager boundingRectForGlyphRange: _textView.selectedRange inTextContainer: _textView.textContainer ];
    
    dispatch_async
    (
        dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0 ),
        ^( void )
        {
            @synchronized( self )
            {
                NSUInteger           line;
                NSUInteger           column;
                NSArray            * results;
                
                [ _codeCompletionViewController cancelOpening ];
                [ _codeCompletionViewController closePopover ];
                
                RELEASE_IVAR( _codeCompletionViewController );
                
                line   = ( NSUInteger )( _textView.currentLine );
                column = ( NSUInteger )( _textView.currentColumn );
                
                if( line == NSNotFound || column == NSNotFound )
                {
                    return;
                }
                
                results = [ _document.sourceFile.translationUnit completionResultsForLine: line column: column ];
                
                if( results.count > 0 || delayed == NO )
                {
                    _codeCompletionViewController = [ [ CECodeCompletionViewController alloc ] initWithCompletionResults: results ];
                    
                    rect.size.width = ( CGFloat )1;
                    
                    dispatch_sync
                    (
                        dispatch_get_main_queue(),
                        ^( void )
                        {
                            [ _codeCompletionViewController openInPopoverRelativeToRect: rect ofView: _textView preferredEdge: NSMaxYEdge delay: delayed ];
                        }
                    );
                }
            }
        }
    );
}

@end
