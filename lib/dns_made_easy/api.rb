module DnsMadeEasy
  class Api
    def initialize(api_key, api_secret)
      @api_key = api_key
      @api_secret = api_secret
      @endpoint = 'https://api.dnsmadeeasy.com/V2.0'
    end

    def get_domains
      get_request('/dns/managed/')[:body]['data']
    end

    def get_domain(domain_name_or_id)
      if is_numeric?(domain_name_or_id)
        get_request("/dns/managed/#{domain_name_or_id}")[:body]
      else
        get_domains.find { |d| d['name'] == domain_name_or_id }
      end
    end

    def get_domain_records(domain_name_or_id, filters={})
      domain = get_domain(domain_name_or_id)
      response = get_request("/dns/managed/#{domain['id']}/records")[:body]['data']

      response.find_all { |x|
        filters.all? { |k,v|  x[k.to_s] == v }
      }
    end

    def get_domain_record(domain_name_or_id, filters={})
      get_domain_records(domain_name_or_id, filters).first
    end

    def update_domain_record(domain_name_or_id, filters={}, new_values={})
      domain = get_domain(domain_name_or_id)
      record = get_domain_record(domain_name_or_id, filters)
      attributes = record.merge(new_values).to_json

      response = put_request("/dns/managed/#{domain['id']}/records/#{record['id']}", attributes)
      response[:status_code] == 200
    end

    private

    def get_request(action, params={})
      begin
        parse_response(RestClient.get("#{@endpoint}#{action}", {params: params}.merge(build_headers)))
      rescue => e
        parse_response(e.response)
      end
    end

    def post_request(action, params={})
      begin
        parse_response(RestClient.post("#{@endpoint}#{action}", params, build_headers))
      rescue => e
        parse_response(e.response)
      end
    end

    def put_request(action, params={})
      begin
        parse_response(RestClient.put("#{@endpoint}#{action}", params, build_headers))
      rescue => e
        parse_response(e.response)
      end
    end

    def delete_request(action, params={})
      begin
        parse_response(RestClient.delete("#{@endpoint_url}#{action}", params, build_headers))
      rescue => e
        parse_response(e.response)
      end
    end

    def build_headers
      request_date = Time.now.httpdate
      hmac = OpenSSL::HMAC.hexdigest('sha1', @api_secret, request_date)

      {
        'Accept' => 'application/json',
        'x-dnsme-apiKey' => @api_key,
        'x-dnsme-requestDate' => request_date,
        'x-dnsme-hmac' => hmac
      }
    end

    def parse_response(response)
      {
        headers: response.headers,
        body: (JSON.parse(response.body) rescue response.body),
        status_code: response.code
      }
    end

    def is_numeric?(obj)
       obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
    end
  end
end
