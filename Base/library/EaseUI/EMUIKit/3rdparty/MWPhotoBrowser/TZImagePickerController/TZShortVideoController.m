//
//  TZShortVideoController.m
//  wisdomstudy
//
//  Created by ggx on 2017/8/24.
//  Copyright © 2017年 高广校. All rights reserved.
//

#import "TZShortVideoController.h"
#import <AVFoundation/AVFoundation.h>
#import "SDShortVideoProgressView.h"
typedef void(^PropertyChangeBlock)(AVCaptureDevice *captureDevice);
#define kMaxVideoLength 10
#define kProgressTimerTimeInterval 0.015
#define Global_tintColor [UIColor colorWithRed:0 green:(190 / 255.0) blue:(12 / 255.0) alpha:1]
@interface TZShortVideoController ()
{
    BOOL isMovie;
}

@property (weak, nonatomic)IBOutlet UIView *viewContainer; //视频区域
@property (strong,nonatomic) AVCaptureSession *captureSession;//负责输入和输出设备之间的数据传递
@property (strong,nonatomic) AVCaptureDeviceInput *captureDeviceInput;//负责从AVCaptureDevice获得输入数据
@property (strong,nonatomic) AVCaptureStillImageOutput *captureStillImageOutput;//照片输出流
@property (strong,nonatomic) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;//相机拍摄预览图层

@property (nonatomic,weak) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *ConfirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *takeButton;//拍照按钮
@property (nonatomic, weak) IBOutlet UILabel *cancelAlertLabel;
@property (weak, nonatomic) IBOutlet SDShortVideoProgressView *progressView;

@property (weak, nonatomic) UIImageView *focusCursor; //聚焦光标

@property (nonatomic, strong) NSTimer *progressTimer;
@property (assign,nonatomic) BOOL enableRotation;//是否允许旋转（注意在视频录制过程中禁止屏幕旋转）
@property (strong,nonatomic) AVCaptureMovieFileOutput *captureMovieFileOutput;//视频输出流

@property (assign,nonatomic) UIBackgroundTaskIdentifier backgroundTaskIdentifier;//后台任务标识
@property (nonatomic, assign) CGFloat videoLength; //视频长度
@property (nonatomic, strong) NSURL *outputMovieURL;
@end

@implementation TZShortVideoController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupCaptureSession];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupCaptureSession];
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.captureSession startRunning];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.captureSession stopRunning];
}


#pragma mark - UI方法
#pragma mark 视频录制
//开始录制
- (IBAction)LongDown:(UIButton *)sender {
    [self startRecordingVideo];
}
//结束录制
- (IBAction)UpInside:(UIButton *)sender {
    //结束录制
    [self endRecordingVideo];
}
- (IBAction)cancelButtonClicked:(UIButton *)sender forEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:true completion:nil];

}
//完成录制，返回
- (void)CongirmMovie{
    if (self.cancelOperratonBlock) {
        self.cancelOperratonBlock(self.outputMovieURL);
    }
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)setupCaptureSession
{
    //初始化会话
    _captureSession=[[AVCaptureSession alloc]init];
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]) {//设置分辨率
        _captureSession.sessionPreset=AVCaptureSessionPreset1280x720;
    }
    //获得输入设备
    AVCaptureDevice *captureDevice=[self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];//取得后置摄像头
    if (!captureDevice) {
        NSLog(@"取得后置摄像头时出现问题.");
        return;
    }
    //添加一个音频输入设备
    AVCaptureDevice *audioCaptureDevice=[[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    
    
    NSError *error=nil;
    //根据输入设备初始化设备输入对象，用于获得输入数据
    _captureDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:captureDevice error:&error];
    if (error) {
        NSLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    AVCaptureDeviceInput *audioCaptureDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:audioCaptureDevice error:&error];
    if (error) {
        NSLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    //初始化设备输出对象，用于获得输出数据
    _captureMovieFileOutput=[[AVCaptureMovieFileOutput alloc]init];
    
    //将设备输入添加到会话中
    if ([_captureSession canAddInput:_captureDeviceInput]) {
        [_captureSession addInput:_captureDeviceInput];
        [_captureSession addInput:audioCaptureDeviceInput];
        AVCaptureConnection *captureConnection=[_captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        if ([captureConnection isVideoStabilizationSupported ]) {
            captureConnection.preferredVideoStabilizationMode=AVCaptureVideoStabilizationModeAuto;
        }
    }
    
    //将设备输出添加到会话中
    if ([_captureSession canAddOutput:_captureMovieFileOutput]) {
        [_captureSession addOutput:_captureMovieFileOutput];
    }
    
    //创建视频预览层，用于实时展示摄像头状态
    _captureVideoPreviewLayer=[[AVCaptureVideoPreviewLayer alloc]initWithSession:self.captureSession];
    
    CALayer *layer=self.viewContainer.layer;
    layer.masksToBounds=YES;
    
    _captureVideoPreviewLayer.frame= layer.bounds;
    _captureVideoPreviewLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;//填充模式
    //将视频预览层添加到界面中
    //[layer addSublayer:_captureVideoPreviewLayer];
    [layer insertSublayer:_captureVideoPreviewLayer below:self.focusCursor.layer];
    
    _enableRotation=YES;
    [self addNotificationToCaptureDevice:captureDevice];
    [self addGenstureRecognizer];
}
#pragma mark - 通知
/**
 *  给输入设备添加通知
 */
-(void)addNotificationToCaptureDevice:(AVCaptureDevice *)captureDevice{
    //注意添加区域改变捕获通知必须首先设置设备允许捕获
//    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
//        captureDevice.subjectAreaChangeMonitoringEnabled=YES;
//    }];
//    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
//    //捕获区域发生改变
//    [notificationCenter addObserver:self selector:@selector(areaChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}
/**
 *  改变设备属性的统一操作方法
 *
 *  @param propertyChange 属性改变操作
 */
-(void)changeDeviceProperty:(PropertyChangeBlock)propertyChange{
//    AVCaptureDevice *captureDevice= [self.captureDeviceInput device];
//    NSError *error;
//    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
//    if ([captureDevice lockForConfiguration:&error]) {
//        propertyChange(captureDevice);
//        [captureDevice unlockForConfiguration];
//    }else{
//        NSLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
//    }
}

/**
 *  添加点按手势，点按时聚焦
 */
-(void)addGenstureRecognizer{
//    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScreen:)];
//    [self.viewContainer addGestureRecognizer:tapGesture];
}

#pragma mark - 私有方法

/**
 *  取得指定位置的摄像头
 *
 *  @param position 摄像头位置
 *
 *  @return 摄像头设备
 */
-(AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position{
    NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position]==position) {
            return camera;
        }
    }
    return nil;
}

- (void)startRecordingVideo
{
    [self setupTimer];
    
    //根据设备输出获得连接
    AVCaptureConnection *captureConnection=[self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    if (![self.captureMovieFileOutput isRecording]) {
        self.enableRotation=NO;
        //如果支持多任务则则开始多任务
        if ([[UIDevice currentDevice] isMultitaskingSupported]) {
            self.backgroundTaskIdentifier=[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
        }
        //预览图层和视频方向保持一致
        captureConnection.videoOrientation=[self.captureVideoPreviewLayer connection].videoOrientation;
        NSString *outputFielPath=[NSTemporaryDirectory() stringByAppendingString:@"myMovie.mov"];
        NSLog(@"save path is :%@",outputFielPath);
        NSURL *fileUrl=[NSURL fileURLWithPath:outputFielPath];
        [self.captureMovieFileOutput startRecordingToOutputFileURL:fileUrl recordingDelegate:self];
    }
}
#pragma mark - 视频输出代理
-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections{
    NSLog(@"开始录制...");
}
-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error{
    
    self.cancelAlertLabel.hidden = YES;
    self.ConfirmBtn.hidden       = NO;
    self.takeButton.hidden       = YES;
    [self.takeButton setTitleColor:Global_tintColor forState:UIControlStateNormal];
    self.progressView.progressLine.backgroundColor = Global_tintColor;
    
    
//    if (self.shouldCancel) {
//        self.shouldCancel = NO;
//        return;
//    }
    NSLog(@"视频录制完成.");
    //视频录入完成之后在后台将视频存储到相簿
    self.enableRotation=YES;
    UIBackgroundTaskIdentifier lastBackgroundTaskIdentifier = self.backgroundTaskIdentifier;
    self.backgroundTaskIdentifier=UIBackgroundTaskInvalid;
    
    self.outputMovieURL = outputFileURL;
    
    [self CongirmMovie];
    
}

- (void)endRecordingVideo{
    [self removeTimer];
    NSLog(@" = %f",self.videoLength);
    if (self.videoLength > 0.3) {
        //录像
        NSLog(@"进行录像处理");
    }else{
        //拍照
        NSLog(@"进行拍照处理");
    }
    if ([self.captureMovieFileOutput isRecording]) {
        [self.captureMovieFileOutput stopRecording];//停止录制
    }
}

- (void)setupTimer
{
    self.progressView.hidden = NO;
    self.videoLength = 0;
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:kProgressTimerTimeInterval target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
}
- (void)removeTimer{
    self.progressView.progress = 0;
    self.progressView.hidden = YES;
    
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

- (void)updateProgress
{
    if (self.videoLength >= kMaxVideoLength) {
        [self endRecordingVideo];
        return;
    }
    self.videoLength += kProgressTimerTimeInterval;
    CGFloat progress = self.videoLength / kMaxVideoLength;
    NSLog(@"%f",self.videoLength);
    self.progressView.progress = progress;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
