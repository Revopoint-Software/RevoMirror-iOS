#import "RMI_WeakTools.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>


static CADisplayLink *displayLink = nil;
static NSMutableDictionary<NSString*,void(^)(double)> *displayLinkBlockList = nil;

static NSMutableDictionary<NSString*,NSTimer*> *timerList = nil;


@interface RMI_WeakTools____AutoRemove : NSObject
@property(nonatomic,copy)void(^onDealloc)(void);
@end

@implementation RMI_WeakTools____AutoRemove
-(void)dealloc{
    if (self.onDealloc!=nil) {
        self.onDealloc();
    }
}
@end


@interface RMI_WeakTools____DisplayLink____Handle : NSObject
@end

@implementation RMI_WeakTools____DisplayLink____Handle

-(void)onFrame{
    
    NSMutableDictionary *dic = [displayLinkBlockList copy];
    
    for (id key in dic) {
        void(^block)(double) = dic[key];
        if (block) {
            block(displayLink.duration);
        }
    }
}
@end


@interface RMI_WeakTools____Timer____Handle : NSObject
@property(nonatomic,copy)void(^block)(void);
@end

@implementation RMI_WeakTools____Timer____Handle

-(void)onTimer{
    if (_block) {
        _block();
    }
}

@end



@implementation RMI_WeakTools

+(void)addBlockOnDealloc:(id)obj key:(NSString*)key block:(void(^)(void))block{
    
    const char *objc_key = [key UTF8String];
    
    RMI_WeakTools____AutoRemove *autoRemove = objc_getAssociatedObject(obj,objc_key);
    
    if (autoRemove == nil) {
        autoRemove = [RMI_WeakTools____AutoRemove new];
        autoRemove.onDealloc = block;
        objc_setAssociatedObject(obj,objc_key, autoRemove, OBJC_ASSOCIATION_RETAIN);
    }
}


+(void)startDisplayLink:(id)obj block:(void(^)(double duration))block{
    NSString *key = [NSString stringWithFormat:@"%p",obj];
    
    static RMI_WeakTools____DisplayLink____Handle *handle = nil;
    
    if (handle == nil) {
       
        handle = [RMI_WeakTools____DisplayLink____Handle new];
    }
    
    
    if (displayLinkBlockList == nil) {
        
        displayLink = [CADisplayLink displayLinkWithTarget:handle selector:@selector(onFrame)];
        [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        
        
        displayLinkBlockList = [NSMutableDictionary new];
    }
    
    displayLinkBlockList[key] = block;
    
    [RMI_WeakTools addBlockOnDealloc:obj key:@"RMI_WeakTools____DisplayLink____Handle" block:^{
        [displayLinkBlockList removeObjectForKey:key];
    }];
    
}

+(void)stopDisplayLink:(id)obj{
    NSString *key = [NSString stringWithFormat:@"%p",obj];
    [displayLinkBlockList removeObjectForKey:key];
}



+(void)startTimer:(id)obj
     timeInterval:(double)timeInterval
      isImmediate:(BOOL)isImmediate
            block:(void(^)(void))block
{
    if (block && isImmediate) {
        block();//nstimer fire
    }
    
    
    NSString *key = [NSString stringWithFormat:@"%p",obj];
    
    
    if (timerList == nil) {
        timerList = [NSMutableDictionary new];
    }
    
    [RMI_WeakTools stopTimerWithKey:key];
    
    
    RMI_WeakTools____Timer____Handle *handle  = [RMI_WeakTools____Timer____Handle new];
    handle.block = block;
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:handle selector:@selector(onTimer) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];

    timerList[key] = timer;
    
    [RMI_WeakTools addBlockOnDealloc:obj key:@"RMI_WeakTools____Timer____Handle" block:^{
        [RMI_WeakTools stopTimerWithKey:key];
    }];
}

+(void)stopTimerWithKey:(NSString*)key{
    NSTimer *timer = timerList[key];
    [timer invalidate];
    
    [timerList removeObjectForKey:key];
}

+(void)stopTimer:(id)obj{
    NSString *key = [NSString stringWithFormat:@"%p",obj];
    [RMI_WeakTools stopTimerWithKey:key];
}






+(void)addTimerOneTimes:(id)obj timeInterval:(double)timeInterval block:(void(^)(void))block{
    
    
    NSString *key = [NSString stringWithFormat:@"%p",obj];
    
    static NSMutableDictionary<NSString*,NSMutableArray<NSTimer*>*> *dic = nil;
    
    if (dic == nil) {
        dic = [NSMutableDictionary new];
    }
    
    if (dic[key] == nil) {
        dic[key] = [NSMutableArray new];
    }
    
    RMI_WeakTools____Timer____Handle *handle  = [RMI_WeakTools____Timer____Handle new];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:handle selector:@selector(onTimer) userInfo:nil repeats:NO];
    
    [dic[key] addObject:timer];
    
    handle.block = ^{
        if (block) {
            block();
        }
        [dic[key] removeObject:timer];
        [timer invalidate];
    };
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    
    [RMI_WeakTools addBlockOnDealloc:obj key:@"RMI_WeakTools____addTimerOneTimes____Handle" block:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            for (NSTimer *t in dic[key]) {
                [t invalidate];
            }
            [dic removeObjectForKey:key];
        });
    }];
}

+(void)startTimerOneTimes:(id)obj timeInterval:(double)timeInterval block:(void(^)(void))block{
    
    
    NSString *key = [NSString stringWithFormat:@"%p",obj];
    
    static NSMutableDictionary<NSString*,NSTimer*> *dic = nil;
    
    if (dic == nil) {
        dic = [NSMutableDictionary new];
    }
    
    [dic[key] invalidate];//覆盖 停止之前的
    
    
    RMI_WeakTools____Timer____Handle *handle  = [RMI_WeakTools____Timer____Handle new];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:handle selector:@selector(onTimer) userInfo:nil repeats:NO];
    
    dic[key] = timer;
    
    handle.block = ^{
        if (block) {
            block();
        }
        [dic[key] invalidate];
        [dic removeObjectForKey:key];
    };
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    [RMI_WeakTools addBlockOnDealloc:obj key:@"RMI_WeakTools____startTimerOneTimes____Handle" block:^{
        [dic[key] invalidate];
        [dic removeObjectForKey:key];
    }];
    
}


+ (void)runWithHz:(id)obj hz:(float)hz block:(void(^)(void))block
{
    NSString *key = [NSString stringWithFormat:@"%p", obj];
    
    static NSMutableDictionary<NSString *, NSMutableArray<dispatch_source_t> *> *dic = nil;
    
    if (dic == nil) {
        dic = [NSMutableDictionary new];
    }
    
    if (dic[key] == nil) {
        dic[key] = [NSMutableArray new];
    }
    
    dispatch_queue_t queue = dispatch_queue_create("com.RevoScan.runWithHz",dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_DEFAULT, 0));
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, (1000/hz) * NSEC_PER_MSEC, 0);
    
    dispatch_source_set_event_handler(timer, ^{
        if (block) {
            block();
        }
    });
    
    dispatch_resume(timer);
    
    [dic[key] addObject:timer];
    
    
    static dispatch_queue_t removeKeyQueue;
    
    if (removeKeyQueue == nil) {
        removeKeyQueue = dispatch_queue_create("com.RevoScan.runWithHz.removeKey",dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_DEFAULT, 0));
    }
    
    [RMI_WeakTools addBlockOnDealloc:obj key:@"runWithHz" block:^{
        dispatch_async(removeKeyQueue, ^{
            for (dispatch_source_t time in dic[key]) {
                dispatch_source_cancel(time);
            }
            
            [dic removeObjectForKey:key];
        });
    }];
}


@end
