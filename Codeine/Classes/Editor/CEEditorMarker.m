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

#import "CEEditorMarker.h"

@implementation CEEditorMarker

- ( void )drawRect: ( NSRect )rect
{
    NSColor      * color1;
    NSColor      * color2;
    NSGradient   * gradient;
    NSBezierPath * path;
    CGFloat        h;
    CGFloat        s;
    CGFloat        b;
    
    h = ( CGFloat )0;
    s = ( CGFloat )0;
    b = ( CGFloat )0;
    
    color1 = [ NSColor colorForControlTint: NSBlueControlTint ];
    color1 = [ color1 colorUsingColorSpaceName: NSDeviceRGBColorSpace ];
    
    [ color1 getHue: &h saturation: &s brightness: &b alpha: NULL ];
    
    if( APPLICATION.isActive == YES )
    {
        color1 = [ NSColor colorWithCalibratedHue: h saturation: s + ( CGFloat )0.2 brightness: b alpha: ( CGFloat )1 ];
        color2 = [ NSColor colorWithCalibratedHue: h saturation: s + ( CGFloat )0.4 brightness: b - ( CGFloat )0.4 alpha: ( CGFloat )1 ];
    }
    else
    {
        color1 = [ NSColor colorWithCalibratedHue: h saturation: ( CGFloat )0 brightness: b alpha: ( CGFloat )1 ];
        color2 = [ NSColor colorWithCalibratedHue: h saturation: ( CGFloat )0 brightness: b - ( CGFloat )0.4 alpha: ( CGFloat )1 ];
    }
    
    gradient = [ [NSGradient alloc ] initWithColorsAndLocations: color1, ( CGFloat )0, color2, ( CGFloat )1, nil ];
    path     = [ NSBezierPath bezierPath ];
    rect     = NSInsetRect( rect, ( CGFloat )1, ( CGFloat )0 );
    
    [ path appendBezierPathWithRoundedRect: rect xRadius: ( CGFloat )5 yRadius: ( CGFloat )5 ];
    [ gradient drawInBezierPath: path angle: ( CGFloat )90 ];
    [ gradient release ];
    
    rect.origin.x    += ( CGFloat )0.30;
    rect.origin.y    += ( CGFloat )0.30;
    rect.size.width  -= ( CGFloat )0.60;
    rect.size.height -= ( CGFloat )0.60;
    
    gradient = [ [ NSGradient alloc ] initWithStartingColor:    [ NSColor colorWithCalibratedWhite: ( CGFloat )0 alpha: ( CGFloat )0.50 ]
                                              endingColor:      [ NSColor colorWithCalibratedWhite: ( CGFloat )0 alpha: ( CGFloat )0.75 ]
               ];
    
    [ path appendBezierPath: [ NSBezierPath bezierPathWithRoundedRect: rect xRadius: ( CGFloat )5 yRadius: ( CGFloat )5 ] ];
    [ path setWindingRule: NSEvenOddWindingRule ];
    [ gradient drawInBezierPath: path angle: ( CGFloat )90 ];
    
    [ gradient release ];
}

@end
