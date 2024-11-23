class History {
  final String equation;
  final String result;

  History({required this.equation, required this.result});

  factory History.fromJson(Map<String, dynamic> json) => History(
        equation: json["equation"],
        result: json["result"],
    );

    Map<String, dynamic> toJson() => {
        "equation": equation,
        "result": result,
    };
}