import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';

class AddNewCourse extends StatefulWidget {
  const AddNewCourse({Key? key}) : super(key: key);

  @override
  State<AddNewCourse> createState() => _AddNewCourseState();
}

class _AddNewCourseState extends State<AddNewCourse> {

  TextEditingController _courseNameController=TextEditingController();
  TextEditingController _courseFeeController=TextEditingController();

  XFile? _courseImage;
  String? imageUrl;
  chooseImageFromGC() async{
    ImagePicker _picker=ImagePicker();
    _courseImage = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      
    });
  }

  writeData() async{
    File imageFile=File(_courseImage!.path);
    FirebaseStorage _storage=FirebaseStorage.instance;

      UploadTask _uploadTask   = _storage.ref("courses").child(_courseImage!.name).putFile(imageFile);
      TaskSnapshot snapshot=await _uploadTask;
      imageUrl=await snapshot.ref.getDownloadURL();

      CollectionReference _referCollection=FirebaseFirestore.instance.collection("arrange_course");

      _referCollection.add({
        "course_name":_courseNameController.text,
        "course_fee":_courseFeeController.text,
        "img":imageUrl,
      });
  }

  

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 530,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        color: Colors.greenAccent,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextField(
              controller: _courseNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                hintText: "Enter course name",
                hintStyle: TextStyle(fontSize: 18)
              ),
            ),
            SizedBox(height: 15,),

             TextField(
              controller: _courseFeeController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                hintText: "Enter course fee",
                hintStyle: TextStyle(fontSize: 18)
              ),
            ),
            SizedBox(height: 15,),

            Expanded(
              child: Container(
                child: _courseImage==null?
                IconButton(
                  onPressed: (){
                    chooseImageFromGC();
                  }, 
                  icon: Icon(Icons.photo,size: 30,),
                  ):Image.file(File(_courseImage!.path))
              )
              ),
              SizedBox(height: 8,),

            ElevatedButton(
              onPressed: (){
                writeData();
              }, 
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Text("Add Course",style: TextStyle(fontSize: 16),),
              ),
              )

          ],
        ),
      ),
    );
  }
}