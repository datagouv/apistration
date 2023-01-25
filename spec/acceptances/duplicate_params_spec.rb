RSpec.describe 'Duplicate params' do
  Dir[File.join(root_path, 'payloads/*')].each do |operation_id|
    next unless File.directory?(operation_id)

    describe operation_id.split('/')[-1] do
      it 'has no duplicate params' do
        all_payloads = Dir[File.join(operation_id, '*.yaml')].map do |payload|
          YAML.load_file(payload).merge(
            'name' => File.basename(payload)
          )
        end

        all_params = all_payloads.map { |payload| payload['params'] }

        if all_params.uniq == all_params
          expect(true).to be true
        else
          duplicate_params = all_params.uniq.select { |e| all_params.count(e) > 1 }

          error_message = ''

          duplicate_params.each do |params|
            payloads = all_payloads.select { |payload| payload['params'] == params }

            error_message << "Duplicate params found in #{payloads.map { |payload| payload['name'] }} : #{params}\n"
          end

          fail error_message
        end
      end
    end
  end
end
