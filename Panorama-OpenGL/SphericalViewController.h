//
//   SphericalViewController.h
//  Panorama-OpenGL
//
//  Created by Jakey on 16/7/20.
//  Copyright © 2016年 www.skyfox.org. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface SphericalViewController : GLKViewController
{
    GLKMatrix4 modelViewProjectionMatrix;
    GLKMatrix3 normalMatrix;
    float rotation;
    
    GLuint vertexArray;
    GLuint vertexBuffer;
    

}
@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic, strong) GLKTextureInfo *texture;
@property (nonatomic, strong) GLKBaseEffect *effect;


@end
