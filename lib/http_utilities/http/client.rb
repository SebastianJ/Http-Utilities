# -*- encoding : utf-8 -*-

module HttpUtilities
  module Http
    class Client
      include HttpUtilities::Http::Logger
      
      def get(url, arguments: {}, options: {}, retries: 3)
        response        =   nil
        request         =   build_request(options: options)
        
        begin
          response      =   request.interface.get(url, arguments)
          response      =   HttpUtilities::Http::Response.new(response, request, options)
    
        rescue Faraday::TimeoutError, Net::ReadTimeout, Timeout::Error, StandardError => e
          log(:error, "[HttpUtilities::Http::Client] - An error occurred while trying to fetch the response. Error Class: #{e.class.name}. Error Message: #{e.message}.")
          retries      -=   1
          retry if retries > 0
        end

        return response
      end
      
      def post(url, data: nil, options: {}, retries: 3)
        response        =   nil
        request         =   build_request(options: options)
    
        begin
          response      =   request.interface.post(url, data)
          response      =   HttpUtilities::Http::Response.new(response, request, options)
    
        rescue Faraday::TimeoutError, Net::ReadTimeout, Timeout::Error, StandardError => e
          log(:error, "[HttpUtilities::Http::Client] - An error occurred while trying to fetch the response. Error Class: #{e.class.name}. Error Message: #{e.message}.")
          retries          -=   1
          retry if retries > 0
        end

        return response
      end
      
      private
      def build_request(options: {}, client_options: {})
        client_options                      =   client_options.merge(ssl: {verify: false})
        
        adapter                             =   options.fetch(:adapter, Faraday.default_adapter)
        timeout                             =   options.fetch(:timeout, 60)
        open_timeout                        =   options.fetch(:open_timeout, 60)
        request_headers                     =   options.fetch(:request_headers, {})
        response_adapters                   =   options.fetch(:response_adapters, [])
        
        request                             =   HttpUtilities::Http::Request.new
        request.set_proxy_options(options)
        
        proxy_options                       =   request.generate_proxy_options
    
        connection      =   Faraday.new(client_options) do |builder|
          builder.headers[:user_agent]      =   request.user_agent
          
          request_headers.each do |key, value|
            builder.headers[key]            =   value 
          end if request_headers && !request_headers.empty?
          
          builder.options[:timeout]         =   timeout if timeout
          builder.options[:open_timeout]    =   open_timeout if open_timeout
          
          response_adapters.each do |response_adapter|
            builder.send(:response, response_adapter)
          end if response_adapters && response_adapters.any?

          builder.proxy     proxy_options unless proxy_options.empty?
          
          builder.adapter   adapter
        end

        request.interface                   =   connection
        
        return request
      end
      
    end
  end
end

