import 'package:carousel_slider/carousel_slider.dart';
import 'package:expense_tracker/model/setup_payment/currency_model.dart';
import 'package:expense_tracker/model/setup_payment/setup_payment_model.dart';
import 'package:expense_tracker/reusable_component/import.dart';
import 'package:expense_tracker/screens/home/home_and_statement_bloc.dart';
import 'package:expense_tracker/services/common_services.dart';
import 'package:expense_tracker/utils/common/base_bloc.dart';
import 'package:expense_tracker/utils/common/utils.dart';
import 'package:expense_tracker/utils/extensions/extension.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../../screens/notification/notification.dart';
import '../../utils/enums.dart';

class CommonDebitCard extends StatefulWidget {
  final CarouselSliderController carouselController;
  final bool isCardSmallDown;
  final HomeAndStatementBloc? homeAndStatementBloc;
  final List<SetUpPaymentModel>? listPaymentMethod;
  final int initialIndex;
  const CommonDebitCard(
      {super.key,
      this.homeAndStatementBloc,
      required this.carouselController,
      required this.listPaymentMethod,
      this.isCardSmallDown = false,
      this.initialIndex = 0,
      required this.onChange});
  final Function onChange;
  @override
  State<CommonDebitCard> createState() => _CommonDebitCardState();
}

class _CommonDebitCardState extends State<CommonDebitCard> {
  int _cardIndex = 0;
  CommonServices commonServices = CommonServices();

  List<String> cardBackImageList = [
    ImgConstants.cardBackGroundTransparentShadow,
    ImgConstants.cardBackGroundTransparentShadow2,
    ImgConstants.cardBackGroundTransparentShadow3,
  ];

  BuildContext? myContext;
  bool isShowShowcase = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if ((widget.listPaymentMethod?.length ?? 0) == 1) {
      _cardIndex = 0;
    }

    return (widget.isCardSmallDown)
        ? SizedBox(
            height: context.getHeightWithSize(sizeConstant: 175.0),
            child: smallcardBack(
              setUpPaymentModel: widget.listPaymentMethod![_cardIndex],
              paymentTypeEnum:
                  widget.listPaymentMethod![_cardIndex].paymentType ==
                          PaymentTypeEnum.card.title.toLowerCase()
                      ? PaymentTypeEnum.card
                      : widget.listPaymentMethod![_cardIndex].paymentType ==
                              PaymentTypeEnum.cash.title.toLowerCase()
                          ? PaymentTypeEnum.cash
                          : PaymentTypeEnum.bank,
            ).paddingSymmetric(horizontal: 15),
          )
        : SizedBox(
            height: context.getHeightWithSize(sizeConstant: 175.0),
            child: CarouselSlider(
              items: getListViewData(),
              options: CarouselOptions(
                enlargeCenterPage: true,
                onPageChanged: ((index, reason) {
                  setState(() => _cardIndex = index);
                  widget.onChange(widget.listPaymentMethod![index], index);
                }),
                enableInfiniteScroll: false,
                viewportFraction: 0.7,
                initialPage: widget.initialIndex,
                //width: context.getWidthWithSize(sizeConstant: 255.0),
                height: context.getHeightWithSize(sizeConstant: 155.0),
              ),
              carouselController: widget.carouselController,
            ));
  }

  List<Widget> getListViewData() {
    List<Widget> listData = [];
    for (int i = 0; i < (widget.listPaymentMethod?.length ?? 0); i++) {
      listData.add(Transform.scale(
        scale: i == _cardIndex ? 1.20 : 0.9,
        child: Card(
            color: Colors.transparent,
            elevation: 0,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            semanticContainer: true,
            child: cardBack(
              index: i,
              setUpPaymentModel: widget.listPaymentMethod![i],
              paymentTypeEnum: widget.listPaymentMethod![i].paymentType ==
                      PaymentTypeEnum.card.title.toLowerCase()
                  ? PaymentTypeEnum.card
                  : widget.listPaymentMethod![i].paymentType ==
                          PaymentTypeEnum.cash.title.toLowerCase()
                      ? PaymentTypeEnum.cash
                      : PaymentTypeEnum.bank,
            )),
      ));
    }
    return listData;
  }

  Widget cardBack(
      {required SetUpPaymentModel setUpPaymentModel,
      required int index,
      required PaymentTypeEnum paymentTypeEnum}) {
    Color backColor = HexColor(setUpPaymentModel.color);

    return Container(
      width: context.getWidthWithSize(sizeConstant: 255.0),
      height: context.getHeightWithSize(sizeConstant: 155.0),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
          color: backColor,
          image: DecorationImage(
            image:
                AssetImage(cardBackImageList[index % cardBackImageList.length]),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.mainDarkColor.withOpacity(0.12),
              offset: const Offset(1, 1),
              blurRadius: 8,
              spreadRadius: 3,
            ), //BoxShadow
          ],
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(MsgConstants.balance,
                      style: AppTextStyles.textStyle15w400(AppColors.mainColor)
                          .copyWith(
                        shadows: <Shadow>[
                          Shadow(
                            offset: const Offset(1, 1),
                            blurRadius: 5.0,
                            color: AppColors.mainDarkColor.withOpacity(0.8),
                          ),
                        ],
                      )),
                  StreamBuilder<List<CurrencyModel>>(
                      stream: aGeneralBloc.listCurrencyModel,
                      builder: (context, snapshot) {
                        CurrencyModel? currencyModel =
                            aGeneralBloc.getCurrencyById(
                                currencyId: setUpPaymentModel.currencyId);
                        return Text(
                          "${currencyModel?.currencySymbol ?? ""} ${getAmount(setUpPaymentModel)}",
                          style:
                              AppTextStyles.textStyle16w700(AppColors.mainColor)
                                  .copyWith(
                            shadows: <Shadow>[
                              Shadow(
                                offset: const Offset(1, 1),
                                blurRadius: 5.0,
                                color: AppColors.mainDarkColor.withOpacity(0.8),
                              ),
                            ],
                          ),
                        );
                      })
                ],
              ),
              if (aGeneralBloc.isOrgAdmin() || aGeneralBloc.isOrgUserOnly())
                FutureBuilder<int>(
                    initialData: 0,
                    future: commonServices.getPendingTransactionCount(
                        paymentId: setUpPaymentModel.id ?? ""),
                    builder: (cont, snap) {
                      if (snap.data == 0) {
                        return Container();
                      }
                      return InkWell(
                        onTap: () {
                          context.navigateToWithReturn(NotificationPage(
                              initialTab: 0,
                              onApproveCallBack: (value) {
                                if (value) {
                                  if (widget.homeAndStatementBloc != null) {
                                    widget.homeAndStatementBloc
                                        ?.setPendingLocalCount();
                                  }
                                }
                              },
                              setUpPaymentModel: setUpPaymentModel));
                        },
                        child: CircleAvatar(
                          radius: 6,
                          backgroundColor: AppColors.primaryRed,
                          child: Text(
                            "${snap.data ?? "0"}",
                            style: AppTextStyles.textStyle10w700(
                                    AppColors.mainColor)
                                .copyWith(fontSize: 9),
                          ).paddingOnly(bottom: 1),
                        ).paddingOnly(top: 5),
                      );
                    })
            ],
          ).paddingOnly(left: 10, top: 5, right: 13),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (paymentTypeEnum == PaymentTypeEnum.card) ...[
                Row(
                  children: [
                    StreamBuilder<List<CardNameModel>>(
                        stream: aGeneralBloc.listCardNameModel,
                        builder: (context, snapshot) {
                          return Text(
                            aGeneralBloc
                                    .getCardNameById(
                                        id: setUpPaymentModel.cardNameId ?? "")
                                    ?.cardName
                                    .split(" ")
                                    .first ??
                                "",
                            style: AppTextStyles.textStyle15w700(
                                    AppColors.mainColor)
                                .copyWith(
                              shadows: <Shadow>[
                                Shadow(
                                  offset: const Offset(1, 1),
                                  blurRadius: 5.0,
                                  color:
                                      AppColors.mainDarkColor.withOpacity(0.8),
                                ),
                              ],
                            ),
                          );
                        }),
                    3.0.widthSizedBox,
                    Text(
                      "**${setUpPaymentModel.cardNumber}",
                      style: AppTextStyles.textStyle12w700(AppColors.mainColor)
                          .copyWith(
                        fontSize: 7,
                        shadows: <Shadow>[
                          Shadow(
                            offset: const Offset(1, 1),
                            blurRadius: 5.0,
                            color: AppColors.mainDarkColor.withOpacity(0.8),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
              if (paymentTypeEnum == PaymentTypeEnum.bank) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreamBuilder<List<BankNameModel>>(
                        stream: aGeneralBloc.listBankNameModel,
                        builder: (context, snapshot) {
                          String bankName = aGeneralBloc
                                  .getBankNameById(
                                      id: setUpPaymentModel.bankNameId ?? "")
                                  ?.bankName ??
                              "";
                          return Text(
                            longStringToShort(bankName, len: 10),
                            style: AppTextStyles.textStyle15w700(
                                    AppColors.mainColor)
                                .copyWith(
                              shadows: <Shadow>[
                                Shadow(
                                  offset: const Offset(1, 1),
                                  blurRadius: 5.0,
                                  color:
                                      AppColors.mainDarkColor.withOpacity(0.8),
                                ),
                              ],
                            ),
                          );
                        }),
                    Text(
                      "${setUpPaymentModel.bankAccountNumber}",
                      style: AppTextStyles.textStyle10w700(AppColors.mainColor)
                          .copyWith(
                        fontSize: 7,
                        shadows: <Shadow>[
                          Shadow(
                            offset: const Offset(1, 1),
                            blurRadius: 5.0,
                            color: AppColors.mainDarkColor.withOpacity(0.8),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                8.0.widthSizedBox,
              ],
              if (paymentTypeEnum == PaymentTypeEnum.cash) ...[
                StreamBuilder<List<CurrencyModel>>(
                    stream: aGeneralBloc.listCurrencyModel,
                    builder: (context, snapshot) {
                      CurrencyModel? currencyModel =
                          aGeneralBloc.getCurrencyById(
                              currencyId: setUpPaymentModel.currencyId);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                currencyModel?.currencyCode ?? "",
                                style: AppTextStyles.textStyle11w400(
                                        AppColors.mainColor)
                                    .copyWith(
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: const Offset(1, 1),
                                      blurRadius: 5.0,
                                      color: AppColors.mainDarkColor
                                          .withOpacity(0.8),
                                    ),
                                  ],
                                ),
                              ),
                              5.5.widthSizedBox,
                              CircleAvatar(
                                radius: (currencyModel?.currencySymbol.length ??
                                            0) >=
                                        2
                                    ? 8
                                    : 7,
                                backgroundColor: AppColors.cFF771C,
                                child: Text(
                                  currencyModel?.currencySymbol ?? '',
                                  style: AppTextStyles.textStyle9w400(
                                          AppColors.mainColor)
                                      .copyWith(shadows: <Shadow>[
                                    Shadow(
                                      offset: const Offset(1, 1),
                                      blurRadius: 5.0,
                                      color: AppColors.mainDarkColor
                                          .withOpacity(0.8),
                                    ),
                                  ], fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            longStringToShort(
                                currencyModel?.currencyName ?? ""),
                            style: AppTextStyles.textStyle11w400(
                                    AppColors.mainColor)
                                .copyWith(
                              shadows: <Shadow>[
                                Shadow(
                                  offset: const Offset(1, 1),
                                  blurRadius: 5.0,
                                  color:
                                      AppColors.mainDarkColor.withOpacity(0.8),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                8.0.widthSizedBox,
              ],
              GradientText(
                paymentTypeEnum.title.toLowerCase(),
                style:
                    const TextStyle(fontSize: 50.0, fontWeight: FontWeight.w700)
                        .copyWith(
                  shadows: <Shadow>[
                    Shadow(
                      offset: const Offset(1, 1),
                      blurRadius: 5.0,
                      color: AppColors.mainDarkColor.withOpacity(1),
                    ),
                  ],
                ),
                gradientType: GradientType.linear,
                radius: 25,
                colors: [
                  HexColor("#FF9D9D").withOpacity(0.35),
                  HexColor("#C8FFE1").withOpacity(0.35),
                  HexColor("#BFA0FF").withOpacity(0.35),
                  HexColor("#FF9BD7").withOpacity(0.35),
                  HexColor("#FFEA9F").withOpacity(0.35),
                ],
              ).paddingOnly(right: 10),
            ],
          ).paddingOnly(
            left: 10,
          ),
        ],
      ),
    );
  }

  Widget smallcardBack({
    required SetUpPaymentModel setUpPaymentModel,
    required PaymentTypeEnum paymentTypeEnum,
  }) {
    CurrencyModel? currencyModel =
        aGeneralBloc.getCurrencyById(currencyId: setUpPaymentModel.currencyId);
    return Container(
      width: context.getWidthWithSize(sizeConstant: 255.0),
      height: context.getHeightWithSize(sizeConstant: 155.0),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        //vertical: 10
      ),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          color: HexColor(setUpPaymentModel.color)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    MsgConstants.balance,
                    style: AppTextStyles.textStyle15w400(AppColors.mainColor)
                        .copyWith(
                      shadows: <Shadow>[
                        Shadow(
                          offset: const Offset(1, 1),
                          blurRadius: 5.0,
                          color: AppColors.mainDarkColor.withOpacity(0.8),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "${currencyModel?.currencySymbol ?? ""} ${getAmount(setUpPaymentModel)}",
                    //"${currencyModel?.currencySymbol ?? ""}${setUpPaymentModel.amount.currencyFormat}",
                    style: AppTextStyles.textStyle16w700(AppColors.mainColor)
                        .copyWith(
                      shadows: <Shadow>[
                        Shadow(
                          offset: const Offset(1, 1),
                          blurRadius: 5.0,
                          color: AppColors.mainDarkColor.withOpacity(0.8),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              GradientText(
                paymentTypeEnum.title.toLowerCase(),
                style:
                    const TextStyle(fontSize: 40.0, fontWeight: FontWeight.w700)
                        .copyWith(
                  shadows: <Shadow>[
                    Shadow(
                      offset: const Offset(1, 1),
                      blurRadius: 5.0,
                      color: AppColors.mainDarkColor.withOpacity(1),
                    ),
                  ],
                ),
                gradientType: GradientType.linear,
                radius: 25,
                colors: [
                  HexColor("#FF9D9D").withOpacity(0.35),
                  HexColor("#C8FFE1").withOpacity(0.35),
                  HexColor("#BFA0FF").withOpacity(0.35),
                  HexColor("#FF9BD7").withOpacity(0.35),
                  HexColor("#FFEA9F").withOpacity(0.35),
                ],
              ).paddingOnly(right: 5),
            ],
          ),
        ],
      ),
    );
  }

  String getAmount(SetUpPaymentModel setUpPaymentModel) {
    if (setUpPaymentModel.creatorId ==
        aGeneralBloc.currentOrganizationModelStream.valueOrNull?.profileId) {
      return setUpPaymentModel.amount.currencyFormat;
    } else {
      AssignUserModel? assignUserModel;
      int? index = setUpPaymentModel.assignOrgUserRelationModel?.indexWhere(
          (element) =>
              element.userId ==
              aGeneralBloc
                  .currentOrganizationModelStream.valueOrNull?.profileId);
      if (index != null && index != -1) {
        assignUserModel = setUpPaymentModel.assignOrgUserRelationModel?[index];
      }
      return (assignUserModel?.assignAmount ?? 0).currencyFormat;
    }
  }
}
