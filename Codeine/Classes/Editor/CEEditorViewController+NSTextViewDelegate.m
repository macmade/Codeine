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

#import "CEEditorViewController+NSTextViewDelegate.h"
#import "CEPreferences.h"

@implementation CEEditorViewController( NSTextViewDelegate )

- ( BOOL )textView: ( NSTextView * )textView doCommandBySelector: ( SEL )sel
{
    if( sel == @selector( insertTab: ) && [ [ CEPreferences sharedInstance ] autoExpandTabs ] == YES )
    {
        {
            NSInteger         column;
            NSUInteger        spaces;
            NSUInteger        i;
            NSMutableString * indent;
            NSString        * text;
            NSUInteger        tabWidth;
            NSRange           range;
            NSRange           lineRange;
            UniChar           c;
            NSUInteger        location;
            
            range       = textView.selectedRange;
            text        = textView.textStorage.string;
            lineRange   = [ text lineRangeForRange: range ];
            text        = [ text substringWithRange: NSMakeRange( range.location, lineRange.length - ( range.location - lineRange.location ) ) ];
            location    = 0;
            
            for( i = 0; i < text.length; i++ )
            {
                c = [ text characterAtIndex: i ];
                
                if( c != ' ' )
                {
                    break;
                }
                
                location++;
            }
            
            textView.selectedRange = NSMakeRange( range.location + location, 0 );
            
            tabWidth = [ [ CEPreferences sharedInstance ] tabWidth ];
            column   = [ textView currentColumn ];
            
            if( column == NSNotFound )
            {
                return NO;
            }
            
            indent = [ NSMutableString string ];
            column = column - 1;
            spaces = ( NSUInteger )column % tabWidth;
            
            for( i = tabWidth; i > spaces; i-- )
            {
                [ indent appendString: @" " ];
            }
            
            if( range.length > 0 )
            {
                if( [ textView shouldChangeTextInRange: range replacementString: @"" ] == NO )
                {
                    return NO;
                }
                
                [ textView replaceCharactersInRange: range withString: @"" ];
            }
            
            [ _textView insertText: indent ];
            
            return YES;
        }
    }
    else if( sel == @selector( insertNewline: ) && [ [ CEPreferences sharedInstance ] autoIndent ] == YES )
    {
        {
            NSRange             range;
            NSRange             lineRange;
            NSString          * text;
            NSInteger           i;
            UniChar             c;
            BOOL                shouldIndent;
            NSUInteger          columns;
            NSUInteger          tabWidth;
            NSMutableString   * indent;
            NSUInteger          mod;
            
            if( [ [ CEPreferences sharedInstance ] autoIndent ] == NO )
            {
                return NO;
            }
            
            text            = textView.textStorage.string;
            range           = textView.selectedRange;
            lineRange       = [ text lineRangeForRange: range ];
            text            = [ text substringWithRange: NSMakeRange( lineRange.location, range.location - lineRange.location ) ];
            shouldIndent    = NO;
            tabWidth        = [ [ CEPreferences sharedInstance ] tabWidth ];
            
            for( i = ( NSInteger )text.length - 1; i >= 0; i-- )
            {
                c = [ text characterAtIndex: ( NSUInteger )i ];
                
                if( c == ' ' || c == '\t' )
                {
                    continue;
                }
                else if( c == '{' )
                {
                    shouldIndent = ( [ [ CEPreferences sharedInstance ] indentAfterBrace ] ) ? YES : NO;
                    
                    break;
                }
                else if( c == '[' )
                {
                    shouldIndent = ( [ [ CEPreferences sharedInstance ] indentAfterBracket ] ) ? YES : NO;
                    
                    break;
                }
                else if( c == '(' )
                {
                    shouldIndent = ( [ [ CEPreferences sharedInstance ] indentAfterParenthesis ] ) ? YES : NO;
                    
                    break;
                }
                else
                {
                    break;
                }
            }
            
            columns = 0;
            indent  = [ NSMutableString string ];
            
            for( i = 0; i < ( NSInteger )text.length; i++ )
            {
                c = [ text characterAtIndex: ( NSUInteger )i ];
                
                if( c == ' ' )
                {
                    [ indent appendString: @" " ];
                    
                    columns += 1;
                }
                else if( c == '\t' )
                {
                    [ indent appendString: @"\t" ];
                    
                    columns += tabWidth;
                }
                else
                {
                    break;
                }
            }
            
            if( shouldIndent == YES )
            {
                mod = indent.length % tabWidth;
                mod = ( mod == 0 ) ? tabWidth : tabWidth - mod;
                
                if( [ [ CEPreferences sharedInstance ] autoExpandTabs ] == YES )
                {
                    for( i = 0; i < ( NSInteger )mod; i++ )
                    {
                        [ indent appendString: @" " ];
                    }
                }
                else
                {
                    [ indent appendString: @"\t" ];
                }
            }
            
            [ textView insertText: [ NSString stringWithFormat: @"\n%@", indent ] ];
            
            return YES;
        }
    }
    else if( sel == @selector( deleteBackward: ) )
    {
        {
            static BOOL isDeleting = NO;
            
            NSRange    range;
            NSRange    lineRange;
            NSString * text;
            NSUInteger i;
            NSUInteger mod;
            NSUInteger tabWidth;
            UniChar    c;
            NSUInteger charIndex;
            
            if( isDeleting == YES )
            {
                return NO;
            }
            
            isDeleting  = YES;
            range       = textView.selectedRange;
            text        = textView.textStorage.string;
            
            if( range.location == 0 || range.length > 0 )
            {
                isDeleting = NO;
                
                return NO;
            }
            
            if( range.location > 0 )
            {
                c = [ text characterAtIndex: range.location - 1 ];
                
                if( c != ' ' )
                {
                    isDeleting = NO;
                    
                    return NO;
                }
            }
            
            lineRange   = [ text lineRangeForRange: range ];
            tabWidth    = [ [ CEPreferences sharedInstance ] tabWidth ];
            mod         = ( range.location - lineRange.location ) % tabWidth;
            mod         = ( mod == 0 ) ? tabWidth : mod;
            
            for( i = 0; i < mod; i++ )
            {
                charIndex = ( range.location - 1 ) - i;
                
                c = [ text characterAtIndex: charIndex ];
                
                if( c != ' ' )
                {
                    break;
                }
                
                [ textView doCommandBySelector: sel ];
                
                if( charIndex == 0 )
                {
                    break;
                }
            }
            
            isDeleting = NO;
            
            return YES;
        }
    }
    
    return NO;
}

@end
