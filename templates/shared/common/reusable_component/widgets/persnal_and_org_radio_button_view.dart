// import 'package:expense_tracker/model/common_profile_management_model.dart';
// import 'package:expense_tracker/reusable_component/import.dart';
// import 'package:expense_tracker/reusable_component/widgets/common_head_bar.dart';

// import 'package:expense_tracker/utils/extensions/extension.dart';
// import 'package:flutter/material.dart';
// import 'package:rxdart/subjects.dart';

// import '../../model/organization_model.dart';

// class RadioButtonPersnalAndOrgView extends StatelessWidget {
//   bool isPersnolSelect = false;
//   CommonProfileManageMentModel? selectedOrgModel;

//   final Function orgCallBack;
//   RadioButtonPersnalAndOrgView(
//       {super.key, required this.selectedOrgModel, required this.orgCallBack});

//   @override
//   Widget build(BuildContext context) {
//     if ((selectedOrgModel?.accountType ==
//         CommonProfileTypeModelEnum.personal.typeKey)) {
//       isPersnolSelect = true;
//     }

//     return _selectPersonalOrganisation(context);
//   }

//   Widget _selectPersonalOrganisation(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: AppColors.scaffoldColor,
//         borderRadius: BorderRadiusDirectional.circular(10.0),
//         border: Border.all(
//             width: 1.0, style: BorderStyle.solid, color: AppColors.cF3F3F3),
//       ),
//       height: context.getHeightWithSize(sizeConstant: 110.0),
//       child: Padding(
//         padding: EdgeInsets.only(
//           left: context.getWidthWithSize(sizeConstant: 16),
//           right: context.getWidthWithSize(sizeConstant: 16),
//         ),
//         child: _profileTypeList(context),
//       ),
//     );
//   }

//   Widget _profileTypeList(BuildContext context) {
//     return Column(
//       children: [
//         _profileContent(
//             strType: MsgConstants.personal,
//             imgProfileType: ImgConstants.icPersonal,
//             isSelected: isPersnolSelect,
//             context: context,
//             onTap: () {
//               orgCallBack(selectedOrgModel);
//             }),
//         _profileContent(
//             strType: MsgConstants.organization,
//             imgProfileType: ImgConstants.icOrganisation,
//             isSelected: !isPersnolSelect,
//             context: context,
//             onTap: () {
//               orgCallBack(selectedOrgModel);
//             }),
//       ],
//     );
//   }

//   Widget _profileContent(
//       {String? strType,
//       String? imgProfileType,
//       required VoidCallback onTap,
//       required BuildContext context,
//       bool? isSelected}) {
//     return InkWell(
//       onTap: () {},
//       child: SizedBox(
//         height: context.getHeightWithSize(
//           sizeConstant: (strType == MsgConstants.organization) ? 55 : 50.0,
//         ),
//         child: Row(
//           children: [
//             Image.asset(
//               imgProfileType ?? '',
//               height: 20.0,
//               width: 20.0,
//               fit: BoxFit.contain,
//             ),
//             12.0.widthSizedBox,
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     strType ?? '',
//                     style: AppTextStyles.textStyle16w400(AppColors.c24262D),
//                   ),
//                   if (strType == MsgConstants.organization)
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Text(
//                           selectedOrgModel?.orgName ?? "",
//                           style:
//                               AppTextStyles.textStyle15w400(AppColors.c24262D),
//                         ),
//                         InkWell(
//                           onTap: () {},
//                           child: Padding(
//                             padding: EdgeInsets.only(
//                               left: AspectSize.getWithSize(
//                                 context: context,
//                                 sizeConstant: 14.25,
//                               ),
//                               top: AspectSize.getWithSize(
//                                 context: context,
//                                 sizeConstant: 3,
//                               ),
//                             ),
//                             child: ImgConstants.icArrowDown
//                                 .svgAssetImage(width: 15.5, height: 8.5),
//                           ),
//                         )
//                       ],
//                     )
//                 ],
//               ),
//             ),
//             Image.asset(
//               isSelected == true
//                   ? ImgConstants.icSelectedRadio
//                   : ImgConstants.icUnselectedRadio,
//               height: 20.0,
//               width: 20.0,
//               fit: BoxFit.contain,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
