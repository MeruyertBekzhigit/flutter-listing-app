import 'package:flutter/cupertino.dart';
import 'package:sample_listing_app/models/payload.dart';

class _ViewModel extends ChangeNotifier {
  var _state = _PayloadState();

  _PayloadState get state => _state;
  set state(_PayloadState val) {
    _state = _state.copyWith(items: val.payloads);
    notifyListeners();
  }
}

class _PayloadState {
  final List<Payload> payloads;

  _PayloadState({
    this.payloads = const <Payload>[],
  });

  _PayloadState copyWith({
    List<Payload>? items,
  }) {
    return _PayloadState(
      payloads: payloads ?? this.payloads,
    );
  }
}
