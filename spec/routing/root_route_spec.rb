require 'rails_helper'

RSpec.describe 'routes to the root path', :type => :routing do
  it 'should route to projects#root' do
    expect(get: root_path).to route_to(controller: 'projects', action: 'root')
  end
end