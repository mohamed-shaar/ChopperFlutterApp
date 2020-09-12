import 'package:built_collection/built_collection.dart';
import 'package:chopper/chopper.dart';
import 'package:chopper_trial/data/built_value_converter.dart';
import 'package:chopper_trial/data/mobile_data_interceptor.dart';
import 'package:chopper_trial/model/built_post.dart';

part 'post_api_service.chopper.dart';

@ChopperApi(baseUrl: '/posts')
abstract class PostApiService extends ChopperService {
  @Get()
  Future<Response<BuiltList<BuiltPost>>> getPosts();

  @Get(path: '/{id}')
  Future<Response<BuiltPost>> getPostWithId(@Path('id') int id);

  @Post()
  Future<Response<BuiltPost>> postPost(@Body() BuiltPost body);

  static PostApiService create() {
    final client = ChopperClient(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      services: [
        _$PostApiService(),
      ],
      converter: BuiltValueConverter(),
      interceptors: [
        HttpLoggingInterceptor(),
        MobileDataInterceptor(),
      ],
    );
    return _$PostApiService(client);
  }
}
