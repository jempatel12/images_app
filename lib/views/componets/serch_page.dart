import 'package:flutter/material.dart';
import 'package:grid_staggered_lite/grid_staggered_lite.dart';
import 'package:sizer/sizer.dart';
import '../../helper/image_helper_api.dart';
import '../../modals/image_modal.dart';
import '../screens/deteil_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

late Future<List<ImageModal>?> _status;

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // _status = Image_api.image_api.feach_Data("popular");
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    final key = new GlobalKey<ScaffoldState>();
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                hintText: "Search",
                border: OutlineInputBorder(),
              ),
              onChanged: (val) {
                //_status = Image_api.image_api.feach_Data(val);
              },
            ),
            SizedBox(height: 1.h),
            FutureBuilder(
              future: _status,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error Is ${snapshot.error}"),
                  );
                } else if (snapshot.hasData) {
                  List<ImageModal>? list = snapshot.data;
                  if ((list!.isEmpty)) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Center(
                        child: Container(
                          height: 70.h,
                          width: 93.w,
                          child: Scrollbar(
                            thickness: 15,
                            trackVisibility: true,
                            thumbVisibility: true,
                            interactive: true,
                            child: StaggeredGridView.countBuilder(
                              crossAxisCount: 4,
                              itemCount: list!.length,
                              itemBuilder: (BuildContext context, int i) => InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailPage(
                                              image: list[i].largeImageURL),
                                          settings:
                                          RouteSettings(arguments: list[i])));
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
                              new StaggeredTile.count(
                                  2, index.isEven ? 2.5 : 3.5),
                              mainAxisSpacing: 4.0,
                              crossAxisSpacing: 4.0,
                            ),
                          ),
                        ));
                  }
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