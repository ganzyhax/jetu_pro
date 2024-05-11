// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
//
// class ChooseOnMapScreen extends StatelessWidget {
//   const ChooseOnMapScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: FlutterMap(
//         options: MapOptions(
//           center: state.mapCenter,
//           zoom: 14,
//           interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
//           onPositionChanged: (val, bool) => EasyDebounce.debounce(
//             'tag',
//             const Duration(milliseconds: 200),
//                 () {
//               center = val.center!;
//               context.read<JetuMapCubit>().onAddressChange(val.center!);
//             },
//           ),
//         ),
//         layers: [
//           TileLayerOptions(
//             urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//             subdomains: ['a', 'b', 'c'],
//             retinaMode: true,
//           ),
//           MarkerLayerOptions(
//             markers: [
//               for (var j in data.users)
//                 Marker(
//                   point: LatLng(j.lat ?? 0.0, j.long ?? 0.0),
//                   builder: (context) {
//                     return GestureDetector(
//                       onTap: () => onRefresh?.call(),
//                       child: Container(
//                         height: 24.h,
//                         width: 24.h,
//                         color: AppColors.yellow,
//                       ),
//                     );
//                   },
//                 )
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
