enum AnchorType {
  robot(label: '机器人主播'),
  mediator(label: '呼叫转移主播'),
  streamer(label: '正常主播');

  final String label;
  const AnchorType({required this.label});
}
