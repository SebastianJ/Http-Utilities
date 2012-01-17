module HttpUtilities
  module Http
    module Get

      def retrieve_raw_content(url, options = {})
        return retrieve_content_from_url(url, options)
      end

      def retrieve_raw_xml(url, options = {})
        return retrieve_content_from_url(url, options)
      end

      def retrieve_parsed_xml(url, options = {})
        options.merge!({:force_encoding => true, :format => :xml})
        return retrieve_content_from_url(url, options)
      end

      def retrieve_parsed_html(url, options = {})
        options.merge!({:force_encoding => true, :format => :html})
        return retrieve_content_from_url(url, options)
      end

      def retrieve_parsed_html_and_fallback_to_proxies(url, options = {})
        options.merge!({:force_encoding => true, :format => :html})
        return retrieve_raw_content_and_fallback_to_proxies(url, options)
      end

      def retrieve_parsed_xml_and_fallback_to_proxies(url, options = {})
        options.merge!({:force_encoding => true, :format => :xml})
        return retrieve_raw_content_and_fallback_to_proxies(url, options)
      end

      def retrieve_raw_content_and_fallback_to_proxies(url, options = {})
        retries = 0
        max_retries = options.delete(:maximum_retrieval_retries) { |e| 5 }
        options.merge!({:force_encoding => true})

        response  =   retrieve_content_from_url(url, options)

        while (!response && retries < max_retries) do
          options.merge!({:use_proxy => true})
          response  =   retrieve_content_from_url(url, options)
          retries += 1
        end

        return response
      end

      def retrieve_content_from_url(url, options = {})
        response        =   nil
        method          =   options[:method] || :net_http

        if (method.eql?(:open_uri))
          response = retrieve_open_uri_content(url, options)
        elsif (method.eql?(:net_http))
          response = retrieve_net_http_content(url, options)
        elsif (method.eql?(:curl))
          response = retrieve_curl_content(url, options)
        end

        return response
      end

    end
  end
end

