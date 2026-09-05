import 'package:flutter/material.dart';

class CommandBindingButton extends StatelessWidget {
  CommandBindingButton({super.key});

  final UploadCommand command = UploadCommand();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: command.canExecute
          ? () async {
              final result = await command.call();
              if (result is SuccessResult<void, String>) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Upload successful!')));
              } else if (result is ErrorResult<void, String>) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(result.error)));
              }
            }
          : null,
      child: command.isExecuting ? CircularProgressIndicator() : Text('Upload'),
    );
  }
}

class UploadCommand extends CommandUseCase<void, String> {
  bool _isExecuting = false;

  @override
  Future<Result<void, String>> call() async {
    try {
      // Simulate an upload operation
      _isExecuting = true;
      await Future.delayed(Duration(seconds: 2));
      // If successful, return a success result
      return Result.success(null);
    } catch (e) {
      // If there's an error, return an error result
      return Result.error('Upload failed: $e');
    } finally {
      _isExecuting = false;
    }
  }

  @override
  bool get isExecuting => _isExecuting;

  @override
  bool get canExecute => !_isExecuting;
}

abstract class CommandUseCase<T, E extends Object?> {
  Future<Result<void, E>> call();

  bool get isExecuting; // Placeholder for execution state
  bool get canExecute; // Placeholder for execution state
}

abstract class Result<T, E extends Object?> {
  factory Result.success(T data) => SuccessResult(data);
  factory Result.error(E error) => ErrorResult(error);
}

class SuccessResult<T, E> implements Result<T, E> {
  final T data;
  SuccessResult(this.data);

  @override
  String toString() => 'Result.success(data: $data)';
}

class ErrorResult<T, E> implements Result<T, E> {
  final E error;
  ErrorResult(this.error);

  @override
  String toString() => 'Result.error(error: $error)';
}
