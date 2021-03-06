module Fleet
  class Discovery
    class << self
      def hosts
        new(discovery_url).hosts
      end
    end

    attr_accessor :discovery_url

    def initialize(discovery_url = Fleetctl.options.discovery_url)
      @discovery_url = discovery_url
    end

    def data
      @data ||= JSON.parse(Net::HTTP.get(URI.parse(@discovery_url)))
    end

    def hosts
      begin
        data['node']['nodes'].map{|node| node['value'].split(':')[0..1].join(':').split('//').last}
      rescue => e
        Fleetctl.logger.error 'ERROR in Fleet::Discovery#hosts, returning empty set'
        Fleetctl.logger.error e.message
        Fleetctl.logger.error e.backtrace.join("\n")
        []
      end
    end
  end
end
