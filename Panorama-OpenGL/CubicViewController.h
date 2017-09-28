//
//  CubicViewController.h
//  Panorama-OpenGL
//
//  Created by Jakey on 2016/10/27.
//  Copyright © 2016年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface CubicViewController : GLKViewController
{
    UIPanGestureRecognizer *_panGesture;
    GLKMatrix4 _rotMatrix;
    
}
@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic, strong) GLKTextureInfo *cubemap;
@property (nonatomic, strong) GLKSkyboxEffect *skyboxEffect;

@property (nonatomic) float rotation;

@end
