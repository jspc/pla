require 'spec_helper'

describe PLA do
  let(:pla){PLA}
  it "doesn't crap it's self when loaded" do
    expect(pla).not_to be(nil)
  end
end
