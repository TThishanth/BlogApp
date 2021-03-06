import 'dart:io';

import 'package:BlogApp/screens/home_screen.dart';
import 'package:BlogApp/widgets/progress_indicator_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import 'package:uuid/uuid.dart';

class UploadPage extends StatefulWidget {
  final String uid;
  UploadPage({this.uid});
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>
    with AutomaticKeepAliveClientMixin<UploadPage> {
  File _imageFile;
  bool _isUploading = false;
  String blogId = Uuid().v4();
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  TextEditingController _blogTitle = TextEditingController();
  TextEditingController _blogDescription = TextEditingController();
  TextEditingController _blogBody = TextEditingController();

  _selectImage(ctx) {
    return showDialog(
      context: ctx,
      builder: (context) {
        return SimpleDialog(
          title: Text('Create Blog'),
          children: [
            SimpleDialogOption(
              child: Text('Photo with Camera'),
              onPressed: _getImageFromCamera,
            ),
            SimpleDialogOption(
              child: Text('Photo from Gallery'),
              onPressed: _getImageFromGallery,
            ),
            SimpleDialogOption(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  Future _getImageFromGallery() async {
    Navigator.pop(context);
    PickedFile _image = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(_image.path);
    });
  }

  Future _getImageFromCamera() async {
    Navigator.pop(context);
    PickedFile _image = await _picker.getImage(source: ImageSource.camera);
    setState(() {
      _imageFile = File(_image.path);
    });
  }

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
                  onPressed: () => _selectImage(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _clearImage() {
    setState(() {
      _imageFile = null;
    });
  }

  _compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;

    // Read an image from file (webp in this case).
    // decodeImage will identify the format of the image and use the appropriate
    // decoder.
    Im.Image imageFile = Im.decodeImage(_imageFile.readAsBytesSync());

    // Save the thumbnail as a JPG.
    final compressedImageFile = File('$path/img_$blogId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 80));

    setState(() {
      _imageFile = compressedImageFile;
    });
  }

  Future<String> _uploadImage(_imageFile) async {
    UploadTask uploadTask =
        storageRef.child('blog_$blogId.jpg').putFile(_imageFile);
    TaskSnapshot storageSnap = await uploadTask;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  createPostInFirestore(
      {String mediaURL, String title, String description, String body}) {
    postsRef.doc(widget.uid).collection('userPosts').doc(blogId).set({
      "blogId": blogId,
      "ownerId": widget.uid,
      "title": title,
      "description": description,
      "blogBody": body,
      "mediaUrl": mediaURL,
      "timestamp": timestamp,
      "bookmarks": {},
    });
    // we need to see our posts in timeline
    timelineRef.doc(blogId).set({
      "blogId": blogId,
      "ownerId": widget.uid,
      "title": title,
      "description": description,
      "blogBody": body,
      "mediaUrl": mediaURL,
      "timestamp": timestamp,
      "bookmarks": {},
    });
    // Add in notification
    notificationRef.doc(blogId).set({
      "blogId": blogId,
      "ownerId": widget.uid,
      "title": title,
      "timestamp": timestamp,
    });
  }

  _handleSubmit() async {
    final _isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_isValid) {
      _formKey.currentState.save();

      setState(() {
        _isUploading = true;
      });

      await _compressImage();

      String mediaUrl = await _uploadImage(_imageFile);

      createPostInFirestore(
        mediaURL: mediaUrl,
        title: _blogTitle.text.trim(),
        description: _blogDescription.text.trim(),
        body: _blogBody.text.trim(),
      );

      _blogTitle.clear();
      _blogDescription.clear();
      _blogBody.clear();

      setState(() {
        _imageFile = null;
        _isUploading = false;
        blogId = Uuid().v4();
      });
    }
  }

  SafeArea buildUploadForm() {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: _clearImage,
          ),
          title: Text(
            'Create Blog',
            style: TextStyle(
              color: Colors.blueGrey,
            ),
          ),
          actions: [
            FlatButton(
              onPressed: _isUploading ? null : _handleSubmit,
              child: Text(
                'Post',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
          ],
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: ListView(
            children: [
              _isUploading ? linearProgress() : Text(''),
              Container(
                height: 210.0,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(_imageFile),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        controller: _blogTitle,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter the title';
                          } else if (value.trim().length > 15) {
                            return 'Blog title must be under 15 characters';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Blog title',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          prefixIcon: Icon(Icons.title),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        controller: _blogDescription,
                        maxLines: 2,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter the blog description';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Blog Description',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          prefixIcon: Icon(Icons.description),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        controller: _blogBody,
                        maxLines: 4,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter the blog body';
                          } else if (value.trim().length < 150) {
                            return 'Blog body must be atleast 150 characters';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Blog Body',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          prefixIcon: Icon(Icons.animation),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _imageFile == null ? buildSplashPage() : buildUploadForm();
  }
}
