module SelfHostedDoc
  class ValidUrl
    def initialize(expected, file_extension)
      @expected = expected
      @file_extension = file_extension
    end

    def matches?(target)
      @target = target
      valid_url?
    end

    def failure_message(target)
      "expected #{target} to match #{expected_storage_url}"
    end

    private

    def valid_url?
      @target =~ /#{expected_storage_url}/
    end

    def expected_storage_url
      "https://my_example_storage.fr/siade_dev/.+-#{@expected}#{@file_extension}"
    end
  end

  def be_a_valid_self_hosted_document_url(filename)
    split_filename = filename.split('.')
    extension = split_filename.pop
    filename_without_ext = split_filename.join('.')
    ValidUrl.new(filename_without_ext, ".#{extension}")
  end

  def be_a_valid_self_hosted_pdf_url(expected)
    ValidUrl.new(expected, '.pdf')
  end

  def be_a_valid_self_hosted_zip_url(expected)
    ValidUrl.new(expected, '.zip')
  end
end
