require 'rails_helper'

RSpec.describe ApplicationHelper do 

  describe '#format_date' do
    it 'returns a date in the format yyyy/mm/dd' do
      expect(format_date(Date.new(2015,12,8))).to eq('2015/12/08')
    end
  end

end