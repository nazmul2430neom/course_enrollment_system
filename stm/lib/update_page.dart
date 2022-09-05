import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';

class UpdateCourse extends StatefulWidget {
  String? documentId;
  String? courseName;
  String? courseFee;
  String? courseImg;

  UpdateCourse(this.documentId,this.courseName,this.courseFee,this.courseImg);

  @override
  State<UpdateCourse> createState() => _UpdateCourseState();
}

class _UpdateCourseState extends State<UpdateCourse> {

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

  writeUpdateData() async{

   if(_courseImage==null){
       CollectionReference _referCollection=FirebaseFirestore.instance.collection("arrange_course");

      _referCollection.doc(widget.documentId).update({
        "course_name":_courseNameController.text,
        "course_fee":_courseFeeController.text,
        "img":widget.courseImg,
      });
   }

   else{
     File imageFile=File(_courseImage!.path);
    FirebaseStorage _storage=FirebaseStorage.instance;

      UploadTask _uploadTask   = _storage.ref("courses").child(_courseImage!.name).putFile(imageFile);
      TaskSnapshot snapshot=await _uploadTask;
      imageUrl=await snapshot.ref.getDownloadURL();

      CollectionReference _referCollection=FirebaseFirestore.instance.collection("arrange_course");

      _referCollection.doc(widget.documentId).update({
        "course_name":_courseNameController.text,
        "course_fee":_courseFeeController.text,
        "img":imageUrl,
      });
   }

   
  }

  @override
  void initState() {
    
    super.initState();
    _courseNameController.text=widget.courseName!;
    _courseFeeController.text=widget.courseFee!;
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
                Stack(
                  children: [
                    Image.network("${widget.courseImg}"),
                    CircleAvatar(
                      child: IconButton(
                        onPressed: (){
                          chooseImageFromGC();
                        }, 
                        icon: Icon(Icons.photo),
                        ),
                    )
                  ],
                )
                  :Image.file(File(_courseImage!.path)
                  ),
              )
              ),
              SizedBox(height: 8,),

            ElevatedButton(
              onPressed: (){
                writeUpdateData();
                Navigator.of(context).pop();
              }, 
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Text("Update Course",style: TextStyle(fontSize: 16),),
              ),
              )

          ],
        ),
      ),
    );
  }
}