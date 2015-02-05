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

#import "CEFixItViewController.h"

@implementation CEFixItViewController

@synthesize textView          = _textView;
@synthesize messageTextField  = _messageTextField;
@synthesize iconView          = _iconView;

- ( id )initWithDiagnostic: ( CKDiagnostic * )diagnostic
{
    if( ( self = [ self init ] ) )
    {
        _diagnostic = [ diagnostic retain ];
    }
    
    return self;
}

- ( void )dealloc
{
    RELEASE_IVAR( _diagnostic );
    RELEASE_IVAR( _textView );
    RELEASE_IVAR( _messageTextField );
    RELEASE_IVAR( _iconView );
    
    [ super dealloc ];
}

- ( void )awakeFromNib
{
    NSString * severity;
    NSRect     frame;
    
    [ _messageTextField setStringValue: @"" ];
    
    severity = nil;
    
    if( _diagnostic.severity == CKDiagnosticSeverityFatal )
    {
        severity = L10N( "DiagnosticSeverityFatal" );
        
        [ _iconView setImage: [ NSImage imageNamed: @"Error" ] ];
    }
    else if( _diagnostic.severity == CKDiagnosticSeverityError )
    {
        severity = L10N( "DiagnosticSeverityError" );
        
        [ _iconView setImage: [ NSImage imageNamed: @"Error" ] ];
    }
    else if( _diagnostic.severity == CKDiagnosticSeverityWarning )
    {
        severity = L10N( "DiagnosticSeverityWarning" );
        
        [ _iconView setImage: [ NSImage imageNamed: @"Warning" ] ];
    }
    else if( _diagnostic.severity == CKDiagnosticSeverityFatal )
    {
        severity = L10N( "DiagnosticSeverityNotice" );
        
        [ _iconView setImage: [ NSImage imageNamed: @"Notice" ] ];
    }
    else if( _diagnostic.severity == CKDiagnosticSeverityIgnored )
    {
        severity = L10N( "DiagnosticSeverityIgnored" );
        
        [ _iconView setImage: [ NSImage imageNamed: @"Notice" ] ];
    }
    
    [ _messageTextField setStringValue: [ NSString stringWithFormat: L10N( "DiagnosticMessage" ), severity, _diagnostic.line, _diagnostic.spelling ] ];
    [ _messageTextField sizeToFit ];
    
    frame            = self.view.frame;
    frame.size.width = _messageTextField.frame.origin.x + _messageTextField.frame.size.width + ( CGFloat )20;
    self.view.frame  = frame;
}

- ( IBAction )fix: ( id )sender
{
    CKFixIt * fixit;
    NSRange   range;
    
    ( void )sender;
    
    if( _diagnostic.fixIts.count == 0 )
    {
        return;
    }
    
    fixit           = [ _diagnostic.fixIts objectAtIndex: 0 ];
    range           = _diagnostic.range;
    range.location += range.length;
    
    [ _textView replaceCharactersInRange: range withString: fixit.string ];
}

@end
