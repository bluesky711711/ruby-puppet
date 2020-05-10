#
# @api private
#
# Resolve a service using SRV
#
class Puppet::HTTP::Resolver::SRV < Puppet::HTTP::Resolver
  #
  # @api private
  #
  # @param [Puppet::HTTP::Client] client
  # @param [String] domain srv domain
  # @param [Resolv::DNS] dns
  #
  def initialize(client, domain:, dns: Resolv::DNS.new)
    @client = client
    @srv_domain = domain
    @delegate = Puppet::Network::Resolver.new(dns)
  end

  #
  # @api private
  #
  # Walk the available srv records and return the first that successfully connects
  #
  # @param [Puppet::HTTP::Session] session
  # @param [Symbol] name the service being resolved
  # @param [Puppet::SSL::SSLContext] ssl_context
  # @param [Proc] error_handler (nil) optional callback for each error
  #   encountered while resolving a route.
  #
  # @return [Puppet::HTTP::Service] if an available service is found, return
  #   it. Return nil otherwise.
  #
  def resolve(session, name, ssl_context: nil, error_handler: nil)
    # Here we pass our HTTP service name as the DNS SRV service name
    # This is fine for :ca, but note that :puppet and :file are handled
    # specially in `each_srv_record`.
    @delegate.each_srv_record(@srv_domain, name) do |server, port|
      service = Puppet::HTTP::Service.create_service(@client, session, name, server, port)
      return service if check_connection?(session, service, ssl_context: ssl_context, error_handler: error_handler)
    end

    return nil
  end
end
