//
//  Digits.h
//
//  Copyright (c) 2015 Twitter. All rights reserved.
//

#if TARGET_OS_WATCH
#error Digits doesn't support watchOS
#endif

#import <DigitsKit/DGTAppearance.h>
#if !TARGET_OS_TV
#import <DigitsKit/DGTAuthenticateButton.h>
#import <DigitsKit/DGTContactAccessAuthorizationStatus.h>
#endif
#import <DigitsKit/DGTSession.h>
#import <TwitterCore/TWTRAuthConfig.h>

@class DGTAuthenticationConfiguration;
@class DGTDebugConfiguration;
@class TWTRAuthConfig;
@class UIViewController;
@protocol DGTSessionUpdateDelegate;
@protocol DGTAuthEventDelegate;
@protocol DGTContactsEventDelegate;
@protocol DGTCompletionViewController;

NS_ASSUME_NONNULL_BEGIN

/**
 *  The `Digits` class contains the main methods to implement the Digits authentication flow.
 */
@interface Digits : NSObject

/**
 *  Returns the unique Digits object (singleton).
 *
 *  @return The Digits singleton.
 */
+ (Digits *)sharedInstance;

/**
 *  Start Digits with your consumer key and secret. These will override any credentials
 *  present in your applications Info.plist.
 *
 *  You do not need to call this method unless you wish to provide credentials other than those
 *  in your Info.plist.
 *
 *  @param consumerKey    Your Digits application's consumer key.
 *  @param consumerSecret Your Digits application's consumer secret.
 */
- (void)startWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret;

/**
 *  Start Digits with a consumer key, secret, and keychain access group. See -[Digits startWithConsumerKey:consumerSecret:]
 *
 *  @param consumerKey    Your Digits application's consumer key.
 *  @param consumerSecret Your Digits application's consumer secret.
 *  @param accessGroup    An optional keychain access group to apply to session objects stored in the keychain.
 *
 *  @note In the majority of situations applications will not need to specify an access group to use with Digits sessions.
 *  This value is only needed if you plan to share credentials with another application that you control or if you are
 *  using Digits with an app extension.
 */
- (void)startWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret accessGroup:(nullable NSString *)accessGroup;

/**
 *
 *  @return The Digits user session or nil if there's no authenticated user.
 */
- (nullable DGTSession *)session;

/**
 *  Authentication configuration details. Encapsulates the `consumerKey` and `consumerSecret` credentials required to authenticate a Twitter application.
 */
@property (nonatomic, strong, readonly) TWTRAuthConfig *authConfig;

/**
 *  Notifies whenever there have been changes to the Digits Session or if it is no longer a valid session.
 */
@property (nonatomic, weak) id<DGTSessionUpdateDelegate> sessionUpdateDelegate;

/**
 *  Be notified of various events taking place during the authentcation flow.  
 */
@property (nonatomic, weak) id<DGTAuthEventDelegate> authEventDelegate;

/**
 *  Be notified of various contacts related activities flow.
 */
@property (nonatomic, weak) id<DGTContactsEventDelegate> contactsEventDelegate;


/**
 *  Configuration to override Digits behavior. e.g. provide a digits session stub that will be returned instead of completing the authentication flow.
 */
@property (nonatomic, strong, nullable) DGTDebugConfiguration *debugOverrides;

/**
 *  Starts the authentication flow UI with the standard appearance. The UI is presented as a modal off of the top-most view controller. The modal title is the application name.
 *
 *  @param completion Block called after the authentication flow has ended.
 */
- (void)authenticateWithCompletion:(DGTAuthenticationCompletion)completion __TVOS_UNAVAILABLE;

/**
 *  Starts the authentication flow in a modal UI
 *
 *  @param viewController    View controller used to present the modal authentication controller. Pass `nil` to use default top-most view controller.
 *  @param configuration     Options to configure the Digits experience
 *  @param completion        Block called after the authentication flow has ended.
 */
- (void)authenticateWithViewController:(nullable UIViewController *)viewController configuration:(DGTAuthenticationConfiguration *)configuration completion:(DGTAuthenticationCompletion)completion __TVOS_UNAVAILABLE;

/**
 *  Starts the authentication flow in your own navigation UI. Digits view controllers will be pushed into the passed navigation controller and after the flow is done, success or failure; the completion view controller will be pushed into the top of the original stack.
 *
 *  @param navigationController     Navigation controller used to pushed the Digits view into.
 *  @param configuration            Options to configure the Digits experience
 *  @param completionViewController View controller pushed to the navigation controller when the auth flow is completed
 */
- (void)authenticateWithNavigationViewController:(UINavigationController *)navigationController configuration:(DGTAuthenticationConfiguration *)configuration completionViewController:(id<DGTCompletionViewController>)completionViewController __TVOS_UNAVAILABLE;

/**
 *  Deletes the local Digits user session from this app. This will not make a network request to invalidate the session. Subsequent calls to `authenticateWith` methods will start a new Digits authentication flow.
 */
- (void)logOut;

@end

NS_ASSUME_NONNULL_END
