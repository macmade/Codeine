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

#import "CEPreferencesFontsAndColorsOptionsViewController+CEColorChooserViewDelegate.h"
#import "CEPreferences.h"
#import "CEColorChooserView.h"

@implementation CEPreferencesFontsAndColorsOptionsViewController( CEColorChooserViewDelegate )

- ( void )colorChooserView: ( CEColorChooserView * )view didChooseColor: ( NSColor * )color
{
    ( void )view;
    
    if( view.representedObject == CEPreferencesKeyBackgroundColor )
    {
        [ [ CEPreferences sharedInstance ] setBackgroundColor: color ];
    }
    else if( view.representedObject == CEPreferencesKeyForegoundColor )
    {
        [ [ CEPreferences sharedInstance ] setForegroundColor: color ];
    }
    else if( view.representedObject == CEPreferencesKeyCurrentLineColor )
    {
        [ [ CEPreferences sharedInstance ] setCurrentLineColor: color ];
    }
    else if( view.representedObject == CEPreferencesKeySelectionColor )
    {
        [ [ CEPreferences sharedInstance ] setSelectionColor: color ];
    }
    else if( view.representedObject == CEPreferencesKeyInvisibleColor )
    {
        [ [ CEPreferences sharedInstance ] setInvisibleColor: color ];
    }
    else if( view.representedObject == CEPreferencesKeyKeywordColor )
    {
        [ [ CEPreferences sharedInstance ] setKeywordColor: color ];
    }
    else if( view.representedObject == CEPreferencesKeyPreprocessorColor )
    {
        [ [ CEPreferences sharedInstance ] setPreprocessorColor: color ];
    }
    else if( view.representedObject == CEPreferencesKeyPredefinedColor )
    {
        [ [ CEPreferences sharedInstance ] setPredefinedColor: color ];
    }
    else if( view.representedObject == CEPreferencesKeyProjectColor )
    {
        [ [ CEPreferences sharedInstance ] setProjectColor: color ];
    }
    else if( view.representedObject == CEPreferencesKeyNumberColor )
    {
        [ [ CEPreferences sharedInstance ] setNumberColor: color ];
    }
    else if( view.representedObject == CEPreferencesKeyStringColor )
    {
        [ [ CEPreferences sharedInstance ] setStringColor: color ];
    }
    else if( view.representedObject == CEPreferencesKeyCommentColor )
    {
        [ [ CEPreferences sharedInstance ] setCommentColor: color ];
    }
}

@end
