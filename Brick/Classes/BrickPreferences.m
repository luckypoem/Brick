#import "BrickPreferences.h"

const NSString *DebugFlag = @"debug";

// Duplicated in BrickLayer
const NSString *launchDaemonPlistPath = @"/Library/LaunchDaemons/com.funkensturm.Brick.plist";

@implementation BrickPreferences

# pragma mark Initialization

+ (void) loadDefaults {
  NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Defaults" ofType:@"plist"];
  NSDictionary *defaults = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
  [Log debug:@"Registering default preferences..."];
  [[self backend] registerDefaults:defaults];
  [Log debug:@"Ensuring empty preferences file on disk..."];
  [[self backend] setBool:YES forKey:@"booted"];
  [[self backend] synchronize];
}

# pragma mark Public Getters

+ (BOOL) debugMode {
  return [[self backend] boolForKey:(NSString*)DebugFlag];
}

+ (BOOL) rememberingOnReboot {
  return [[NSFileManager defaultManager] fileExistsAtPath:(NSString*)launchDaemonPlistPath];
}

+ (NSString*) preferencesFilePath {
  NSArray *path = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
  NSString *folder = [path objectAtIndex:0];
  NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
  NSString *filename = [NSString stringWithFormat:@"%@.plist", bundleIdentifier];
  return [[folder stringByAppendingPathComponent:@"Preferences"] stringByAppendingPathComponent:filename];
}

# pragma mark Public Setters

+ (void) toggleDebugMode {
  if ([self debugMode]) {
    [Log debug:@"Deactivating Debug Mode..."];
    [[self backend] setBool:YES forKey:(NSString*)DebugFlag];
  } else {
    [Log debug:@"Activating Debug Mode..."];
    [[self backend] setBool:NO forKey:(NSString*)DebugFlag];
  }
}

# pragma mark Internal Getters

+ (NSUserDefaults*) backend {
  return [NSUserDefaults standardUserDefaults];
}

@end
