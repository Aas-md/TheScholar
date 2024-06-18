
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_scholar/utils/app_colors.dart';

class SimpleDialogBox extends StatelessWidget {
  final appColors = AppColors();

  SimpleDialogBox({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(

      margin: const EdgeInsets.symmetric(vertical: 110,horizontal: 29),
      decoration: BoxDecoration(
        color: appColors.dialogBackColor,
        borderRadius: BorderRadius.circular(15),
      ),

      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
           const Text(
              'Choose a post',
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
           const  SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: [
                _buildIconButton(context, Icons.photo, 'Gallery', _handleGallery,const Color(0xff028391)),
                _buildIconButton(context, Icons.camera_alt, 'Camera', _handleCamera,const Color(0xff5C88C4)),
                _buildIconButton(context, Icons.insert_drive_file, 'Document', _handleFile,const Color(0xff5C2FC2)),
                _buildIconButton(context, Icons.text_fields, 'Text', _handleText,const Color(0xff615EFC)),
              ],
            ),
            const SizedBox(height: 20),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(BuildContext context, IconData icon, String label, Function onTap,Color color) {
    return GestureDetector(
      onTap: () => onTap(context),
      child: Column(
        children: [

          Container(
            height: 60,
            width: 60,
            decoration:  BoxDecoration(
              shape: BoxShape.circle,
              // color: Color(0xff028391)
              color: color,
            ),
            child: Center(child:Icon(icon, size: 30, color: Colors.white) ,),
          ),


          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12.0),
          ),
        ],
      ),
    );
  }

  void _handleGallery(BuildContext context) {
    // Handle Gallery action
    Navigator.of(context).pop();
    Get.toNamed('/PickPrevImage');
    // Add your code here
  }

  void _handleCamera(BuildContext context) {
    // Handle Camera action
    Navigator.of(context).pop();
    Get.toNamed('/CameraPick');
    // Add your code here
  }

  void _handleFile(BuildContext context) {
    // Handle File action
    Navigator.of(context).pop();
  Get.toNamed('/PdfPost');
    // Add your code here
  }

  void _handleText(BuildContext context) {
    // Handle Text action
    Navigator.of(context).pop();
    Get.toNamed('/TextPost');
    // Add your code here
  }
}
