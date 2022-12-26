import 'package:flutter/material.dart';
import 'package:grid_gallery/grid_gallery.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grid Gallery Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final GalleryController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GalleryController()..addListener(() => _listenController());
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _listenController() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grid Gallery'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: MaterialButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            PhotoSelectPage(controller: _controller),
                      ),
                    ),
                    height: 72.0,
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    child: Text(
                      'Show Page',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: MaterialButton(
                    onPressed: () => showModalBottomSheet(
                      context: context,
                      builder: (_) => PhotoSelectPage(controller: _controller),
                    ),
                    height: 72.0,
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    child: Text(
                      'Show Bottom Dialog',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: MaterialButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (_) => PhotoSelectPage(controller: _controller),
                    ),
                    height: 72.0,
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    child: Text(
                      'Show Dialog',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _controller.selectedIndexes.length,
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  print('${_controller.items[index].asset}');
                  print('${_controller.items[index].data}');
                },
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Ink(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(
                          _controller
                              .items[_controller.selectedIndexes[index]].data,
                        ),
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PhotoSelectPage extends StatelessWidget {
  const PhotoSelectPage({Key? key, required this.controller}) : super(key: key);

  final GalleryController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Photo'),
      ),
      body: GridGallery(
        controller: controller,
        onChanged: () {
          print('main: ${controller.selectedIndexes}');
        },
        onAdded: (index) {
          print('onAdded: ${index}');
        },
        onRemoved: (index) {
          print('onRemoved: ${index}');
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.deselectAll(),
        child: Icon(Icons.delete_sweep),
      ),
    );
  }
}
