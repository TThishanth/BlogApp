import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:uuid/uuid.dart';

class UploadPage extends StatefulWidget {
  final String uid;
  UploadPage({this.uid});
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  var _imageFile;
  bool isUploading;
  String blogId = Uuid().v4();
  final ImagePicker picker = ImagePicker();
  TextEditingController blogTitle = TextEditingController();
  TextEditingController blogDescription = TextEditingController();
  TextEditingController blogBody = TextEditingController();

  SafeArea buildSplashPage() {
    return SafeArea(
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(top: 50.0),
                child: Lottie.asset(
                  'animation/upload.json',
                  height: 350.0,
                ),
              ),
              Container(
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 30.0,
                  ),
                  color: Colors.orange,
                  child: Text(
                    'Upload',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildUploadForm() {}

  @override
  Widget build(BuildContext context) {
    return _imageFile == null ? buildSplashPage() : buildUploadForm();
  }
}
