sealed class SearchEvents {}

class SearchSubmittedEvent extends SearchEvents {
  final String query;

  SearchSubmittedEvent(this.query);
}

class SearchClearedEvent extends SearchEvents {}
