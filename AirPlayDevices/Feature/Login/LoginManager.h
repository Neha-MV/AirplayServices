//
//  LoginManager.h
//  AirPlayDevices
//

// LoginManager.h
#import <Foundation/Foundation.h>
#import <AppAuth/AppAuth.h>

@interface LoginManager : NSObject

@property(nonatomic, strong, nullable) OIDAuthState *authState;
@property(nonatomic, strong, nullable) id<OIDExternalUserAgentSession> currentAuthorizationFlow;
+ (instancetype)sharedManager;
- (void)startOAuthFlowWithViewController:(UIViewController *)presentingViewController
                              completion:(void (^)(BOOL success, NSString * _Nullable token, NSError * _Nullable error))completion;
- (void)silentLoginWithCompletion:(void (^)(BOOL success))completion;
- (void)forceLogout;
- (BOOL)isNetworkReachable;

@end


