import 'package:flutter/material.dart';
import 'package:grid_staggered_lite/grid_staggered_lite.dart';
import 'package:sizer/sizer.dart';
import '../../helper/image_helper_api.dart';
import '../../modals/image_modal.dart';
import '../screens/deteil_page.dart';

class DataList extends StatefulWidget {
  const DataList({Key? key}) : super(key: key);

  @override
  State<DataList> createState() => _DataListState();
}

late Future<List<ImageModal>?> _status;
final GlobalKey<RefreshIndicatorState> _refreshIndicatorkey =
new GlobalKey<RefreshIndicatorState>();

class _DataListState extends State<DataList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_status = Image_api.image_api.feach_Data("");
    WidgetsBinding.instance?.addPostFrameCallback(
            (_) => _refreshIndicatorkey.currentState?.show());
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    final key = new GlobalKey<ScaffoldState>();
    return RefreshIndicator(
      key: key,
      onRefresh: () async {
        setState(() {
          _status;
        });
      },
      child: Center(
        child: Column(
          children: [
            FutureBuilder(
              future: _status,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error Is ${snapshot.error}"),
                  );
                } else if (snapshot.hasData) {
                  List<ImageModal>? list = snapshot.data;
                  return Center(
                      child: Container(
                        height: 81.h,
                        width: 93.w,
                        child: StaggeredGridView.countBuilder(
                          crossAxisCount: 4,
                          scrollDirection: Axis.vertical,
                          itemCount: list!.length,
                          itemBuilder: (BuildContext context, int i) => InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DetailPage(image: list![i].largeImageURL),
                                      settings:
                                      RouteSettings(arguments: list![i])));
                            },
                            child: new Container(
                                color: Colors.blue,
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    new Center(
                                        child: Image.network(
                                          "${list[i].largeImageURL}",
                                          height: 372.h,
                                          width: 50.w,
                                          fit: BoxFit.fill,
                                        )),
                                    Text(
                                      "${list[i].tags}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    )
                                  ],
                                )),
                          ),
                          staggeredTileBuilder: (int index) =>
                          new StaggeredTile.count(2, index.isEven ? 2.5 : 3.5),
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                        ),
                      ));
                }
                return Center(child: CircularProgressIndicator());
              },
            )
          ],
        ),
      ),
    );
  }
}