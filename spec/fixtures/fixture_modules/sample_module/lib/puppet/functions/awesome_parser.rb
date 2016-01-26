# extremely helpful documentation
# https://github.com/puppetlabs/puppet-specifications/blob/master/language/func-api.md#the-4x-api
Puppet::Functions.create_function(:awesome_parser) do
  # the function below is called by puppet and and must match
  # the name of the puppet function above. You can set your
  # required parameters below and puppet 4 will enforce these
  # change x and y to suit your needs although only one parameter is required
  def awesome_parser(x,y)
    x >= y ? x : y
  end

  # you can define other helper methods in this code block as well
end
