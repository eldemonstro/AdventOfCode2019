# frozen_string_literal: true

RSpec.describe Day01::Solver do
  subject { described_class.new('input.txt') }

  context '#part01' do
    it do
      subject.input = ['12']

      expect(subject.part01).to eq 2
    end

    it do
      subject.input = ['14']

      expect(subject.part01).to eq 2
    end

    it do
      subject.input = ['1969']

      expect(subject.part01).to eq 654
    end

    it do
      subject.input = ['100756']

      expect(subject.part01).to eq 33_583
    end
  end

  context '#part02' do
    it do
      subject.input = ['12']

      expect(subject.part02).to eq 2
    end

    it do
      subject.input = ['1969']

      expect(subject.part02).to eq 966
    end

    it do
      subject.input = ['100756']

      expect(subject.part02).to eq 50_346
    end
  end
end
