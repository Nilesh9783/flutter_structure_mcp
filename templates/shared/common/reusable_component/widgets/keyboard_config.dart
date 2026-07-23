

// TODO in future remove
// KeyboardActionsConfig getKeyboardActionsConfig(
//     BuildContext context, List<FocusNode> list) {
//   return KeyboardActionsConfig(
//     keyboardBarColor: Colors.grey[200],
//     nextFocus: true,
//     actions: List.generate(
//       list.length,
//       (i) => KeyboardActionsItem(
//         focusNode: list[i],
//         toolbarButtons: [
//           (node) {
//             return GestureDetector(
//               onTap: () => node.unfocus(),
//               child: Padding(
//                 padding: const EdgeInsets.only(right: 16.0),
//                 child: _buildDoneButton(),
//               ),
//             );
//           },
//         ],
//       ),
//     ),
//   );
// }

