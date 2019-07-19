# frozen_string_literal: true

module Connection
  class BaseApi
    include HTTParty

    class Error500Exception < ApiException; end
    class Error422Exception < ApiException; end
    class Error404Exception < ApiException; end
    class Error400Exception < ApiException; end

    class << self
      def request(method, path, options = {})
        response_object = public_send(method, path, options)
        validate_response(response_object.response)
      end

      private

      def validate_response(response_struct)
        status = response_struct.code.to_i
        parsed_body = parse_body(response_struct.body)

        return parsed_body unless status.between?(400, 599)

        status_message = response_struct.msg
        raise error_klass(status).new(status, status_message, parsed_body)
      end

      def parse_body(body)
        JSON.parse(body.presence || '{}')
      rescue JSON::ParserError
        raise Error500Exception
      end

      def error_klass(status)
        case status
        when 400
          Error400Exception
        when 404
          Error404Exception
        when 422
          Error422Exception
        else
          Error500Exception
        end
      end
    end
  end
end
