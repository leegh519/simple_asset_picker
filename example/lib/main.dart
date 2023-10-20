import 'package:flutter/material.dart';
import 'package:simple_asset_picker/simple_asset_picker.dart';

void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<AssetEntity> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () async {
              list = await Picker.pickAssets(
                context,
                pickerConfig: PickerConfig(
                  mainColor: Colors.green,
                  brightness: Brightness.light,
                  gridCount: 3,
                  maxAssets: 10,
                  pageSize: 30,
                  requestType: RequestType.common,
                  selectedAssets: list,
                  useCamera: false,
                ),
              );
              setState(() {});
            },
            child: const Text('사진선택'),
          ),
          const SizedBox(
            height: 50,
          ),
          Container(
            color: Colors.grey[200],
            height: list.isEmpty ? 0 : 120,
            padding: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('선택한 사진'),
                Expanded(
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: list.length,
                    itemBuilder: (_, index) {
                      return SizedBox(
                        width: 100,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: AssetEntityImage(
                                list[index],
                                isOriginal: false,
                                thumbnailSize: const ThumbnailSize.square(80),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (_, __) {
                      return const SizedBox(
                        width: 5,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
