import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:stm/add_new_course.dart';
import 'package:stm/update_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Stream<QuerySnapshot> courseStream=FirebaseFirestore.instance.collection("arrange_course").snapshots();

  addCourse() {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isDismissible: true,
      isScrollControlled: true,
      context: context,
      builder: (context)=>AddNewCourse());
  }

  Future <void>deleteCourse(selectDocument){
    return FirebaseFirestore.instance
    .collection("arrange_course")
    .doc(selectDocument)
    .delete();
    
  }

  Future <void>editCourse(selectDocument,courseName,courseFee,courseImg){
    
     return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isDismissible: true,
      isScrollControlled: true,
      context: context,
      builder: (context)=>UpdateCourse(selectDocument,courseName,courseFee,courseImg));
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      floatingActionButton: FloatingActionButton(
        onPressed: (){
           addCourse();
        },
        child: Icon(Icons.add),
        ),

        body:StreamBuilder<QuerySnapshot>(
      stream: courseStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            return Stack(
              children: [
                Container(
                height: 270,
                child: Card(
                  elevation: 10,
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.network(data["img"],
                        fit:BoxFit.cover ,
                        width: MediaQuery.of(context).size.width,
                        )
                        ),

                      Container(
                        child: Text(data["course_name"],style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                      ),  

                      Container(
                        child: Text(data["course_fee"],style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                      ),

                      
                    ],
                  )
                ),
              ),

              Positioned(
                 right: 0,   

                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    
                  ),
                 padding: EdgeInsets.all(8),
                  width: 120,
                  child: Card(
                    elevation: 10,
                    color: Colors.tealAccent,
                    child: Row(
                      
                      children: [
                        IconButton(onPressed: (){
                          editCourse(document.id,data["course_name"],data["course_fee"],data["img"]);
                        }, 
                        icon: Icon(Icons.edit)),
                        
                        IconButton(
                          onPressed: (){
                          deleteCourse(document.id);
                        }, 
                        icon: Icon(Icons.delete))
                      ],
                    ),
                  ),
                ),
                ),

              ],

            );
          }).toList(),
        );
      },
    )
    );
  }
}