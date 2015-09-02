require 'spec_helper'

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Restaurant, type: :model do
  it { is_expected.to have_many :reviews }
end
