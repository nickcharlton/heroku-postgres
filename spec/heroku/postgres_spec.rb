require 'spec_helper'

describe Heroku::Postgres do
  it 'has a version number' do
    expect(Heroku::Postgres::VERSION).not_to be nil
  end
end
