module Datagouv
  class YmlUidWriter
    class UidNotFoundError < StandardError
    end

    def initialize(api:, uid:, base_path: Rails.root.join('config/endpoints'))
      @api = api
      @uid = uid
      @base_path = base_path
    end

    def write(datagouv_uid)
      edit_file { |lines, index| insert_datagouv_uid_line(lines, index, datagouv_uid) }
    end

    def remove
      edit_file { |lines, index| remove_datagouv_uid_line(lines, index) }
    end

    private

    attr_reader :api, :uid, :base_path

    def edit_file
      path = file_path
      lines = File.readlines(path)
      index = uid_line_index(lines)

      yield(lines, index)
      File.write(path, lines.join)
    end

    def uid_line_index(lines)
      lines.find_index { |line| line.match?(uid_line_pattern) }
    end

    def uid_line_pattern
      /^(\s*-\s*)uid:\s*["']#{Regexp.escape(uid)}["']/
    end

    def insert_datagouv_uid_line(lines, index, datagouv_uid)
      remove_datagouv_uid_line(lines, index)
      prefix = lines[index][/^(\s*-\s*)/, 1]
      indent = prefix.gsub('-', ' ')
      lines.insert(index + 1, "#{indent}datagouv_uid: '#{datagouv_uid}'\n")
    end

    def remove_datagouv_uid_line(lines, index)
      next_index = index + 1
      lines.delete_at(next_index) if lines[next_index]&.match?(/^\s*datagouv_uid:/)
    end

    def file_path
      Dir["#{base_path}/#{api}/*.yml"].find { |file| File.readlines(file).any? { |line| line.match?(uid_line_pattern) } } ||
        raise(UidNotFoundError, "Datagouv::YmlUidWriter: no yml file found for uid '#{uid}' in api '#{api}'")
    end
  end
end
