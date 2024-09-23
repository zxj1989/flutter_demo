import 'package:flutter/material.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});
  @override
  // ignore: library_private_types_in_public_api
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  String _selectedType = '请选择举报类型';
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    _descriptionController.dispose();
    _emailController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _selectReportType(BuildContext context) async {
    final List<String> reportTypes = ['诈骗', '骚扰', '不当内容'];
    final String? selectedType = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('选择举报类型'),
          children: reportTypes.map((String type) {
            return SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, type);
              },
              child: Text(type),
            );
          }).toList(),
        );
      },
    );

    if (selectedType != null) {
      setState(() {
        _selectedType = selectedType;
      });
    }
  }

  void _submitReport() {
    final String url = _urlController.text;
    final String description = _descriptionController.text;
    final String email = _emailController.text;
    final String note = _noteController.text;

    if (_selectedType == '请选择举报类型' ||
        url.isEmpty ||
        description.isEmpty ||
        email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请填写完整的举报信息')),
      );
    } else {
      // 处理提交逻辑
      print('举报类型: $_selectedType');
      print('URL: $url');
      print('举报内容: $description');
      print('电子邮件: $email');
      print('备注: $note');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('举报成功')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('举报')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Type:'),
            SizedBox(height: 8),
            GestureDetector(
              onTap: () => _selectReportType(context),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(_selectedType),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Text('URL:'),
            SizedBox(height: 8),
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '请输入URL，需以http或https开头',
              ),
            ),
            SizedBox(height: 16),
            Text('Describe:'),
            SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '详细填写举报理由，有利于审核，不得少于8个字',
              ),
            ),
            SizedBox(height: 16),
            Text('Email:'),
            SizedBox(height: 8),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '务必填写正确的邮箱地址',
              ),
            ),
            SizedBox(height: 16),
            Text('备注：'),
            SizedBox(height: 8),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '请输入备注',
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _submitReport,
                child: Text('Send'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
