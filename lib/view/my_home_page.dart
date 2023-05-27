// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../controller/tap_controller.dart';

// class MyHomePage extends StatelessWidget {
//   const MyHomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final TapController controller = Get.put(TapController());
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             GetBuilder<TapController>(
//               builder: (tapController) {
//                 return Text(controller.x.toString());
//               },
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             GestureDetector(
//                 onTap: () {
//                   controller.increaseX();
//                 },
//                 child: const TapWidget()),
//             const SizedBox(
//               height: 20,
//             ),
//             GestureDetector(onTap: () {}, child: const TapWidget()),
//             const SizedBox(
//               height: 20,
//             ),
//             GestureDetector(onTap: () {}, child: const TapWidget()),
//             const SizedBox(
//               height: 20,
//             ),
//             GestureDetector(onTap: () {}, child: const TapWidget()),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class TapWidget extends StatelessWidget {
//   const TapWidget({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       child: Container(
//         width: double.infinity,
//         height: 60,
//         decoration: BoxDecoration(
//           color: Colors.grey[300],
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: const Center(
//           child: Text('Tap'),
//         ),
//       ),
//     );
//   }
// }
