require 'rails_helper'

RSpec.describe 'routes to the downloads controller', :type => :routing do
  it 'should route to downloads#download' do
    expect(get: '/tmp/uploads/comment/attachments/1/file.mp3')
        .to route_to(controller: 'downloads', action: 'download', comment_id: '1', file_name: 'file', format: 'mp3')
  end
end