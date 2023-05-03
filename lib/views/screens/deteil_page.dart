import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';

class DetailPage extends StatefulWidget {
  DetailPage({Key? key, required this.image}) : super(key: key);
  String image;
  @override
  State<DetailPage> createState() => _DetailPageState();
}

ScreenshotController screenshotController = ScreenshotController();

class _DetailPageState extends State<DetailPage> {
  Future<void> _setwallpaper() async {
    var file = await DefaultCacheManager().getSingleFile(widget.image);
    try {
      WallpaperManagerFlutter()
          .setwallpaperfromFile(file, WallpaperManagerFlutter.HOME_SCREEN);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Wallpaper updated'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error Setting Wallpaper'),
        ),
      );
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Screenshot(
            controller: screenshotController,
            child: CachedNetworkImage(
              imageUrl: widget.image,
              height: 100.h,
              width: 100.w,
              placeholder: (context, url) => Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, uri) => Center(
                child: Icon(
                  Icons.error_outline_rounded,
                  color: Colors.red,
                ),
              ),
              fit: BoxFit.fill,
            ),
          ),
          Container(
              height: 50,
              width: double.infinity,
              // color: Colors.white,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                        onTap: () async {
                          final image = await screenshotController.capture();
                          if (image == null) return;

                          // await saveImage(image);
                          saveAndShare(image);
                        },
                        child: isRow(image: "assets/images/929539.png")),
                    InkWell(
                        onTap: () async {
                          final image = await screenshotController.capture();
                          if (image == null) return;

                          await saveImage(image);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Image Is Save In Album"),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.green,
                          ));
                        },
                        child: isRow(image: "assets/images/download.png")),
                    InkWell(
                        onTap: () async {
                          _setwallpaper();
                        },
                        child: isRow(image: "assets/images/wallpaper.png")),
                  ]))
        ],
      ),
    );
  }

  Widget isRow({required String image}) {
    return Image.asset(
      "$image",
      width: 40,
      color: Colors.blue,
    );
  }

  Future saveAndShare(Uint8List bytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/flutter.png');
    image.writeAsBytesSync(bytes);
    await Share.shareFiles([image.path]);
  }

  Future<String> saveImage(Uint8List bytes) async {
    await [Permission.storage].request();
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '_')
        .replaceAll(':', '_');
    final name = "screenshot_$time";
    final result = await ImageGallerySaver.saveImage(bytes, name: name);

    return result['filePath'];
  }
}