class Util {
  static String durationFormat(int second) {
    final duration = Duration(seconds: second);
    final minutes = duration.inMinutes;
    final seconds = second % 60;

    final minutesString = '$minutes'.padLeft(1, '0');
    final secondsString = '$seconds'.padLeft(2, '0');
    return '$minutesString:$secondsString';
  }
}
