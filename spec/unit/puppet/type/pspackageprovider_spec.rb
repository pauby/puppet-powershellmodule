require 'spec_helper'

describe Puppet::Type.type(:pspackageprovider) do
  subject { resource }

  let(:resource) { described_class.new(name: 'pspackageprovider') }
  let :params do
    [
      :name,
    ]
  end

  let :properties do
    [
      :ensure,
      :version,
    ]
  end

  it 'has expected properties' do
    expect(described_class.properties.map(&:name)).to include(*properties)
  end

  it 'has expected parameters' do
    expect(described_class.parameters).to include(*params)
  end

  it 'does not have unexpected properties' do
    expect(properties).to include(*described_class.properties.map(&:name))
  end

  it 'does not have unexpected parameters' do
    expect(params + [:provider]).to include(*described_class.parameters)
  end

  describe 'parameter :name' do
    subject { resource.parameters[:name] }

    it { is_expected.to be_isnamevar }

    it 'does not allow nil' do
      expect {
        resource[:name] = nil
      }.to raise_error(Puppet::Error, %r{Got nil value for name})
    end

    it 'does not allow empty' do
      expect {
        resource[:name] = ''
      }.to raise_error(Puppet::ResourceError, %r{A non-empty name must})
    end

    ['value', 'value with spaces', 'UPPER CASE', '0123456789_-', 'With.Period'].each do |value|
      it "should accept '#{value}'" do
        expect { resource[:name] = value }.not_to raise_error
      end
    end

    ['*', '()', '[]', '!@'].each do |value|
      it "should reject '#{value}'" do
        expect { resource[:name] = value }.to raise_error(Puppet::ResourceError, %r{is not a valid name})
      end
    end
  end

  describe 'parameter :version' do
    it 'does not allow nil' do
      expect {
        resource[:version] = nil
      }.to raise_error(Puppet::Error, %r{Got nil value for version})
    end

    it 'does not allow empty' do
      expect {
        resource[:version] = ''
      }.to raise_error(Puppet::ResourceError, %r{A non-empty version must})
    end

    it 'accepts valid string value' do
      resource[:version] = 'C:\\location\for\provider'
      resource[:version] = 'H:\wakka\wakka'
    end
  end
end
