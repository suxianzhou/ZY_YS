#import <UIKit/UIKit.h>
#import "DWSDK.h"
#import "RWClassListModel.h"

@interface DWCustomPlayerViewController : UIViewController

@property (strong, nonatomic)DWMoviePlayerController  *player;

@property (copy, nonatomic)NSString *videoId;
@property (copy, nonatomic)NSString *videoLocalPath;
@property (copy, nonatomic)NSString *videotitle;

-(id)initWithvideoClassModel:(RWClassListModel *)classModel;

- (void)playLocalVideo;

-(void)prepareToPlayVideo:(BOOL) shouldPlay;
-(void)play;
-(void)pause;
-(void)resume;

@end
