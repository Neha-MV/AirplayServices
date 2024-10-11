// LoginManager.m
#import "LoginManager.h"
#import <SystemConfiguration/SystemConfiguration.h>

@implementation LoginManager

+ (instancetype)sharedManager {
    static LoginManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)startOAuthFlowWithViewController:(UIViewController *)presentingViewController completion:(void (^)(BOOL success, NSString *token, NSError *error))completion {

    NSURL *issuer = [NSURL URLWithString:@"https://accounts.google.com"];
    NSURL *redirectURI = [NSURL URLWithString:@"com.demo.Airplay.AirPlayDevices:/oauthredirect"]; // Make sure this is registered

    // Discover configuration from the issuer URL
    [OIDAuthorizationService discoverServiceConfigurationForIssuer:issuer
        completion:^(OIDServiceConfiguration * _Nullable configuration, NSError * _Nullable error) {
            if (!configuration) {
                NSLog(@"Error retrieving discovery document: %@", [error localizedDescription]);
                return;
            }

            // Create the authorization request
            OIDAuthorizationRequest *request = [[OIDAuthorizationRequest alloc] initWithConfiguration:configuration
                                                                                             clientId:@"116696020893-6plcf0luuas529gen2bhb3cuedea6tvu.apps.googleusercontent.com"
                                                                                         clientSecret:nil
                                                                                               scopes:@[OIDScopeOpenID, OIDScopeProfile]
                                                                                          redirectURL:redirectURI
                                                                                         responseType:OIDResponseTypeCode
                                                                                 additionalParameters:nil];

            // Make sure the presenting view controller is valid (not nil)
            if (presentingViewController == nil) {
                NSLog(@"Error: presentingViewController is nil");
                return;
            }

            // Start the OAuth authorization request
            self.currentAuthorizationFlow =
                [OIDAuthState authStateByPresentingAuthorizationRequest:request
                                               presentingViewController:presentingViewController
                                                               callback:^(OIDAuthState *_Nullable authState, NSError *_Nullable error) {
                    if (authState) {
                        NSLog(@"Authorization successful: %@", authState.lastTokenResponse.accessToken);
                        NSData *tokenData = [NSKeyedArchiver archivedDataWithRootObject:authState requiringSecureCoding:NO error:nil];
                           [[NSUserDefaults standardUserDefaults] setObject:tokenData forKey:@"OAuthToken"];
                        completion(YES, authState.lastTokenResponse.accessToken, nil);
                    } else {
                        NSLog(@"Authorization error: %@", [error localizedDescription]);
                        completion(NO, nil, error);
                    }
                }];
    }];
}


- (void)silentLoginWithCompletion:(void (^)(BOOL success))completion {
    NSData *tokenData = [[NSUserDefaults standardUserDefaults] objectForKey:@"OAuthToken"];

    if (tokenData) {
        self.authState = [NSKeyedUnarchiver unarchivedObjectOfClass:[OIDAuthState class] fromData:tokenData error:nil];
        if (self.authState && self.authState.isAuthorized) {
            completion(YES);
        } else {
            [self forceLogout];
            completion(NO);
        }
    } else {
        completion(NO);
    }
}

- (void)forceLogout {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"OAuthToken"];
}

- (BOOL)isNetworkReachable {
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, "www.google.com");
    SCNetworkReachabilityFlags flags;
    BOOL isReachable = SCNetworkReachabilityGetFlags(reachability, &flags);
    CFRelease(reachability);
    return isReachable && (flags & kSCNetworkReachabilityFlagsReachable) && !(flags & kSCNetworkReachabilityFlagsConnectionRequired);
}

@end
