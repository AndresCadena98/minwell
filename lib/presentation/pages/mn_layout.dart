import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:minwell/commons/commons.dart';
import 'package:minwell/presentation/presentation.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pageController = PageController(initialPage: 0);

  /// Controller to handle bottom nav bar and also handles initial page
  final _controller = NotchBottomBarController(index: 0);

  int maxCount = 5;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          HomePageView(),
          FavoritePageView(),
          ProfilePageView()
        ],
      ),
      extendBody: true,
      bottomNavigationBar: AnimatedNotchBottomBar(
              /// Provide NotchBottomBarController
              notchBottomBarController: _controller,
              color: bottomAppBar,
              showLabel: false,
              notchColor: buttonsBar,

              /// restart app if you change removeMargins
              removeMargins: false,
              bottomBarWidth: 500,
              durationInMilliSeconds: 300,
              bottomBarItems:  [
                BottomBarItem(
                  inActiveItem: const Icon(
                    Icons.home_filled,
                    color: Colors.white,
                  ),
                  activeItem: Icon(
                    Icons.home_filled,
                    color: iconBarColor,
                  ),
                  itemLabel: 'home',
                ),
                BottomBarItem(
                  inActiveItem: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                  ),
                  activeItem: Icon(
                    Icons.favorite,
                    color: iconBarColor,
                  ),
                  itemLabel: 'favorite',
                ),

                

                
             
               
              ],
              onTap: (index) {
                /// perform action on tab change and to update pages you can update pages without pages
                
                _pageController.jumpToPage(index);
              },
            )
     
    
    );
  }
}