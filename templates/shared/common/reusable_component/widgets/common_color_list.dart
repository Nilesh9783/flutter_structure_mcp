import 'package:expense_tracker/utils/extensions/color_extension.dart' as ct;
import 'package:expense_tracker/utils/extensions/extension.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../main.dart';
import '../../model/setup_payment/setup_payment_model.dart';
import '../../utils/common/constants.dart';
import '../../utils/theme/colors.dart';
import '../custom/custom_color_picker.dart';
import 'filled_button.dart';

class CommonColorList extends StatefulWidget {

  final List<ColorModel>? listColor;
  final Function onSelectColor;
  final Function onAddColor;

  const CommonColorList({super.key,required this.listColor,required this.onAddColor,required this.onSelectColor});

  @override
  State<CommonColorList> createState() => _CommonColorListState();
}

class _CommonColorListState extends State<CommonColorList> {
  Color? colorPicker;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      children: getListColor(widget.listColor),
    );
  }

  List<Widget> getListColor(List<ColorModel>? listColor) {
    List<GestureDetector> lst = listColor
        ?.map((color) => GestureDetector(
      onTap: () {
        if (color.isOther ?? false) {
          colorPickerDialog();
        }else{
          widget.onSelectColor(color);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(left: 14, top: 14),
        decoration: BoxDecoration(
            border: color.isSelected ?? false
                ? Border.all(color: AppColors.cD0D0D0)
                : (brightness == Brightness.dark)?Border.all(color: AppColors.mainDarkColor):Border.all(color: AppColors.mainColor),
            borderRadius: BorderRadius.circular(10),
            color: AppColors.cF3F3F3),
        padding: const EdgeInsets.symmetric(
            horizontal: 10, vertical: 10),
        child: color.isOther ?? false
            ?  Icon(
          Icons.add,
          color: AppColors.isLightModeColor,
          size: 18,
        )
            : CircleAvatar(
          radius: 10,
          backgroundColor: HexColor(color.hexColor ?? ""),
        ),
      ),
    ))
        .toList() ??
        [];
    return lst;
  }

  void colorPickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: SingleChildScrollView(
            child: CustomColorPicker(
              pickerColor: Colors.pink,
              displayThumbColor: true,
              enableAlpha: true,
              hueRingStrokeWidth: 20,
              onColorChanged: (colorValue) {
                colorPicker = colorValue;
              },
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            CommonFilledButton(
              onPressed: () {
                ColorModel color=ColorModel(
                  isSelected: true,
                  hexColor: colorPicker?.toHex()??Colors.pink.toHex(),
                  isActive: true,
                );
                widget.onAddColor(color);
              },
              btnText: MsgConstants.apply,
            ).paddingSymmetric(horizontal: 30),
          ],
        );
      },
    );
  }
}
