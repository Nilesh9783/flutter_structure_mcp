import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/model/category_models/category_request_resp_model.dart';
import 'package:expense_tracker/model/group/group_model.dart';
import 'package:expense_tracker/model/organization_model.dart';
import 'package:expense_tracker/model/setup_payment/setup_payment_model.dart';
import 'package:expense_tracker/model/user_model.dart';
import 'package:expense_tracker/reusable_component/widgets/cat_icon_comon_tile.dart';
import 'package:expense_tracker/screens/transaction/detail_transaction/transaction_detail.dart';
import 'package:expense_tracker/screens/transaction/detail_transaction/transaction_detail_bloc.dart';
import 'package:expense_tracker/services/common_services.dart';
import 'package:expense_tracker/services/group_services.dart';
import 'package:expense_tracker/services/transaction_services.dart';
import 'package:expense_tracker/utils/common/base_bloc.dart';
import 'package:expense_tracker/utils/enums.dart';
import 'package:expense_tracker/utils/extensions/datetime_extension.dart';
import 'package:expense_tracker/utils/extensions/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:expense_tracker/model/setup_payment/currency_model.dart';
import 'package:rxdart/rxdart.dart';
import '../../../model/trasaction_add_expense_model.dart';
import '../../../utils/common/config.dart';
import '../../../utils/common/constants.dart';
import '../../../utils/common/firebase_constant.dart';
import '../../../utils/common/utils.dart';
import '../../../utils/theme/app_text_style.dart';
import '../../../utils/theme/colors.dart';
import '../../dialogs/dispute_dialog.dart';
import '../app_add_image.dart';

class CommonTransactionList extends StatefulWidget {
  final List<TrsactionAddExpenseModel> transactionModelList;
  final bool? isPaymentWidgetShow;
  final bool? isUserWidgetShow;
  final Function onTap;
  final Function? approveCallBack;
  final Function? disputeCallBack;
  final ScrollController? scrollController;

  const CommonTransactionList(
      {super.key,
      required this.transactionModelList,
      this.approveCallBack,
      this.disputeCallBack,
      this.scrollController,
      this.isPaymentWidgetShow = false,
      this.isUserWidgetShow = false,
      required this.onTap});

  @override
  State<CommonTransactionList> createState() => _CommonTransactionListState();
}

class _CommonTransactionListState extends State<CommonTransactionList> {
  CommonServices commonServices = CommonServices();
  TransactionServices transactionServices = TransactionServices();
  GroupServices groupServices = GroupServices();
  TransactionDetailBloc transactionDetailBloc = TransactionDetailBloc();
  BehaviorSubject<bool> isGroupContentRefresh = BehaviorSubject.seeded(true);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SlidableAutoCloseBehavior(
      child: ListView.separated(
        controller: widget.scrollController ?? ScrollController(),
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        separatorBuilder: (cont, index) {
          return Container(
            width: double.infinity,
            height: 1,
            color: AppColors.cF3F3F3,
          );
        },
        itemCount: widget.transactionModelList.length,
        itemBuilder: (BuildContext context, int index) {
          TrsactionAddExpenseModel? transactionModel =
              widget.transactionModelList[index];
          bool isSameDate = true;
          bool isLastIndex = (widget.transactionModelList.length) == index + 1;
          final DateTime date =
              transactionModel.transactionDate?.toDate() ?? DateTime.now();

          if (index == 0) {
            isSameDate = false;
          } else {
            final DateTime prevDate = widget
                    .transactionModelList[index - 1].transactionDate
                    ?.toDate() ??
                DateTime.now();
            isSameDate = date.mmDDYYYY == prevDate.mmDDYYYY;
          }
          bool isBottomRadius = false;
          if (!isLastIndex) {
            final DateTime prevDate = widget
                    .transactionModelList[index + 1].transactionDate
                    ?.toDate() ??
                DateTime.now();
            isBottomRadius = date.mmDDYYYY != prevDate.mmDDYYYY;
          } else if (isLastIndex && !isSameDate) {
            isBottomRadius = true;
          }

          if (index == 0 || !(isSameDate)) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Text(
                    transactionModel.transactionDate
                            ?.toDate()
                            .friendlyDateTime ??
                        "",
                    style: AppTextStyles.textStyle12w400(AppColors.cA3A3A3),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (transactionModel.transactionType !=
                        TransactionTypeEnum.topUp.name) {
                      widget.onTap(transactionModel);
                    }
                  },
                  child: Container(
                    margin:
                        isLastIndex ? const EdgeInsets.only(bottom: 40) : null,
                    decoration: BoxDecoration(
                        color: AppColors.transCardColor,
                        borderRadius: isBottomRadius
                            ? BorderRadius.circular(10)
                            : const BorderRadius.only(
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(10),
                              )),
                    child: cardItem(
                        transactionModel: transactionModel,
                        isBottomRadius: isBottomRadius,
                        isFirstIndex: isSameDate),
                  ),
                ),
              ],
            );
          } else {
            return GestureDetector(
              onTap: () {
                if (transactionModel.transactionType !=
                    TransactionTypeEnum.topUp.name) {
                  widget.onTap(transactionModel);
                }
              },
              child: Container(
                margin: isLastIndex ? const EdgeInsets.only(bottom: 40) : null,
                decoration: BoxDecoration(
                    color: AppColors.transCardColor,
                    borderRadius: isBottomRadius
                        ? const BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          )
                        : null),
                child: cardItem(
                    transactionModel: transactionModel,
                    isBottomRadius: isBottomRadius,
                    isFirstIndex: isSameDate),
              ),
            );
          }
        },
      ),
    );
  }

  Widget cardItem(
      {TrsactionAddExpenseModel? transactionModel,
      required bool isBottomRadius,
      required bool isFirstIndex}) {
    return (!aGeneralBloc.isPersonalUser())
        ? StreamBuilder<bool>(
            stream: isGroupContentRefresh,
            builder: (context, snapshot) {
              return Slidable(
                  // enabled: (transactionModel?.transactionType ==
                  //             TransactionTypeEnum.expense.name &&
                  //         aGeneralBloc.isOrgAdmin()
                  //     ? true
                  //     : transactionModel?.isApproveDisputeSlideShow()??false?true:aGeneralBloc.currentOrganizationModelStream.valueOrNull
                  //             ?.profileId !=
                  //         transactionModel?.creatorId),
                  enabled: transactionModel?.isMyTransfer() ?? false,
                  startActionPane: transactionModel?.status ==
                          TransactionStatusEnum.pending.name
                      ? ActionPane(
                          extentRatio: 0.14,
                          motion: const ScrollMotion(),
                          children: [
                            CustomSlidableAction(
                              borderRadius: !isFirstIndex
                                  ? isBottomRadius
                                      ? const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10))
                                      : !isFirstIndex
                                          ? const BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                            )
                                          : const BorderRadius.only(
                                              bottomLeft: Radius.circular(10),
                                            )
                                  : isBottomRadius
                                      ? const BorderRadius.only(
                                          bottomLeft: Radius.circular(10))
                                      : BorderRadius.circular(0),
                              backgroundColor: AppColors.yellow,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.zero,
                              onPressed: (BuildContext context) {
                                if (transactionModel?.transactionType ==
                                    TransactionTypeEnum.expense.name) {
                                  showDisputeDialog(transactionModel);
                                  if (widget.disputeCallBack != null) {
                                    widget.disputeCallBack!();
                                  }
                                } else {
                                  transactionDetailBloc.transactionServices
                                      .rejectTransferTransaction(
                                    transactionId: transactionModel?.id ?? "",
                                    creatorId:
                                        transactionModel?.creatorId ?? "",
                                  );
                                  kNavigatorKey.currentState?.context
                                      .showSucess(
                                          MsgConstants.transferRejectedSuc);
                                }
                              },
                              child: Text(
                                  transactionModel?.transactionType ==
                                          TransactionTypeEnum.expense.name
                                      ? MsgConstants.disputeText
                                      : MsgConstants.rejectText,
                                  style: AppTextStyles.textStyle12w400(
                                      AppColors.mainColor)),
                            ),
                          ],
                        )
                      : null,
                  endActionPane: (transactionModel?.status !=
                              TransactionStatusEnum.approved.name &&
                          transactionModel?.status !=
                              TransactionStatusEnum.rejected.name)
                      ? ActionPane(
                          extentRatio: 0.14,
                          motion: const ScrollMotion(),
                          children: [
                            CustomSlidableAction(
                              backgroundColor: AppColors.greenLight,
                              foregroundColor: Colors.white,
                              borderRadius: !isFirstIndex
                                  ? isBottomRadius
                                      ? const BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10))
                                      : !isFirstIndex
                                          ? const BorderRadius.only(
                                              topRight: Radius.circular(10),
                                            )
                                          : const BorderRadius.only(
                                              bottomRight: Radius.circular(10),
                                            )
                                  : isBottomRadius
                                      ? const BorderRadius.only(
                                          bottomRight: Radius.circular(10))
                                      : BorderRadius.circular(0),
                              padding: EdgeInsets.zero,
                              onPressed: (BuildContext context) {
                                transactionServices.approvedTransaction(
                                    transaction: transactionModel);
                                kNavigatorKey.currentState?.context.showSucess(
                                    MsgConstants.transactionApproveSuc);
                                if (widget.approveCallBack != null) {
                                  widget.approveCallBack!();
                                }
                              },
                              child: Text(
                                  transactionModel?.transactionType ==
                                          TransactionTypeEnum.expense.name
                                      ? MsgConstants.approvedText
                                      : MsgConstants.acceptedText,
                                  style: AppTextStyles.textStyle12w400(
                                      AppColors.mainColor)),
                            ),
                          ],
                        )
                      : null,
                  key: Key(transactionModel.toString()),
                  child: dataView(transactionModel));
            })
        : dataView(transactionModel);
  }

  Widget dataView(TrsactionAddExpenseModel? transactionModel) {
    if (transactionModel?.categoryRequestRespsModel != null) {
      return contentViewWidget(
          transactionModel?.categoryRequestRespsModel, transactionModel);
    } else if ((widget.isPaymentWidgetShow ?? true) ||
        (widget.isUserWidgetShow ?? false)) {
      return contentViewWidget(
          transactionModel?.categoryRequestRespsModel, transactionModel);
    } else {
      return FutureBuilder<CategoryRequestRespsModel?>(
          future: commonServices
              .getCategoryBasedOnId(transactionModel?.categoryId ?? ""),
          builder: (context, snap) {
            CategoryRequestRespsModel? categoryRequestRespsModel = snap.data;
            //once its get first time then we add into local list for fatching data
            if (categoryRequestRespsModel != null) {
              aGeneralBloc.categoryListForCommonLoadedData.removeWhere(
                  (element) => element?.id == categoryRequestRespsModel.id);
              aGeneralBloc.categoryListForCommonLoadedData
                  .add(categoryRequestRespsModel);
            }

            if (!snap.hasData) {
              return contentViewWidget(
                  categoryRequestRespsModel, transactionModel);
            }
            return contentViewWidget(
                categoryRequestRespsModel, transactionModel);
          });
    }
  }

  Widget contentViewWidget(CategoryRequestRespsModel? categoryRequestRespsModel,
      TrsactionAddExpenseModel? transactionModel) {
    transactionModel?.categoryRequestRespsModel = categoryRequestRespsModel;
    String genricBlocID =
        aGeneralBloc.currentOrganizationModelStream.valueOrNull?.profileId ??
            "";
    bool isMyTransfer = transactionModel?.isMyTransfer() ?? false;
    return SizedBox(
      height: 80.0,
      child: Padding(
        // padding:
        // const EdgeInsets.only(
        //   right: 8.0,left: 2
        // ),
        //change
        padding: const EdgeInsets.only(right: 10.0, left: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (!(widget.isPaymentWidgetShow ?? true))
              widget.isUserWidgetShow ?? false
                  ? userImage(
                      context: context,
                      imgURL:
                          transactionModel?.userCommonModel?.profileImageUrl,
                      initials: getNameInitials(
                          firstName:
                              transactionModel?.userCommonModel?.firstName,
                          lastName:
                              transactionModel?.userCommonModel?.lastName),
                      width: 60,
                      borderRadius: 12,
                      height: 60,
                    ).paddingOnly(
                      left: 8,
                    )
                  : SizedBox(
                      width: 65,
                      child: Stack(
                        children: [
                          (transactionModel?.transactionType ==
                                      TransactionTypeEnum.topUp.name ||
                                  transactionModel?.transactionType ==
                                      TransactionTypeEnum.transfer.name)
                              ? Container(
                                  height: context.getHeightWithSize(
                                      sizeConstant: 48),
                                  width: context.getWidthWithSize(
                                      sizeConstant: 48),
                                  // margin: const EdgeInsets.only(left: 10, right: 10, top: 24),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: HexColor(
                                        transactionModel?.topUpTransferColor ??
                                            "#f3f3f3"),
                                  ),
                                  //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  child: Center(
                                      child: Text(
                                    "${transactionModel?.topUpTransferCurrncySymbol}",
                                    style: AppTextStyles.textStyle20w700(
                                            AppColors.mainColor)
                                        .copyWith(fontSize: 25),
                                  ))).paddingOnly(left: 8, top: 12, bottom: 12)
                              : CategoryIconImageCommonWidget(
                                  iconIconUrl: categoryRequestRespsModel
                                      ?.categoryIconsModel?.iconUrl,
                                  color: HexColor(
                                      categoryRequestRespsModel?.color ??
                                          "#f3f3f3"),
                                ).paddingOnly(left: 8, top: 12, bottom: 12),
                          bottomSmalUserImageWidget(
                              transactionModel: transactionModel),
                        ],
                      ),
                    ),
            10.0.widthSizedBox,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.isPaymentWidgetShow ?? false
                        ? commonServices
                            .getPaymentInfo(transactionModel?.setUpPaymentModel)
                        : widget.isUserWidgetShow ?? false
                            ? "${transactionModel?.userCommonModel?.firstName} ${transactionModel?.userCommonModel?.lastName}"
                            : (transactionModel?.transactionType ==
                                        TransactionTypeEnum.topUp.name ||
                                    transactionModel?.transactionType ==
                                        TransactionTypeEnum.transfer.name)
                                ? "${transactionModel?.topUpTransferTypeFrom.capitalizeFirstLetter()} ${transactionModel?.transactionType.capitalizeFirstLetter()}"
                                : categoryRequestRespsModel?.catName ?? "",
                    style: AppTextStyles.textStyle16w400(AppColors.c181818),
                  ),
                  if (transactionModel?.transactionType ==
                      TransactionTypeEnum.transfer.name) ...[
                    2.0.heightSizedBox,
                    FutureBuilder<UserModel?>(
                        future: isMyTransfer
                            ? transactionDetailBloc.getUserInfo(
                                userID: transactionModel?.creatorId ?? "",
                                userType: transactionModel?.creatorType ?? "")
                            : transactionDetailBloc.getOrgUserOrAdmin(
                                userId: transactionModel?.transferToEndUserId ??
                                    ""),
                        builder: (cont, snap) {
                          if (!snap.hasData) {
                            return const SizedBox();
                          }
                          //if first time loaded we will fill user info in trasaction bloc then we will use for future reloaded
                          if (!(aGeneralBloc
                              .commopnTrsactionListBloc.listUserModel
                              .contains(snap.data))) {
                            aGeneralBloc.commopnTrsactionListBloc.listUserModel
                                .add(snap.data);
                          }

                          String text = isMyTransfer
                              ? "By: ${snap.data?.firstName} ${snap.data?.lastName}"
                              : "To: ${snap.data?.firstName} ${snap.data?.lastName}";
                          return Text(
                            text,
                            style: AppTextStyles.textStyle12w400(
                                AppColors.isLightModeColor),
                          );
                        }),
                    2.0.heightSizedBox,
                  ],
                  if ((transactionModel?.description?.isNotEmpty ?? false) &&
                      transactionModel?.transactionType !=
                          TransactionTypeEnum.transfer.name) ...[
                    2.0.heightSizedBox,
                    Text(
                      transactionModel?.description ?? "",
                      overflow: TextOverflow.ellipsis,
                      maxLines:
                          (transactionModel?.groupId ?? '').isNotEmpty ? 1 : 2,
                      style: AppTextStyles.textStyle12w400(AppColors.cA3A3A3),
                    ),
                    2.0.heightSizedBox,
                  ],
                  if ((transactionModel?.groupId ?? '').isNotEmpty)
                    FutureBuilder<GroupModel?>(
                        future: transactionDetailBloc.getGroupData(
                            groupId: transactionModel?.groupId ?? ""),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData && snapshot.data == null) {
                            return const SizedBox();
                          }
                          transactionModel?.groupModel = snapshot.data;
                          isGroupContentRefresh.add(true);
                          return Column(
                            children: [
                              2.0.heightSizedBox,
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: AppColors.cF3F3F3),
                                child: Text(
                                  longStringToShort(snapshot.data?.name ?? ""),
                                  style: AppTextStyles.textStyle14w400(
                                          AppColors.c24262D)
                                      .copyWith(fontSize: 10),
                                ),
                              ),
                            ],
                          );
                        })
                ],
              ).paddingOnly(top: 2),
            ),
            8.0.widthSizedBox,
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text(
                    // TODO remove +/- symbol removed
                    // '${transactionModel?.isNegativeAmount ?? true ? "-" : "+"} ₹${transactionModel?.amount!.currencyFormat ?? ""}',

                    '${getCurrencySymBol(transactionModel: transactionModel)} ${transactionModel?.transactionAmount?.currencyFormat ?? ""}',
                    style: AppTextStyles.textStyle15w700(
                        transactionModel?.transactionType ==
                                TransactionTypeEnum.expense.name
                            ? AppColors.cFF1000
                            : transactionModel?.transactionType ==
                                    TransactionTypeEnum.topUp.name
                                ? AppColors.greenLight
                                : isMyTransfer
                                    ? AppColors.greenLight
                                    : (genricBlocID ==
                                                transactionModel
                                                    ?.transferToEndUserId ||
                                            genricBlocID ==
                                                transactionModel?.creatorId)
                                        ? AppColors.cFF1000
                                        : AppColors.c4483F7),
                  ),
                ),
                // if (!(transactionModel?.isApproved ?? true)) ...[
//   5.0.heightSizedBox,
//   GestureDetector(
//       onTap: () {
//         context.navigateTo(DisputeTransaction(
//           transactionModel: transactionModel!,
//         ));
//       },
//       child: ImgConstants.icExclamationCircle.svgAssetImage()
//   )
// ]

                // if (!((transactionModel?.status ==
                //         TrsactionTypeEnum.approved.name)) &&
                //     !(transactionModel?.status ==
                //         TrsactionTypeEnum.disputed.name)) ...[
                //   5.0.heightSizedBox,
                //   GestureDetector(
                //       onTap: () {
                //         // context.navigateTo(DisputeTransaction(
                //         //   transactionModel: transactionModel!,
                //         // ));
                //       },
                //       child: ImgConstants.pandingTrasaction.svgAssetImage())
                // ],
                //TODO: Sprint 2
                // if ((transactionModel?.status ==
                //     TrsactionTypeEnum.approved.name)) ...[
                //   5.0.heightSizedBox,
                //
                //   GestureDetector(
                //       onTap: () {
                //         // context.navigateTo(DisputeTransaction(
                //         //   transactionModel: transactionModel!,
                //         // ));
                //       },
                //       child: ImgConstants.approved.svgAssetImage())
                // ],
                // if ((transactionModel?.status ==
                //     TrsactionTypeEnum.disputed.name)) ...[
                //   5.0.heightSizedBox,
                //   GestureDetector(
                //       onTap: () {
                //         // context.navigateTo(DisputeTransaction(
                //         //   transactionModel: transactionModel!,
                //         // ));
                //       },
                //       child: ImgConstants.icExclamationCircle.svgAssetImage())
                // ]
                Row(
                  children: [
                    if (transactionModel?.isPersnol ?? false)
                      addImage(
                              context: context,
                              height: 20.0,
                              width: 20.0,
                              img: ImgConstants.icPersonal)
                          .paddingOnly(right: 3),
                    if (transactionModel?.transactionType !=
                        TransactionTypeEnum.topUp.name)
                      GestureDetector(
                          onTap: () {
                            if (transactionModel?.status ==
                                TransactionStatusEnum.disputed.name) {
                              context.navigateTo(TransactionDetailPage(
                                transactionModel: transactionModel!,
                              ));
                            }
                          },
                          child: transactionModel?.status ==
                                  TransactionStatusEnum.approved.name
                              ? ImgConstants.approved.svgAssetImage()
                              : transactionModel?.status ==
                                      TransactionStatusEnum.disputed.name
                                  ? ImgConstants.icExclamationCircle
                                      .svgAssetImage()
                                  : transactionModel?.status ==
                                          TransactionStatusEnum.rejected.name
                                      ? ImgConstants.icRejectIcon
                                          .svgAssetImage(height: 14, width: 14)
                                      : ImgConstants.pandingTrasaction
                                          .svgAssetImage())
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  String getCurrencySymBol({TrsactionAddExpenseModel? transactionModel}) {
    String currId = '';
    String currSymBol = '';

    for (SetUpPaymentModel method
        in aGeneralBloc.listPaymentMethodsModel.valueOrNull ?? []) {
      if (method.id == transactionModel?.paymentMethodId) {
        currId = method.currencyId;
        transactionModel?.setUpPaymentModel = method;
        break;
      }
    }

    for (CurrencyModel model
        in aGeneralBloc.listCurrencyModel.valueOrNull ?? []) {
      if (model.id == currId) {
        currSymBol = model.currencySymbol;
        break;
      }
    }
    return currSymBol;
  }

  Widget bottomSmalUserImageWidget(
      {required TrsactionAddExpenseModel? transactionModel}) {
    return FutureBuilder<UserModel?>(
        future: transactionDetailBloc.getUserInfo(
            userID: transactionModel?.creatorId ?? '',
            userType: transactionModel?.creatorType ?? ""),
        builder: (context, snap) {
          UserModel? userOrgRelation = snap.data;
          if (!snap.hasData) {
            return defaultLogoShow(transactionModel);
          }
          transactionModel?.userCommonModel = userOrgRelation;

          if (transactionModel?.creatorId ==
              aGeneralBloc
                  .currentOrganizationModelStream.valueOrNull?.profileId) {
            return defaultLogoShow(transactionModel);
          }

          return Positioned(
            top: 43,
            left: 43,
            child: userImage(
                imgURL: userOrgRelation?.profileImageUrl,
                initials: getNameInitials(
                    firstName: userOrgRelation?.firstName ?? '',
                    lastName: userOrgRelation?.lastName ?? ''),
                textStyle: AppTextStyles.textStyle7w400(AppColors.whiteColor),
                context: context,
                height: 20,
                width: 20,
                borderRadius: 30),
          );
        });
  }

  Widget defaultLogoShow(TrsactionAddExpenseModel? transactionModel) {
    if (aGeneralBloc.currentOrganizationModelStream.valueOrNull
            ?.isPersonalUser() ??
        false) {
      return Positioned(
          top: 43,
          left: 43,
          child: addImage(
              context: context,
              height: 20.0,
              width: 20.0,
              img: ImgConstants.icPersonal));
    } else if (transactionModel?.creatorType ==
        CommonProfileTypeModelEnum.organizationAdmin.typeKey) {
      return Positioned(
        top: 43,
        left: 43,
        child: addImage(
            context: context,
            height: 20.0,
            width: 20.0,
            img: ImgConstants.icOrganisation),
      );
    } else {
      return Positioned(
        top: 43,
        left: 43,
        child: addImage(
            context: context,
            height: 20.0,
            width: 20.0,
            img: ImgConstants.icOrganisation),
      );
    }
  }

  Future<void> showDisputeDialog(TrsactionAddExpenseModel? transactionModel) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return DisputeDialog(
          onDispute: (String value) {
            if (value.isNotEmpty) {
              transactionServices.disputeTransaction(
                  transactionId: transactionModel?.id ?? "",
                  creatorId: transactionModel?.creatorId ?? "",
                  data: {
                    TrsactionAddExpenseModelFiled.status:
                        TransactionStatusEnum.disputed.name,
                    TrsactionAddExpenseModelFiled.transactionDisputeMessage: [
                      TransactionMessage(
                        userID: aGeneralBloc.currentOrganizationModelStream
                            .valueOrNull?.profileId,
                        userType: aGeneralBloc.currentOrganizationModelStream
                            .valueOrNull?.accountType,
                        createdDate: Timestamp.now(),
                        message: value,
                        docsList: [],
                      ).toJson()
                    ]
                  });
              kNavigatorKey.currentState?.context
                  .showSucess(MsgConstants.transactionDisPuteSuc);
            }
          },
        );
      },
    );
  }
}
