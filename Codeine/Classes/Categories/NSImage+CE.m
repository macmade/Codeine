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

#import "NSImage+CE.h"

typedef struct __RGBPixel
{
    uint8_t alpha;
    uint8_t blue;
    uint8_t green;
    uint8_t red;
}
__RGBPixel;

@implementation NSImage( CE )

- ( NSImage * )imageWithSize: ( CGFloat )size
{
    NSSize         s;
    NSEnumerator * e;
    NSImage      * image;
    NSImageRep   * rep;
    
    s = NSMakeSize( size, size );
    e = [ [ self representations ] objectEnumerator ];
    
    while( ( rep = [ e nextObject ] ) )
    {
        if( NSEqualSizes( [ rep size ], s ) )
        {
            image = [ [ NSImage alloc ] initWithSize: s ];
            
            [ image addRepresentation: rep ];
            
            return [ image autorelease ];
        }
    }
    
    image = [ [ NSImage alloc ] initWithSize: s ];
    
    [ image lockFocus ];
    [ [ NSGraphicsContext currentContext ] setImageInterpolation: NSImageInterpolationHigh ];
    [ self drawInRect: NSMakeRect( ( CGFloat )0, ( CGFloat )0, size , size ) fromRect: NSMakeRect( ( CGFloat )0, ( CGFloat )0, self.size.width, self.size.height ) operation: NSCompositeCopy fraction: ( CGFloat )1 ];
    [ image unlockFocus ];
    
    return [ image autorelease ];
}

- ( NSImage * )grayscaleImage
{
    CGSize          size;
    NSUInteger      width;
    NSUInteger      height;
    __RGBPixel    * pixels;
    __RGBPixel    * pixel;
    NSUInteger      row;
    NSUInteger      column;
    CGFloat         gray;
    CGColorSpaceRef colorSpace;
    CGContextRef    context;
    CGImageRef      cgImage;
    NSImage       * image;
    
    size        = self.size;
    width       = ( NSUInteger )size.width;
    height      = ( NSUInteger )size.height;
    pixels      = ( __RGBPixel * )calloc( width * height, sizeof( __RGBPixel ) );
    
    if( pixels == NULL )
    {
        return nil;
    }
    
    colorSpace  = CGColorSpaceCreateDeviceRGB();
    context     = CGBitmapContextCreate
    (
        pixels,
        width,
        height,
        8,
        width * sizeof( __RGBPixel ),
        colorSpace,
        kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast
    );
    
    CGContextDrawImage
    (
        context,
        CGRectMake( ( CGFloat )0, ( CGFloat )0, ( CGFloat )width, ( CGFloat )height ),
        [ self CGImageForProposedRect: NULL context: [ NSGraphicsContext currentContext ] hints: nil ]
    );
    
    for( row = 0; row < height; row++ )
    {
        for( column = 0; column < width; column++ )
        {
            pixel = &( pixels[ row * width + column ] );
            gray  = ( CGFloat )0.299 * ( CGFloat )pixel->red;
            gray += ( CGFloat )0.587 * ( CGFloat )pixel->green;
            gray += ( CGFloat )0.114 * ( CGFloat )pixel->blue;
            
            pixel->red   = ( uint8_t )gray;
            pixel->green = ( uint8_t )gray;
            pixel->blue  = ( uint8_t )gray;
        }
    }
    
    cgImage = CGBitmapContextCreateImage( context );
    
    CGContextRelease( context );
    CGColorSpaceRelease( colorSpace );
    free( pixels );
    
    if( cgImage == NULL )
    {
        return nil;
    }
    
    image = [ [ NSImage alloc ] initWithCGImage: cgImage size: self.size ];
    
    CGImageRelease( cgImage );
    
    return [ image autorelease ];
}

@end
