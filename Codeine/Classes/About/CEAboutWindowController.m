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

#import "CEAboutWindowController.h"
#import "CEBackgroundView.h"

@implementation CEAboutWindowController

@synthesize versionTextField = _versionTextField;
@synthesize backgroundView   = _backgroundView;
@synthesize iconView         = _iconView;

- ( void )dealloc
{
    RELEASE_IVAR( _versionTextField );
    RELEASE_IVAR( _backgroundView );
    RELEASE_IVAR( _iconView );
    
    [ super dealloc ];
}

- ( void )awakeFromNib
{
    NSString * version;
    NSString * build;
    NSString * versionString;
    NSImage  * icon;
    CGImageRef cgImage;
    NSRect     rect;
    
    version = [ [ NSBundle mainBundle ] objectForInfoDictionaryKey: NSBundleInfoKeyCFBundleShortVersionString ];
    build   = [ [ NSBundle mainBundle ] objectForInfoDictionaryKey: NSBundleInfoKeyCFBundleVersion ];
    
    versionString = [ NSString stringWithFormat:  L10N( "AppVersion" ), version, [ build uppercaseString ] ];
    
    [ _versionTextField setStringValue: versionString ];
    [ _backgroundView setBackgroundColor: [ NSColor whiteColor ] ];
    
    icon    = [ NSImage imageNamed: @"Application" ];
    rect    = NSMakeRect( ( CGFloat )0, ( CGFloat )0, ( CGFloat )512, ( CGFloat )512 );
    cgImage = [ icon CGImageForProposedRect: &rect context: nil hints: nil ];
    icon   = [ [ NSImage alloc ] initWithCGImage: cgImage size: NSMakeSize( ( CGFloat )512, ( CGFloat )512 ) ];
    
    [ _iconView setImage: icon ];
    [ icon release ];
}

@end
