//
//  CubicViewController.m
//  Panorama-OpenGL
//
//  Created by Jakey on 2016/10/27.
//  Copyright © 2016年 www.skyfox.org. All rights reserved.
//

#import "CubicViewController.h"
#import <OpenGLES/ES2/glext.h>

@interface CubicViewController ()

@end

@implementation CubicViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupGL];
}


-(void) panHandler:(UIPanGestureRecognizer*)sender{
    
    
    
}
- (void)setupGL
{
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    
    GLKView *view = (GLKView*)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [EAGLContext setCurrentContext:self.context];
    
    self.skyboxEffect = GLKSkyboxEffect.new;
    
    glEnable(GL_DEPTH_TEST);
    
    
    NSArray *cubeMapFileNames = [NSArray arrayWithObjects:
                                 [[NSBundle mainBundle] pathForResource:@"right" ofType:@"png"],
                                 [[NSBundle mainBundle] pathForResource:@"left" ofType:@"png"],
                                 [[NSBundle mainBundle] pathForResource:@"up" ofType:@"png"],
                                 [[NSBundle mainBundle] pathForResource:@"down" ofType:@"png"],
                                 [[NSBundle mainBundle] pathForResource:@"front" ofType:@"png"],
                                 [[NSBundle mainBundle] pathForResource:@"back" ofType:@"png"],
                                 nil];
    
    NSError *error;
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                        forKey:GLKTextureLoaderOriginBottomLeft];
    self.cubemap = [GLKTextureLoader cubeMapWithContentsOfFiles:cubeMapFileNames
                                                        options:options
                                                          error:&error];
    self.skyboxEffect.textureCubeMap.name = self.cubemap.name;
    
    glBindVertexArrayOES(0);
    
    _rotMatrix = GLKMatrix4Identity;
}

- (void)tearDownGL
{
    self.skyboxEffect = nil;
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
    float aspect = fabs(self.view.bounds.size.width / self.view.bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(80.0f), aspect, 0.1f, 100.0f);
    
    self.skyboxEffect.transform.projectionMatrix = projectionMatrix;
    
    //    _rotMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -3.5f);
    //    _rotMatrix = GLKMatrix4Rotate(_rotMatrix, self.rotation, 0.f, 1.f, 0.f);
    //    _rotMatrix = GLKMatrix4Scale(_rotMatrix, 50, 50, 50);
    self.skyboxEffect.transform.modelviewMatrix = _rotMatrix;
    
    //   self.rotation += self.timeSinceLastUpdate * 0.1f;
    
    
    //    float aspect = fabs(self.view.bounds.size.width / self.view.bounds.size.height);
    //    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 4.0f, 10.0f);
    //    self.skyboxEffect.transform.projectionMatrix = projectionMatrix;
    //
    //    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -6.0f);
    //    modelViewMatrix = GLKMatrix4Multiply(modelViewMatrix, _rotMatrix);
    //    self.skyboxEffect.transform.modelviewMatrix = modelViewMatrix;
    
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [self.skyboxEffect prepareToDraw];
    [self.skyboxEffect draw];
}


// Remove everything inside touchesBegan
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

// Add new touchesMoved method
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.view];
    CGPoint lastLoc = [touch previousLocationInView:self.view];
    CGPoint diff = CGPointMake(lastLoc.x - location.x, lastLoc.y - location.y);
    
    
    float rotX = -1 * GLKMathDegreesToRadians(diff.y / 2.0);
    float rotY = -1 * GLKMathDegreesToRadians(diff.x / 2.0);
    
    [self GetArcBallPosition:lastLoc.x withY:lastLoc.y];
    
    bool isInvertible;
    
    if (fabs(rotX)<fabs(rotY)) {
        GLKVector3 yAxis = GLKMatrix4MultiplyVector3(GLKMatrix4Invert(_rotMatrix, &isInvertible),
                                                     GLKVector3Make(0, 1, 0));
        _rotMatrix = GLKMatrix4Rotate(_rotMatrix, rotY, yAxis.x, yAxis.y, yAxis.z);
    }else{
        GLKVector3 xAxis = GLKMatrix4MultiplyVector3(GLKMatrix4Invert(_rotMatrix, &isInvertible),
                                                     GLKVector3Make(1, 0, 0));
        _rotMatrix = GLKMatrix4Rotate(_rotMatrix, rotX, xAxis.x, xAxis.y, xAxis.z);
        
    }
    
    
}
//
-(GLKVector3)GetArcBallPosition:(CGFloat)x withY:(CGFloat)y
{
    CGFloat _width = self.view.bounds.size.width;
    CGFloat _height = self.view.bounds.size.height;
    CGFloat _length = _width > _height ? _width : _height;
    
    CGFloat r_x = (_width / 2) / _length;
    CGFloat r_y = (_height / 2) / _length;
    CGFloat _radiusRadius = (float)(r_x * r_x + r_y * r_y);
    
    float rx = (x - _width / 2) / _length;
    float ry = (_height / 2 - y) / _length;
    float zz = _radiusRadius - rx * rx - ry * ry;
    float rz = (zz > 0 ? sqrt(zz) : 0);
    
    //    GLKVector3 result = GLKVector3Make((float)(rx * _vectorRight.X + ry * _vectorUp.X + rz * _vectorCenterEye.X),
    //                   (float)(rx * _vectorRight.Y + ry * _vectorUp.Y + rz * _vectorCenterEye.Y),
    //                    (float)(rx * _vectorRight.Z + ry * _vectorUp.Z + rz * _vectorCenterEye.Z));
    GLKVector3 result;
    return result;
}

@end
