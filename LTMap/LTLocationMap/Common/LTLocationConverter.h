//
//  LTLocationConverter.h
//  LTMap
//
//  经纬度转换
//  Created by aken on 2017/6/21.
//  Copyright © 2017年 LTMap. All rights reserved.
//

/*
 相关的坐标系
 1）GPS以及iOS系统定位获得的坐标是地理坐标系WGS1984；
 2）Web地图一般用的坐标细是投影坐标系WGS 1984 Web Mercator；
 3）国内出于相关法律法规要求，对国内所有GPS设备及地图数据都进行了加密偏移处理，代号GCJ-02，这样GPS定位获得的坐标与地图上的位置刚好对应上；
 4）特殊的是百度地图在这基础上又进行一次偏移，通称Bd-09;
 1.坐标的转换逻辑
 1）<CoreLocation/CoreLocation.h>中提供的CLLocationManager类获取的坐标是WGS1984坐标，这种坐标显示在原生地图(国内ios原生地图也是用的高德)、谷歌地图或高德地图需要进行WGS1984转GCJ-02计算，苹果地图及谷歌地图用的都是高德地图的数据，所以这三种情况坐标处理方法一样，即将WGS1984坐标转换成偏移后的GCJ-02才可以在地图上正确显示位置。
 
 2）在高德地图中获取的坐标是已经转换成GCJ-02的坐标，这时候的坐标无需转换可以直接显示到地图上的正确位置。
 */


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LTLocationConverter : NSObject


/**
 *	@brief	世界标准地理坐标(WGS-84) 转换成 中国国测局地理坐标（GCJ-02）<火星坐标>
 *
 *  ####只在中国大陆的范围的坐标有效，以外直接返回世界标准坐标
 *
 *	@param 	location 	世界标准地理坐标(WGS-84)
 *
 *	@return	中国国测局地理坐标（GCJ-02）<火星坐标>
 */
+ (CLLocationCoordinate2D)wgs84ToGcj02:(CLLocationCoordinate2D)location;


/**
 *	@brief	中国国测局地理坐标（GCJ-02） 转换成 世界标准地理坐标（WGS-84）
 *
 *  ####此接口有1－2米左右的误差，需要精确定位情景慎用
 *
 *	@param 	location 	中国国测局地理坐标（GCJ-02）
 *
 *	@return	世界标准地理坐标（WGS-84）
 */
+ (CLLocationCoordinate2D)gcj02ToWgs84:(CLLocationCoordinate2D)location;


/**
 *	@brief	世界标准地理坐标(WGS-84) 转换成 百度地理坐标（BD-09)
 *
 *	@param 	location 	世界标准地理坐标(WGS-84)
 *
 *	@return	百度地理坐标（BD-09)
 */
+ (CLLocationCoordinate2D)wgs84ToBd09:(CLLocationCoordinate2D)location;


/**
 *	@brief	中国国测局地理坐标（GCJ-02）<火星坐标> 转换成 百度地理坐标（BD-09)
 *
 *	@param 	location 	中国国测局地理坐标（GCJ-02）<火星坐标>
 *
 *	@return	百度地理坐标（BD-09)
 */
+ (CLLocationCoordinate2D)gcj02ToBd09:(CLLocationCoordinate2D)location;


/**
 *	@brief	百度地理坐标（BD-09) 转换成 中国国测局地理坐标（GCJ-02）<火星坐标>
 *
 *	@param 	location 	百度地理坐标（BD-09)
 *
 *	@return	中国国测局地理坐标（GCJ-02）<火星坐标>
 */
+ (CLLocationCoordinate2D)bd09ToGcj02:(CLLocationCoordinate2D)location;


/**
 *	@brief	百度地理坐标（BD-09) 转换成 世界标准地理坐标（WGS-84）
 *
 *  ####此接口有1－2米左右的误差，需要精确定位情景慎用
 *
 *	@param 	location 	百度地理坐标（BD-09)
 *
 *	@return	世界标准地理坐标（WGS-84）
 */
+ (CLLocationCoordinate2D)bd09ToWgs84:(CLLocationCoordinate2D)location;


@end
