part of 'extension.dart';

extension StrExtension on String? {
  String get firstCharUpperCase {
    String? value = this;
    if (value == null || value.isEmpty) {
      return "";
    }
    var result = value[0].toUpperCase();
    for (int i = 1; i < value.length; i++) {
      if (value[i - 1] == " ") {
        result = result + value[i].toUpperCase();
      } else {
        result = result + value[i];
      }
    }
    return result;
  }

  Widget loadNetworkImage(
      {double? height, double? width, BoxFit? fit, String? errorImg}) {
    String? image = this;
    // if ((image ?? '').isEmpty) {
    //   return const SizedBox();
    // }
    return CachedNetworkImage(
        placeholder: (BuildContext c, String s) => Container(
              color: AppColors.cBABABA,
              height: height,
              width: width,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
        fit: fit ?? BoxFit.none,
        height: height,
        width: width,
        errorWidget: (_, __, ___) => SizedBox(
              height: height,
              width: width,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
        imageUrl: (image ?? ''));
  }

  Widget loadNetworkImageSvgCatIcons(
      {double? height, double? width, BoxFit? fit, String? errorImg}) {
    String? image = this;

    String? assestesPath;

    if ((image ?? '').isNotEmpty) {
      assestesPath =
          aGeneralBloc.localItemModel.getSvgAssetesPath(svgUrl: image ?? '');
    }
    // debugPrint(" svg url $image $assestesPath");

    if ((image ?? '').isEmpty) {
      return const SizedBox();
    }
    return SvgPicture.network(
      image ?? '',
      // ignore: deprecated_member_use
      color: Colors.white,

      placeholderBuilder: (
        BuildContext c,
      ) {
        if ((assestesPath ?? '').isEmpty) {
          return SizedBox(
            height: height,
            width: width,
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          );
        }

        return SvgPicture.asset(
          assestesPath ?? '',
          color: Colors.white,
          fit: fit ?? BoxFit.none,
          height: height,
          width: width,
        );
      },
      fit: fit ?? BoxFit.none,
      height: height,
      width: width,
    );
  }

  Color getColorFromString() {
    String? colorString = this;
    Color otherColor = AppColors.grey;
    if (colorString != null) {
      int value = int.parse(colorString, radix: 16);
      otherColor = Color(value);
    }
    return otherColor;
  }

  String capitalizeFirstLetter() {
    if ((this ?? '').isEmpty) return '';
    return (this?[0].toUpperCase() ?? "") + this!.substring(1).toLowerCase();
  }

  String capitalizeFirstWordOnly() {
    if ((this ?? '').isEmpty) return '';
    return (this?[0].toUpperCase() ?? "") + this!.substring(1);
  }

  String mobileNumberFormat() {
    if (this?.length != 10) {
      return this ?? "";
    }

    return "${this?.substring(0, 2)}-${this?.substring(2, 6)}-${this?.substring(6, 10)}";
  }

  Future<File> urlToFile() async {
    Uri uri = Uri.parse(this ?? '');
// generate random number.
    var rng = Random();
// get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();
// get temporary path from temporary directory.
    String tempPath = tempDir.path;
// create a new file in temporary path with random file name.
    File file = File('$tempPath${rng.nextInt(100)}.png');
// call http.get method and pass imageUrl into it to get response.
    http.Response response = await http.get(uri);
// write bodyBytes received in response to file.
    await file.writeAsBytes(response.bodyBytes);
// now return the file which is created with random name in
// temporary directory and image bytes from response is written to // that file.
    return file;
  }
}
