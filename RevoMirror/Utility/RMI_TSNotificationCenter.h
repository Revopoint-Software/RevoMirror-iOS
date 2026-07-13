#import <Foundation/Foundation.h>

#define COUNT_PARMS2(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,RESULT, ...) RESULT
#define COUNT_PARMS(...) COUNT_PARMS2(__VA_ARGS__,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1)

#define STRING_CONNECT__(A, B) A ## B
#define STRING_CONNECT(A, B) STRING_CONNECT__(A, B)

#define TSNC(...) STRING_CONNECT(TSNC_,COUNT_PARMS(__VA_ARGS__))(__VA_ARGS__)

NS_ROOT_CLASS
@interface RMI_TSNotificationCenter

#define TSNC_1(name) \
+(void)call_##name;

#define TSNC_3(name,type1,name1) \
+(void)call_##name##_with_##name1:(type1)name1;

#define TSNC_5(name,type1,name1,type2,name2) \
+(void)call_##name##_with_##name1:(type1)name1 name2:(type2)name2;

#define TSNC_7(name,type1,name1,type2,name2,type3,name3) \
+(void)call_##name##_with_##name1:(type1)name1 name2:(type2)name2 name3:(type3)name3;

#define TSNC_9(name,type1,name1,type2,name2,type3,name3,type4,name4) \
+(void)call_##name##_with_##name1:(type1)name1 name2:(type2)name2 name3:(type3)name3 name4:(type4)name4;

#define TSNC_11(name,type1,name1,type2,name2,type3,name3,type4,name4,type5,name5) \
+(void)call_##name##_with_##name1:(type1)name1 name2:(type2)name2 name3:(type3)name3 name4:(type4)name4 name5:(type5)name5;

#include "RMI_TSNotificationCenter__config.h"

#undef TSNC_1
#undef TSNC_3
#undef TSNC_5
#undef TSNC_7
#undef TSNC_9
#undef TSNC_11

+(void)removeNotificationObserve:(id)observer;

@end




@interface NSObject(RMI_TSNotificationCenter)
#define TSNC_1(name) \
-(void)ts_##name:(void(^)(void))block;

#define TSNC_3(name,type1,name1) \
-(void)ts_##name:(void(^)(type1 name1))block;

#define TSNC_5(name,type1,name1,type2,name2) \
-(void)ts_##name:(void(^)(type1 name1,type2 name2))block;

#define TSNC_7(name,type1,name1,type2,name2,type3,name3) \
-(void)ts_##name:(void(^)(type1 name1,type2 name2,type3 name3))block;

#define TSNC_9(name,type1,name1,type2,name2,type3,name3,type4,name4) \
-(void)ts_##name:(void(^)(type1 name1,type2 name2,type3 name3,type4 name4))block;

#define TSNC_11(name,type1,name1,type2,name2,type3,name3,type4,name4,type5,name5) \
-(void)ts_##name:(void(^)(type1 name1,type2 name2,type3 name3,type4 name4,type5 name5))block;

#include "RMI_TSNotificationCenter__config.h"

#undef TSNC_1
#undef TSNC_3
#undef TSNC_5
#undef TSNC_7
#undef TSNC_9
#undef TSNC_11

-(void)ts_regSystemNotificationWithName:(NSString*)name block:(void(^)(NSNotification *notification))block;

@end

