# frozen_string_literal: true

RSpec.describe Day03::Solver do
  subject { described_class.new }

  context '#part01' do
    it do
      subject.input = ['R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51',
                       'U98,R91,D20,R16,D67,R40,U7,R15,U6,R7']

      expect(subject.part01).to eq 135
    end

    it do
      subject.input = ['R8,U5,L5,D3',
                       'U7,R6,D4,L4']

      expect(subject.part01).to eq 6
    end
  end

  context '#part02' do
    it do
      subject.input = ['R75,D30,R83,U83,L12,D49,R71,U7,L72',
                       'U62,R66,U55,R34,D71,R55,D58,R83']

      expect(subject.part02).to eq 610
    end

    it do
      subject.input = ['R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51',
                       'U98,R91,D20,R16,D67,R40,U7,R15,U6,R7']


      expect(subject.part02).to eq 410
    end
  end
end
