import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_response.freezed.dart';

@freezed
class RemoteResponse<T> with _$RemoteResponse<T> {
  const RemoteResponse._();
  const factory RemoteResponse.noConnection({
    required int maxPage,
  }) = _NoConnection<T>;
  const factory RemoteResponse.noModified({
    required int maxPage,
  }) = _NoModified<T>;
  const factory RemoteResponse.withNewData(
    T data, {
    required int maxPage,
  }) = _WithNewData<T>;
}
