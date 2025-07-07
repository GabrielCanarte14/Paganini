class AppIcons {
  AppIcons._();
  static const String _basePath = "assets/svg/";

  static String user = _svgPath("user");
  static String lock = _svgPath("lock");

  static String _svgPath(String name) {
    return "$_basePath$name.svg";
  }
}
