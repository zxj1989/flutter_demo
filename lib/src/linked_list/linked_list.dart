import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

class LinkedListsWidget extends StatefulWidget {
  const LinkedListsWidget({super.key});

  @override
  State<LinkedListsWidget> createState() => _LinkedListsWidgetState();
}

class _LinkedListsWidgetState extends State<LinkedListsWidget> {
  List<String> leftList = [];
  List<String> rightList = [];
  Map<String, LoadRecord> linkedListMap = {};
  final ScrollController _rightListScrollController = ScrollController();
  final EasyRefreshController _refreshController =
      EasyRefreshController(controlFinishLoad: true);

  String selectedLeftItem = '';
  int selectedIndex = 0; // 保存当前选中的索引
  bool hasMoreData = true;

  @override
  void initState() {
    super.initState();
    fetchLeftListData(); // 在组件初始化时发起请求
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey,
              child: ListView.builder(
                itemCount: leftList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      onLeftItemSelected(leftList[index], index);
                    },
                    child: Container(
                      color:
                          index == selectedIndex ? Colors.white : Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 14.5),
                      child: Text(
                        leftList[index],
                        style: TextStyle(
                          color: index == selectedIndex
                              ? Colors.blue
                              : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            )),
        Expanded(
          flex: 4,
          child: EasyRefresh(
            controller: _refreshController,
            callLoadOverOffset: 100.0, // 这里设置上拉加载触发的距离，单位为像素
            onLoad: hasMoreData
                ? () async {
                    debugPrint('onLoad');
                    await fetchRightListData(selectedLeftItem);
                  }
                : null,
            footer: const ClassicFooter(
              noMoreText: '没有更多数据了',
              processingText: "加载中...",
              processedText: "加载成功",
              dragText: "上拉加载更多",
              showText: true,
              showMessage: false,
              spacing: 8.0,
              safeArea: false,
              noMoreIcon:
                  Image(image: AssetImage('assets/images/no_more_icon.png')),
            ),
            child: ListView.builder(
              padding: const EdgeInsets.all(0),
              controller: _rightListScrollController,
              itemCount: rightList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(rightList[index]),
                  splashColor: Colors.green,
                  hoverColor: Colors.green,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  // 定义一个方法用于发起异步请求获取左侧数据
  Future<void> fetchLeftListData() async {
    await Future.delayed(const Duration(seconds: 2), () {
      // 模拟请求完成后更新左侧列表数据
      setState(() {
        List<String> list = [];
        for (var i = 0; i < 30; i++) {
          list.add('Item $i');
        }
        leftList = list;
        selectedLeftItem = leftList[0];
      });

      // 发起异步请求获取右侧数据
      fetchRightListData(leftList[0]);
    });
  }

  Future<void> fetchRightListData(String item) async {
    LoadRecord? record = linkedListMap[item];
    if (record != null && !record.hasMoreData) {
      _refreshController.finishLoad(IndicatorResult.noMore);
      return;
    }
    await Future.delayed(const Duration(seconds: 2), () {
      if (record == null) {
        debugPrint('fetchRightListData: $item record is null');
        List<String> dataList = [];
        for (var i = 0; i < 30; i++) {
          dataList.add('Subitem ${i + 1}');
        }
        record = LoadRecord(
          page: 1,
          hasMoreData: true,
          dataList: dataList,
        );
        linkedListMap[item] = record!;
      } else {
        debugPrint('fetchRightListData: $item record is not null');
        record!.page++;
        record!.hasMoreData = record!.page < 5;
        for (var i = 0; i < 30; i++) {
          record!.dataList.add('Subitem ${record!.dataList.length + 1}');
        }
      }

      linkedListMap[item] = record!;
      // 模拟请求完成后更新右侧列表数据
      setState(() {
        rightList = record?.dataList ?? [];
        hasMoreData = record!.hasMoreData;
      });
      if (record!.hasMoreData) {
        _refreshController.finishLoad(IndicatorResult.success);
      } else {
        _refreshController.finishLoad(IndicatorResult.noMore);
      }
    });
  }

  void onLeftItemSelected(String item, int index) {
    // 更新选中的左侧列表项
    _rightListScrollController.jumpTo(0);
    setState(() {
      selectedLeftItem = item;
      selectedIndex = index; // 更新选中的索引
      rightList = linkedListMap[item]?.dataList ?? [];
      hasMoreData = linkedListMap[item]?.hasMoreData ?? true;
    });
    _refreshController.resetFooter();
    LoadRecord? record = linkedListMap[item];
    if (record != null) {
      setState(() {
        rightList = record.dataList;
      });
      return;
    }
    fetchRightListData(item);
  }
}

class LoadRecord {
  int page;
  bool hasMoreData;
  List<String> dataList;

  LoadRecord({
    required this.page,
    required this.hasMoreData,
    required this.dataList,
  });
}
