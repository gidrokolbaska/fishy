import 'package:flutter/material.dart';

class UploadDialog extends StatefulWidget {
  const UploadDialog({
    super.key,
    required this.function,
    this.description,
  });
  final Function function;
  final String? description;
  @override
  State<UploadDialog> createState() => _UploadDialogState();
}

class _UploadDialogState extends State<UploadDialog> {
  @override
  void initState() {
    super.initState();
    widget.function.call();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.description ?? 'Идет загрузка и обработка фотографий',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      content: const CircularProgressIndicator.adaptive(),
      icon: const Icon(Icons.cloud_upload),
    );
  }
}
