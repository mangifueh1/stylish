// lib/search_query_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// A StateProvider to hold the current search query string.
// It's initialized to an empty string.
final searchQueryProvider = StateProvider<String>((ref) => '');