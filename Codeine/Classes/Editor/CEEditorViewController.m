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

#import "CEEditorViewController.h"
#import "CEEditorViewController+Private.h"
#import "CEEditorViewController+NSTextViewDelegate.h"
#import "CEEditorViewController+CEEditorTextViewDelegate.h"
#import "CEPreferences.h"
#import "CEMainWindowController.h"
#import "CESourceFile.h"
#import "CEEditorLayoutManager.h"
#import "CEEditorRulerView.h"
#import "CEDocument.h"
#import "CESyntaxHighlighter.h"

@implementation CEEditorViewController

@synthesize textView = _textView;

- ( void )dealloc
{
    [ NOTIFICATION_CENTER removeObserver: self ];
    [ [ _textView enclosingScrollView ] setVerticalRulerView: nil ];
    
    RELEASE_IVAR( _textView );
    RELEASE_IVAR( _layoutManager );
    RELEASE_IVAR( _document );
    RELEASE_IVAR( _highlighter );
    RELEASE_IVAR( _rulerView );
    RELEASE_IVAR( _codeCompletionViewController );
    
    [ super dealloc ];
}

- ( void )awakeFromNib
{
    [ NOTIFICATION_CENTER addObserver: self selector: @selector( updateView ) name: CEPreferencesNotificationValueChanged object: nil ];
    
    _textView.delegate  = self;
    _layoutManager      = [ CEEditorLayoutManager new ];
    
    [ _layoutManager setTextStorage: _textView.textStorage ];
    [ _textView.textContainer replaceLayoutManager: _layoutManager ];
    [ _layoutManager addTextContainer: _textView.textContainer ];
    [ _textView.textContainer setLayoutManager: _layoutManager ];
    
    [ NOTIFICATION_CENTER addObserver: self selector: @selector( selectionDidChange: ) name: NSTextViewDidChangeSelectionNotification object: _textView ];
    [ self updateView ];
}

- ( CEDocument * )document
{
    @synchronized( self )
    {
        return _document;
    }
}

- ( void )setDocument: ( CEDocument * )document
{
    CEMainWindowController * controller;
    
    @synchronized( self )
    {
        if( document != _document )
        {
            RELEASE_IVAR( _document );
            RELEASE_IVAR( _highlighter );
            
            _document           = [ document retain ];
            _rulerView.document = _document;
            controller          = ( CEMainWindowController * )self.view.window.windowController;
            
            if( controller.activeDocument != document )
            {
                controller.activeDocument = document;
            }
            
            _highlighter = [ [ CESyntaxHighlighter alloc ] initWithTextView: _textView sourceFile: document.sourceFile ];
            
            [ _highlighter startHighlighting ];
            
            _textView.string = document.sourceFile.text;
            
            [ _highlighter highlight ];
        }
    }
}

@end
