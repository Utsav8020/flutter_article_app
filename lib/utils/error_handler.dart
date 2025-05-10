class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Object? originalError;

  ApiException(
    this.message, {
    this.statusCode,
    this.originalError,
  });

  @override
  String toString() {
    String result = message;
    
    if (statusCode != null) {
      result += ' (Status code: $statusCode)';
    }
    
    if (originalError != null) {
      result += '\nOriginal error: $originalError';
    }
    
    return result;
  }
}

// Function to get user-friendly error messages
String getUserFriendlyErrorMessage(Exception error) {
  if (error is ApiException) {
    if (error.statusCode == 404) {
      return 'The requested content could not be found. Please try again later.';
    } else if (error.statusCode == 500) {
      return 'Server error. Please try again later.';
    } else if (error.statusCode == 401 || error.statusCode == 403) {
      return 'You do not have permission to access this content.';
    } else if (error.message.contains('Network error')) {
      return 'Network error. Please check your internet connection and try again.';
    }
    return error.message;
  }
  
  return 'An unexpected error occurred. Please try again later.';
}
