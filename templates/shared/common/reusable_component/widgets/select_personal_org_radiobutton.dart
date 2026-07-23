import 'package:expense_tracker/model/common_profile_management_model.dart';
import 'package:expense_tracker/reusable_component/import.dart';
import 'package:expense_tracker/utils/common/base_bloc.dart';
import 'package:expense_tracker/utils/extensions/extension.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../model/organization_model.dart';
import 'common_head_bar.dart';

// ignore: must_be_immutable
class SelectPersonalOrganisation extends StatefulWidget {
  final Function orgCallBack;
  CommonProfileManageMentModel? organizationModel;
  final bool isFromSetPayment;
  SelectPersonalOrganisation(
      {super.key,
      required this.orgCallBack,
      required this.organizationModel,
      required this.isFromSetPayment});

  @override
  State<SelectPersonalOrganisation> createState() =>
      _SelectPersonalOrganisationState();
}

class _SelectPersonalOrganisationState
    extends State<SelectPersonalOrganisation> {
  bool isPersnolSelect = false;
  CommonProfileManageMentModel? persnalModel;
  CommonProfileManageMentModel? organizationModelLocal;
  //List<CommonProfileManageMentModel> orgList = [];
  BehaviorSubject<List<CommonProfileManageMentModel>?> listOrganizationStraem =
      BehaviorSubject<List<CommonProfileManageMentModel>?>();
  List<CommonProfileManageMentModel> orgList = [];
  @override
  void initState() {
    super.initState();
    List<CommonProfileManageMentModel> list =[];
    list.addAll(aGeneralBloc.listBaseOrganizationStraem.valueOrNull ?? []);
    listOrganizationStraem.add(list);

    orgList.addAll(listOrganizationStraem.valueOrNull ?? []);
    persnalModel = orgList
        .where((element) => element.accountType
            .toLowerCase()
            .contains(CommonProfileTypeModelEnum.personal.typeKey))
        .first;
    orgList.removeWhere((element) => element.accountType
        .toLowerCase()
        .contains(CommonProfileTypeModelEnum.personal.typeKey));
    if (widget.isFromSetPayment) {
      orgList.removeWhere((element) => element.accountType
          .contains(CommonProfileTypeModelEnum.organizationUser.typeKey));
    }

    if (widget.organizationModel == null) {
      orgList.first.isSelectedOprationBase = true;
      widget.organizationModel = orgList.first;
      organizationModelLocal = orgList.first;
    } else {
      for (var element in orgList) {
        if (element.profileId == widget.organizationModel?.profileId) {
          element.isSelectedOprationBase = true;
          organizationModelLocal = element;
        }
      }
    }
  }

  @override
  void dispose() {
    for (var element in orgList) {
      element.isSelectedOprationBase = false;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (!(widget.organizationModel?.accountType ==
    //     CommonProfileTypeModelEnum.personal.typeKey)) {
    //   organizationModelLocal = widget.organizationModel;
    // }
    return _selectPersonalOrganisation();
  }

  Widget _selectPersonalOrganisation() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.scaffoldColor,
        borderRadius: BorderRadiusDirectional.circular(10.0),
        border: Border.all(
            width: 1.0, style: BorderStyle.solid, color: AppColors.cF3F3F3),
      ),
      height: context.getHeightWithSize(sizeConstant: 110.0),
      child: Padding(
        padding: EdgeInsets.only(
          left: context.getWidthWithSize(sizeConstant: 16),
          right: context.getWidthWithSize(sizeConstant: 16),
        ),
        child: _profileTypeList(),
      ),
    );
  }

  Widget _profileTypeList() {
    return Column(
      children: [
        _profileContent(
            strType: MsgConstants.personal,
            imgProfileType: ImgConstants.icPersonal,
            isSelected: isPersnolSelect,
            onTap: () {
              widget.orgCallBack(persnalModel);
            }),
        _profileContent(
            strType: MsgConstants.organization,
            imgProfileType: ImgConstants.icOrganisation,
            isSelected: !isPersnolSelect,
            onTap: () {
              widget.orgCallBack(organizationModelLocal);
            }),
      ],
    );
  }

  Widget _profileContent(
      {String? strType,
      String? imgProfileType,
      required VoidCallback onTap,
      bool? isSelected}) {
    return InkWell(
      onTap: () {
        if (imgProfileType == ImgConstants.icOrganisation) {
          setState(() {
            isPersnolSelect = false;
          });
        } else {
          setState(() {
            isPersnolSelect = true;
          });
        }

        onTap();
      },
      child: SizedBox(
        height: context.getHeightWithSize(
          sizeConstant: (strType == MsgConstants.organization) ? 55 : 50.0,
        ),
        child: Row(
          children: [
            Image.asset(
              imgProfileType ?? '',
              height: 20.0,
              width: 20.0,
              fit: BoxFit.contain,
            ),
            12.0.widthSizedBox,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    strType ?? '',
                    style: AppTextStyles.textStyle16w400(AppColors.c24262D),
                  ),
                  if (strType == MsgConstants.organization)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          organizationModelLocal?.orgName.capitalizeFirstWordOnly() ?? "",
                          style:
                              AppTextStyles.textStyle15w400(AppColors.c24262D).copyWith(fontWeight: FontWeight.w600),
                        ),
                        InkWell(
                          onTap: () {
                            showCurrencyBottomSheet(onSelect: (orgModel) {
                              widget.orgCallBack(orgModel);
                              setState(() {
                                isPersnolSelect = false;
                                widget.organizationModel =
                                    organizationModelLocal;
                                organizationModelLocal = orgModel;
                              });
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: AspectSize.getWithSize(
                                context: context,
                                sizeConstant: 14.25,
                              ),
                              top: AspectSize.getWithSize(
                                context: context,
                                sizeConstant: 3,
                              ),
                            ),
                            child: ImgConstants.icArrowDown
                                .svgAssetImage(width: 15.5, height: 8.5),
                          ),
                        )
                      ],
                    )
                ],
              ),
            ),
            Image.asset(
              isSelected == true
                  ? ImgConstants.icSelectedRadio
                  : ImgConstants.icUnselectedRadio,
              height: 20.0,
              width: 20.0,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }

  Future showCurrencyBottomSheet({required Function onSelect}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
              height: context.height/2,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CommonHeadBar(
                      title: MsgConstants.selectOrganization,
                      callBackClose: () {
                        widget.orgCallBack((isPersnolSelect)
                            ? persnalModel
                            : organizationModelLocal);
                      },
                    ),
                    10.0.heightSizedBox,
                    StreamBuilder<List<CommonProfileManageMentModel>?>(
                        stream: listOrganizationStraem,
                        builder: (_, snapshot) {
                          return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: orgList.length,
                              itemBuilder: (cont, index) {
                                CommonProfileManageMentModel organizationModel =
                                    orgList[index];
                                return Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        for (var element in orgList) {
                                          element.isSelectedOprationBase = false;
                                        }
                                        orgList[index].isSelectedOprationBase =
                                            true;
                                        listOrganizationStraem.add(orgList);
                                        onSelect(organizationModel);
                                        context.navigateBack();
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          bottom: AspectSize.getWithSize(
                                              context: context,
                                              sizeConstant: 10.0),
                                          top: AspectSize.getWithSize(
                                              context: context,
                                              sizeConstant: 10.0),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                getProfileImage(
                                                    organizationModel),
                                                16.0.widthSizedBox,
                                                Text(
                                                  (organizationModel.orgName)
                                                      .capitalizeFirstWordOnly(),
                                                  style: AppTextStyles
                                                      .textStyle16w400(
                                                          AppColors.c24262D),
                                                ),
                                              ],
                                            ),
                                            Image.asset(
                                              organizationModel
                                                          .isSelectedOprationBase ==
                                                      true
                                                  ? ImgConstants.icSelectedRadio
                                                  : ImgConstants
                                                      .icUnselectedRadio,
                                              height: AspectSize.getWithSize(
                                                context: context,
                                                sizeConstant: 20.0,
                                              ),
                                              width: AspectSize.getWithSize(
                                                context: context,
                                                sizeConstant: 20.0,
                                              ),
                                              fit: BoxFit.contain,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              });
                        }),
                    20.0.heightSizedBox,
                  ],
                ).paddingSymmetric(horizontal: 20),
              ),
            );
          },
        );
      },
    );
  }
}
