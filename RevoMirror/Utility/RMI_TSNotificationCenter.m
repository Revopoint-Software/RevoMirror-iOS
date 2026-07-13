#import "RMI_TSNotificationCenter.h"
#import "RMI_WeakTools.h"


@implementation RMI_TSNotificationCenter

+(NSMutableDictionary*) getBlockDic{
    static NSMutableDictionary* dic = nil;
    if (dic==nil) {
        dic=[NSMutableDictionary new];
    }
    //dic <string, <string,block> >
    return dic;
}

+(void)addObserver:(id)observer key:(NSString*)key value:(id)value{
    NSMutableDictionary *dic = [RMI_TSNotificationCenter getBlockDic];
    NSString *Id=[NSString stringWithFormat:@"(%s_%p)",object_getClassName(observer),observer];
    if (dic[Id]==nil) {
        dic[Id] =[NSMutableDictionary new];
    }
    
    [RMI_WeakTools addBlockOnDealloc:observer key:@"RMI_TSNotificationCenterAutoRemove" block:^{
        [RMI_TSNotificationCenter removeObserver:Id];
    }];
    
    
    //--------------------------debug--------------------------
//    if (dic[Id][key]!=nil) {
//        NSLog(@"[RMI_TSNotificationCenter] cover %@ %@",Id,key);
//    }else{
//        NSLog(@"[RMI_TSNotificationCenter] reg %@ %@",Id,key);
//    }
    //--------------------------debug--------------------------
    
    
    dic[Id][key] = value;
}

+(void)removeObserver:(NSString*)Id{
    NSMutableDictionary *dic = [RMI_TSNotificationCenter getBlockDic];
    [dic removeObjectForKey:Id];
    
    //--------------------------debug--------------------------
    NSLog(@"[RMI_TSNotificationCenter remove %@",Id);
    //--------------------------debug--------------------------
}

+(void)removeNotificationObserve:(id)observer
{
    NSString *Id=[NSString stringWithFormat:@"(%s_%p)",object_getClassName(observer),observer];
    [RMI_TSNotificationCenter removeObserver:Id];
}

#define TSNC_1(name) \
+(void)call_##name{\
NSMutableDictionary *dic = [RMI_TSNotificationCenter getBlockDic];\
NSArray *arr = dic.allKeys;\
for (int x=0;x<arr.count;x++){\
NSString* d = [arr objectAtIndex:x];\
void (^block)(void) = dic[d][@#name];\
if (block!=nil) {block();}}}


#define TSNC_3(name,type1,name1) \
+(void)call_##name##_with_##name1:(type1)name1{\
NSMutableDictionary *dic = [RMI_TSNotificationCenter getBlockDic];\
NSArray *arr = dic.allKeys;\
for (int x=0;x<arr.count;x++){\
NSString* d = [arr objectAtIndex:x];\
void (^block)(type1 name1) = dic[d][@#name];\
if (block!=nil) {block(name1);}}}


#define TSNC_5(name,type1,name1,type2,name2) \
+(void)call_##name##_with_##name1:(type1)name1 name2:(type2)name2{\
NSMutableDictionary *dic = [RMI_TSNotificationCenter getBlockDic];\
NSArray *arr = dic.allKeys;\
for (int x=0;x<arr.count;x++){\
NSString* d = [arr objectAtIndex:x];\
void (^block)(type1 name1,type2 name2) = dic[d][@#name];\
if (block!=nil) {block(name1,name2);}}}


#define TSNC_7(name,type1,name1,type2,name2,type3,name3) \
+(void)call_##name##_with_##name1:(type1)name1 name2:(type2)name2 name3:(type3)name3{\
NSMutableDictionary *dic = [RMI_TSNotificationCenter getBlockDic];\
NSArray *arr = dic.allKeys;\
for (int x=0;x<arr.count;x++){\
NSString* d = [arr objectAtIndex:x];\
void (^block)(type1 name1,type2 name2,type3 name3) = dic[d][@#name];\
if (block!=nil) {block(name1,name2,name3);}}}


#define TSNC_9(name,type1,name1,type2,name2,type3,name3,type4,name4) \
+(void)call_##name##_with_##name1:(type1)name1 name2:(type2)name2 name3:(type3)name3 name4:(type4)name4{\
NSMutableDictionary *dic = [RMI_TSNotificationCenter getBlockDic];\
NSArray *arr = dic.allKeys;\
for (int x=0;x<arr.count;x++){\
NSString* d = [arr objectAtIndex:x];\
void (^block)(type1 name1,type2 name2,type3 name3,type4 name4) = dic[d][@#name];\
if (block!=nil) {block(name1,name2,name3,name4);}}}


#define TSNC_11(name,type1,name1,type2,name2,type3,name3,type4,name4,type5,name5) \
+(void)call_##name##_with_##name1:(type1)name1 name2:(type2)name2 name3:(type3)name3 name4:(type4)name4 name5:(type5)name5{\
NSMutableDictionary *dic = [RMI_TSNotificationCenter getBlockDic];\
NSArray *arr = dic.allKeys;\
for (int x=0;x<arr.count;x++){\
NSString* d = [arr objectAtIndex:x];\
void (^block)(type1 name1,type2 name2,type3 name3,type4 name4,type5 name5) = dic[d][@#name];\
if (block!=nil) {block(name1,name2,name3,name4,name5);}}}

#include "RMI_TSNotificationCenter__config.h"

#undef TSNC_1
#undef TSNC_3
#undef TSNC_5
#undef TSNC_7
#undef TSNC_9
#undef TSNC_11

@end





@implementation NSObject(RMI_TSNotificationCenter)

#define TSNC_1(name) \
-(void)ts_##name:(void(^)(void))block\
{[RMI_TSNotificationCenter addObserver:self key:@#name value:block];}

#define TSNC_3(name,type1,name1) \
-(void)ts_##name:(void(^)(type1 name1))block \
{[RMI_TSNotificationCenter addObserver:self key:@#name value:block];}

#define TSNC_5(name,type1,name1,type2,name2) \
-(void)ts_##name:(void(^)(type1 name1,type2 name2))block\
{[RMI_TSNotificationCenter addObserver:self key:@#name value:block];}

#define TSNC_7(name,type1,name1,type2,name2,type3,name3) \
-(void)ts_##name:(void(^)(type1 name1,type2 name2,type3 name3))block\
{[RMI_TSNotificationCenter addObserver:self key:@#name value:block];}

#define TSNC_9(name,type1,name1,type2,name2,type3,name3,type4,name4) \
-(void)ts_##name:(void(^)(type1 name1,type2 name2,type3 name3,type4 name4))block\
{[RMI_TSNotificationCenter addObserver:self key:@#name value:block];}

#define TSNC_11(name,type1,name1,type2,name2,type3,name3,type4,name4,type5,name5) \
-(void)ts_##name:(void(^)(type1 name1,type2 name2,type3 name3,type4 name4,type5 name5))block\
{[RMI_TSNotificationCenter addObserver:self key:@#name value:block];}

#include "RMI_TSNotificationCenter__config.h"

#undef TSNC_1
#undef TSNC_3
#undef TSNC_5
#undef TSNC_7
#undef TSNC_9
#undef TSNC_11




-(void)ts_regSystemNotificationWithName:(NSString*)name block:(void(^)(NSNotification* notification))block{
    
    NSString *Id=[NSString stringWithFormat:@"(%s_%p)",object_getClassName(self),self];
    
    //-----static dic-----//
    static NSMutableDictionary *dic = nil;
    if (dic==nil) {
        dic=[NSMutableDictionary new];
    }
    if (dic[Id]==nil) {
        dic[Id] = [NSMutableArray new];
    }
    [dic[Id] addObject:[[NSNotificationCenter defaultCenter] addObserverForName:name object:nil queue:[NSOperationQueue mainQueue] usingBlock:block]];
    
    
    //--------------------------debug--------------------------
    NSLog(@"[RMI_TSNotificationCenter] system add %@ %@",Id,name);
    //--------------------------debug--------------------------
    
    
    
    [RMI_WeakTools addBlockOnDealloc:self key:@"SystemNotificationAutoRemove" block:^{
        for (id observer in dic[Id]) {
            [[NSNotificationCenter defaultCenter] removeObserver:observer];
        }
        [dic removeObjectForKey:Id];
        
        //--------------------------debug--------------------------
        NSLog(@"[RMI_TSNotificationCenter] system remove %@",Id);
        //--------------------------debug--------------------------
    }];
    
    
}

@end
