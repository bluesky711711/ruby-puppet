#
# @api private
#
# Resolve a service using settings. This is the default resolver if none of the
# other resolvers find a functional connection.
#
class Puppet::HTTP::Resolver::Settings < Puppet::HTTP::Resolver
  #
  # @api private
  #
  # Resolve a service using the default server and port settings for this service.
  #
  # @param [Puppet::HTTP::Session] session
  # @param [Symbol] name the name of the service to be resolved
  # @param [Puppet::SSL::SSLContext] ssl_context
  # @param [Proc] error_handler (nil) optional callback for each error
  #   encountered while resolving a route.
  #
  # @return [Puppet::HTTP::Service] if the service successfully connects,
  #   return it. Otherwise, return nil.
  #
  def resolve(session, name, ssl_context: nil, error_handler: nil)
    service = Puppet::HTTP::Service.create_service(@client, session, name)
    check_connection?(session, service, ssl_context: ssl_context, error_handler: error_handler) ? service : nil
  end
end
