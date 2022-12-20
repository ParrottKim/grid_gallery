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

  void _listenController() => setState(() {});

  @override
  void initState() {
    super.initState();
    _controller = GalleryController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grid Gallery'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 90.0,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: _controller.selectedIndexes.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: () {},
                  child: Ink(
                    width: 90.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: MemoryImage(
                          _controller
                              .items[_controller.selectedIndexes[index]].data,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            MaterialButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GridGallery(),
                ),
              ),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              child: Text('Open Gallery'),
            ),
          ],
        ),
      ),
    );
  }
}
