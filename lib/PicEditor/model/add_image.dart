
import 'dart:io';

import 'dart:ui';

class AddImages{
  File image_file;
  Offset image_position=Offset(0.0,0.0);
  double x_image=0.0;
  double y_image=0.0;
  bool isSelected=true;
  double image_width=50;
  double image_height=50;

  AddImages(this.image_file);
}