# Flutter Infinite List example

###### Key topics
- Observe state changes with **BlocObserver**
- **BlocProvider**: widget that provider a bloc to it children.
- **BlocBuilder**: widget that handles building the widget in response to new states.
- Adding events with **context.read**.
- Prevent Uneccessary rebuilds with Equatable.
- Use the transformEvents method with Rx.


###### In-use packages
- bloc_concurrency: a Dart package that exposes custom event transformers inspired by *ember concurrency*. Built to work with *bloc*
- equatable
- flutter_bloc
- bloc
- http
- stream_transform
-(dev)
    - bloc_lint
    - bloc_test
    - moctail

##### REST API
this project use *jsonplaceholder* as data source.

`jsonplacholder` is and online REST API which serves fake data; it's very useful for building prototypes.


###### Data model
- post.dart

```Dart
import 'package:equatable/equatable.dart';

final class Post extends Equatable{
    const Post({
        required this.id, required this.title, required this.body
    });

    final int id;
    final String title;
    final String body;

    @override 
    List<Object> get props => [id, title, body];
}

```

###### Post Bloc

- Post Events - represent user interaction

```dart
part of 'post_bloc.dart';

sealed class PostEvent extends Equatable {
    @override
    List<Object> get props => [];
}

final class PostFetched extends PostEvent {}
```

- Post States 
    - *PostInitial* - will tell the presentation layer it needs to render al oading indicator while the initial batch of posts are loaded.
    - *PostSuccess* - will tell the presentation layer it has content to render
        - posts - will be the List<Post> which will be displayed
        - hasReachedMax - will tell the presentation layer whether or not it has reached the maximum number of posts
    - *PostFailure* - will the the presentation layer that an error has occurred while fetching posts.

```Dart
part of 'post_bloc.dart';

enum PostStatus { initial, success, failure}

final class PostState extends Equatable {

    final PostStatus status;
    final List<Post> posts;
    final bool hasReachedMax;

    PostState copyWith({
        PostStatus? status,
        List<Post>? posts,
        bool? hasReachedMax,
    }){
        return PostState(
            status: status ?? this.status,
            posts: posts ?? this.posts,
            hasReachedMax: hasReachedMax ?? this.hasReachedMax
        );
    }

    @override
    String toString(){
        return '''
        PostState { status: $status, hasReachedMax: $hasReachedMax, posts: ${post.length} }
        ''';
    }

    @override
    List<Object> get props =>[status, posts, hasReachedMax];
}
```
