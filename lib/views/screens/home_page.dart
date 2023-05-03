import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../cantrollers/theme_controller.dart';
import '../componets/data_list.dart';
import '../componets/like_page.dart';
import '../componets/serch_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

late TabController tabController;
int initialTabIndex = 1;

List list = [];

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    list.add(1);
  }

  themeController themecontroller = Get.put(themeController());
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool listlenth = true;
        if (list.isEmpty) {
          listlenth = true;
        } else if (list.length >= 0) {
          setState(() {
            int i = list.length;
            i--;
            print("remove ${list[i]}");
            list.remove(list[i]);
            i--;
            initialTabIndex = list[i];
            tabController = TabController(
                length: 3, vsync: this, initialIndex: initialTabIndex);
            print(initialTabIndex);

            listlenth = false;
          });
        }
        return await listlenth;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("HD WallPaper"),
          centerTitle: true,
          actions: [
            GetBuilder<themeController>(builder: (_) {
              return IconButton(
                onPressed: () {
                  themecontroller.themeChange();
                },
                icon: Icon((themecontroller.dark)
                    ? Icons.light_mode
                    : Icons.dark_mode),
              );
            }),
          ],
        ),
        bottomNavigationBar: ConvexAppBar(
          // backgroundColor: Colors.green,
          controller: tabController,

          initialActiveIndex: initialTabIndex,
          items: [
            TabItem(icon: Icons.favorite, title: 'Like'),
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.search, title: 'Search')
          ],
          onTap: (int i) {
            setState(() {
              initialTabIndex = i;
              list.add(initialTabIndex);
              print(list);
            });
          },
        ),
        body: IndexedStack(
          index: initialTabIndex,
          children: [
            LikePage(),
            DataList(),
            SearchPage(),
          ],
        ),
      ),
    );
  }
}