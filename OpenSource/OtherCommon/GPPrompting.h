//
//  GPPrompting.h
//  OMPBaby
//
//  Created by hong chen on 12-11-8.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@protocol GPPromptingDelegate <NSObject>

-(void)doSomethingAfterHidden:(id)sender;

@end

@interface GPPrompting : UIView
@property(nonatomic, assign) id<GPPromptingDelegate>delegate;
-(id) initWithView:(UIView *)view Text:(NSString *)text Icon:(NSString *) imgString;
-(void)show;
-(void)hid;
@end
