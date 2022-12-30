import 'package:flutter/material.dart';

class ShowAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

showAlert(BuildContext context,String title,String msg) async {
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
        backgroundColor: Colors.yellow[50],
        title: Text(title,style: const TextStyle(color: Colors.black87),),
        content:Wrap(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Text(msg,style: const TextStyle(color: Colors.black54),),
                  const SizedBox(height: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                          child: ElevatedButton(
                            onPressed: (){
                              //Navigator.popUntil(context, ModalRoute.withName('/'));
                              Navigator.of(context).pop(true);
                            },
                            child: const Text("Yes",style: TextStyle(color: Colors.black54,fontSize: 13)),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                              onPrimary: Colors.blue,
                              minimumSize: const Size(70,30),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                            ),
                          )
                      ),
                      const SizedBox(width: 10,),
                      Container(
                          child: ElevatedButton(
                            onPressed: (){
                              Navigator.of(context).pop(false);
                            },
                            child: const Text("No",
                                style: TextStyle(color: Colors.black54,fontSize: 13)),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                              onPrimary: Colors.blue,
                              minimumSize: const Size(70,30),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                            ),
                          )
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        )),
  );
}
