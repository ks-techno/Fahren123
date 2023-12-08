import 'package:Fahren123/util/dimensions.dart';
import 'package:Fahren123/view/base/my_text_field.dart';
import 'package:flutter/material.dart';
import '../../../util/styles.dart';
import '../utils/enum.dart';
import '../utils/flutter_custom_select_item.dart';
import '../utils/utils.dart';
import 'flutter_custom_selector_sheet.dart';

class CustomSingleSelectField<T> extends StatefulWidget
    with CustomBottomSheetSelector<T> {
  final double? width;
  final String title;
  final String Function(dynamic value)? itemAsString;
  final InputDecoration? decoration;
  final String? Function(String?)? validator;
  final void Function(dynamic value)? onSelectionDone;
  final T? initialValue;
  final Color selectedItemColor;
  final List<T> items;
  final TextStyle ?textStyle;

  CustomSingleSelectField({
    Key? key,
    required this.items,
    required this.title,
    required this.onSelectionDone,
    this.textStyle,
    this.width,
    this.itemAsString,
    this.decoration,
    this.validator,
    this.initialValue,
    this.selectedItemColor = Colors.redAccent,
  }) : super(key: key);

  @override
  State<CustomSingleSelectField> createState() =>
      _CustomSingleSelectFieldState();
}

class _CustomSingleSelectFieldState<T>
    extends State<CustomSingleSelectField<T>> {
  final TextEditingController _controller = TextEditingController();
  T? selectedItem;

  @override
  void initState() {
    selectedItem = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _controller.text = _selectedItemAsString(selectedItem);
    return GestureDetector(
      onTap: () async {
        Map<String, List<T>?> result =
            await CustomBottomSheetSelector<T>().customBottomSheet(
          buildContext: context,
          selectedItemColor: widget.selectedItemColor,
          initialSelection: selectedItem != null ? [selectedItem!] : [],
          buttonType: CustomDropdownButtonType.singleSelect,
          headerName: widget.title,
          textStyle: widget.textStyle,
          dropdownItems: _getDropdownItems(list: widget.items),
        );

        if (result[selectedList] != null) {
          if (widget.onSelectionDone != null) {
            widget.onSelectionDone!(result[selectedList]!.first);
          }
          selectedItem = result[selectedList]!.first;
          _controller.text = _selectedItemAsString(selectedItem);
          setState(() {});
        }
      },
      child: Container(
        width: widget.width??double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: TextFormField(
          controller: _controller,
          readOnly: true,
          enabled: false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: widget.validator,
          style: widget.textStyle??defaultTextStyle(
            fontSize: 16,
          ),
          decoration: inputFieldDecoration(context: context,hintText: widget.title,suffixIcon: null, fieldRadius: Dimensions.BORDER_RADIUS),
        ),
      ),
    );
    // return GestureDetector(
    //   onTap: () async {
    //     Map<String, List<T>?> result =
    //         await CustomBottomSheetSelector<T>().customBottomSheet(
    //       buildContext: context,
    //       selectedItemColor: widget.selectedItemColor,
    //       initialSelection: selectedItem != null ? [selectedItem!] : [],
    //       buttonType: CustomDropdownButtonType.singleSelect,
    //       headerName: widget.title,
    //       textStyle: widget.textStyle,
    //       dropdownItems: _getDropdownItems(list: widget.items),
    //     );
    //
    //     if (result[selectedList] != null) {
    //       if (widget.onSelectionDone != null) {
    //         widget.onSelectionDone!(result[selectedList]!.first);
    //       }
    //       selectedItem = result[selectedList]!.first;
    //       _controller.text = _selectedItemAsString(selectedItem);
    //       setState(() {});
    //     }
    //   },
    //   child: Container(
    //     width: widget.width??double.infinity,
    //     padding: const EdgeInsets.symmetric(horizontal: 10),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Padding(
    //           padding: const EdgeInsets.only(bottom: 2,left: 5),
    //           child: Text(
    //             widget.title,
    //             style: ralewayRegular.copyWith(fontSize: 12),
    //           ),
    //         ),
    //         TextFormField(
    //           controller: _controller,
    //           readOnly: true,
    //           enabled: false,
    //           autovalidateMode: AutovalidateMode.onUserInteraction,
    //           validator: widget.validator,
    //           style: widget.textStyle??defaultTextStyle(
    //             fontSize: 16,
    //           ),
    //           decoration: inputFieldDecoration(context: context,hintText: widget.title,suffixIcon: null),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  String _selectedItemAsString(T? data) {
    if (data == null) {
      return "";
    } else if (widget.itemAsString != null) {
      return widget.itemAsString!(data);
    } else {
      return data.toString();
    }
  }

  List<CustomMultiSelectDropdownItem<T>> _getDropdownItems(
      {required List<T> list}) {
    List<CustomMultiSelectDropdownItem<T>> _list =
        <CustomMultiSelectDropdownItem<T>>[];
    for (T _item in list) {
      _list.add(CustomMultiSelectDropdownItem(_item, _item.toString()));
    }
    return _list;
  }
}
