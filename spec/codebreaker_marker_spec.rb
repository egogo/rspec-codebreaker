require 'spec_helper'

describe Codebreaker::Marker do
  subject {Codebreaker::Marker}
  let(:secret) { '1234' }
  describe '.mark' do

      it 'shows empty string when there is no match' do
        subject.mark(secret, '5566').should eq ''
      end

      it 'shows plus signs for each number/position match' do
        subject.mark(secret, '1256').should eq '++'
      end

      it 'shows minus signs for each number match, position mismatch' do
        subject.mark(secret, '3456').should eq '--'
      end

      it 'shows plus signs on the first place' do
        subject.mark(secret, '5634').should eq '++'
      end

      it 'shows correct pattern for mixed result' do
        subject.mark(secret, '1243').should eq '++--'
      end

      it 'shows correct pattern for same numbers' do
        subject.mark(secret, '2222').should eq '+'
      end
  end
end
