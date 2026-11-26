module MockedSampleDocument
  protected

  def mock_call
    context.mocked_data = {
      status: 200,
      payload: {
        data: {
          document_url: self.class::SAMPLE_DOCUMENT_URL,
          expires_in: 1.day.to_i
        },
        links: {},
        meta: {}
      }
    }
  end
end
