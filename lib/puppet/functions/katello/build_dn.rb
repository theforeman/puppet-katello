# frozen_string_literal: true

require 'yaml'
# @summary
#   Convert an array of attribute pairs to a DN string, ignoring empty values
#
# @example Pass a set of
#   $client_dn = katello::build_dn([['CN', 'foo.example.com'], ['O', 'my_org']])
Puppet::Functions.create_function(:'katello::build_dn') do
  # @param options
  dispatch :build_dn do
    param 'Array[Tuple[String[1], Optional[String[1]]]]', :options
    return_type 'String'
  end

  def build_dn(options)
    options.select { |_key, value| value }.map { |key, value| "#{key}=#{value}" }.join(', ')
  end
end
