#import <Foundation/Foundation.h>

NS_ROOT_CLASS
@interface RMI_WeakTools

//obj回收前调用block
//注意:同1个obj 同1个key 只能添加1次 不能覆盖
+(void)addBlockOnDealloc:(id)obj key:(NSString*)key block:(void(^)(void))block;

//obj销毁自动stop  obj覆盖
//duration timeInterval 单帧时间 单位秒

+(void)startDisplayLink:(id)obj block:(void(^)(double duration))block;
+(void)stopDisplayLink:(id)obj;

//立刻执行
+(void)startTimer:(id)obj
     timeInterval:(double)timeInterval
      isImmediate:(BOOL)isImmediate
            block:(void(^)(void))block;

+(void)stopTimer:(id)obj;


//addTimerOneTimes 不覆盖
//不是立刻执行
+(void)addTimerOneTimes:(id)obj timeInterval:(double)timeInterval block:(void(^)(void))block;
+(void)startTimerOneTimes:(id)obj timeInterval:(double)timeInterval block:(void(^)(void))block;

// 创建一条串行队列的子线程运行计时器,block回调也在子线程
+ (void)runWithHz:(id)obj hz:(float)hz block:(void(^)(void))block;

@end
