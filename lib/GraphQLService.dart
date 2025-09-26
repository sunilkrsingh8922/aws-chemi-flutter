import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLService {
  static HttpLink httpLink = HttpLink("https://graphqlzero.almansi.me/api");

  static ValueNotifier<GraphQLClient> initClient() {
    return ValueNotifier(
      GraphQLClient(
        link: httpLink,
        cache: GraphQLCache(store: InMemoryStore()),
      ),
    );
  }
}
