
#import "WTViewController.h"
#import "OWMWeatherAPI.h"
#import <TSMessages/TSMessage.h>
#import "WTDescriptionController.h"
#import "City.h"
#import "Weather.h"
@interface WTViewController () {
	OWMWeatherAPI *_weatherAPI;
	NSMutableArray *_forecast;
	NSDateFormatter *_dateFormatter;
	
	int downloadCount;
}

@property (strong, nonatomic) City * city;

@end

@implementation WTViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	downloadCount = 0;
	
	NSString *dateComponents = @"H:m yyMMMMd";
	NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:dateComponents options:0 locale:[NSLocale systemLocale] ];
	_dateFormatter = [[NSDateFormatter alloc] init];
	[_dateFormatter setDateFormat:dateFormat];
	
	_forecast = [@[] mutableCopy];
	
	_weatherAPI = [[OWMWeatherAPI alloc] initWithAPIKey:WeatherAPIKey];
	
	// We want localized strings according to the prefered system language
	[_weatherAPI setLangWithPreferedLanguage];
	
	// We want the temperatures in celcius, you can also get them in farenheit.
	[_weatherAPI setTemperatureFormat:kOWMTempCelcius];
	
	[self.activityIndicator stopAnimating];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _forecast.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
	}
	
	Weather * weather = _forecast[indexPath.row];

	cell.textLabel.text = [NSString stringWithFormat:@"%.1f℃",
												 [weather.temperature floatValue]];
	cell.detailTextLabel.text = [_dateFormatter stringFromDate:weather.date];
	
	return cell;
}

#pragma mark-

- (void)searchPressed {
	[self.activityIndicator startAnimating];
	
	NSLog(@"user searching for city %@", [self.cityName.text capitalizedString]);
	[_weatherAPI currentWeatherByCityName:[self.cityName.text capitalizedString] withCallback:^(NSError *error, NSDictionary *result) {
		downloadCount++;
		if (downloadCount > 1) [self.activityIndicator stopAnimating];
		
		if (error) {
			// Handle the error
			[TSMessage showNotificationWithTitle:@"Error"
																	subtitle:@"There was a problem fetching the latest weather."
																			type:TSMessageNotificationTypeError];

			return;
		}
		
		self.cityName.text = [NSString stringWithFormat:@"%@",
													result[@"name"]
													];
		
		self.currentTemp.text = [NSString stringWithFormat:@"%.1f℃",
														 [result[@"main"][@"temp"] floatValue] ];
		
		self.currentTimestamp.text =  [_dateFormatter stringFromDate:result[@"dt"]];
		
		self.weather.text = result[@"weather"][0][@"description"];
	}];
	
	NSInteger daysCount = self.segmentedControl.selectedSegmentIndex == 0 ? 3:7;
	[_weatherAPI dailyForecastWeatherByCityName:[self.cityName.text capitalizedString] withCount:daysCount andCallback:^(NSError *error, NSDictionary *result) {
		downloadCount++;
		if (downloadCount > 1) [self.activityIndicator stopAnimating];
		
		if (error) {
			// Handle the error;
			[TSMessage showNotificationWithTitle:@"Error"
																	subtitle:@"There was a problem fetching the latest weather."
																			type:TSMessageNotificationTypeError];
			return;
		}
		
		self.city = [City createCityIfNeeded:result];
		[_forecast removeAllObjects];
		_forecast = [[self.city forecastCount:daysCount] mutableCopy];
		[self.forecastTableView reloadData];
		
	}];
	
	[_weatherAPI searchForCityName:[self.cityName.text capitalizedString] withCallback:^(NSError *error, NSDictionary *result) {
		NSLog(@"found: %@", result);
		self.city.grnd_level = [result[@"list"][0][@"main"][@"grnd_level"] stringValue];
		self.city.sea_level = [result[@"list"][0][@"main"][@"sea_level"] stringValue];
	}];
	
}

#pragma mark- Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.destinationViewController isKindOfClass:[WTDescriptionController class]]) {
		WTDescriptionController * dst = (WTDescriptionController *)segue.destinationViewController;
		dst.city = self.city;
	}
}

#pragma mark- UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	[self searchPressed];
	return NO;
}

#pragma mark- UISegmentedControl

- (IBAction)segmentIndexDidChange:(id)sender {
	[self searchPressed];
}


@end
