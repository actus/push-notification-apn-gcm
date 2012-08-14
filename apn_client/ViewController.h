//
//  ViewController.h
//  apnTest
//
//  Created by  on 12. 7. 19..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (retain, nonatomic) NSString * myToken;

- (BOOL)requestUrl:(NSString *)url;
@end
