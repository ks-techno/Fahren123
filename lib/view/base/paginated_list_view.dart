import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Fahren123/helper/responsive_helper.dart';
import 'package:Fahren123/util/dimensions.dart';
import 'package:Fahren123/util/styles.dart';

class PaginatedListView extends StatefulWidget {
  final ScrollController scrollController;
  final Function(int offset) onPaginate;
  final int totalSize;
  final int offset;
  final Widget itemView;
  const PaginatedListView({
    Key ?key, required this.scrollController, required this.onPaginate, required this.totalSize,
    required this.offset, required this.itemView,
  }) : super(key: key);

  @override
  State<PaginatedListView> createState() => _PaginatedListViewState();
}

class _PaginatedListViewState extends State<PaginatedListView> {
  late int _offset;
  late List<int> _offsetList;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _offset = 1;
    _offsetList = [1];

    widget.scrollController.addListener(() {
      if (widget.scrollController.position.pixels == widget.scrollController.position.maxScrollExtent && !_isLoading) {
        if(mounted && !ResponsiveHelper.isDesktop(context)) {
          _paginate();
        }
      }
    });
  }

  void _paginate() async {
    int pageSize = (widget.totalSize / 10).ceil();
    if (_offset < pageSize && !_offsetList.contains(_offset+1)) {

      setState(() {
        _offset = _offset + 1;
        _offsetList.add(_offset);
        _isLoading = true;
      });
      await widget.onPaginate(_offset);
      setState(() {
        _isLoading = false;
      });

    }else {
      if(_isLoading) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _offset = widget.offset;
    _offsetList = [];
    for(int index=1; index<=widget.offset; index++) {
      _offsetList.add(index);
    }

    return Column(children: [

      widget.itemView,

      (ResponsiveHelper.isDesktop(context) && (_offset >= (widget.totalSize / 10).ceil() || _offsetList.contains(_offset+1))) ? const SizedBox() : Center(child: Padding(
        padding: (_isLoading || ResponsiveHelper.isDesktop(context)) ? const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL) : EdgeInsets.zero,
        child: _isLoading ? const CircularProgressIndicator() : (ResponsiveHelper.isDesktop(context)) ? InkWell(
          onTap: _paginate,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL, horizontal: Dimensions.PADDING_SIZE_LARGE),
            margin: ResponsiveHelper.isDesktop(context) ? const EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL) : null,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              color: Theme.of(context).primaryColor,
            ),
            child: Text('view_more'.tr, style: ralewayMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Colors.white)),
          ),
        ) : const SizedBox(),
      )),

    ]);
  }
}
