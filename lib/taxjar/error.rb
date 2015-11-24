module Taxjar
  class Error < StandardError
    attr_reader :code

    ClientError = Class.new(self)

    ServerError = Class.new(self)

    # Raised when Taxjar endpoint returns the HTTP status code 400
    BadRequest = Class.new(ClientError)

    # Raised when Taxjar endpoint returns the HTTP status code 401
    Unauthorized = Class.new(ClientError)

    # Raised when Taxjar endpoint returns the HTTP status code 403
    Forbidden = Class.new(ClientError)

    # Raised when Taxjar endpoint returns the HTTP status code 404
    NotFound = Class.new(ClientError)

    # Raised when Taxjar endpoint returns the HTTP status code 405
    MethodNotAllowed = Class.new(ClientError)

    # Raised when Taxjar endpoint returns the HTTP status code 406
    NotAcceptable = Class.new(ClientError)

    # Raised when Taxjar endpoint returns the HTTP status code 410
    Gone = Class.new(ClientError)

    # Raised when Taxjar endpoint returns the HTTP status code 422
    UnprocessableEntity = Class.new(ClientError)

    # Raised when Taxjar endpoint returns the HTTP status code 429
    TooManyRequests = Class.new(ClientError)

    # Raised when Taxjar endpoint returns the HTTP status code 500
    InternalServerError = Class.new(ServerError)

    # Raised when Taxjar endpoint returns the HTTP status code 503
    ServiceUnavailable = Class.new(ServerError)

    ERRORS = {
      400 => Taxjar::Error::BadRequest,
      401 => Taxjar::Error::Unauthorized,
      403 => Taxjar::Error::Forbidden,
      404 => Taxjar::Error::NotFound,
      405 => Taxjar::Error::MethodNotAllowed,
      406 => Taxjar::Error::NotAcceptable,
      410 => Taxjar::Error::Gone,
      422 => Taxjar::Error::UnprocessableEntity,
      429 => Taxjar::Error::TooManyRequests,
      500 => Taxjar::Error::InternalServerError,
      503 => Taxjar::Error::ServiceUnavailable
    }

    class << self

      def from_response(body)
        code = body[:status]
        message = body[:detail]
        new(message, code)
      end

    end

    def initialize(message = '', code = nil)
      super(message)
      @code = code
    end

    ConfigurationError = Class.new(::ArgumentError)
  end
end
