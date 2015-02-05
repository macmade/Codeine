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

#import "CELicensePopUpButton.h"
#import "CELicensePopUpButton+Private.h"

@implementation CELicensePopUpButton

- ( id )initWithFrame: ( NSRect )frame
{
    if( ( self = [ super initWithFrame: frame ] ) )
    {
        [ self fillItems ];
    }
    
    return self;
}

- ( id )initWithCoder: ( NSCoder * )coder
{
    if( ( self = [ super initWithCoder: coder ] ) )
    {
        [ self fillItems ];
    }
    
    return self;
}


- ( NSString * )licenseName
{
    NSMenuItem * item;
    
    item = [ self selectedItem ];
    
    return item.title;
}

- ( NSString * )licenseText
{
    NSMenuItem * item;
    NSString   * path;
    NSError    * error;
    NSString   * text;
    
    item  = [ self selectedItem ];
    path  = item.representedObject;
    error = nil;
    text  = nil;
    
    if( [ FILE_MANAGER isReadableFileAtPath: path ] )
    {
        text = [ NSString stringWithContentsOfFile: path encoding: NSUTF8StringEncoding error: &error ];
    }
    
    if( error == nil && text.length > 0 )
    {
        return text;
    }
    
    return @"";
}

@end
