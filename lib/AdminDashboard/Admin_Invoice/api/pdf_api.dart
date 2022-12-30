import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:share_extend/share_extend.dart';


class PdfApi {
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    //final dir = await getApplicationDocumentsDirectory();
    //final file = File('${dir.path}/$name');

    final dir = await getExternalStorageDirectory();
    final file = File('${dir!.absolute.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future shareFile(File file) async {
    //final url = file.path;
    //Share.shareFiles([url], text: 'Invoice');

    if(file!=null){
      ShareExtend.share(file.path, "Invoice");
    }
  }
}
