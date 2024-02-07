import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fridgeat/features/main_screen/widgets/bottom_sheet.dart';
import 'package:fridgeat/features/onboarding/select_seasoning_spiceries_screen.dart';
import 'package:fridgeat/features/recipes_screen/%08user_selections.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:fridgeat/constants/gaps.dart';

late List<CameraDescription> cameras;

class CameraScreen extends StatefulWidget {
  final List<String> selectedSeasonings;
  final List<String> selectedSpiceries;
  final UserSelections userSelections;
  final FlutterVision vision;

  const CameraScreen({
    super.key,
    this.selectedSeasonings = const [],
    this.selectedSpiceries = const [],
    required this.userSelections,
    required this.vision,
  });

  @override
  State<CameraScreen> createState() {
    return _CameraScreenState();
  }
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  CameraController? controller;
  XFile? imageFile;
  XFile? videoFile;
  VideoPlayerController? videoController;
  VoidCallback? videoPlayerListener;
  bool enableAudio = true;

  List<String> ingredientList = [];
  bool sheetExpanded = false;
  List<String> selectedSeasonings = [];
  List<String> selectedSpiceries = [];
  late final UserSelections userSelections = widget.userSelections;

  late List<Map<String, dynamic>> yoloResults;
  CameraImage? cameraImage;
  bool isYoloLoaded = false;
  bool isYoloDetecting = false;

  List<String> recognizedObjects = [];
  String? currentTopRecognition;
  Map<String, String> koreanLabelsMap = {
    "Anchovy": "멸치",
    "Bok choy": "청경채",
    "Bracken": "고사리",
    "King trumpet mushroom": "새송이버섯",
    "Manila clam": "바지락",
    "Paprika": "파프리카",
    "Pumpkin": "호박",
    "Sausage": "소시지",
    "bean sprouts": "숙주나물",
    "beef": "소고기",
    "bellflowerroot": "도라지",
    "broccoli": "브로콜리",
    "burdock": "우엉",
    "button mushroom": "양송이버섯",
    "cabbage": "양배추",
    "carrot": "당근",
    "chicken": "닭고기",
    "chives": "부추",
    "cucumber": "오이",
    "dried shrimp": "말린 새우",
    "dumpling": "만두",
    "egg": "달걀",
    "eggplant": "가지",
    "enoki mushroom": "팽이버섯",
    "garlic": "마늘",
    "ginger": "생강",
    "green onion": "파",
    "ham": "햄",
    "jukini": "쥬키니",
    "kimchi": "김치",
    "lettuce": "상추",
    "mackerel": "고등어",
    "mussel": "홍합",
    "napa cabbage": "배추",
    "onion": "양파",
    "oyster mushroom": "느타리버섯",
    "pepper": "후추",
    "perilla leaves": "깻잎",
    "pork": "돼지고기",
    "potato": "감자",
    "radish": "무",
    "salmon": "연어",
    "shepherd-s purse": "냉이",
    "shiitake": "표고버섯",
    "shrimp": "새우",
    "small octopus": "낙지",
    "squid": "오징어",
    "sweetpotato": "고구마",
    "tahu": "두부",
    "tomato": "토마토",
    "watercress": "미나리"
  };

  @override
  void initState() {
    super.initState();
    init();
    startDetection();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          selectedSeasonings = widget.selectedSeasonings; // 인수로 받은 조미료 목록을 설정
          selectedSpiceries = widget.selectedSpiceries; // 인수로 받은 양념류 목록을 설정
        });
      }
    });
  }

  init() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.max);
    await controller?.initialize();
    await loadYoloModel();
    setState(() {
      isYoloLoaded = true;
      isYoloDetecting = true;
      yoloResults = [];
    });
    await startDetection();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    stopDetection(); // 위젯이 제거될 때 객체 인식 중지
    super.dispose();
    controller!.dispose();
  }

  void _toggleSheet() {
    setState(() {
      sheetExpanded = !sheetExpanded;
      isYoloDetecting = !sheetExpanded; // CustomBottomSheet의 상태에 따라 객체 인식 상태 변경
    });

    if (isYoloDetecting) {
      startDetection();
    } else {
      stopDetection();
    }
  }

// CameraScreen 내에서:
  void onDropletIconPressed() async {
    stopDetection(); // 객체 인식 기능을 중지합니다.

    print(userSelections.seasonings);
    print(userSelections.spiceries);
    final selectedItems = await Navigator.of(context).push(_createRoute());
    startDetection(); // 다시 화면으로 돌아왔을 때 객체 인식 기능을 재개합니다.

    if (selectedItems != null && selectedItems is Map) {
      List<String>? newSelectedSeasonings =
          List<String>.from(selectedItems['selectedSeasonings'] ?? []);
      List<String>? newSelectedSpiceries =
          List<String>.from(selectedItems['selectedSpiceries'] ?? []);

      // UserSelections 인스턴스 상태를 업데이트
      userSelections.updateSeasonings(newSelectedSeasonings);
      userSelections.updateSpiceries(newSelectedSpiceries);

      // 화면 상태를 새로고침
      setState(() {
        selectedSeasonings = newSelectedSeasonings;
        selectedSpiceries = newSelectedSpiceries;
      });
    }
  }

  Route _createRoute() {
    return PageRouteBuilder(
      transitionDuration: const Duration(
          milliseconds: 300), // Adjust the speed of the animation
      pageBuilder: (context, animation, secondaryAnimation) =>
          SetSeasoningSpiceryScreen(
        userSelections: userSelections,
        hideNavigationBar: false,
        accessedByCameraScreen: true,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  void stopObjectDetection() {
    stopDetection(); // 이 함수는 이미 CameraScreen에 정의되어 있어야 합니다.
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 객체 인식 기능을 다시 시작하는 로직
    startDetection();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (!isYoloLoaded) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              LoadingAnimationWidget.waveDots(color: Colors.black, size: 40),
              Gaps.v10,
              const Text(
                "카메라 모델을 로딩 중입니다.",
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          AspectRatio(
            aspectRatio: controller!.value.aspectRatio,
            child: CameraPreview(
              controller!,
            ),
          ),
          ...displayBoxesAroundRecognizedObjects(size),
          Positioned(
            top: 35.0,
            right: 30.0,
            child: IconButton(
              icon: const Icon(
                FontAwesomeIcons.droplet,
                color: Colors.white,
                size: 22.0,
              ),
              // CameraScreen에서 "droplet" 아이콘의 onPressed 이벤트를 수정합니다.
              onPressed: onDropletIconPressed,
            ),
          ),
          Positioned(
            top: 40.0,
            left: 100.0,
            child: Container(
              width: 200.0,
              height: 40.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: Colors.black.withOpacity(0.3),
              ),
              child: Center(
                child: Text(
                  currentTopRecognition ?? '식재료를 인식해주세요',
                  style: const TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 200.0,
            left: 0.0,
            right: 0.0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  if (currentTopRecognition != null) {
                    setState(() {
                      ingredientList.add(currentTopRecognition!);
                    });
                  } else {
                    // currentTopRecognition이 null일 때 처리 로직을 추가
                  }
                },
                child: Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 5.0,
                        spreadRadius: 1.0,
                        offset: const Offset(0.0, 2.0),
                      ),
                    ],
                  ),
                  child: const Icon(
                    FontAwesomeIcons.plus,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
          CustomBottomSheet(
            ingredients: ingredientList,
            isExpanded: sheetExpanded,
            userSelections: userSelections,
            onToggle: _toggleSheet,
            stopObjectDetection: stopObjectDetection,
          ),
        ],
      ),
    );
  }

  Future<void> loadYoloModel() async {
    await widget.vision.loadYoloModel(
        labels: 'assets/labels.txt',
        modelPath: 'assets/yolov8n_best_float16.tflite',
        modelVersion: "yolov8",
        numThreads: 2,
        useGpu: true);
    setState(() {
      isYoloLoaded = true;
    });
  }

  Future<void> yoloOnFrame(CameraImage cameraImage) async {
    if (!isYoloDetecting) return;

    final result = await widget.vision.yoloOnFrame(
      bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
      imageHeight: cameraImage.height,
      imageWidth: cameraImage.width,
      iouThreshold: 0.4,
      confThreshold: 0.4,
      classThreshold: 0.5,
    );
    if (result.isNotEmpty) {
      setState(() {
        yoloResults = result;
        String englishLabel =
            result.reduce((a, b) => a['box'][4] > b['box'][4] ? a : b)['tag'];
        currentTopRecognition = koreanLabelsMap[englishLabel] ?? "직접 입력해주세요";
      });
    }
  }

  Future<void> startDetection() async {
    // 상태를 설정하여 객체 감지가 진행 중임을 나타냅니다.
    setState(() {
      isYoloDetecting = true;
    });

    // 컨트롤러가 초기화되었고 이미지 스트리밍을 하고 있지 않은지 확인합니다.
    if (controller != null &&
        controller!.value.isInitialized &&
        !controller!.value.isStreamingImages) {
      // 이미지 스트림을 시작합니다.
      await controller?.startImageStream((image) async {
        if (isYoloDetecting) {
          cameraImage = image;
          yoloOnFrame(image);
        }
      });
    }
  }

  Future<void> stopDetection() async {
    setState(() {
      isYoloDetecting = false;
      yoloResults.clear();
    });
  }

  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    if (yoloResults.isEmpty) return [];
    double factorX = screen.width / (cameraImage?.height ?? 1);
    double factorY = screen.height / (cameraImage?.width ?? 1);

    Color colorPick = const Color.fromARGB(255, 50, 233, 30);

    return yoloResults.map((result) {
      return Positioned(
        left: result["box"][0] * factorX,
        top: result["box"][1] * factorY,
        width: (result["box"][2] - result["box"][0]) * factorX,
        height: (result["box"][3] - result["box"][1]) * factorY,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: Colors.pink, width: 2.0),
          ),
          child: Text(
            "${result['tag']} ${(result['box'][4] * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              background: Paint()..color = colorPick,
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
        ),
      );
    }).toList();
  }
}
