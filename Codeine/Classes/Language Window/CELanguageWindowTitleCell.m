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

#import "CELanguageWindowTitleCell.h"
#import "CESourceFile.h"

@implementation CELanguageWindowTitleCell

- ( void )drawWithFrame: ( NSRect )frame inView: ( NSView * )view
{
    CESourceFileLanguage  language;
    NSString            * languageName;
    NSMutableDictionary * attributes;
    CGFloat               fontSize;
    CGRect                textRect;
    
    ( void )view;
    
    if( [ self.objectValue isKindOfClass: [ NSNumber class ] ] == NO )
    {
        return;
    }
    
    language = ( CESourceFileLanguage )[ ( NSNumber * )( self.objectValue ) integerValue ];
    
    switch( language )
    {
        case CESourceFileLanguageC:
            
            languageName = L10N( "LanguageC" );
            
            break;
            
        case CESourceFileLanguageCPP:
            
            languageName = L10N( "LanguageCPP" );
            
            break;
            
        case CESourceFileLanguageObjC:
            
            languageName = L10N( "LanguageObjC" );
            
            break;
            
        case CESourceFileLanguageObjCPP:
            
            languageName = L10N( "LanguageObjCPP" );
            
            break;
            
        case CESourceFileLanguageHeader:
            
            languageName = L10N( "LanguageHeader" );
            
            break;
            
        case CESourceFileLanguageNone:
        default:
            
            languageName = nil;
            
            break;
    }
    
    fontSize              = [ NSFont systemFontSize ];
    textRect              = frame;
    textRect.origin.y    += ( frame.size.height - fontSize ) / ( CGFloat )2;
    textRect.size.height -= ( frame.size.height - fontSize ) / ( CGFloat )2;
    
    attributes  = [ NSMutableDictionary dictionaryWithCapacity: 10 ];
    
    [ attributes setObject: [ NSFont systemFontOfSize: fontSize ]   forKey: NSFontAttributeName ];
    [ attributes setObject: [ NSColor clearColor ]                  forKey: NSBackgroundColorAttributeName ];
    
    if( self.backgroundStyle == NSBackgroundStyleDark )
    {
        [ attributes setObject: [ NSColor whiteColor ] forKey: NSForegroundColorAttributeName ];
    }
    else
    {
        [ attributes setObject: [ NSColor textColor ] forKey: NSForegroundColorAttributeName ];
    }
    
    [ languageName drawInRect: textRect withAttributes: attributes ];
}

@end
