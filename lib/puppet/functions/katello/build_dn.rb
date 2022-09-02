# frozen_string_literal: true

require 'yaml'
# @summary
#   Convert an array of attribute pairs to a DN string, ignoring empty values
#
# @example Pass a set of
#   $client_dn = katello::build_dn([['CN', 'foo.example.com'], ['O', 'my_org']])
Puppet::Functions.create_function(:'katello::build_dn') do
  # @param options
  #
  # @return String
  dispatch :build_dn do
    param 'Array', :options
  end

  def build_dn(options)
    dn = ''

    options.each_with_index do |value, index|
      next if value[1].nil?
      dn += "#{options[index][0]}=#{value[1]}"
      dn += ', ' unless index == (options.length - 1)
    end

    dn
  end
end
