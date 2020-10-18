import 'package:blue_waves_flutter/helpers/image_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../connection.dart';
import 'beach_page.dart';

class AllBeaches extends StatefulWidget {
  @override
  _AllBeachesState createState() => _AllBeachesState();
}

class _AllBeachesState extends State<AllBeaches> {
  Query query = FirebaseFirestore.instance.collection('beaches');
  @override
  Widget build(BuildContext context) {
    var md = MediaQuery.of(context).size;

    return Container(
      color: Colors.transparent,
      child: StreamBuilder<QuerySnapshot>(
        stream: query.snapshots(),
        builder: (context, stream) {
          if (stream.connectionState == ConnectionState.waiting) {
            return const SizedBox();
          }

          if (stream.hasError) {
            return Center(child: Text(stream.error.toString()));
          }

          var querySnapshot = stream.data;
          return Padding(
            padding: EdgeInsets.only(top: md.height / 5),
            child: ListView.builder(
              itemCount: querySnapshot.size,
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) => GestureDetector(
                onTap: () async {
                  logger.i(querySnapshot.docs[index].data()['description']);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BeachPage(
                        beach: querySnapshot.docs[index].data(),
                      ),
                    ),
                  );
                },
                child: BWavesImage(
                  url: querySnapshot.docs[index].data()['images'][0],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
