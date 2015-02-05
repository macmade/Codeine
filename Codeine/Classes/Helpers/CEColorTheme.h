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

@interface CEColorTheme: NSObject
{
@protected
    
    NSString * _name;
    NSColor  * _foregroundColor;
    NSColor  * _backgroundColor;
    NSColor  * _selectionColor;
    NSColor  * _currentLineColor;
    NSColor  * _invisibleColor;
    NSColor  * _keywordColor;
    NSColor  * _commentColor;
    NSColor  * _stringColor;
    NSColor  * _predefinedColor;
    NSColor  * _projectColor;
    NSColor  * _preprocessorColor;
    NSColor  * _numberColor;
    
@private
    
    RESERVED_IVARS( CEColorTheme , 5 );
}

@property( atomic, readwrite, copy ) NSString * name;
@property( atomic, readwrite, copy ) NSColor  * foregroundColor;
@property( atomic, readwrite, copy ) NSColor  * backgroundColor;
@property( atomic, readwrite, copy ) NSColor  * selectionColor;
@property( atomic, readwrite, copy ) NSColor  * currentLineColor;
@property( atomic, readwrite, copy ) NSColor  * invisibleColor;
@property( atomic, readwrite, copy ) NSColor  * keywordColor;
@property( atomic, readwrite, copy ) NSColor  * commentColor;
@property( atomic, readwrite, copy ) NSColor  * stringColor;
@property( atomic, readwrite, copy ) NSColor  * predefinedColor;
@property( atomic, readwrite, copy ) NSColor  * projectColor;
@property( atomic, readwrite, copy ) NSColor  * preprocessorColor;
@property( atomic, readwrite, copy ) NSColor  * numberColor;

+ ( NSArray * )defaultColorThemes;
+ ( id )defaultColorThemeWithName: ( NSString * )name;
+ ( id )colorThemeWithName: ( NSString * )name;
- ( id )initWithName: ( NSString * )name;

@end
