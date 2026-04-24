import 'dart:async';
import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sorry_2026/AdManager/ad_helper.dart';
import 'package:sorry_2026/utils/pass_data_between_screens.dart';
import 'package:url_launcher/url_launcher.dart';

import '/data/Messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/widgets/CustomFBTextWidget.dart';
import '/widgets/CustomFeatureCard.dart';
import '/widgets/CustomFullCard.dart';
import 'AdManager/ad_manager.dart';

import 'Enums/project_routes_enum.dart';
import 'Singleton/project_manager.dart';
import 'data/Gifs.dart';
import 'data/Images.dart';
import 'data/Quotes.dart';
import 'data/Shayari.dart';
import 'data/Status.dart';

import 'utils/SizeConfig.dart';

import 'MyDrawer.dart';
import 'widgets/AppStoreAppsItemWidget1.dart';
import 'widgets/CustomBannerWidget.dart';
import 'widgets/CustomTextOnlyWidget.dart';
import 'widgets/DesignerContainer.dart';

// Height = 8.96
// Width = 4.14

// Height = 8.96
// Width = 4.14
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    implements ProjectListener, AdListener {
  String _authStatus = 'Unknown';

  BannerAd? _bannerAd;
  ProjectManager projectManager = ProjectManager.instance;
  AdManager adManager = AdManager.instance;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback(
      (_) => initPlugin(),
    );

    projectManager.listener = this;

    adManager.adListener = this;

    projectManager.startApp();

    adManager.loadAdsInAdManager();
    loadBannerAd();
  }

 void loadBannerAd() {
  _bannerAd = adManager.loadBannerAd(
    BannerAdListener(
      onAdLoaded: (ad) {
        debugPrint("Banner Ad Loaded");

        setState(() {});
      },
      onAdFailedToLoad: (ad, error) {
        debugPrint("Banner Failed: ${error.message}");
        ad.dispose();
      },
    ),
  );
}


  @override
  void dispose() {
    super.dispose();

    debugPrint("Home Page: Dispose Called");
    projectManager.listener = null;
    adManager.adListener = null;
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlugin() async {
    final TrackingStatus status =
        await AppTrackingTransparency.trackingAuthorizationStatus;
    setState(() => _authStatus = '$status');
    // If the system can show an authorization request dialog
    if (status == TrackingStatus.notDetermined) {
      // Show a custom explainer dialog before the system dialog
      await showCustomTrackingDialog(context);
      // Wait for dialog popping animation
      await Future.delayed(const Duration(milliseconds: 200));
      // Request system's tracking authorization dialog
      final TrackingStatus status =
          await AppTrackingTransparency.requestTrackingAuthorization();
      setState(() => _authStatus = '$status');
    }

    final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
    debugPrint("UUID: $uuid");
  }

  Future<void> showCustomTrackingDialog(
    BuildContext context,
  ) async => await showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: const Text('Dear User'),
      content: Text(
        'We care about your privacy and data security. We keep this app free by showing ads. '
        'Can we continue to use your data to tailor ads for you?\n\nYou can change your choice anytime in the app settings. '
        'Our partners will collect data and use a unique identifier on your device to show you ads.',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Continue', style: Theme.of(context).textTheme.bodySmall),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
          style: Theme.of(context).appBarTheme.toolbarTextStyle,
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  DesignerContainer(
                    isLeft: false,
                    child: Padding(
                      padding: EdgeInsets.all(SizeConfig.width(8)),
                      child: Center(
                        child: Text(
                          "Choose Apology Type From Below",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                    ),
                  ),

                  Divider(),

                  // Wishes Start
                  DesignerContainer(
                    isLeft: true,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8)),
                          child: Text(
                            "Select Your Language For Messages  ",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8)),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                CustomTextOnlyWidget(
                                  language: "English",
                                  size: size,
                                  color: Colors.orange,
                                  text: Messages.englishData[1],

                                  onTap: () {
                                    ProjectManager.instance.clickOnButton(
                                      ProjectRoutes.messagesList.toString(),
                                      PassDataBetweenScreens("1", "1"),
                                    );
                                  },
                                ),

                                SizedBox(width: SizeConfig.width(5)),

                                CustomTextOnlyWidget(
                                  size: size,
                                  language: "हिंदी",
                                  text: Messages.hindiData[2],
                                  color: Colors.brown,
                                  onTap: () {
                                    ProjectManager.instance.clickOnButton(
                                      ProjectRoutes.messagesList.toString(),
                                      PassDataBetweenScreens("4", "1"),
                                    );
                                  },
                                ),

                                SizedBox(width: SizeConfig.width(5)),

                                CustomTextOnlyWidget(
                                  size: size,
                                  language: "Español",
                                  text: Messages.spanishData[6],
                                  color: Colors.deepOrangeAccent,
                                  onTap: () {
                                    ProjectManager.instance.clickOnButton(
                                      ProjectRoutes.messagesList.toString(),
                                      PassDataBetweenScreens("7", "1"),
                                    );
                                  },
                                ),

                                SizedBox(width: SizeConfig.width(5)),

                                CustomTextOnlyWidget(
                                  size: size,
                                  language: "Deutsche",
                                  text: Messages.germanData[8],
                                  color: Colors.redAccent,
                                  onTap: () {
                                    ProjectManager.instance.clickOnButton(
                                      ProjectRoutes.messagesList.toString(),
                                      PassDataBetweenScreens("3", "1"),
                                    );
                                  },
                                ),

                                SizedBox(width: SizeConfig.width(5)),

                                CustomTextOnlyWidget(
                                  size: size,
                                  language: "français",
                                  text: Messages.frenchData[11],
                                  color: Colors.blueGrey,
                                  onTap: () {
                                    ProjectManager.instance.clickOnButton(
                                      ProjectRoutes.messagesList.toString(),
                                      PassDataBetweenScreens("2", "1"),
                                    );
                                  },
                                ),

                                SizedBox(width: SizeConfig.width(5)),

                                CustomTextOnlyWidget(
                                  size: size,
                                  language: "Italiano",
                                  text: Messages.italyData[0],
                                  color: Colors.green[400],
                                  onTap: () {
                                    ProjectManager.instance.clickOnButton(
                                      ProjectRoutes.messagesList.toString(),
                                      PassDataBetweenScreens("5", "1"),
                                    );
                                  },
                                ),

                                SizedBox(width: SizeConfig.width(5)),

                                CustomTextOnlyWidget(
                                  size: size,
                                  language: "Português",
                                  text: Messages.portugalData[1],
                                  color: Colors.deepPurpleAccent,
                                  onTap: () {
                                    ProjectManager.instance.clickOnButton(
                                      ProjectRoutes.messagesList.toString(),
                                      PassDataBetweenScreens("6", "1"),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Wishes end
                  Divider(),

                  //Image Start
                  DesignerContainer(
                    isLeft: false,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8)),
                          child: Text(
                            "Sorry & Apology Images",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8)),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: InkWell(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  CustomFeatureCard(
                                    size: size,
                                    imageUrl: Images.imagesPath[2],
                                    ontap: () {},
                                  ),
                                  CustomFeatureCard(
                                    size: size,
                                    imageUrl: Images.imagesPath[5],
                                    ontap: () {},
                                  ),
                                  CustomFeatureCard(
                                    size: size,
                                    imageUrl: Images.imagesPath[15],
                                    ontap: () {},
                                  ),
                                  CustomFeatureCard(
                                    size: size,
                                    imageUrl: Images.imagesPath[19],
                                    ontap: () {},
                                  ),
                                ],
                              ),
                              onTap: () {
                                print("Images Clicked");
                                ProjectManager.instance.clickOnButton(
                                  ProjectRoutes.imagesList.toString(),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Image End
                  Divider(),

                  // Quotes Start
                  DesignerContainer(
                    isLeft: true,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8)),
                          child: Text(
                            "Sorry & Apology Quotes",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8)),
                          child: InkWell(
                            child: Container(
                              width: size.width - SizeConfig.width(16),
                              height: size.width / 2,
                              decoration: BoxDecoration(
                                color:
                                    MediaQuery.of(context).platformBrightness ==
                                        Brightness.dark
                                    ? Theme.of(context).primaryColorDark
                                    : Colors.yellow,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(
                                    SizeConfig.height(20),
                                  ),
                                  topRight: Radius.circular(
                                    SizeConfig.height(20),
                                  ),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 0),
                                    blurRadius: 4,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Icon(
                                    Icons.format_quote,
                                    color: Theme.of(
                                      context,
                                    ).primaryIconTheme.color,
                                  ),
                                  Positioned(
                                    top: 20,
                                    width: size.width - SizeConfig.width(16),
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                          SizeConfig.width(8),
                                        ),
                                        child: Text(
                                          Quotes.quotesData[9],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(color: Colors.black),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    bottom: 0,
                                    right: 0,
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                          SizeConfig.width(8),
                                        ),
                                        child: Text(
                                          "Tap Here to Continue",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(color: Colors.red),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              print("Quotes Clicked");
                              ProjectManager.instance.clickOnButton(
                                ProjectRoutes.quotesList.toString(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Quotes End
                  Divider(),
                  //Native Ad

                  //Gifs Start
                  DesignerContainer(
                    isLeft: true,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8)),
                          child: Text(
                            "Sorry Gifs",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8)),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: InkWell(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  CustomFeatureCard(
                                    size: size,
                                    imageUrl: Gifs.gifsPath[3],
                                    ontap: () {},
                                  ),
                                  CustomFeatureCard(
                                    size: size,
                                    imageUrl: Gifs.gifsPath[4],
                                    ontap: () {},
                                  ),
                                  CustomFeatureCard(
                                    size: size,
                                    imageUrl: Gifs.gifsPath[23],
                                    ontap: () {},
                                  ),
                                  CustomFeatureCard(
                                    size: size,
                                    imageUrl: Gifs.gifsPath[2],
                                    ontap: () {},
                                  ),
                                ],
                              ),
                              onTap: () {
                                print("Gifs Clicked");
                                ProjectManager.instance.clickOnButton(
                                  ProjectRoutes.gifsList.toString(),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Gifs End
                  Divider(),
                  // Shayari start
                  DesignerContainer(
                    isLeft: false,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8)),
                          child: Text(
                            " Sorry Shayari ",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8)),
                          child: InkWell(
                            child: Container(
                              width: size.width - SizeConfig.width(16),
                              height: size.width / 2,
                              decoration: BoxDecoration(
                                color:
                                    MediaQuery.of(context).platformBrightness ==
                                        Brightness.dark
                                    ? Theme.of(context).primaryColorDark
                                    : Colors.white,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(
                                    SizeConfig.height(20),
                                  ),
                                  topRight: Radius.circular(
                                    SizeConfig.height(20),
                                  ),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 0),
                                    blurRadius: 4,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Icon(
                                    Icons.format_quote,
                                    color: Theme.of(
                                      context,
                                    ).primaryIconTheme.color,
                                  ),
                                  Positioned(
                                    top: 20,
                                    width: size.width - SizeConfig.width(16),
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                          SizeConfig.width(8),
                                        ),
                                        child: Text(
                                          Shayari.shayariData[2],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(color: Colors.black),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    bottom: 0,
                                    right: 0,
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                          SizeConfig.width(8),
                                        ),
                                        child: Text(
                                          "Tap Here to Continue",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(color: Colors.red),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              print("Shayari Clicked");
                              ProjectManager.instance.clickOnButton(
                                ProjectRoutes.shayariList.toString(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Shayari end
                  Divider(),

                  // Wish Creator Start
                  DesignerContainer(
                    isLeft: false,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8)),
                          child: Text(
                            "Generate Apology Cards",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8)),
                          child: CustomBannerWidget(
                            size: MediaQuery.of(context).size,
                            imagePath: Gifs.gifsPath[23],
                            buttonText: "Generate Card",
                            topText: "Send Sorry & Apology",
                            middleText: "E-Cards",
                            bottomText: "Share it With Your Loved Ones",
                            onTap: () {
                              ProjectManager.instance.clickOnButton(
                                ProjectRoutes.memeGenerator.toString(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Wish Creator End
                  Divider(),

                  // Status Start
                  DesignerContainer(
                    isLeft: true,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8)),
                          child: Text(
                            "Sorry Status For Whatsapp & FB",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8)),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                CustomFBTextWidget(
                                  size: size,
                                  text: Status.statusData[2],
                                  color: Colors.orange[900],
                                  url: Gifs.gifsPath[2],
                                  isLeft: false,
                                  ontap: () {
                                    print("Status Clicked");
                                    ProjectManager.instance.clickOnButton(
                                      ProjectRoutes.statusList.toString(),
                                    );
                                  },
                                ),
                                SizedBox(width: SizeConfig.width(8)),
                                CustomFBTextWidget(
                                  size: size,
                                  text: Status.statusData[3],
                                  color: Colors.blue,
                                  url: Gifs.gifsPath[2],
                                  isLeft: false,
                                  ontap: () {
                                    print("Status Clicked");
                                    ProjectManager.instance.clickOnButton(
                                      ProjectRoutes.statusList.toString(),
                                    );
                                  },
                                ),
                                SizedBox(width: SizeConfig.width(8)),
                                CustomFBTextWidget(
                                  size: size,
                                  text: Status.statusData[4],
                                  color: Colors.indigoAccent,
                                  url: Gifs.gifsPath[2],
                                  isLeft: false,
                                  ontap: () {
                                    print("Status Clicked");
                                    ProjectManager.instance.clickOnButton(
                                      ProjectRoutes.statusList.toString(),
                                    );
                                  },
                                ),
                                SizedBox(width: SizeConfig.width(8)),
                                CustomFBTextWidget(
                                  size: size,
                                  text: Status.statusData[1],
                                  color: Colors.purple,
                                  url: Gifs.gifsPath[2],
                                  isLeft: false,
                                  ontap: () {
                                    print("Status Clicked");
                                    ProjectManager.instance.clickOnButton(
                                      ProjectRoutes.statusList.toString(),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //Status End
                 /* Divider(),

                  Padding(
                    padding: EdgeInsets.all(SizeConfig.width(8)),
                    child: Text(
                      "Play Game \"Sell Rakhi\"",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),

                  CustomFullCard(
                    size: MediaQuery.of(context).size,
                    imageUrl: "assets/rakhi_game.jpeg",
                    onTap: () {
                      if (Platform.isAndroid) {
                        // Android-specific code
                        print("More Button Clicked");
                        launch(
                          "https://play.google.com/store/apps/developer?id=Festival+Messages+SMS",
                        );
                      } else if (Platform.isIOS) {
                        // iOS-specific code
                        print("More Button Clicked");
                        launch("https://apps.apple.com/us/app/-/id1434054710");
                      }
                    },
                  ),
*/
                  Divider(),

                  Padding(
                    padding: EdgeInsets.all(SizeConfig.width(8)),
                    child: Text(
                      "Apps From Developer",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: EdgeInsets.all(SizeConfig.width(8)),
                      child: Row(
                        children: <Widget>[
                          //Column1
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AppStoreAppsItemWidget1(
                                imageUrl:
                                    "https://is1-ssl.mzstatic.com/image/thumb/Purple117/v4/8f/e7/b5/8fe7b5bc-03eb-808c-2b9e-fc2c12112a45/mzl.jivuavtz.png/292x0w.jpg",
                                appTitle: "Good Morning Images & Messages",
                                appUrl:
                                    "https://apps.apple.com/us/app/good-morning-images-messages-to-wish-greet-gm/id1232993917",
                              ),
                              Divider(),
                              AppStoreAppsItemWidget1(
                                imageUrl:
                                    "https://is4-ssl.mzstatic.com/image/thumb/Purple114/v4/44/e0/fd/44e0fdb5-667b-5468-7b2f-53638cba539e/AppIcon-1x_U007emarketing-0-7-0-0-85-220.png/292x0w.jpg",
                                appTitle: "Birthday Status Wishes Quotes",
                                appUrl:
                                    "https://apps.apple.com/us/app/birthday-status-wishes-quotes/id1522542709",
                              ),
                              Divider(),
                              AppStoreAppsItemWidget1(
                                imageUrl:
                                    "https://is4-ssl.mzstatic.com/image/thumb/Purple114/v4/1a/58/a4/1a58a480-a0ae-1940-2cf3-38524430f66b/AppIcon-0-1x_U007emarketing-0-0-GLES2_U002c0-512MB-sRGB-0-0-0-85-220-0-0-0-7.png/292x0w.jpg",
                                appTitle: "Astrology Horoscope Lal Kitab",
                                appUrl:
                                    "https://apps.apple.com/us/app/astrology-horoscope-lal-kitab/id1448343526",
                              ),
                            ],
                          ),
                          SizedBox(width: SizeConfig.width(3)),
                          //Column2
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AppStoreAppsItemWidget1(
                                imageUrl:
                                    "https://is2-ssl.mzstatic.com/image/thumb/Purple124/v4/e9/96/64/e99664d3-1083-5fac-6a0c-61718ee209fd/AppIcon-0-1x_U007emarketing-0-0-GLES2_U002c0-512MB-sRGB-0-0-0-85-220-0-0-0-7.png/292x0w.jpg",
                                appTitle: "Weight Loss My Diet Coach Tips",
                                appUrl:
                                    "https://apps.apple.com/us/app/weight-loss-my-diet-coach-tips/id1448343218",
                              ),
                              Divider(),
                              AppStoreAppsItemWidget1(
                                imageUrl:
                                    "https://is2-ssl.mzstatic.com/image/thumb/Purple127/v4/5f/7c/45/5f7c45c7-fb75-ea39-feaa-a698b0e4b09e/pr_source.jpg/292x0w.jpg",
                                appTitle: "English Speaking Course Grammar",
                                appUrl:
                                    "https://apps.apple.com/us/app/english-speaking-course-learn-grammar-vocabulary/id1233093288",
                              ),
                              Divider(),
                              AppStoreAppsItemWidget1(
                                imageUrl:
                                    "https://is4-ssl.mzstatic.com/image/thumb/Purple128/v4/50/ad/82/50ad82d9-0d82-5007-fcdd-cc47c439bfd0/AppIcon-0-1x_U007emarketing-0-85-220-10.png/292x0w.jpg",
                                appTitle: "English Hindi Language Diction",
                                appUrl:
                                    "https://apps.apple.com/us/app/english-hindi-language-diction/id1441243874",
                              ),
                            ],
                          ),
                          SizedBox(width: SizeConfig.width(3)),

                          //Column3
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AppStoreAppsItemWidget1(
                                imageUrl:
                                    "https://is1-ssl.mzstatic.com/image/thumb/Purple118/v4/79/1e/61/791e61de-500c-6c97-3947-8abbc6b887e3/AppIcon-0-1x_U007emarketing-0-0-GLES2_U002c0-512MB-sRGB-0-0-0-85-220-0-0-0-7.png/292x0w.jpg",
                                appTitle: "Bangladesh Passport Visa Biman",
                                appUrl:
                                    "https://apps.apple.com/us/app/bangladesh-passport-visa-biman/id1443074171",
                              ),
                              Divider(),
                              AppStoreAppsItemWidget1(
                                imageUrl:
                                    "https://is1-ssl.mzstatic.com/image/thumb/Purple126/v4/dd/34/c3/dd34c3e8-5c9f-51aa-a3eb-3a203f5fd49b/AppIcon-0-1x_U007emarketing-0-0-GLES2_U002c0-512MB-sRGB-0-0-0-85-220-0-0-0-10.png/292x0w.jpg",
                                appTitle: "Complete Spoken English Course",
                                appUrl:
                                    "https://apps.apple.com/us/app/complete-spoken-english-course/id1440118617",
                              ),
                            ],
                          ),
                          SizedBox(width: SizeConfig.width(3)),

                          //Column4
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AppStoreAppsItemWidget1(
                                imageUrl:
                                    "https://is4-ssl.mzstatic.com/image/thumb/Purple128/v4/bd/00/ee/bd00ee3b-43af-6b07-62a6-28c68373a8b5/AppIcon-1x_U007emarketing-85-220-0-9.png/292x0w.jpg",
                                appTitle: "Happy Thanksgiving Day Greeting SMS",
                                appUrl:
                                    "https://apps.apple.com/us/app/happy-merry_christmas-greeting-sms/id1435157874",
                              ),

                              Divider(),
                              AppStoreAppsItemWidget1(
                                imageUrl:
                                    "https://is1-ssl.mzstatic.com/image/thumb/Purple114/v4/0f/d6/f4/0fd6f410-9664-94a5-123f-38d787bf28c6/AppIcon-1x_U007emarketing-0-7-0-0-85-220.png/292x0w.jpg",
                                appTitle: "Rakshabandhan Images Greetings",
                                appUrl:
                                    "https://apps.apple.com/us/app/rakshabandhan-images-greetings/id1523619788",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _bannerAd == null
    ? const SizedBox()
    : SizedBox(
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      ),

      drawer: MyDrawer(),
    );
  }

  @override
  void moveToScreen(String s, [PassDataBetweenScreens? object]) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      Navigator.of(context).pushNamed(s, arguments: object);
    });
  }

  @override
  void moveToScreenAfterAd(String s, [PassDataBetweenScreens? object]) {
    Navigator.of(context).pushNamed(s, arguments: object);
  }

  @override
  void showAd(String s, [PassDataBetweenScreens? object]) {
    AdManager.instance.showInterstitialAd(s, object);
  }
}
