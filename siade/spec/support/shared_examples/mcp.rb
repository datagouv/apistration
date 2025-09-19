RSpec.shared_examples 'valid MCP tool' do |params|
  let(:retriever) { params[:retriever] }
  let(:tool_params) { params[:tool_params] }
  let(:retriever_params) { params[:retriever_params] }

  it 'has a title' do
    expect(described_class.title).to be_present
  end

  it 'has a tool name' do
    expect(described_class.tool_name).to be_present
  end

  it 'has a description' do
    expect(described_class.description).to be_present
  end

  describe '.call' do
    subject(:tool_call) { described_class.call(**tool_params) }

    let(:siren) { valid_siren }
    let(:interactor_context) do
      interactor_context = Interactor::Context.new

      begin
        interactor_context.fail!
      rescue StandardError
        false
      end

      interactor_context
    end

    before do
      allow(retriever).to receive(:call).and_return(interactor_context)
      allow(described_class).to receive(:render_errors).and_return('Error')
    end

    it 'calls retriever with valid arguments' do
      expect(retriever).to receive(:call).with(
        hash_including(params: retriever_params)
      )

      tool_call
    end
  end
end
