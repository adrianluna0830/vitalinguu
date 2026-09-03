final class OneOf2<A, B> {
  final Object? _value;
  final int _index;

  const OneOf2._(this._value, this._index);

  factory OneOf2.first(A value) {
    return OneOf2._(value, 0);
  }

  factory OneOf2.second(B value) {
    return OneOf2._(value, 1);
  }

  T when<T>({
    required T Function(A value) first,
    required T Function(B value) second,
  }) {
    return switch (_index) {
      0 => first(_value as A),
      1 => second(_value as B),
      _ => throw StateError('Invalid OneOf2 state'),
    };
  }
}

final class OneOf3<A, B, C> {
  final Object? _value;
  final int _index;

  const OneOf3._(this._value, this._index);

  factory OneOf3.first(A value) {
    return OneOf3._(value, 0);
  }

  factory OneOf3.second(B value) {
    return OneOf3._(value, 1);
  }

  factory OneOf3.third(C value) {
    return OneOf3._(value, 2);
  }

  T when<T>({
    required T Function(A value) first,
    required T Function(B value) second,
    required T Function(C value) third,
  }) {
    return switch (_index) {
      0 => first(_value as A),
      1 => second(_value as B),
      2 => third(_value as C),
      _ => throw StateError('Invalid OneOf3 state'),
    };
  }
}

final class OneOf4<A, B, C, D> {
  final Object? _value;
  final int _index;

  const OneOf4._(this._value, this._index);

  factory OneOf4.first(A value) {
    return OneOf4._(value, 0);
  }

  factory OneOf4.second(B value) {
    return OneOf4._(value, 1);
  }

  factory OneOf4.third(C value) {
    return OneOf4._(value, 2);
  }

  factory OneOf4.fourth(D value) {
    return OneOf4._(value, 3);
  }

  T when<T>({
    required T Function(A value) first,
    required T Function(B value) second,
    required T Function(C value) third,
    required T Function(D value) fourth,
  }) {
    return switch (_index) {
      0 => first(_value as A),
      1 => second(_value as B),
      2 => third(_value as C),
      3 => fourth(_value as D),
      _ => throw StateError('Invalid OneOf4 state'),
    };
  }
}

final class OneOf5<A, B, C, D, E> {
  final Object? _value;
  final int _index;

  const OneOf5._(this._value, this._index);

  factory OneOf5.first(A value) {
    return OneOf5._(value, 0);
  }

  factory OneOf5.second(B value) {
    return OneOf5._(value, 1);
  }

  factory OneOf5.third(C value) {
    return OneOf5._(value, 2);
  }

  factory OneOf5.fourth(D value) {
    return OneOf5._(value, 3);
  }

  factory OneOf5.fifth(E value) {
    return OneOf5._(value, 4);
  }

  T when<T>({
    required T Function(A value) first,
    required T Function(B value) second,
    required T Function(C value) third,
    required T Function(D value) fourth,
    required T Function(E value) fifth,
  }) {
    return switch (_index) {
      0 => first(_value as A),
      1 => second(_value as B),
      2 => third(_value as C),
      3 => fourth(_value as D),
      4 => fifth(_value as E),
      _ => throw StateError('Invalid OneOf5 state'),
    };
  }
}

final class OneOf6<A, B, C, D, E, F> {
  final Object? _value;
  final int _index;

  const OneOf6._(this._value, this._index);

  factory OneOf6.first(A value) {
    return OneOf6._(value, 0);
  }

  factory OneOf6.second(B value) {
    return OneOf6._(value, 1);
  }

  factory OneOf6.third(C value) {
    return OneOf6._(value, 2);
  }

  factory OneOf6.fourth(D value) {
    return OneOf6._(value, 3);
  }

  factory OneOf6.fifth(E value) {
    return OneOf6._(value, 4);
  }

  factory OneOf6.sixth(F value) {
    return OneOf6._(value, 5);
  }

  T when<T>({
    required T Function(A value) first,
    required T Function(B value) second,
    required T Function(C value) third,
    required T Function(D value) fourth,
    required T Function(E value) fifth,
    required T Function(F value) sixth,
  }) {
    return switch (_index) {
      0 => first(_value as A),
      1 => second(_value as B),
      2 => third(_value as C),
      3 => fourth(_value as D),
      4 => fifth(_value as E),
      5 => sixth(_value as F),
      _ => throw StateError('Invalid OneOf6 state'),
    };
  }
}

final class OneOf7<A, B, C, D, E, F, G> {
  final Object? _value;
  final int _index;

  const OneOf7._(this._value, this._index);

  factory OneOf7.first(A value) {
    return OneOf7._(value, 0);
  }

  factory OneOf7.second(B value) {
    return OneOf7._(value, 1);
  }

  factory OneOf7.third(C value) {
    return OneOf7._(value, 2);
  }

  factory OneOf7.fourth(D value) {
    return OneOf7._(value, 3);
  }

  factory OneOf7.fifth(E value) {
    return OneOf7._(value, 4);
  }

  factory OneOf7.sixth(F value) {
    return OneOf7._(value, 5);
  }

  factory OneOf7.seventh(G value) {
    return OneOf7._(value, 6);
  }

  T when<T>({
    required T Function(A value) first,
    required T Function(B value) second,
    required T Function(C value) third,
    required T Function(D value) fourth,
    required T Function(E value) fifth,
    required T Function(F value) sixth,
    required T Function(G value) seventh,
  }) {
    return switch (_index) {
      0 => first(_value as A),
      1 => second(_value as B),
      2 => third(_value as C),
      3 => fourth(_value as D),
      4 => fifth(_value as E),
      5 => sixth(_value as F),
      6 => seventh(_value as G),
      _ => throw StateError('Invalid OneOf7 state'),
    };
  }
}

final class OneOf8<A, B, C, D, E, F, G, H> {
  final Object? _value;
  final int _index;

  const OneOf8._(this._value, this._index);

  factory OneOf8.first(A value) {
    return OneOf8._(value, 0);
  }

  factory OneOf8.second(B value) {
    return OneOf8._(value, 1);
  }

  factory OneOf8.third(C value) {
    return OneOf8._(value, 2);
  }

  factory OneOf8.fourth(D value) {
    return OneOf8._(value, 3);
  }

  factory OneOf8.fifth(E value) {
    return OneOf8._(value, 4);
  }

  factory OneOf8.sixth(F value) {
    return OneOf8._(value, 5);
  }

  factory OneOf8.seventh(G value) {
    return OneOf8._(value, 6);
  }

  factory OneOf8.eighth(H value) {
    return OneOf8._(value, 7);
  }

  T when<T>({
    required T Function(A value) first,
    required T Function(B value) second,
    required T Function(C value) third,
    required T Function(D value) fourth,
    required T Function(E value) fifth,
    required T Function(F value) sixth,
    required T Function(G value) seventh,
    required T Function(H value) eighth,
  }) {
    return switch (_index) {
      0 => first(_value as A),
      1 => second(_value as B),
      2 => third(_value as C),
      3 => fourth(_value as D),
      4 => fifth(_value as E),
      5 => sixth(_value as F),
      6 => seventh(_value as G),
      7 => eighth(_value as H),
      _ => throw StateError('Invalid OneOf8 state'),
    };
  }
}

final class OneOf9<A, B, C, D, E, F, G, H, I> {
  final Object? _value;
  final int _index;

  const OneOf9._(this._value, this._index);

  factory OneOf9.first(A value) {
    return OneOf9._(value, 0);
  }

  factory OneOf9.second(B value) {
    return OneOf9._(value, 1);
  }

  factory OneOf9.third(C value) {
    return OneOf9._(value, 2);
  }

  factory OneOf9.fourth(D value) {
    return OneOf9._(value, 3);
  }

  factory OneOf9.fifth(E value) {
    return OneOf9._(value, 4);
  }

  factory OneOf9.sixth(F value) {
    return OneOf9._(value, 5);
  }

  factory OneOf9.seventh(G value) {
    return OneOf9._(value, 6);
  }

  factory OneOf9.eighth(H value) {
    return OneOf9._(value, 7);
  }

  factory OneOf9.ninth(I value) {
    return OneOf9._(value, 8);
  }

  T when<T>({
    required T Function(A value) first,
    required T Function(B value) second,
    required T Function(C value) third,
    required T Function(D value) fourth,
    required T Function(E value) fifth,
    required T Function(F value) sixth,
    required T Function(G value) seventh,
    required T Function(H value) eighth,
    required T Function(I value) ninth,
  }) {
    return switch (_index) {
      0 => first(_value as A),
      1 => second(_value as B),
      2 => third(_value as C),
      3 => fourth(_value as D),
      4 => fifth(_value as E),
      5 => sixth(_value as F),
      6 => seventh(_value as G),
      7 => eighth(_value as H),
      8 => ninth(_value as I),
      _ => throw StateError('Invalid OneOf9 state'),
    };
  }
}

final class OneOf10<A, B, C, D, E, F, G, H, I, J> {
  final Object? _value;
  final int _index;

  const OneOf10._(this._value, this._index);

  factory OneOf10.first(A value) {
    return OneOf10._(value, 0);
  }

  factory OneOf10.second(B value) {
    return OneOf10._(value, 1);
  }

  factory OneOf10.third(C value) {
    return OneOf10._(value, 2);
  }

  factory OneOf10.fourth(D value) {
    return OneOf10._(value, 3);
  }

  factory OneOf10.fifth(E value) {
    return OneOf10._(value, 4);
  }

  factory OneOf10.sixth(F value) {
    return OneOf10._(value, 5);
  }

  factory OneOf10.seventh(G value) {
    return OneOf10._(value, 6);
  }

  factory OneOf10.eighth(H value) {
    return OneOf10._(value, 7);
  }

  factory OneOf10.ninth(I value) {
    return OneOf10._(value, 8);
  }

  factory OneOf10.tenth(J value) {
    return OneOf10._(value, 9);
  }

  T when<T>({
    required T Function(A value) first,
    required T Function(B value) second,
    required T Function(C value) third,
    required T Function(D value) fourth,
    required T Function(E value) fifth,
    required T Function(F value) sixth,
    required T Function(G value) seventh,
    required T Function(H value) eighth,
    required T Function(I value) ninth,
    required T Function(J value) tenth,
  }) {
    return switch (_index) {
      0 => first(_value as A),
      1 => second(_value as B),
      2 => third(_value as C),
      3 => fourth(_value as D),
      4 => fifth(_value as E),
      5 => sixth(_value as F),
      6 => seventh(_value as G),
      7 => eighth(_value as H),
      8 => ninth(_value as I),
      9 => tenth(_value as J),
      _ => throw StateError('Invalid OneOf10 state'),
    };
  }
}
