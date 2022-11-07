import 'package:bootcamp_project_02/core/infraestructure/sembast_database.dart';
import 'package:bootcamp_project_02/github/core/infrastructure/github_headers.dart';
import 'package:sembast/sembast.dart';

class GithuhHeadersCache {
  final SembastDatabase _sembastDatabase;
  final _store = stringMapStoreFactory.store('headers');

  GithuhHeadersCache(this._sembastDatabase);

  Future<void> saveHeaders(Uri uri, GithubHeaders headers) async {
    await _store.record(uri.toString()).put(
          _sembastDatabase.instance,
          headers.toJson(),
        );
  }

  Future<GithubHeaders?> getHeaders(Uri uri) async {
    final json =
        await _store.record(uri.toString()).get(_sembastDatabase.instance);
    return json == null ? null : GithubHeaders.fromJson(json);
  }

  Future<void> deleteHeaders(Uri uri) async {
    await _store.record(uri.toString()).delete(_sembastDatabase.instance);
  }
}
