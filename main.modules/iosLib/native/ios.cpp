#import "FlurryAnalytics.h"

void flurryInit(String secret_code){
    
    NSString *secretCode = secret_code.ToNSString();
    [FlurryAnalytics startSession:secretCode];
    
}

void flurrySendEvent(String event_name){
    
    NSString *eventName = event_name.ToNSString();
    [FlurryAnalytics logEvent:eventName];
    
}

#import <GameKit/GameKit.h>
//#include "console.h" 
#import <sys/utsname.h>

@interface GameCenter : UIViewController <GKLeaderboardViewControllerDelegate, GKAchievementViewControllerDelegate>
{
	bool isAuthenticated;
	bool gameCenterAvailable;
    bool isViewOpened;
    
	UIViewController *gameCenterViewController;
}

@property (nonatomic,retain) UIViewController *gameCenterViewController;

- (void)authenticateLocalPlayer;
- (void)registerForAuthenticationNotification;
- (void)authenticationChanged;
- (bool)isAuthenticated;
- (bool)isViewOpened;

- (void)reportScore:(int64_t)score forCategory:(NSString*)category;
- (void)reportScore:(GKScore *)scoreReporter;
- (void)saveScoreToDevice:(GKScore *)score;
- (void)retrieveScoresFromDevice;
- (void)showLeaderboard;
- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController;

- (void)reportAchievementIdentifier:(NSString*)identifier percentComplete:(float)percent;
- (void)reportAchievementIdentifier:(GKAchievement *)achievement;
- (void)saveAchievementToDevice:(GKAchievement *)achievement;
- (void)retrieveAchievementsFromDevice;
- (void)showAchievements;
- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController;

- (void)close;

@end

static GameCenter *gameCenter;

namespace GameCenterWrapper {
	void authenticate();
	void reportScore(int score, int category);
	void reportAchievement(int achievement);
	bool isAuthenticated();
	void showLeaderboard();
	void showAchievements();
	void close();
}

bool IsGameCenterAvailable()
{
    // Check for presence of GKLocalPlayer API.	
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));	
	
    // The device must be running running iOS 4.1 or later.	
    NSString *reqSysVer = @"4.1";	
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];	
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);	
	
    return (gcClass && osVersionSupported);
}

@implementation GameCenter

@synthesize gameCenterViewController;

//--------------------------------------------------------
// Static functions/variables
//--------------------------------------------------------

static NSString *getGameCenterSavePath()
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [NSString stringWithFormat:@"%@/GameCenterSave.txt",[paths objectAtIndex:0]];
}

static NSString *scoresArchiveKey = @"Scores";

static NSString *achievementsArchiveKey = @"Achievements";

//--------------------------------------------------------
// Authentication
//--------------------------------------------------------

- (void)authenticateLocalPlayer {
	isAuthenticated = NO; // assume the player isn't authenticated
	gameCenterAvailable = IsGameCenterAvailable();
	
	if(!gameCenterAvailable){
		return;
	}
	
	gameCenterViewController = [[UIViewController alloc] init];
	
    [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error) {		
     if (error == nil){
     // Insert code here to handle a successful authentication.
     isAuthenticated = YES;
     [self registerForAuthenticationNotification];
     
     // report any unreported scores or achievements
     [self retrieveScoresFromDevice];
     [self retrieveAchievementsFromDevice];
     
     // let the scripts know
     //Con::executef(2,"gameCenterAuthenticationChanged","1");
     }else{
     //Con::executef(2,"gameCenterAuthenticationChanged","0");
     }
     }];
}

- (void)registerForAuthenticationNotification
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver: self selector:@selector(authenticationChanged) name:GKPlayerAuthenticationDidChangeNotificationName object:nil];
}

- (void)authenticationChanged
{
	isAuthenticated = NO; // assume the player isn't authenticated
	gameCenterAvailable = IsGameCenterAvailable();
	
	if(!gameCenterAvailable){
		return;
	}
	
    if ([GKLocalPlayer localPlayer].isAuthenticated){		
        // Insert code here to handle a successful authentication.
		isAuthenticated = YES;
		
		// report any unreported scores or achievements
		[self retrieveScoresFromDevice];
		[self retrieveAchievementsFromDevice];
		
		// let the scripts know
		//Con::executef(2,"gameCenterAuthenticationChanged","1");
	}else{
		//Con::executef(2,"gameCenterAuthenticationChanged","0");
	}
}

- (bool)isAuthenticated
{
	return gameCenterAvailable && isAuthenticated;
}

//--------------------------------------------------------
// Leaderboard
//--------------------------------------------------------

- (void)reportScore:(int64_t)score forCategory:(NSString*)category
{
	if(!gameCenterAvailable)
		return;
	
    GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:category] autorelease];
	if(scoreReporter){
		scoreReporter.value = score;	
		
		[scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {	
         if (error != nil){
         // handle the reporting error
         [self saveScoreToDevice:scoreReporter];
         }
         }];	
	}
}

- (void)reportScore:(GKScore *)scoreReporter
{
	if(!gameCenterAvailable)
		return;
	
	if(scoreReporter){
		[scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {	
         if (error != nil){
         // handle the reporting error
         [self saveScoreToDevice:scoreReporter];
         }
         }];	
	}
}

- (void)saveScoreToDevice:(GKScore *)score
{
	NSString *savePath = getGameCenterSavePath();
	
	// If scores already exist, append the new score.
	NSMutableArray *scores = [[[NSMutableArray alloc] init] autorelease];
	NSMutableDictionary *dict;
	if([[NSFileManager defaultManager] fileExistsAtPath:savePath]){
		dict = [[[NSMutableDictionary alloc] initWithContentsOfFile:savePath] autorelease];
		
		NSData *data = [dict objectForKey:scoresArchiveKey];
		if(data) {
			NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
			scores = [unarchiver decodeObjectForKey:scoresArchiveKey];
			[unarchiver finishDecoding];
			[unarchiver release];
			[dict removeObjectForKey:scoresArchiveKey]; // remove it so we can add it back again later
		}
	}else{
		dict = [[[NSMutableDictionary alloc] init] autorelease];
	}
	
	[scores addObject:score];
	
	// The score has been added, now save the file again
	NSMutableData *data = [NSMutableData data];	
	NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	[archiver encodeObject:scores forKey:scoresArchiveKey];
	[archiver finishEncoding];
	[dict setObject:data forKey:scoresArchiveKey];
	[dict writeToFile:savePath atomically:YES];
	[archiver release];
}

- (void)retrieveScoresFromDevice
{
	NSString *savePath = getGameCenterSavePath();
	
	// If there are no files saved, return
	if(![[NSFileManager defaultManager] fileExistsAtPath:savePath]){
		return;
	}
	
	// First get the data
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:savePath];
	NSData *data = [dict objectForKey:scoresArchiveKey];
	
	// A file exists, but it isn't for the scores key so return
	if(!data){
		return;
	}
	
	NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
	NSArray *scores = [unarchiver decodeObjectForKey:scoresArchiveKey];
	[unarchiver finishDecoding];
	[unarchiver release];
	
	// remove the scores key and save the dictionary back again
	[dict removeObjectForKey:scoresArchiveKey];
	[dict writeToFile:savePath atomically:YES];
	
	
	// Since the scores key was removed, we can go ahead and report the scores again
	for(GKScore *score in scores){
		[self reportScore:score];
	}
}

- (void)showLeaderboard
{
	if(!isAuthenticated)
		return;
	
    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];	
    if (leaderboardController != nil) {
        leaderboardController.leaderboardDelegate = self;
		
		UIWindow* window = [UIApplication sharedApplication].keyWindow;
		[window addSubview: gameCenterViewController.view];
        [gameCenterViewController presentModalViewController: leaderboardController animated: YES];
        isViewOpened = YES;
    }	
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    [gameCenterViewController dismissModalViewControllerAnimated:YES];
	[viewController.view removeFromSuperview];
	[viewController release];
    isViewOpened = NO;
}

//--------------------------------------------------------
// Achievements
//--------------------------------------------------------

- (void)reportAchievementIdentifier:(NSString*)identifier percentComplete:(float)percent
{
	if(!gameCenterAvailable)
		return;
	
    GKAchievement *achievement = [[[GKAchievement alloc] initWithIdentifier: identifier] autorelease];	
    if (achievement){		
		achievement.percentComplete = percent;		
		[achievement reportAchievementWithCompletionHandler:^(NSError *error){
         if (error != nil){
         [self saveAchievementToDevice:achievement];
         }		 
         }];
    }
}

- (void)reportAchievementIdentifier:(GKAchievement *)achievement
{	
	if(!gameCenterAvailable)
		return;
	
    if (achievement){		
		[achievement reportAchievementWithCompletionHandler:^(NSError *error){
         if (error != nil){
         [self saveAchievementToDevice:achievement];
         }		 
         }];
    }
}

- (void)saveAchievementToDevice:(GKAchievement *)achievement
{
	
	NSString *savePath = getGameCenterSavePath();
	
	// If achievements already exist, append the new achievement.
	NSMutableArray *achievements = [[[NSMutableArray alloc] init] autorelease];
	NSMutableDictionary *dict;
	if([[NSFileManager defaultManager] fileExistsAtPath:savePath]){
		dict = [[[NSMutableDictionary alloc] initWithContentsOfFile:savePath] autorelease];
		
		NSData *data = [dict objectForKey:achievementsArchiveKey];
		if(data) {
			NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
			achievements = [unarchiver decodeObjectForKey:achievementsArchiveKey];
			[unarchiver finishDecoding];
			[unarchiver release];
			[dict removeObjectForKey:achievementsArchiveKey]; // remove it so we can add it back again later
		}
	}else{
		dict = [[[NSMutableDictionary alloc] init] autorelease];
	}
	
	
	[achievements addObject:achievement];
	
	// The achievement has been added, now save the file again
	NSMutableData *data = [NSMutableData data];	
	NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	[archiver encodeObject:achievements forKey:achievementsArchiveKey];
	[archiver finishEncoding];
	[dict setObject:data forKey:achievementsArchiveKey];
	[dict writeToFile:savePath atomically:YES];
	[archiver release];	
}

- (void)retrieveAchievementsFromDevice
{
	NSString *savePath = getGameCenterSavePath();
	
	// If there are no files saved, return
	if(![[NSFileManager defaultManager] fileExistsAtPath:savePath]){
		return;
	}
	
	// First get the data
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:savePath];
	NSData *data = [dict objectForKey:achievementsArchiveKey];
	
	// A file exists, but it isn't for the achievements key so return
	if(!data){
		return;
	}
	
	NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
	NSArray *achievements = [unarchiver decodeObjectForKey:achievementsArchiveKey];
	[unarchiver finishDecoding];
	[unarchiver release];
	
	// remove the achievements key and save the dictionary back again
	[dict removeObjectForKey:achievementsArchiveKey];
	[dict writeToFile:savePath atomically:YES];
	
	// Since the key file was removed, we can go ahead and try to report the achievements again
	for(GKAchievement *achievement in achievements){
		[self reportAchievementIdentifier:achievement];
	}
}

- (void)showAchievements
{	
	if(!isAuthenticated)
		return;
	
    GKAchievementViewController *achievements = [[GKAchievementViewController alloc] init];	
    if (achievements != nil){
        achievements.achievementDelegate = self;
		
		UIWindow* window = [UIApplication sharedApplication].keyWindow;
		[window addSubview: gameCenterViewController.view];
        [gameCenterViewController presentModalViewController: achievements animated: YES];
        isViewOpened = YES;
    }	
}

- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
    [gameCenterViewController dismissModalViewControllerAnimated:YES];
	[viewController.view removeFromSuperview];
	[viewController release];
    isViewOpened = NO;
}

- (bool)isViewOpened
{
	return isViewOpened;
}

//--------------------------------------------------------
// Goodbye
//--------------------------------------------------------

- (void)close
{
	[gameCenterViewController release];
}

@end



void InitializeGameCenter()
{
    if(IsGameCenterAvailable())
    {
        gameCenter = [[GameCenter alloc] init];  
        [gameCenter authenticateLocalPlayer];  
    }
}
void ReInitGameCenter()
{
	if(gameCenter)
	{
		[gameCenter authenticationChanged]; 
	}
}
bool IsPlayerAvailable()
{
	if(gameCenter)
	{
		return [gameCenter isAuthenticated]; 
	}
	return false;
}
void SendScore(int scScore, String scCategory)
{
	if(gameCenter)
	{
		NSString *sCategory = scCategory.ToNSString();
		[gameCenter reportScore:scScore forCategory: sCategory];  
	}
}
void SendAchievement(String scAchName, float scPercent)
{
	if(gameCenter)
	{
		NSString *sAchName = scAchName.ToNSString();
		[gameCenter reportAchievementIdentifier:sAchName percentComplete: scPercent];
        
	}
}

void OpenLeaderBoard()
{
	if(gameCenter)
	{
		if (![gameCenter isViewOpened]) {
			[gameCenter showLeaderboard];
		}
	}
}
void OpenAchievements()
{
	if(gameCenter)
	{
		if (![gameCenter isViewOpened]) {
			[gameCenter showAchievements];
		}
	}
}
void DeInitGameCenter()
{
    if(IsGameCenterAvailable())
    {
        [gameCenter close];
        [gameCenter release];
    }
}


bool IsGameCenterVisible()
{
	if (gameCenter) {
		return [gameCenter isViewOpened];
	}
	
	return NO;
}

#import "Kiip.h"

#define KP_APP_KEY    @"9ea2584d5c2e6251e82ee11eb8373f5d"
#define KP_APP_SECRET @"a0b3477c74efbee0d8c2e616b0575e9f"


NSString *isKiipShown;

void KPunlockAchievement(String ach_id)
{
    NSString *s_ach_id = ach_id.ToNSString();
    [[KPManager sharedManager] unlockAchievement:s_ach_id];
    
}

void KPupdateLeaderboard(int kpscore, String lb_id)
{
    double s_kpscore = kpscore;
    NSString *s_lb_id = lb_id.ToNSString();
    [[KPManager sharedManager] updateScore:s_kpscore onLeaderboard:s_lb_id];
}


String isKiipVisible()
{
    NSString *iks = isKiipShown;
    return iks;
}


@interface Kiip : UIViewController <KPManagerDelegate>{
    @public
    
    UIAlertView *alert;
    NSMutableArray *resources;
    
    KPViewPosition kpViewPosition;
    
}

//@property (nonatomic, retain) UISwitch *toggleAction;
@property (nonatomic, retain) NSMutableArray *resources;

- (void)unlockAchievement: (NSString*) achievement_id;
- (void)saveLeaderboard: (double) KPscore onLeaderboard:(NSString*) leaderboardID;
- (void) initializeKiipWithTags:(NSArray*)tags;

@end


@implementation Kiip

@synthesize resources;

- (void) initializeKiipWithTags:(NSArray*)tags {
    // Initialize Kiip Session
    // KPManager* manager = [[KPManager alloc] initWithKey:KP_APP_KEY secret:KP_APP_SECRET testFrequency:100 withTags:tags];
    KPManager* manager = [[KPManager alloc] initWithKey:KP_APP_KEY secret:KP_APP_SECRET testFrequency:100];// withTags:tags];
    [KPManager setSharedManager:manager];
    [manager setDelegate:self];
    [manager release];
}

- (void)unlockAchievement: (NSString *) achievementId{
    NSLog(@"unlock achievement");
    [[KPManager sharedManager] unlockAchievement:achievementId];//].text withTags:[NSArray arrayWithObjects:@"movies", @"music", nil]];
}

- (void)saveLeaderboard: (double) KPscore onLeaderboard:(NSString*)leaderboardId;{
    NSLog(@"save leaderboard");
    [[KPManager sharedManager] updateScore:KPscore onLeaderboard:leaderboardId];
}

- (void) willPresentNotification:(NSString*)rid {
    NSLog(@"Delegate: willPresentNotification");
    
}

- (void) didPresentNotification:(NSString*)rid {
    NSLog(@"Delegate: didPresentNotification");
    
}

- (void) willCloseNotification:(NSString*)rid {
    NSLog(@"Delegate: willCloseNotification");
}

- (void) didCloseNotification:(NSString*)rid {
    NSLog(@"Delegate: didCloseNotification");
    //isKiipShown = @"0";
    
}

- (void) willShowWebView:(NSString*)rid {
    NSLog(@"Delegate: willShowWebView");
    isKiipShown = @"1";
}

- (void) didShowWebView:(NSString*)rid {
    NSLog(@"Delegate: didShowWebView");
    isKiipShown = @"1";
}

- (void) willCloseWebView:(NSString*)rid {
    NSLog(@"Delegate: willCloseWebView");
    isKiipShown = @"0";
}

- (void) didCloseWebView:(NSString*)rid {
    NSLog(@"Delegate: didCloseWebView");
    isKiipShown = @"0";
}

- (void) managerDidEndSession:(KPManager*)manager;
{
    isKiipShown = @"0";
}

- (void) didGetActivePromos:(NSArray*)promos;
{
    isKiipShown = @"0";
}

@end

static Kiip *kiipLib;

namespace KiipWrapper {
	void InitKiip();
}


void InitKiip()
{
    
    kiipLib = [[Kiip alloc] init]; 
    [kiipLib initializeKiipWithTags:[NSArray arrayWithObjects:@"male", @"sports", nil]];
    
}
