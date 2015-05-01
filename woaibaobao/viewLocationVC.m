//
//  viewLocationVC.m
//  woaibaobao
//
//  Created by 梁建 on 14/10/23.
//  Copyright (c) 2014年 梁建. All rights reserved.
//

#import "viewLocationVC.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MyAnnotation.h"
@interface viewLocationVC ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation viewLocationVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}







- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMapView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)setupMapView
{
    CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake(_latitude, _longitude);
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(locationCoordinate, 2000, 2000);
    [_mapView setRegion:region animated:YES];
    
    CLLocation *location = [[CLLocation alloc]initWithLatitude:_latitude longitude:_longitude];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if(!error && [placemarks count] > 0){
            id placeMark = [placemarks objectAtIndex:0];
            if([placeMark isKindOfClass:[CLPlacemark class]]){
                NSDictionary *addressDict = [(CLPlacemark *)placeMark addressDictionary];
                
                NSString *myAddress = [NSString stringWithFormat:@"%@%@%@%@",
                                       addressDict[@"State"] ? addressDict[@"State"] :@"",
                                       addressDict[@"City"] ? addressDict[@"City"] : @"",
                                       addressDict[@"SubLocality"] ? addressDict[@"SubLocality"]: @"",
                                       addressDict[@"Street"] ? addressDict[@"Street"] :@""];
                
                MyAnnotation *myAnnotation = [[MyAnnotation alloc]initWithCoordinate:locationCoordinate andTitle:addressDict[@"Name"] andSubtitle:myAddress];
                [_mapView addAnnotation:myAnnotation];
                
            }
        }
        else{
            NSLog(@"reverseGeocodeLocation Error:%@",error);
        }
    }];
    
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKPinAnnotationView *annotationView=(MKPinAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:@"PIN_ANNOTATION"];
    
    if (annotationView==nil) {
        annotationView=[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"PIN_ANNOTATION"];
    }
    annotationView.canShowCallout=YES;
    annotationView.pinColor=MKPinAnnotationColorRed;
    annotationView.animatesDrop=YES;
    return annotationView;
}


















@end
