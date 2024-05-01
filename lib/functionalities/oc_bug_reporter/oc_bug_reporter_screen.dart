import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'oc_bug_reporter.dart';
import 'oc_image_editor_screen.dart';

class OCBugReporterScreen extends StatefulWidget {
  const OCBugReporterScreen({this.image, this.onBugReporterClosed, super.key});
  final Uint8List? image;
  final Function? onBugReporterClosed;

  @override
  State<OCBugReporterScreen> createState() => _OCBugReporterScreenState();

  static Route<void> route(Uint8List? image, Function? onBugReporterClosed) {
    return MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/ocbugreporter'),
        builder: (_) => OCBugReporterScreen(
              image: image,
              onBugReporterClosed: onBugReporterClosed,
            ));
  }
}

class _OCBugReporterScreenState extends State<OCBugReporterScreen> {
  final TextEditingController _titleTextController = TextEditingController();
  final TextEditingController _descriptionTextController =
      TextEditingController();

  Uint8List? image;

  @override
  void initState() {
    image = widget.image;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          foregroundColor: Colors.white,
          title: const Text(
            'OC Bug Reporter',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
              widget.onBugReporterClosed?.call();
            },
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(children: <Widget>[
            const SizedBox(
              height: 16,
            ),
            if (image == null)
              Container()
            else
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Column(
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: Image.memory(
                          image!,
                          width: 150,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              OCImageEditorScreen.route(image!, (p0) {
                                image = p0;
                                setState(() {});
                              }));
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            'Edit Image',
                            style: TextStyle(color: Colors.red, fontSize: 14),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              controller: _titleTextController,
              autocorrect: false,
              style: TextStyle(color: Colors.black.withOpacity(0.8)),
              cursorColor: Colors.black,
              decoration: InputDecoration(
                counterText: '',
                fillColor: Colors.white,
                filled: false,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                labelText: 'Title',
                labelStyle: TextStyle(color: Colors.black.withOpacity(0.4)),
                hintStyle: TextStyle(color: Colors.black.withOpacity(0.4)),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              textAlign: TextAlign.left,
              textAlignVertical: TextAlignVertical.top,
              controller: _descriptionTextController,
              autocorrect: false,
              maxLines: 10,
              style: TextStyle(color: Colors.black.withOpacity(0.8)),
              cursorColor: Colors.black,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                floatingLabelAlignment: FloatingLabelAlignment.start,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                isDense: true,
                alignLabelWithHint: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                labelText: 'Description',
                labelStyle: TextStyle(color: Colors.black.withOpacity(0.4)),
                hintStyle: TextStyle(color: Colors.black.withOpacity(0.4)),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            MaterialButton(
              color: Colors.blue,
              minWidth: double.maxFinite,
              onPressed: _onSubmitButtonClick,
              height: 45,
              child: const Text(
                'Report',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
          ]),
        ),
      ),
    );
  }

  void _onSubmitButtonClick() {
    if (_titleTextController.text.isEmpty ||
        _descriptionTextController.text.isEmpty) {
      // Utilities.showSnackBar(
      //     context, 'Title and description are required', SnackbarStyle.error);
      return;
    }

    OCBugReporterService().createLog(
        image, _titleTextController.text, _descriptionTextController.text);
    Navigator.pop(context);
    widget.onBugReporterClosed?.call();
  }
}
