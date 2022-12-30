import 'package:flutter/material.dart';

class AddCommentModal extends StatefulWidget {
  const AddCommentModal({Key? key}) : super(key: key);

  @override
  State<AddCommentModal> createState() => _AddCommentModalState();
}

class _AddCommentModalState extends State<AddCommentModal> {
  Color appBarColor = Colors.white,
      appBarIconColor = Colors.black,
      primaryButtonColor = Colors.orange,
      secondaryButtonColor = Colors.orangeAccent;
  Color bottomBarColor = Colors.white, bottomMenuIconColor = Color(0xFFFF7643);

  @override
  Widget build(BuildContext context) {
          return SimpleDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 46,
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text("Add comment",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),),
                            Container(
                              padding: EdgeInsets.only(right: 8),
                              alignment: Alignment.centerRight,
                              child: Icon(Icons.clear,color: Colors.white,),
                            ),
                          ],
                        ),
                      ),
                    ),

                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Container(
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.start,
                           children: [
                             Padding(
                                padding: const EdgeInsets.all(10),
                                child: SizedBox(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1.5, color: Colors.grey)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1.5, color: Colors.grey)),

                                      hintText: "Enter a message",
                                    ),

                                    keyboardType: TextInputType.multiline,
                                    maxLines: 5,
                                  ),
                                ),
                              ),
                    SizedBox(height: 10,),

                    Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: 100,
                                  height: 35,
                                  // color: primaryButtonColor,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    child: const Text('Post'),
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(200,50),
                                      backgroundColor: primaryButtonColor,
                                      shape: const StadiumBorder(),
                                      shadowColor: Colors.grey,
                                      elevation: 5,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15,),
                                SizedBox(width: 100,
                                  height: 35,
                                  child: ElevatedButton(
                                    onPressed: ()  {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel'),
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(200,50),
                                      backgroundColor: secondaryButtonColor,
                                      shape: const StadiumBorder(),
                                      shadowColor: Colors.grey,
                                      elevation: 5,
                                    ),
                                  ),)
                              ],
                    ),
                    SizedBox(height: 10,),
                           ],
                         ),
                       ),
                     ),
                  ],
                ),
              ]);

  }
}
