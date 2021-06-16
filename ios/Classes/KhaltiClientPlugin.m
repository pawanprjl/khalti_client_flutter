#import "KhaltiClientPlugin.h"
#if __has_include(<khalti_client/khalti_client-Swift.h>)
#import <khalti_client/khalti_client-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "khalti_client-Swift.h"
#endif

@implementation KhaltiClientPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftKhaltiClientPlugin registerWithRegistrar:registrar];
}
@end
