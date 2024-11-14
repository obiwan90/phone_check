import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'routes/app_pages.dart';
import 'controllers/theme_controller.dart';
import 'services/init_service.dart';

void main() async {
  await InitService.initServices();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: '手机检测',
          debugShowCheckedModeBanner: false,
          theme: themeController.getLightTheme(),
          darkTheme: themeController.getDarkTheme(),
          themeMode: ThemeMode.system,
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          defaultTransition: Transition.fadeIn,
          builder: (context, child) {
            if (child == null) return const SizedBox.shrink();

            // 应用全局字体
            final textTheme = Theme.of(context).textTheme;
            return MediaQuery(
              // 设置文字大小不随系统设置变化
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: Theme(
                data: Theme.of(context).copyWith(
                  textTheme: GoogleFonts.notoSansTextTheme(textTheme),
                ),
                child: child,
              ),
            );
          },
          // 监听主题变化
          onInit: () {
            themeController.isDarkMode
                ? Get.changeThemeMode(ThemeMode.dark)
                : Get.changeThemeMode(ThemeMode.light);
          },
        );
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.h,
            floating: false,
            pinned: true,
            backgroundColor: Theme.of(context).primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                '手机检测工具',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.phone_android,
                    size: 80.sp,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(16.w),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16.h,
                crossAxisSpacing: 16.w,
                childAspectRatio: 1.1,
              ),
              delegate: SliverChildListDelegate([
                _buildFeatureCard(
                  context: context,
                  icon: Icons.screen_rotation,
                  title: '屏幕测试',
                  subtitle: '检测屏幕显示',
                  onTap: () => Get.toNamed('/screen-test'),
                ),
                _buildFeatureCard(
                  context: context,
                  icon: Icons.touch_app,
                  title: '触控测试',
                  subtitle: '检测触摸响应',
                  onTap: () => Get.toNamed('/touch-test'),
                ),
                _buildFeatureCard(
                  context: context,
                  icon: Icons.camera_alt,
                  title: '相机测试',
                  subtitle: '检测相机功能',
                  onTap: () => Get.toNamed('/camera-test'),
                ),
                _buildFeatureCard(
                  context: context,
                  icon: Icons.speaker,
                  title: '扬声器测试',
                  subtitle: '检测音频播放',
                  onTap: () => Get.toNamed('/speaker-test'),
                ),
                _buildFeatureCard(
                  context: context,
                  icon: Icons.sensors,
                  title: '传感器测试',
                  subtitle: '检测设备传感器',
                  onTap: () => Get.toNamed('/sensor-test'),
                ),
                _buildFeatureCard(
                  context: context,
                  icon: Icons.battery_full,
                  title: '电池信息',
                  subtitle: '查看电池状态',
                  onTap: () => Get.toNamed('/battery-info'),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 32.sp,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
